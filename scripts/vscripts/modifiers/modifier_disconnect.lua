modifier_disconnect = class({})

function modifier_disconnect:IsHidden()
	return true
end

function modifier_disconnect:CheckState()
	
	local state =
	{
		[MODIFIER_PROPERTY_DISABLE_HEALING] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end



function modifier_disconnect:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_disconnect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

