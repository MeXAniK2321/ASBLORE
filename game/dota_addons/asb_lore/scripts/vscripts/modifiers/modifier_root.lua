modifier_root = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_root:IsHidden()
	return false
end

function modifier_root:IsDebuff()
	return true
end

function modifier_root:IsStunDebuff()
	return false
end

function modifier_root:IsPurgable()
	return true
end

function modifier_root:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_root:OnRefresh( kv )
	
end

function modifier_root:OnRemoved()
end

function modifier_root:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_root:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_root:GetEffectName()
	return "particles/ui_mouseactions/international2020/ping_player_questionmarks.vpcf"
end

function modifier_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end