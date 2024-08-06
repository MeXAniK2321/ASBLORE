item_paimon = item_paimon or class({})
LinkLuaModifier("modifier_paimon", "items/item_paimon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paimon_buff", "items/item_paimon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paimon_debuff", "items/item_paimon", LUA_MODIFIER_MOTION_NONE)

function item_paimon:GetIntrinsicModifierName()
	return "modifier_paimon"
end
function item_paimon:OnSpellStart()
    if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_paimon_buff")  then
    else
      self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_paimon_buff", {} )
      local sound_cast = "paimon.scream"
	  EmitSoundOn( sound_cast, self:GetCaster() )
      self:SpendCharge(0)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_paimon = modifier_paimon or class({})

function modifier_paimon:IsHidden() return true end
function modifier_paimon:IsDebuff() return false end
function modifier_paimon:IsPurgable() return false end
function modifier_paimon:IsPurgeException() return false end
function modifier_paimon:RemoveOnDeath() return false end
function modifier_paimon:CheckState()
	local state = {
		              [MODIFIER_STATE_CANNOT_MISS] = true,
	              }

	return state
end
function modifier_paimon:DeclareFunctions()
	local func = {	
				     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
				     MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
				     MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
				     MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				     MODIFIER_EVENT_ON_ATTACK_LANDED,
				     MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
				     MODIFIER_PROPERTY_MANA_BONUS,
				     MODIFIER_PROPERTY_HEALTH_BONUS,
				     MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
				     MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
				     MODIFIER_PROPERTY_CAST_RANGE_BONUS,
				     MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
				 }
	
	return func
end
function modifier_paimon:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('str')
end
function modifier_paimon:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('damage')
end 
function modifier_paimon:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('stat')
end
function modifier_paimon:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('stat')
end
function modifier_paimon:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('damage')
end    
function modifier_paimon:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then		
			if not params.attacker:IsIllusion() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_paimon_debuff", {duration = 1.5 })
			end
		end
	end
end
function modifier_paimon:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end
function modifier_paimon:GetModifierPercentageCooldown()
    if self:GetParent():HasItemInInventory("item_octarine_core") or self:GetParent():HasItemInInventory("item_watch") then return 0 end
    self.cd = self:GetAbility():GetSpecialValueFor('cd')
    return self.cd
end
function modifier_paimon:GetModifierPercentageManacost()
    return self:GetAbility():GetSpecialValueFor('reduce_mana')
end


modifier_paimon_debuff = modifier_paimon_debuff or class({})

function modifier_paimon_debuff:DeclareFunctions()
    local funcs = {
		              MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		              MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                  }

    return funcs
end
function modifier_paimon_debuff:GetModifierAttackSpeedBonus_Constant()
    return -60
end
function modifier_paimon_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -15
end
function modifier_paimon_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end
function modifier_paimon_debuff:StatusEffectPriority()
    return 10
end
 
---------------------------------------------------------------------------------------------------------------------
modifier_paimon_buff = modifier_paimon_buff or class({})

function modifier_paimon_buff:IsHidden() return false end
function modifier_paimon_buff:IsDebuff() return false end
function modifier_paimon_buff:IsPurgable() return false end
function modifier_paimon_buff:IsPurgeException() return false end
function modifier_paimon_buff:RemoveOnDeath() return false end
function modifier_paimon_buff:CheckState()
	local state = {
		              [MODIFIER_STATE_CANNOT_MISS] = true,
	              }

	return state
end
function modifier_paimon_buff:DeclareFunctions()
	local func = {		
		             MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
				 }
	return func
end
function modifier_paimon_buff:GetModifierPercentageCooldown()
    if self:GetParent():HasItemInInventory("item_octarine_core") or self:GetParent():HasItemInInventory("item_watch") or self:GetParent():HasItemInInventory("item_paimon") then return 0 end
	self.cd = 15
    return self.cd
end
function modifier_paimon_buff:GetAbilityTextureName()
	return "paimon"
end
