modifier_chronosphere_speed_lua = class({})

--[[Author: Perry,Noya
	Date: 26.09.2015.
	Removes the movement speed limit and applies the chronosphere effect]]
function modifier_chronosphere_speed_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}

	return funcs
end
function modifier_chronosphere_speed_lua:GetModifierProcAttack_BonusDamage_Magical()
	return 400
end

function modifier_chronosphere_speed_lua:GetModifierMoveSpeed_Limit()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_chronosphere_speed_lua:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_chronosphere_speed_lua:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("speed")
end


function modifier_chronosphere_speed_lua:CheckState()
	local state = {
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}

	return state
end

function modifier_chronosphere_speed_lua:IsHidden()
	return true
end

function modifier_chronosphere_speed_lua:OnCreated()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_arcana_base_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.nFXIndex, false, false, -1, false, false)
	end
end