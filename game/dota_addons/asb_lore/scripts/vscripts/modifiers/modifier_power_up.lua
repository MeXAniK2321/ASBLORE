modifier_power_up = class({})
function modifier_power_up:IsHidden() return false end
function modifier_power_up:IsDebuff() return false end
function modifier_power_up:IsPurgable() return true end
function modifier_power_up:IsPurgeException() return true end
function modifier_power_up:RemoveOnDeath() return true end
function modifier_power_up:OnCreated( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor('ms') + self:GetCaster():FindTalentValue("special_bonus_issei_25")


	
end

function modifier_power_up:OnRefresh( kv )
	-- get reference
	self.bonus = self:GetAbility():GetSpecialValueFor('ms') + self:GetCaster():FindTalentValue("special_bonus_issei_25")

end
function modifier_power_up:DeclareFunctions()
	local func = {	
					
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					
					}
	return func
end

function modifier_power_up:GetModifierConstantHealthRegen()
    return 100
end
function modifier_power_up:GetModifierMoveSpeedBonus_Constant()
   
	return 60
	end

function modifier_power_up:GetModifierPhysicalArmorBonus()

    
	return 15

	
end


function modifier_power_up:GetEffectName()
	return "particles/issei_power_up.vpcf"
end
function modifier_power_up:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end