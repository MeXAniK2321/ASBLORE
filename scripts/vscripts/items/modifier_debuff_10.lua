modifier_debuff_10 = class({})

function modifier_debuff_10:IsHidden()
	return false
end
function modifier_debuff_10:RemoveOnDeath() return false end
function modifier_debuff_10:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_10:IsPurgable()
    return false
end
function modifier_debuff_10:OnCreated(table)
	local delay = 0.2
	Timers:CreateTimer(delay,function()
	self:GetParent():Kill(self, self:GetParent()) end)
	
end


function modifier_debuff_10:GetTexture()
	return "note"
end
function modifier_debuff_10:GetEffectName()
	return "particles/event_ghoul.vpcf"
end