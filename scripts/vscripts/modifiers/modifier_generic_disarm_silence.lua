modifier_generic_disarm_silence = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_disarm_silence:IsDebuff()
	return true
end

function modifier_generic_disarm_silence:IsStunDebuff()
	return false
end

function modifier_generic_disarm_silence:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_generic_disarm_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics and animations
function modifier_generic_disarm_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_generic_disarm_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end