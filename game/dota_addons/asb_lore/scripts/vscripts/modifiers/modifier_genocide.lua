modifier_genocide = class({})
function modifier_genocide:IsHidden() return false end
function modifier_genocide:IsDebuff() return true end
function modifier_genocide:IsPurgable() return false end
function modifier_genocide:IsPurgeException() return false end
function modifier_genocide:RemoveOnDeath() return false end
function modifier_genocide:AllowIllusionDuplicate() return true end

function modifier_genocide:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["compliment"] = "knife_play",
                            ["frisk_analys"] = "rip_and_tear",
							["frisk_mercy"] = "silent_kill",
							["hopes_and_dreams"] = "little_devil"
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            EmitSoundOn("chara.idea", self.parent)
        
end
end

function modifier_genocide:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_genocide:GetEffectName()
	return "particles/genocide_aura.vpcf"
end

function modifier_genocide:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_genocide:DeclareFunctions()
    local funcs = {
       
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
 
    }

    return funcs
end

function modifier_genocide:GetModifierBonusStats_Agility()
    return 40
end




modifier_genocide_complited = class({})
function modifier_genocide_complited:IsHidden() return false end
function modifier_genocide_complited:IsDebuff() return true end
function modifier_genocide_complited:IsPurgable() return false end
function modifier_genocide_complited:IsPurgeException() return false end
function modifier_genocide_complited:RemoveOnDeath() return false end
function modifier_genocide_complited:AllowIllusionDuplicate() return true end

function modifier_genocide_complited:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                }
    return func
end


function modifier_genocide_complited:GetModifierModelChange()

    
	return "models/frisk/chara.vmdl"

end

function modifier_genocide_complited:GetEffectName()
	return "particles/genocide_complited.vpcf"
end