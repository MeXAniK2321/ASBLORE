modifier_super_saiyan2 = class({})
function modifier_super_saiyan2:IsHidden() return false end
function modifier_super_saiyan2:IsDebuff() return true end
function modifier_super_saiyan2:IsPurgable() return false end
function modifier_super_saiyan2:IsPurgeException() return false end
function modifier_super_saiyan2:RemoveOnDeath() return not self:GetParent():HasShard() end
function modifier_super_saiyan2:AllowIllusionDuplicate() return true end
function modifier_super_saiyan2:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_HEALTH_BONUS,
                     }
    return func
end
function modifier_super_saiyan2:GetModifierModelChange()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
if IsASBPatreon(self:GetParent()) then
return "models/goku/drip/drip_goku_ss_blue.vmdl"
else
     return "models/goku/goku_ss_blue.vmdl"
	 end
else
if IsASBPatreon(self:GetParent()) then
return "models/goku/drip/drip_goku_ss.vmdl"
else
    return "models/goku/goku_ss3.vmdl"
	end
end
end
function modifier_super_saiyan2:GetModifierModelScale()
	return 1
end

function modifier_super_saiyan2:GetModifierHealthBonus()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
return self:GetAbility():GetSpecialValueFor('bonus_hp') + 100
else
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
	end
end
function modifier_super_saiyan2:GetModifierSpellAmplify_Percentage()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
return 25
else
return self:GetAbility():GetSpecialValueFor('bonus_spd')
end
end



function modifier_super_saiyan2:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    if not IsServer() then return end




    
        
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        

       
		
        EmitSoundOn("goku.3", self.parent)
       

        self.parent:Purge(false, true, false, true, true)
    end

function modifier_super_saiyan2:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_super_saiyan2:GetEffectName()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
      return "particles/goku_ss_blue.vpcf"
  else
	return "particles/super_saiyan_level2.vpcf"
	
end
end