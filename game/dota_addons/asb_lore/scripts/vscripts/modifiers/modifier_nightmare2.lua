modifier_nightmare2 = class({})
function modifier_nightmare2:IsHidden() return true end
function modifier_nightmare2:IsDebuff() return true end
function modifier_nightmare2:IsPurgable() return false end
function modifier_nightmare2:IsPurgeException() return false end
function modifier_nightmare2:RemoveOnDeath() return false end
function modifier_nightmare2:AllowIllusionDuplicate() return true end

function modifier_nightmare2:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["un_owen_was_her"] = "lunatic_nightmare",
							["blood_queen"] = "sin_blood_pact",
                            
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

function modifier_nightmare2:OnRefresh(table)
    self:OnCreated(table)
end
