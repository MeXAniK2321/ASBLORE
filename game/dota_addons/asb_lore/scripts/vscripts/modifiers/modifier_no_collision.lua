modifier_no_collision = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_no_collision:IsHidden()
	return false
end

function modifier_no_collision:IsDebuff()
	return true
end

function modifier_no_collision:IsStunDebuff()
	return false
end

function modifier_no_collision:IsPurgable()
	return true
end

function modifier_no_collision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_no_collision:OnRefresh( kv )
	
end

function modifier_no_collision:OnRemoved()
end

function modifier_no_collision:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_no_collision:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end


