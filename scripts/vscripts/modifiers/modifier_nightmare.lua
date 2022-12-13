
modifier_nightmare = class({})

--------------------------------------------------------------------------------
function modifier_nightmare:IsHidden()
	return true
end

function modifier_nightmare:IsDebuff()
	return false
end

function modifier_nightmare:IsPurgable()
	return false
end

function modifier_nightmare:RemoveOnDeath()
	return false
end
function modifier_nightmare:AllowIllusionDuplicate()
 return false 
 end