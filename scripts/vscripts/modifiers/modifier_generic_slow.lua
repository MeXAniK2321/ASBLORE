modifier_generic_slow = class({})

--------------------------------------------------------------------------------

function modifier_generic_slow:IsDebuff()
	return true
end

function modifier_generic_slow:IsStunDebuff()
	return false
end
function modifier_generic_slow:IsHidden()
	return false
end
function modifier_generic_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_generic_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_generic_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor('slow')
end

--------------------------------------------------------------------------------

function modifier_generic_slow:GetEffectName()
	return "particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow_caster_ember.vpcf"
end

function modifier_generic_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end