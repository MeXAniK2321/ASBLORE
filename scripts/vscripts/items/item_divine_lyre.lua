item_divine_lyre = class({})
LinkLuaModifier("modifier_item_divine_lyre", "items/item_divine_lyre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_divine_lyre_buff", "items/item_divine_lyre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_chance", "items/modifier_debuff_chance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_chance", "items/modifier_buff_chance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_1", "items/modifier_debuff_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_2", "items/modifier_debuff_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_3", "items/modifier_debuff_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_4", "items/modifier_debuff_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_5", "items/modifier_debuff_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_1", "items/modifier_buff_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_2", "items/modifier_buff_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_3", "items/modifier_buff_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_4", "items/modifier_buff_4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_5", "items/modifier_buff_5", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_6", "items/modifier_buff_6", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_7", "items/modifier_buff_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_8", "items/modifier_buff_8", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_9", "items/modifier_buff_9", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_buff_10", "items/modifier_buff_10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event", "items/modifier_event", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event_1", "items/modifier_event_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_event_2", "items/modifier_event_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_6", "items/modifier_debuff_6", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_7", "items/modifier_debuff_7", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_8", "items/modifier_debuff_8", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_9", "items/modifier_debuff_9", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_10", "items/modifier_debuff_10", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_divine_lyre_cd", "items/item_divine_lyre", LUA_MODIFIER_MOTION_NONE)

function item_divine_lyre:GetIntrinsicModifierName()
	return "modifier_item_divine_lyre"
end
function item_divine_lyre:OnSpellStart()
	local caster = self:GetCaster()
	local duration = 60
	
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	local hero = PlayerResource:GetSelectedHeroEntity(PID)
		self.buff_chance = 20


	self.event = 1


	
	
	
	
	
	
	if RollPercentage(self.buff_chance) then
    	caster:AddNewModifier(caster, self, "modifier_debuff_chance", {duration = duration})
   	
	
   	
elseif RollPercentage(self.event) then
    	caster:AddNewModifier(caster, self, "modifier_event", {duration = 60})
   	else
  
    	caster:AddNewModifier(caster, self, "modifier_buff_chance", {duration = duration})
   	end
	EmitSoundOn("lyre.casino", caster)
	
	
	
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_divine_lyre = class({})
function modifier_item_divine_lyre:IsHidden() return true end
function modifier_item_divine_lyre:IsDebuff() return false end
function modifier_item_divine_lyre:IsPurgable() return false end
function modifier_item_divine_lyre:IsPurgeException() return false end
function modifier_item_divine_lyre:RemoveOnDeath() return false end

function modifier_item_divine_lyre:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_divine_lyre:DeclareFunctions()
	local func = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		 MODIFIER_PROPERTY_MANA_BONUS,
				
					}
	return func
end
function modifier_item_divine_lyre:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end
function modifier_item_divine_lyre:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_divine_lyre:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_divine_lyre:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_item_divine_lyre:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end     

function modifier_item_divine_lyre:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_divine_lyre:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_divine_lyre:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end



---------------------------------------------------------------------------------------------------------------------
modifier_item_divine_lyre_cd = class({})
function modifier_item_divine_lyre_cd:IsHidden() return true end
function modifier_item_divine_lyre_cd:IsDebuff() return false end
function modifier_item_divine_lyre_cd:IsPurgable() return false end
function modifier_item_divine_lyre_cd:IsPurgeException() return false end
function modifier_item_divine_lyre_cd:RemoveOnDeath() return true end