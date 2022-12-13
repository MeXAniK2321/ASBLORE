
modifier_storyshift = class({})

--------------------------------------------------------------------------------
function modifier_storyshift:IsHidden()
	return true
end

function modifier_storyshift:IsDebuff()
	return false
end

function modifier_storyshift:IsPurgable()
	return false
end

function modifier_storyshift:RemoveOnDeath()
	return false
end
function modifier_storyshift:AllowIllusionDuplicate()
 return false 
 end