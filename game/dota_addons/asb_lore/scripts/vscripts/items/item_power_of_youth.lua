item_power_of_youth = class({})
LinkLuaModifier("modifier_power_of_youth", "items/item_power_of_youth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_power_of_youth_buff", "items/item_power_of_youth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_power_of_youth_debuff", "items/item_power_of_youth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_power_of_youth_aura", "items/item_power_of_youth", LUA_MODIFIER_MOTION_NONE)
function item_power_of_youth:GetIntrinsicModifierName()
	return "modifier_power_of_youth"
end
function item_power_of_youth:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_power_of_youth_buff", {duration = duration})	
	caster:AddNewModifier(caster, self, "modifier_power_of_youth_aura", {duration = duration})	
end

---------------------------------------------------------------------------------------------------------------------
modifier_power_of_youth = class({})
function modifier_power_of_youth:IsHidden() return true end
function modifier_power_of_youth:IsDebuff() return false end
function modifier_power_of_youth:IsPurgable() return false end
function modifier_power_of_youth:IsPurgeException() return false end
function modifier_power_of_youth:RemoveOnDeath() return false end

function modifier_power_of_youth:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT
					}
	return func
end
function modifier_power_of_youth:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_power_of_youth:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('agility')
end

function modifier_power_of_youth:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
  function modifier_power_of_youth:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('damage')
end    
  function modifier_power_of_youth:GetModifierEvasion_Constant()
return self:GetAbility():GetSpecialValueFor('evasion')
end    

 
---------------------------------------------------------------------------------------------------------------------
modifier_power_of_youth_buff = class({})
function modifier_power_of_youth_buff:IsHidden() return false end
function modifier_power_of_youth_buff:IsDebuff() return false end
function modifier_power_of_youth_buff:IsPurgable() return true end
function modifier_power_of_youth_buff:IsPurgeException() return true end
function modifier_power_of_youth_buff:RemoveOnDeath() return true end
function modifier_power_of_youth_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end
function modifier_power_of_youth_buff:CheckState()
	local state = {
	
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_power_of_youth_buff:GetModifierMoveSpeed_AbsoluteMin()
	 return 550
end
function modifier_power_of_youth_buff:GetEffectName()
	return "particles/power_of_youth.vpcf"
end
function modifier_power_of_youth_buff:GetAbilityTextureName()
	
	return "power_of_youth"
end
function modifier_power_of_youth_buff:OnCreated( kv )
	
		EmitSoundOn("power.of_youth", self:GetParent())
	
end
modifier_power_of_youth_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_power_of_youth_aura:IsHidden()
	return false
end

function modifier_power_of_youth_aura:IsDebuff()
	return false
end

function modifier_power_of_youth_aura:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_power_of_youth_aura:OnCreated( kv )
	-- references
	self.radius = 400
	self.evasion = 100
	

	self.aura_duration = 2.5

end

function modifier_power_of_youth_aura:OnRefresh( kv )
	-- same as oncreated
	self:OnCreated( kv )
end

function modifier_power_of_youth_aura:OnRemoved()
end

function modifier_power_of_youth_aura:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects


-- --------------------------------------------------------------------------------
-- -- Status Effects
-- function modifier_power_of_youth_aura:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_INVULNERABLE] = true,
-- 	}

-- 	return state
-- end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_power_of_youth_aura:IsAura()
	return true
end

function modifier_power_of_youth_aura:GetModifierAura()
	return "modifier_power_of_youth_aura_debuff"
end

function modifier_power_of_youth_aura:GetAuraRadius()
	return self.radius
end

function modifier_power_of_youth_aura:GetAuraDuration()
	return self.aura_duration
end

function modifier_power_of_youth_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_power_of_youth_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Graphics & Animations
modifier_power_of_youth_aura_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_power_of_youth_aura_debuff:IsHidden()
	return false
end

function modifier_power_of_youth_aura_debuff:IsDebuff()
	return true
end

function modifier_power_of_youth_aura_debuff:IsStunDebuff()
	return false
end

function modifier_power_of_youth_aura_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_power_of_youth_aura_debuff:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "enemy_movespeed_bonus_pct" )
end

function modifier_power_of_youth_aura_debuff:OnRefresh( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "enemy_movespeed_bonus_pct" )
end

function modifier_power_of_youth_aura_debuff:OnRemoved()
end

function modifier_power_of_youth_aura_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_power_of_youth_aura_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_power_of_youth_aura_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -50
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_power_of_youth_aura_debuff:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun_slow.vpcf"
end

function modifier_power_of_youth_aura_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
