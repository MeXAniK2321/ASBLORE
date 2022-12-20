modifier_generic_stunned_invul_lua = class({})

--------------------------------------------------------------------------------

function modifier_generic_stunned_invul_lua:IsDebuff()
	return true
end

function modifier_generic_stunned_invul_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_generic_stunned_invul_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_generic_stunned_invul_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
function modifier_generic_stunned_invul_lua:GetModifierMoveSpeedBonus_Percentage()
	return -100
end
--------------------------------------------------------------------------------

function modifier_generic_stunned_invul_lua:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_generic_stunned_invul_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end