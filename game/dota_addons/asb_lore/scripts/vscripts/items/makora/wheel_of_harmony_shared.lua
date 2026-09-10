LinkLuaModifier("modifier_item_wheel_of_harmony_passive", "items/makora/wheel_of_harmony_shared.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wheel_of_harmony_physical_immunity", "items/makora/wheel_of_harmony_shared.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wheel_of_harmony_magical_immunity", "items/makora/wheel_of_harmony_shared.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wheel_of_harmony_pure_immunity", "items/makora/wheel_of_harmony_shared.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wheel_of_harmony_debuff_immunity", "items/makora/wheel_of_harmony_shared.lua", LUA_MODIFIER_MOTION_NONE)

WheelOfHarmonyShared = WheelOfHarmonyShared or {}
local Shared = WheelOfHarmonyShared
local TEMP_USE_LEGACY_HARMONY_WHEEL = false

local HARMONY_SOUND = "mahoraga"
local SWITCH_PARTICLE = "particles/items/makora/makora_wheel.vpcf"
local PHYSICAL_IMMUNITY_PARTICLE = "particles/items/makora/wheel3.vpcf"
local MAGICAL_IMMUNITY_PARTICLE = "particles/items/makora/wheel2.vpcf"
local PURE_IMMUNITY_PARTICLE = "particles/items/makora/wheel1.vpcf"
local DEBUFF_IMMUNITY_PARTICLE = "particles/items/makora/wheel4.vpcf"
local SWITCH_PARTICLE_DURATION = 1
local PROC_COOLDOWN_FIELD = "jjk_harmony_proc_cooldown_end_time"
local DEBUFF_MIN_DURATION = 0.25
local MAX_ITEM_SLOT = 19
local HARMONY_HUD_EVENT = "jjk_harmony_counter_update"

local ITEM_CONFIGS = {
	item_wheel_of_harmony = {
		mode = "physical",
		next_item = "item_wheel_of_harmony2",
	},
	item_wheel_of_harmony2 = {
		mode = "magical",
		next_item = "item_wheel_of_harmony3",
	},
	item_wheel_of_harmony3 = {
		mode = "pure",
		next_item = "item_wheel_of_harmony4",
	},
	item_wheel_of_harmony4 = {
		mode = "debuff",
		next_item = "item_wheel_of_harmony",
	},
	item_wheel_of_harmony_active = {
		mode = "pure",
		next_item = "item_wheel_of_harmony4",
	},
}

local IMMUNITY_MODIFIER_BY_MODE = {
	physical = "modifier_item_wheel_of_harmony_physical_immunity",
	magical = "modifier_item_wheel_of_harmony_magical_immunity",
	pure = "modifier_item_wheel_of_harmony_pure_immunity",
	debuff = "modifier_item_wheel_of_harmony_debuff_immunity",
}

local DAMAGE_TYPE_BY_MODE = {
	physical = DAMAGE_TYPE_PHYSICAL,
	magical = DAMAGE_TYPE_MAGICAL,
	pure = DAMAGE_TYPE_PURE,
}

local EXTRA_IMMUNITY_PARTICLE_BY_MODE = {
	physical = PHYSICAL_IMMUNITY_PARTICLE,
	magical = MAGICAL_IMMUNITY_PARTICLE,
	pure = PURE_IMMUNITY_PARTICLE,
	debuff = DEBUFF_IMMUNITY_PARTICLE,
}

local MODIFIER_TEXTURE_BY_MODE = {
	physical = "item_wheel_phys",
	magical = "item_wheel_magic",
	pure = "item_wheel_pure",
	debuff = "item_wheel_effect",
}

local get_mode

local function get_item_config(ability_or_name)
	local ability_name = ability_or_name
	if type(ability_or_name) ~= "string" then
		ability_name = ability_or_name and ability_or_name.GetAbilityName and ability_or_name:GetAbilityName() or ""
	end

	return ITEM_CONFIGS[tostring(ability_name or "")]
end

local function get_harmony_swap_state(caster)
	if not caster or caster:IsNull() then
		return nil
	end

	if not caster._jjk_harmony_swap_pending then
		caster._jjk_harmony_swap_pending = {}
	end

	return caster._jjk_harmony_swap_pending
end

local function release_harmony_swap(caster, slot, token)
	if not caster or caster:IsNull() then
		return
	end

	local state = caster._jjk_harmony_swap_pending
	if not state then
		return
	end

	local entry = state[slot]
	if not entry or entry.token ~= token then
		return
	end

	local ability = entry.ability
	if ability and not ability:IsNull() then
		ability._jjk_harmony_switch_pending = nil
	end

	state[slot] = nil
end

local function is_switch_pending(ability)
	return ability
		and not ability:IsNull()
		and ability._jjk_harmony_switch_pending == true
end

local function get_owner_player_id(hero)
	if not hero or hero:IsNull() or not hero.GetPlayerOwnerID then
		return -1
	end

	return tonumber(hero:GetPlayerOwnerID() or -1) or -1
end

local function resolve_owner_hero(hero)
	if not hero or hero:IsNull() then
		return nil
	end

	local player_id = get_owner_player_id(hero)
	if player_id >= 0 and PlayerResource and PlayerResource.GetSelectedHeroEntity then
		local selected_hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if selected_hero and not selected_hero:IsNull() then
			return selected_hero
		end
	end

	return hero
end

local function send_harmony_hud(hero, payload)
	if not IsServer() or not CustomGameEventManager then
		return
	end

	local owner_hero = resolve_owner_hero(hero)
	local player_id = get_owner_player_id(owner_hero)
	if player_id < 0 or not PlayerResource or not PlayerResource.GetPlayer then
		return
	end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then
		return
	end

	CustomGameEventManager:Send_ServerToPlayer(player, HARMONY_HUD_EVENT, payload or { visible = 0 })
end

local function destroy_temporary_particle(particle, delay)
	if not IsServer() or not particle then
		return
	end

	local lifetime = math.max(0, tonumber(delay or 0) or 0)
	if Timers and Timers.CreateTimer then
		Timers:CreateTimer(lifetime, function()
			pcall(function()
				ParticleManager:DestroyParticle(particle, false)
			end)
			pcall(function()
				ParticleManager:ReleaseParticleIndex(particle)
			end)
		end)
		return
	end

	pcall(function()
		ParticleManager:DestroyParticle(particle, false)
	end)
	pcall(function()
		ParticleManager:ReleaseParticleIndex(particle)
	end)
end

local function play_one_shot_particle(target, particle_name, lifetime)
	if not IsServer() or not target or target:IsNull() or particle_name == nil or particle_name == "" then
		return
	end

	local ok, particle = pcall(function()
		return ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
	end)
	if ok and particle then
		destroy_temporary_particle(particle, lifetime or SWITCH_PARTICLE_DURATION)
	end
end

local function play_switch_effects(caster)
	if not caster or caster:IsNull() then
		return
	end

	caster:EmitSound(HARMONY_SOUND)
	play_one_shot_particle(caster, SWITCH_PARTICLE)
end

local function attach_modifier_particle(modifier, particle_name)
	if not IsServer() or not modifier or modifier:IsNull() or particle_name == nil or particle_name == "" then
		return
	end

	local parent = modifier:GetParent()
	local ok, particle = pcall(function()
		return ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, parent)
	end)
	if ok and particle then
		pcall(function()
			modifier:AddParticle(particle, false, false, -1, false, false)
		end)
	end
end

local function attach_harmony_particles(modifier, mode)
	attach_modifier_particle(modifier, SWITCH_PARTICLE)
	attach_modifier_particle(modifier, EXTRA_IMMUNITY_PARTICLE_BY_MODE[mode])
end

local function prune_events(events, now, window)
	local total = 0
	local next_index = 1

	for index = 1, #events do
		local entry = events[index]
		if entry and now - entry.time <= window then
			events[next_index] = entry
			next_index = next_index + 1
			total = total + (entry.value or 0)
		end
	end

	for index = next_index, #events do
		events[index] = nil
	end

	return total
end

local function add_event(events, now, value, window)
	events[#events + 1] = {
		time = now,
		value = value,
	}

	return prune_events(events, now, window)
end

local function get_proc_cooldown_remaining(ability, now)
	if not ability or ability:IsNull() then
		return 0
	end

	local current_time = tonumber(now or GameRules:GetGameTime() or 0) or 0
	local stored_end_time = tonumber(ability[PROC_COOLDOWN_FIELD] or 0) or 0
	local stored_remaining = math.max(0, stored_end_time - current_time)

	if stored_remaining <= 0 then
		return 0
	end

	local actual_remaining = 0
	if ability.GetCooldownTimeRemaining then
		local ok, value = pcall(function()
			return tonumber(ability:GetCooldownTimeRemaining() or 0) or 0
		end)
		actual_remaining = ok and math.max(0, value or 0) or 0
	end

	if actual_remaining <= 0.05 then
		ability[PROC_COOLDOWN_FIELD] = nil
		return 0
	end

	return math.min(stored_remaining, actual_remaining)
end

local function start_proc_cooldown(ability, duration)
	if not ability or ability:IsNull() then
		return
	end

	local current_time = tonumber(GameRules:GetGameTime() or 0) or 0
	local total_duration = math.max(0, tonumber(duration or 0) or 0)
	ability[PROC_COOLDOWN_FIELD] = current_time + total_duration
end

local function get_caster_cooldown_reduction_factor(caster)
	if not caster or caster:IsNull() or not caster.GetCooldownReduction then
		return 1
	end

	local ok, value = pcall(function()
		return tonumber(caster:GetCooldownReduction() or 0) or 0
	end)
	local factor = ok and value or 0

	if factor == nil or factor <= 0 then
		return 1
	end

	return factor
end

local function get_effective_custom_cooldown(caster, base_cooldown)
	local cooldown = math.max(0, tonumber(base_cooldown or 0) or 0)
	if cooldown <= 0 then
		return 0
	end

	return cooldown * get_caster_cooldown_reduction_factor(caster)
end

local function get_effective_ability_cooldown(ability, fallback)
	if not ability or ability:IsNull() then
		return math.max(0, tonumber(fallback or 0) or 0)
	end

	local cooldown = 0
	local level = math.max(0, tonumber(ability.GetLevel and ability:GetLevel() or 0) or 0)

	if ability.GetCooldown then
		local ok, value = pcall(function()
			return ability:GetCooldown(math.max(level - 1, 0))
		end)
		if ok then
			cooldown = tonumber(value) or 0
		end
	end

	if cooldown <= 0 then
		cooldown = tonumber(fallback or 0) or 0
	end

	return get_effective_custom_cooldown(ability.GetCaster and ability:GetCaster() or nil, cooldown)
end

local function find_item_slot(caster, wanted_item)
	if not caster or caster:IsNull() or not caster.GetItemInSlot then
		return nil
	end

	for slot = 0, MAX_ITEM_SLOT do
		if caster:GetItemInSlot(slot) == wanted_item then
			return slot
		end
	end

	return nil
end

local function swap_item_safe_by_slot(caster, target_slot, old_item, new_name, purchase_time, charges, proc_cooldown_remaining, switch_cooldown, token)
	if not IsServer() or not caster or caster:IsNull() or target_slot == nil then
		return
	end

	if not Timers or not Timers.CreateTimer then
		release_harmony_swap(caster, target_slot, token)
		Shared.ScheduleHudRefresh(caster, FrameTime())
		return
	end

	Timers:CreateTimer(FrameTime(), function()
		if not caster or caster:IsNull() then
			release_harmony_swap(caster, target_slot, token)
			return
		end

		local old_slot = find_item_slot(caster, old_item)
		if old_slot == nil then
			release_harmony_swap(caster, target_slot, token)
			Shared.ScheduleHudRefresh(caster, FrameTime())
			return
		end

		local reggie_temp_state = nil
		if type(_G.JJK_ReggieInnateCaptureTempItemState) == "function" then
			reggie_temp_state = _G.JJK_ReggieInnateCaptureTempItemState(old_item)
		end

		caster:RemoveItem(old_item)

		Timers:CreateTimer(0.01, function()
			if not caster or caster:IsNull() then
				release_harmony_swap(caster, target_slot, token)
				return
			end

			local new_item = CreateItem(new_name, caster, caster)
			if not new_item or new_item:IsNull() then
				release_harmony_swap(caster, target_slot, token)
				Shared.ScheduleHudRefresh(caster, FrameTime())
				return
			end

			if purchase_time then
				new_item:SetPurchaseTime(purchase_time)
			end

			if charges and charges > 0 then
				new_item:SetCurrentCharges(charges)
			end

			if proc_cooldown_remaining and proc_cooldown_remaining > 0 then
				start_proc_cooldown(new_item, proc_cooldown_remaining)
			end

			caster:AddItem(new_item)

			if reggie_temp_state and type(_G.JJK_ReggieInnateApplyCapturedTempItemState) == "function" then
				_G.JJK_ReggieInnateApplyCapturedTempItemState(caster, new_item, reggie_temp_state)
			elseif type(_G.JJK_ReggieInnateTransferTempItem) == "function" then
				_G.JJK_ReggieInnateTransferTempItem(caster, old_item, new_item)
			end

			if switch_cooldown and switch_cooldown > 0 then
				new_item:StartCooldown(switch_cooldown)
			end

			local new_slot = find_item_slot(caster, new_item)
			if new_slot ~= nil and new_slot ~= target_slot and new_slot >= 0 and target_slot >= 0 then
				caster:SwapItems(target_slot, new_slot)
			end

			release_harmony_swap(caster, target_slot, token)
			Shared.ScheduleHudRefresh(caster, FrameTime())
		end)
	end)
end

local function find_display_harmony_item(hero)
	if not hero or hero:IsNull() or not hero.GetItemInSlot then
		return nil
	end

	for slot = 0, MAX_ITEM_SLOT do
		local item = hero:GetItemInSlot(slot)
		if item and not item:IsNull() and get_item_config(item) then
			return item
		end
	end

	return nil
end

local function get_threshold_for_mode(ability, mode)
	if not ability or ability:IsNull() then
		return 0
	end

	if mode == "physical" then
		return tonumber(ability:GetSpecialValueFor("physical_threshold") or 0) or 0
	end

	if mode == "magical" then
		return tonumber(ability:GetSpecialValueFor("magical_threshold") or 0) or 0
	end

	if mode == "debuff" then
		return tonumber(ability:GetSpecialValueFor("debuff_threshold") or 0) or 0
	end

	return tonumber(ability:GetSpecialValueFor("pure_threshold") or 0) or 0
end

local function find_passive_modifier_for_item(hero, ability)
	if not hero or hero:IsNull() or not ability or ability:IsNull() then
		return nil
	end

	for _, modifier in pairs(hero:FindAllModifiersByName("modifier_item_wheel_of_harmony_passive")) do
		if modifier and not modifier:IsNull() and modifier:GetAbility() == ability then
			return modifier
		end
	end

	return nil
end

function Shared.UpdateHudForHero(hero)
	if not IsServer() then
		return
	end

	local owner_hero = resolve_owner_hero(hero)
	if not owner_hero or owner_hero:IsNull() then
		return
	end

	if TEMP_USE_LEGACY_HARMONY_WHEEL then
		send_harmony_hud(owner_hero, { visible = 0 })
		return
	end

	local ability = find_display_harmony_item(owner_hero)
	if not ability then
		send_harmony_hud(owner_hero, { visible = 0 })
		return
	end

	local now = tonumber(GameRules:GetGameTime() or 0) or 0
	local mode = get_mode(ability)
	local modifier = find_passive_modifier_for_item(owner_hero, ability)
	local current = 0
	local physical_threshold = get_threshold_for_mode(ability, "physical")
	local magical_threshold = get_threshold_for_mode(ability, "magical")
	local pure_threshold = get_threshold_for_mode(ability, "pure")
	local debuff_threshold = get_threshold_for_mode(ability, "debuff")

	if modifier and modifier.GetCurrentCounter then
		current = modifier:GetCurrentCounter(now)
	end

	local physical_current = mode == "physical" and current or 0
	local magical_current = mode == "magical" and current or 0
	local pure_current = mode == "pure" and current or 0
	local debuff_current = mode == "debuff" and current or 0

	send_harmony_hud(owner_hero, {
		visible = 1,
		active_type = mode,
		selected_mode = mode,
		physical_current = physical_current,
		physical_threshold = physical_threshold,
		magical_current = magical_current,
		magical_threshold = magical_threshold,
		pure_current = pure_current,
		pure_threshold = pure_threshold,
		debuff_current = debuff_current,
		debuff_threshold = debuff_threshold,
		selected_current = current,
		selected_threshold = get_threshold_for_mode(ability, mode),
		cooldown_remaining = get_proc_cooldown_remaining(ability, now),
	})
end

function Shared.ScheduleHudRefresh(hero, delay)
	if not IsServer() or not hero or hero:IsNull() then
		return
	end

	local refresh_delay = math.max(0, tonumber(delay or 0) or 0)
	if Timers and Timers.CreateTimer then
		Timers:CreateTimer(refresh_delay, function()
			if hero and not hero:IsNull() then
				Shared.UpdateHudForHero(hero)
			end
		end)
		return
	end

	Shared.UpdateHudForHero(hero)
end

local function switch_item(ability)
	if not IsServer() or not ability or ability:IsNull() then
		return
	end

	local config = get_item_config(ability)
	if not config or not config.next_item or config.next_item == "" then
		return
	end

	local caster = ability:GetCaster()
	if not caster or caster:IsNull() then
		return
	end

	if is_switch_pending(ability) then
		return
	end

	if get_proc_cooldown_remaining(ability) > 0 then
		return
	end

	if ability.GetCooldownTimeRemaining and (tonumber(ability:GetCooldownTimeRemaining() or 0) or 0) > 0 then
		return
	end

	local original_slot = find_item_slot(caster, ability)
	if original_slot == nil then
		return
	end

	local purchase_time = tonumber(ability:GetPurchaseTime() or 0) or 0
	local charges = tonumber(ability:GetCurrentCharges() or 0) or 0
	local proc_cooldown_remaining = get_proc_cooldown_remaining(ability)
	local switch_cooldown = get_effective_custom_cooldown(caster, ability:GetSpecialValueFor("switch_cooldown"))
	local state = get_harmony_swap_state(caster)
	if not state or state[original_slot] ~= nil then
		return
	end

	local token = DoUniqueString("harmony_swap")
	state[original_slot] = {
		token = token,
		ability = ability,
	}
	ability._jjk_harmony_switch_pending = true

	play_switch_effects(caster)
	swap_item_safe_by_slot(
		caster,
		original_slot,
		ability,
		config.next_item,
		purchase_time,
		charges,
		proc_cooldown_remaining,
		switch_cooldown,
		token
	)
end

function Shared.GetIntrinsicModifierName(_ability)
	return "modifier_item_wheel_of_harmony_passive"
end

function Shared.OnSpellStart(ability)
	local caster = ability and ability.GetCaster and ability:GetCaster() or nil
	if ability and not ability:IsNull() and ability.EndCooldown then
		ability:EndCooldown()
	end
	if not TEMP_USE_LEGACY_HARMONY_WHEEL then
		switch_item(ability)
	end
	if caster and not caster:IsNull() then
		Shared.ScheduleHudRefresh(caster, FrameTime())
	end
end

get_mode = function(ability)
	if TEMP_USE_LEGACY_HARMONY_WHEEL then
		return "physical"
	end

	local config = get_item_config(ability)
	return config and config.mode or "pure"
end

local function is_enemy_source(parent, source)
	if not source or (source.IsNull and source:IsNull()) or source == parent then
		return false
	end

	return source:GetTeamNumber() ~= parent:GetTeamNumber()
end

local function is_enemy_hero_source(parent, source)
	if not source or (source.IsNull and source:IsNull()) then
		return false
	end

	local hero_source = source
	if not (hero_source.IsRealHero and hero_source:IsRealHero()) then
		if hero_source.GetOwnerEntity then
			local owner_entity = hero_source:GetOwnerEntity()
			if owner_entity and not owner_entity:IsNull() and owner_entity.IsRealHero and owner_entity:IsRealHero() then
				hero_source = owner_entity
			end
		end

		if (not hero_source or hero_source:IsNull() or not (hero_source.IsRealHero and hero_source:IsRealHero()))
			and hero_source.GetPlayerOwner and PlayerResource then
			local owner_player = hero_source:GetPlayerOwner()
			if owner_player and owner_player.GetAssignedHero then
				local assigned_hero = owner_player:GetAssignedHero()
				if assigned_hero and not assigned_hero:IsNull() and assigned_hero.IsRealHero and assigned_hero:IsRealHero() then
					hero_source = assigned_hero
				end
			end
		end

		if (not hero_source or hero_source:IsNull() or not (hero_source.IsRealHero and hero_source:IsRealHero()))
			and source.GetPlayerOwnerID and PlayerResource then
			local player_id = tonumber(source:GetPlayerOwnerID() or -1) or -1
			if player_id >= 0 then
				local selected_hero = PlayerResource:GetSelectedHeroEntity(player_id)
				if selected_hero and not selected_hero:IsNull() and selected_hero.IsRealHero and selected_hero:IsRealHero() then
					hero_source = selected_hero
				end
			end
		end
	end

	return is_enemy_source(parent, hero_source) and hero_source.IsRealHero and hero_source:IsRealHero()
end

local function is_sukuna_hero(unit)
	if not unit or unit:IsNull() or not unit.GetUnitName then
		return false
	end
	local name = tostring(unit:GetUnitName() or "")
	return name == "npc_dota_hero_doom_bringer"
		or name == "npc_dota_hero_doom_bringer_custom"
		or name == "npc_dota_hero_terrorblade"
		or name == "npc_dota_hero_terrorblade_custom"
end

modifier_item_wheel_of_harmony_passive = class({})

function modifier_item_wheel_of_harmony_passive:IsHidden()
	return true
end

function modifier_item_wheel_of_harmony_passive:IsPurgable()
	return false
end

function modifier_item_wheel_of_harmony_passive:RemoveOnDeath()
	return false
end

function modifier_item_wheel_of_harmony_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_wheel_of_harmony_passive:OnCreated()
	self.events = {}
	self.tracked_debuffs = {}
	self:OnRefresh()

	if IsServer() then
		self:StartIntervalThink(0.1)
		Shared.ScheduleHudRefresh(self:GetParent())
	end
end

function modifier_item_wheel_of_harmony_passive:OnRefresh()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return
	end

	self.mode = get_mode(ability)
	self.bonus_all_stats = tonumber(ability:GetSpecialValueFor("bonus_all_stats") or 0) or 0
	self.immunity_duration = tonumber(ability:GetSpecialValueFor("duration") or 0) or 0
	self.counter_window = tonumber(ability:GetSpecialValueFor("counter_window") or 0) or 0
	self.adaptation_cooldown = tonumber(ability:GetSpecialValueFor("adaptation_cooldown") or 0) or 0
	self.switch_cooldown = tonumber(ability:GetSpecialValueFor("switch_cooldown") or 0) or 0
	self.physical_threshold = tonumber(ability:GetSpecialValueFor("physical_threshold") or 0) or 0
	self.magical_threshold = tonumber(ability:GetSpecialValueFor("magical_threshold") or 0) or 0
	self.pure_threshold = tonumber(ability:GetSpecialValueFor("pure_threshold") or 0) or 0
	self.debuff_threshold = tonumber(ability:GetSpecialValueFor("debuff_threshold") or 0) or 0
	self.wheel_physical_damage_resistance = tonumber(ability:GetSpecialValueFor("wheel_physical_damage_resistance") or 0) or 0
	self.wheel_magical_resistance = tonumber(ability:GetSpecialValueFor("wheel_magical_resistance") or 0) or 0
	self.wheel_pure_damage_resistance = tonumber(ability:GetSpecialValueFor("wheel_pure_damage_resistance") or 0) or 0
	self.wheel_status_resistance = tonumber(ability:GetSpecialValueFor("wheel_status_resistance") or 0) or 0

	if IsServer() then
		Shared.ScheduleHudRefresh(self:GetParent())
	end
end

function modifier_item_wheel_of_harmony_passive:OnDestroy()
	if IsServer() then
		Shared.ScheduleHudRefresh(self:GetParent(), FrameTime())
	end
end

function modifier_item_wheel_of_harmony_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_wheel_of_harmony_passive:GetModifierBonusStats_Strength()
	return self.bonus_all_stats or 0
end

function modifier_item_wheel_of_harmony_passive:GetModifierBonusStats_Agility()
	return self.bonus_all_stats or 0
end

function modifier_item_wheel_of_harmony_passive:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats or 0
end

function modifier_item_wheel_of_harmony_passive:GetModifierIncomingDamage_Percentage(params)
	if not params then
		return 0
	end

	if self.mode == "physical" and params.damage_type == DAMAGE_TYPE_PHYSICAL then
		return -(self.wheel_physical_damage_resistance or 0)
	end

	if self.mode == "pure" and params.damage_type == DAMAGE_TYPE_PURE then
		return -(self.wheel_pure_damage_resistance or 0)
	end

	return 0
end

function modifier_item_wheel_of_harmony_passive:GetModifierMagicalResistanceBonus()
	if self.mode ~= "magical" then
		return 0
	end

	return self.wheel_magical_resistance or 0
end

function modifier_item_wheel_of_harmony_passive:GetModifierStatusResistanceStacking()
	if self.mode ~= "debuff" then
		return 0
	end

	return self.wheel_status_resistance or 0
end

function modifier_item_wheel_of_harmony_passive:GetThreshold()
	if self.mode == "physical" then
		return self.physical_threshold or 0
	end

	if self.mode == "magical" then
		return self.magical_threshold or 0
	end

	if self.mode == "debuff" then
		return self.debuff_threshold or 0
	end

	return self.pure_threshold or 0
end

function modifier_item_wheel_of_harmony_passive:GetImmunityModifierName()
	return IMMUNITY_MODIFIER_BY_MODE[self.mode]
end

function modifier_item_wheel_of_harmony_passive:GetCurrentCounter(now)
	return prune_events(self.events or {}, tonumber(now or GameRules:GetGameTime() or 0) or 0, self.counter_window or 0)
end

function modifier_item_wheel_of_harmony_passive:HasActiveProtection()
	local parent = self:GetParent()

	return parent:HasModifier("modifier_item_wheel_of_harmony_physical_immunity")
		or parent:HasModifier("modifier_item_wheel_of_harmony_magical_immunity")
		or parent:HasModifier("modifier_item_wheel_of_harmony_pure_immunity")
		or parent:HasModifier("modifier_item_wheel_of_harmony_debuff_immunity")
end

function modifier_item_wheel_of_harmony_passive:CanTriggerProtection()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not ability or ability:IsNull() or not parent or parent:IsNull() then
		return false
	end

	if is_switch_pending(ability) then
		return false
	end

	if get_proc_cooldown_remaining(ability) > 0 then
		return false
	end

	if parent.IsIllusion and parent:IsIllusion() then
		return false
	end

	return not self:HasActiveProtection()
end

function modifier_item_wheel_of_harmony_passive:OnTakeDamage(params)
	if not IsServer() then
		return
	end

	if self.mode == "debuff" then
		return
	end

	local parent = self:GetParent()
	if params.unit ~= parent or (params.damage or 0) <= 0 then
		return
	end

	if not self:CanTriggerProtection() then
		return
	end

	if not is_enemy_source(parent, params.attacker) then
		return
	end

	local expected_damage_type = DAMAGE_TYPE_BY_MODE[self.mode]
	if expected_damage_type == nil or params.damage_type ~= expected_damage_type then
		return
	end

	local now = tonumber(GameRules:GetGameTime() or 0) or 0
	local total = add_event(self.events, now, params.damage, self.counter_window)
	Shared.ScheduleHudRefresh(parent)
	if total >= self:GetThreshold() then
		self:TriggerProtection()
	end
end

function modifier_item_wheel_of_harmony_passive:ShouldTrackDebuff(modifier)
	if not modifier or modifier == self or not modifier:IsDebuff() then
		return false
	end

	if modifier.GetAuraOwner then
		local aura_owner = modifier:GetAuraOwner()
		if aura_owner and not aura_owner:IsNull() then
			return false
		end
	end

	local duration = 0
	if modifier.GetDuration then
		duration = math.max(duration, tonumber(modifier:GetDuration() or 0) or 0)
	end
	if modifier.GetRemainingTime then
		duration = math.max(duration, tonumber(modifier:GetRemainingTime() or 0) or 0)
	end

	if duration < DEBUFF_MIN_DURATION then
		return false
	end

	return is_enemy_hero_source(self:GetParent(), modifier:GetCaster())
end

function modifier_item_wheel_of_harmony_passive:OnIntervalThink()
	if not IsServer() then
		return
	end

	local now = tonumber(GameRules:GetGameTime() or 0) or 0
	prune_events(self.events, now, self.counter_window)

	if self.mode ~= "debuff" then
		self.tracked_debuffs = {}
		Shared.UpdateHudForHero(self:GetParent())
		return
	end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then
		return
	end

	local observed = {}
	local can_trigger = self:CanTriggerProtection()

	for _, modifier in pairs(parent:FindAllModifiers()) do
		if self:ShouldTrackDebuff(modifier) then
			observed[modifier] = true

			if not self.tracked_debuffs[modifier] then
				self.tracked_debuffs[modifier] = true

				if can_trigger then
					local total = add_event(self.events, now, 1, self.counter_window)
					Shared.ScheduleHudRefresh(parent)
					if total >= self:GetThreshold() then
						self:TriggerProtection()
						return
					end
				end
			end
		end
	end

	for modifier in pairs(self.tracked_debuffs) do
		if not observed[modifier] then
			self.tracked_debuffs[modifier] = nil
		end
	end

	Shared.UpdateHudForHero(parent)
end

function modifier_item_wheel_of_harmony_passive:TriggerProtection()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() or not self:CanTriggerProtection() then
		return
	end

	local parent = self:GetParent()
	local immunity_modifier = self:GetImmunityModifierName()
	if not immunity_modifier or immunity_modifier == "" then
		return
	end

	local proc_cooldown = get_effective_ability_cooldown(ability, self.adaptation_cooldown or 0)
	start_proc_cooldown(ability, proc_cooldown)
	if ability.EndCooldown then
		ability:EndCooldown()
	end
	if ability.StartCooldown and proc_cooldown > 0 then
		ability:StartCooldown(proc_cooldown)
	end
	parent:EmitSound(HARMONY_SOUND)
	play_one_shot_particle(parent, SWITCH_PARTICLE)
	parent:AddNewModifier(parent, ability, immunity_modifier, { duration = self.immunity_duration })
	if is_sukuna_hero(parent) and JJKQuests and JJKQuests.RecordHeroQuestEvent then
		JJKQuests:RecordHeroQuestEvent(parent, "sukuna_harmony_wheel_adapt", 1)
	end

	self.events = {}
	self.tracked_debuffs = {}
	Shared.ScheduleHudRefresh(parent)
end

modifier_item_wheel_of_harmony_physical_immunity = class({})

function modifier_item_wheel_of_harmony_physical_immunity:GetTexture()
	return MODIFIER_TEXTURE_BY_MODE.physical
end

function modifier_item_wheel_of_harmony_physical_immunity:IsHidden()
	return false
end

function modifier_item_wheel_of_harmony_physical_immunity:IsPurgable()
	return false
end

function modifier_item_wheel_of_harmony_physical_immunity:IsDebuff()
	return false
end

function modifier_item_wheel_of_harmony_physical_immunity:OnCreated()
	if IsServer() then
		attach_harmony_particles(self, "physical")
	end
end

function modifier_item_wheel_of_harmony_physical_immunity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
end

function modifier_item_wheel_of_harmony_physical_immunity:GetAbsoluteNoDamagePhysical()
	return 1
end

modifier_item_wheel_of_harmony_magical_immunity = class({})

function modifier_item_wheel_of_harmony_magical_immunity:GetTexture()
	return MODIFIER_TEXTURE_BY_MODE.magical
end

function modifier_item_wheel_of_harmony_magical_immunity:IsHidden()
	return false
end

function modifier_item_wheel_of_harmony_magical_immunity:IsPurgable()
	return false
end

function modifier_item_wheel_of_harmony_magical_immunity:IsDebuff()
	return false
end

function modifier_item_wheel_of_harmony_magical_immunity:OnCreated()
	if IsServer() then
		attach_harmony_particles(self, "magical")
	end
end

function modifier_item_wheel_of_harmony_magical_immunity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
end

function modifier_item_wheel_of_harmony_magical_immunity:GetAbsoluteNoDamageMagical()
	return 1
end

modifier_item_wheel_of_harmony_pure_immunity = class({})

function modifier_item_wheel_of_harmony_pure_immunity:GetTexture()
	return MODIFIER_TEXTURE_BY_MODE.pure
end

function modifier_item_wheel_of_harmony_pure_immunity:IsHidden()
	return false
end

function modifier_item_wheel_of_harmony_pure_immunity:IsPurgable()
	return false
end

function modifier_item_wheel_of_harmony_pure_immunity:IsDebuff()
	return false
end

function modifier_item_wheel_of_harmony_pure_immunity:OnCreated()
	if IsServer() then
		attach_harmony_particles(self, "pure")
	end
end

function modifier_item_wheel_of_harmony_pure_immunity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end

function modifier_item_wheel_of_harmony_pure_immunity:GetAbsoluteNoDamagePure()
	return 1
end

modifier_item_wheel_of_harmony_debuff_immunity = class({})

function modifier_item_wheel_of_harmony_debuff_immunity:GetTexture()
	return MODIFIER_TEXTURE_BY_MODE.debuff
end

function modifier_item_wheel_of_harmony_debuff_immunity:IsHidden()
	return false
end

function modifier_item_wheel_of_harmony_debuff_immunity:IsPurgable()
	return false
end

function modifier_item_wheel_of_harmony_debuff_immunity:IsDebuff()
	return false
end

function modifier_item_wheel_of_harmony_debuff_immunity:OnCreated()
	if not IsServer() then
		return
	end

	attach_harmony_particles(self, "debuff")
	self:GetParent():Purge(false, true, false, true, false)
	self:StartIntervalThink(0.1)
end

function modifier_item_wheel_of_harmony_debuff_immunity:OnIntervalThink()
	if IsServer() then
		self:GetParent():Purge(false, true, false, true, false)
	end
end

function modifier_item_wheel_of_harmony_debuff_immunity:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_item_wheel_of_harmony_debuff_immunity:CheckState()
	return {
		[MODIFIER_STATE_DEBUFF_IMMUNE] = true,
	}
end
