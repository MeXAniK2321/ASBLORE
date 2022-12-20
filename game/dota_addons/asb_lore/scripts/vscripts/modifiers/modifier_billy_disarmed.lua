modifier_billy_disarmed = class({})

--------------------------------------------------------------------------------

function modifier_billy_disarmed:IsDebuff()
	return true
end

function modifier_billy_disarmed:IsStunDebuff()
	return true
end
function modifier_billy_disarmed:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_billy_disarmed:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_billy_disarmed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_billy_disarmed:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_billy_disarmed:GetEffectName()
	return "particles/billy_disarmed.vpcf"
end

function modifier_billy_disarmed:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end