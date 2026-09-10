-- Shared utility functions for Wheel of Harmony items
local M = {}

M.SWITCH_PARTICLE = "particles/items/makora/makora_wheel.vpcf"
M.PHYSICAL_IMMUNITY_PARTICLE = "particles/items/makora/wheel3.vpcf"
M.MAGICAL_IMMUNITY_PARTICLE = "particles/items/makora/wheel2.vpcf"
M.PURE_IMMUNITY_PARTICLE = "particles/items/makora/wheel1.vpcf"
M.DEBUFF_IMMUNITY_PARTICLE = "particles/items/makora/wheel4.vpcf"
M.HARMONY_SOUND = "mahoraga"

M.ITEM_CYCLE = {
	item_wheel_physic = "item_wheel_magic",
	item_wheel_magic = "item_wheel_pure",
	item_wheel_pure = "item_wheel_effect",
	item_wheel_effect = "item_wheel_physic",
}

function M.get_next_item_name(current_item_name)
	return M.ITEM_CYCLE[current_item_name]
end

function M.attach_particle(particle_path, unit)
	if not unit or unit:IsNull() then return nil end
	local particle = ParticleManager:CreateParticle(particle_path, PATTACH_ABSORIGIN_FOLLOW, unit)
	return particle
end

function M.play_switch_effects(unit)
	if not unit or unit:IsNull() then return end
	local npfx = M.attach_particle(M.SWITCH_PARTICLE, unit)
	ParticleManager:ReleaseParticleIndex(npfx)
	EmitSoundOn(M.HARMONY_SOUND, unit)
end

function M.get_proc_cooldown_remaining(ability)
	if not ability or ability:IsNull() then return 0 end
	return ability:GetCooldownTimeRemaining()
end

function M.start_proc_cooldown(ability, duration)
	if not ability or ability:IsNull() then return end
	local nReduction = M.get_cooldown_reduction_factor(ability:GetCaster())

	ability:EndCooldown()
	ability:StartCooldown(duration * nReduction)
end

function M.get_cooldown_reduction_factor(caster)
	if not caster or caster:IsNull() or not caster.GetCooldownReduction then return 1 end
	local ok, value = pcall(function() return tonumber(caster:GetCooldownReduction() or 0) or 0 end)
	local factor = ok and value or 0
	if factor <= 0 then return 1 end
	return factor
end

function M.get_effective_cooldown(caster, base_cooldown)
	local cooldown = math.max(0, tonumber(base_cooldown or 0) or 0)
	if cooldown <= 0 then return 0 end
	return cooldown * M.get_cooldown_reduction_factor(caster)
end

function M.find_item_slot(caster, item)
	if not caster or caster:IsNull() or not caster.GetItemInSlot then return nil end
	for slot = 0, 19 do
		if caster:GetItemInSlot(slot) == item then return slot end
	end
	return nil
end

function M.is_enemy_source(parent, source)
	if not source or (source.IsNull and source:IsNull()) or source == parent then return false end
	if not source.GetTeamNumber then return false end
	return source:GetTeamNumber() ~= parent:GetTeamNumber()
end

function M.switch_to_next_mode(ability)
	if not IsServer() or not ability or ability:IsNull() then return false end
	
	local caster = ability:GetCaster()
	if not caster or caster:IsNull() then return false end
	
	local ability_name = ability:GetAbilityName()
	local next_item_name = M.get_next_item_name(ability_name)
	if not next_item_name then return false end
	
	if M.get_proc_cooldown_remaining(ability) > 0 then return false end
	
	local original_slot = M.find_item_slot(caster, ability)
	if original_slot == nil then return false end
	
	local purchase_time = tonumber(ability:GetPurchaseTime() or 0) or 0
	local charges = tonumber(ability:GetCurrentCharges() or 0) or 0
	-- local proc_cooldown_remaining = M.get_proc_cooldown_remaining(ability)
	local switch_cooldown = ability:GetSpecialValueFor("switch_cooldown")
	
	M.play_switch_effects(caster)
	
	UTIL_Remove(ability)
	-- caster:RemoveItem(ability)
	
	local new_item = CreateItem(next_item_name, caster, caster)
	if not new_item or new_item:IsNull() then return false end
	
	if purchase_time > 0 then new_item:SetPurchaseTime(purchase_time) end
	if charges > 0 then new_item:SetCurrentCharges(charges) end
	
	caster:AddItem(new_item)
	
	-- if proc_cooldown_remaining > 0 then M.start_proc_cooldown(new_item, proc_cooldown_remaining) end
	if switch_cooldown > 0 then
		M.start_proc_cooldown(new_item, switch_cooldown)
	end
	
	local new_slot = M.find_item_slot(caster, new_item)
	if new_slot ~= nil and new_slot ~= original_slot then
		caster:SwapItems(original_slot, new_slot)
	end
	
	return true
end

_G.WheelUtil = M