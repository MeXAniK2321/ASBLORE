item_rebellion = class({})
LinkLuaModifier("modifier_rebellion", "items/item_rebellion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rebellion_buff", "items/item_rebellion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_rebellion_debuff", "items/item_rebellion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rebellion_aura", "items/item_rebellion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rebellion_aura_debuff", "items/item_rebellion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rebellion_passive_debuff", "items/item_rebellion", LUA_MODIFIER_MOTION_NONE)
function item_rebellion:GetIntrinsicModifierName()
	return "modifier_rebellion"
end
function item_rebellion:OnSpellStart()
local caster = self:GetCaster()
   caster:Purge(false, true, false, true, true)
	  if not IsServer() then return nil end
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb(self) then return end
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_rebellion_debuff", {duration = 2.5})

 EmitSoundOn("kyoka.use", caster)
end

---------------------------------------------------------------------------------------------------------------------
modifier_rebellion = class({})
function modifier_rebellion:IsHidden() return true end
function modifier_rebellion:IsDebuff() return false end
function modifier_rebellion:IsPurgable() return false end
function modifier_rebellion:IsPurgeException() return false end
function modifier_rebellion:RemoveOnDeath() return false end
function modifier_rebellion:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end 
function modifier_rebellion:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					}
	return func
end

function modifier_rebellion:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 25
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_rebellion_passive_debuff", {duration = 1.0 })
			local damageTable = {
		attacker = self:GetParent(),
		damage = 175,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:GetParent():EmitSound("bonk")
			end
		end
	end
	end
end

function modifier_rebellion:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end

 function modifier_rebellion:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor('str')
end
  function modifier_rebellion:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('armor')
end   
---------------------------------------------------------------------------------------------------------------------
  function modifier_rebellion:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('damage')
end 


modifier_item_rebellion_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_rebellion_debuff:IsHidden()
	return false
end

function modifier_item_rebellion_debuff:IsDebuff()
	return true
end

function modifier_item_rebellion_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_rebellion_debuff:OnCreated( kv )

	self:StartIntervalThink( 0.2 )


end

function modifier_item_rebellion_debuff:OnRefresh( kv )

end

function modifier_item_rebellion_debuff:OnRemoved()
end

function modifier_item_rebellion_debuff:OnDestroy()

end

--------------------------------------------------------------------------------
function modifier_item_rebellion_debuff:DeclareFunctions()
	local func = {					
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					}
	return func
end
function modifier_item_rebellion_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -30
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_item_rebellion_debuff:OnIntervalThink()

	self:GetParent():Purge(true, false, false, false, false)
	end



function modifier_item_rebellion_debuff:GetEffectName()
	return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end

function modifier_item_rebellion_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_rebellion_passive_debuff = class({})

function modifier_rebellion_passive_debuff:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_rebellion_passive_debuff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():IsRangedAttacker() then
	return 0
	else
    return self:GetAbility():GetSpecialValueFor('slow')
	end
end

function modifier_rebellion_passive_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_rebellion_passive_debuff:StatusEffectPriority()
    return 10
end
