modifier_untarget = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_untarget:IsHidden()
	return false
end

function modifier_untarget:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_untarget:IsStunDebuff()
	return false
end

function modifier_untarget:IsPurgable()
	return false
end

function modifier_untarget:RemoveOnDeath()
	return false
end




function modifier_untarget:OnRemoved()
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_untarget:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

