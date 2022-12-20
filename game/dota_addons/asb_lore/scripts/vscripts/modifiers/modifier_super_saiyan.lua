modifier_super_saiyan = class({})
function modifier_super_saiyan:IsHidden() return false end
function modifier_super_saiyan:IsDebuff() return true end
function modifier_super_saiyan:IsPurgable() return false end
function modifier_super_saiyan:IsPurgeException() return false end
function modifier_super_saiyan:RemoveOnDeath() return true end
function modifier_super_saiyan:AllowIllusionDuplicate() return true end
function modifier_super_saiyan:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_HEALTH_BONUS,
                     }
    return func
end
function modifier_super_saiyan:GetModifierModelChange()
if IsASBPatreon(self:GetParent()) then
return "models/goku/drip/drip_goku_ss.vmdl"
else
    return "models/goku/goku_ss.vmdl"
	end
end
function modifier_super_saiyan:GetModifierModelScale()
	return 1
end
function modifier_super_saiyan:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('bonus_spd')
end
function modifier_super_saiyan:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end



function modifier_super_saiyan:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()






    
        
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        

       
		
        EmitSoundOn("goku.3", self.parent)
       

        self.parent:Purge(false, true, false, true, true)
    end

function modifier_super_saiyan:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_super_saiyan:GetEffectName()

	return "particles/super_saiyan.vpcf"
	end

