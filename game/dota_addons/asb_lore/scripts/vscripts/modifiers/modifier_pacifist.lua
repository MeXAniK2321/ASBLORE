modifier_pacifist = class({})
function modifier_pacifist:IsHidden() return false end
function modifier_pacifist:IsPurgable() return false end
function modifier_pacifist:IsPurgeException() return false end
function modifier_pacifist:RemoveOnDeath() return false end
function modifier_pacifist:AllowIllusionDuplicate() return true end

function modifier_pacifist:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_pacifist:GetEffectName()
	return "particles/pacifist_aura.vpcf"
end

function modifier_pacifist:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_pacifist:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            
							["determination"] = "frisk_return"
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
           
        
end
end
function modifier_pacifist:DeclareFunctions()
	local funcs = {
		
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end


function modifier_pacifist:GetModifierDamageOutgoing_Percentage()
	return -100
end