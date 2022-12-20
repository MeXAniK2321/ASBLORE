modifier_c4_replace = class({})
function modifier_c4_replace:IsHidden() return true end
function modifier_c4_replace:IsDebuff() return true end
function modifier_c4_replace:IsPurgable() return false end
function modifier_c4_replace:IsPurgeException() return false end
function modifier_c4_replace:RemoveOnDeath() return false end
function modifier_c4_replace:AllowIllusionDuplicate() return true end

function modifier_c4_replace:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["c1_spider"] = "deidara_c4",
                            
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    
                end
            end
        end
           
        
end
end

function modifier_c4_replace:OnRefresh(table)
    self:OnCreated(table)
end
