require("items/makora_fix/util")

LinkLuaModifier("modifier_wheel_physic_passive", "items/makora_fix/wheel_physic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wheel_physic_immunity", "items/makora_fix/wheel_physic.lua", LUA_MODIFIER_MOTION_NONE)

item_wheel_physic = class({})

function item_wheel_physic:GetIntrinsicModifierName()
	return "modifier_wheel_physic_passive"
end

function item_wheel_physic:OnSpellStart()
	if self.EndCooldown then self:EndCooldown() end
   WheelUtil.switch_to_next_mode(self)
end

modifier_wheel_physic_passive = class({})

function modifier_wheel_physic_passive:IsHidden() return true end
function modifier_wheel_physic_passive:IsPurgable() return false end
function modifier_wheel_physic_passive:RemoveOnDeath() return false end
function modifier_wheel_physic_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_wheel_physic_passive:OnCreated()
	self.damage_events = {}
	local ability = self:GetAbility()
	if ability then
		self.immunity_duration = ability:GetSpecialValueFor("duration")
		self.counter_window = ability:GetSpecialValueFor("counter_window")
		self.cooldown_time = ability:GetSpecialValueFor("adaptation_cooldown")
		self.threshold = ability:GetSpecialValueFor("physical_threshold")
		self.damage_resist = ability:GetSpecialValueFor("wheel_physical_damage_resistance")
	end
	if IsServer() then self:StartIntervalThink(0.1) end
end

function modifier_wheel_physic_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_AVOID_DAMAGE_AFTER_REDUCTIONS,
	}
end

function modifier_wheel_physic_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_wheel_physic_passive:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_wheel_physic_passive:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_wheel_physic_passive:GetModifierIncomingDamage_Percentage(params)
	if params and params.damage_type == DAMAGE_TYPE_PHYSICAL then
		return -(self.damage_resist or 0)
	end
	return 0
end

function modifier_wheel_physic_passive:HasImmunity()
	return self:GetParent():HasModifier("modifier_wheel_physic_immunity")
end

function modifier_wheel_physic_passive:CanTriggerImmunity()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not ability or ability:IsNull() or not parent or parent:IsNull() then return false end
	if WheelUtil.get_proc_cooldown_remaining(ability) > 0 then return false end
	if parent.IsIllusion and parent:IsIllusion() then return false end
	return not self:HasImmunity()
end

function modifier_wheel_physic_passive:GetModifierAvoidDamageAfterReductions(params)
	if not IsServer() then return end
	local parent = self:GetParent()
	if not self:CanTriggerImmunity() then return end
	if not WheelUtil.is_enemy_source(parent, params.attacker) then return end
	if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

	local now = GameRules:GetGameTime() or 0
	table.insert(self.damage_events, {time = now, damage = params.damage})
	
	local window_start = now - (self.counter_window or 6)
	local i = 1
	while i <= #self.damage_events do
		if self.damage_events[i].time < window_start then
			table.remove(self.damage_events, i)
		else
			i = i + 1
		end
	end
	
	local total = 0
	for _, event in ipairs(self.damage_events) do
		total = total + event.damage
	end
	
	if total >= (self.threshold or 1000) then
		self.damage_events = {}
		self:ActivateImmunity()
		return 1
	end
end

function modifier_wheel_physic_passive:ActivateImmunity()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not ability or ability:IsNull() or not parent or parent:IsNull() then return end
	WheelUtil.start_proc_cooldown(ability, self.cooldown_time or 40)
	local duration = self.immunity_duration or 5
	parent:AddNewModifier(parent, ability, "modifier_wheel_physic_immunity", {duration = duration})
	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", parent)
end

modifier_wheel_physic_immunity = class({})

function modifier_wheel_physic_immunity:GetTexture() return "item_wheel_phys" end
function modifier_wheel_physic_immunity:IsHidden() return false end
function modifier_wheel_physic_immunity:IsPurgable() return false end

function modifier_wheel_physic_immunity:OnCreated()
	if IsServer() then
		self.PFX = WheelUtil.attach_particle(WheelUtil.PHYSICAL_IMMUNITY_PARTICLE, self:GetParent())
		self:AddParticle(self.PFX, false, false, -1, false, false)
	end
end

function modifier_wheel_physic_immunity:DeclareFunctions()
	return { MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL }
end

function modifier_wheel_physic_immunity:GetAbsoluteNoDamagePhysical() return 1 end