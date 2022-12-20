modifier_super_saiyan4 = class({})
function modifier_super_saiyan4:IsHidden() return true end
function modifier_super_saiyan4:IsDebuff() return true end
function modifier_super_saiyan4:IsPurgable() return false end
function modifier_super_saiyan4:IsPurgeException() return false end
function modifier_super_saiyan4:RemoveOnDeath() return true end
function modifier_super_saiyan4:AllowIllusionDuplicate() return true end
function modifier_super_saiyan4:OnCreated()
if IsServer() then
        local ability = self:GetParent():FindAbilityByName("ultra_instinct")
        if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
end
function modifier_super_saiyan4:OnDestroy()
if IsServer() then
        local ability = self:GetParent():FindAbilityByName("ultra_instinct")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
end