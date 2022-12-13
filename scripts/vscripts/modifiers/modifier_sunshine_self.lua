modifier_sunshine_self = class({})
function modifier_sunshine_self:IsHidden() return true end
function modifier_sunshine_self:IsDebuff() return false end
function modifier_sunshine_self:IsPurgable() return false end
function modifier_sunshine_self:IsPurgeException() return true end
function modifier_sunshine_self:RemoveOnDeath() return false end
function modifier_sunshine_self:AllowIllusionDuplicate() return true end
function modifier_sunshine_self:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                     }
    return func
end

function modifier_sunshine_self:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('str')
end
