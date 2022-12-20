modifier_throw_screw = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_throw_screw:IsDebuff()
	return true
end

function modifier_throw_screw:IsStunDebuff()
	return false
end

function modifier_throw_screw:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_throw_screw:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics and animations
function modifier_throw_screw:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_throw_screw:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end