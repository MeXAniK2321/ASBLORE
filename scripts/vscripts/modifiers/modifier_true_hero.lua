modifier_true_hero = class({})
function modifier_true_hero:IsHidden() return true end
function modifier_true_hero:IsDebuff() return true end
function modifier_true_hero:IsPurgable() return false end
function modifier_true_hero:IsPurgeException() return false end
function modifier_true_hero:RemoveOnDeath() return false end
function modifier_true_hero:AllowIllusionDuplicate() return true end

function modifier_true_hero:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["compliment"] = "knife_dance",
                            ["frisk_analys"] = "chocolate",
							["frisk_mercy"] = "mercyfull_reaper",
							["hopes_and_dreams"] = "devilovania"
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

function modifier_true_hero:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_true_hero:GetEffectName()
	return "particles/true_hero_aura.vpcf"
end

function modifier_true_hero:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end