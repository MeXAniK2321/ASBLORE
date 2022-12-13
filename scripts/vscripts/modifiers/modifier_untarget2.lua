modifier_untarget2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_untarget2:IsHidden()
	return false
end

function modifier_untarget2:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_untarget2:IsStunDebuff()
	return false
end

function modifier_untarget2:IsPurgable()
	return false
end

function modifier_untarget2:RemoveOnDeath()
	return false
end




function modifier_untarget2:OnRemoved()
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_untarget2:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end

