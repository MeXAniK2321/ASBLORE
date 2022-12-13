modifier_muted = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_muted:IsDebuff()
	return true
end

function modifier_muted:IsStunDebuff()
	return false
end

function modifier_muted:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_muted:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics and animations
function modifier_muted:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_muted:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end