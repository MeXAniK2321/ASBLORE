item_debate_club = class({})
LinkLuaModifier("modifier_item_debate_club", "items/item_debate_club", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debate_club_debuff", "items/item_debate_club", LUA_MODIFIER_MOTION_NONE)

function item_debate_club:GetIntrinsicModifierName()
	return "modifier_item_debate_club"
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_debate_club = class({})
function modifier_item_debate_club:IsHidden() return true end
function modifier_item_debate_club:IsDebuff() return false end
function modifier_item_debate_club:IsPurgable() return false end
function modifier_item_debate_club:IsPurgeException() return false end
function modifier_item_debate_club:RemoveOnDeath() return false end

---------------------------------------------------------------------------------------------------------------------
function modifier_item_debate_club:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,}
	return func
end
function modifier_item_debate_club:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor('str')
end
  function modifier_item_debate_club:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('armor')
end    
function modifier_item_debate_club:OnAttackLanded(params)
	if IsServer() then
	self.crit_chance = 25
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if RandomInt(0, 100)<self.crit_chance then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_debate_club_debuff", {duration = 2 })
			local damageTable = {
		attacker = self:GetParent(),
		damage = 150,
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
  function modifier_item_debate_club:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end 
  function modifier_item_debate_club:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('bonus_damage')
end 
modifier_debate_club_debuff = class({})

function modifier_debate_club_debuff:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_debate_club_debuff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetParent():IsRangedAttacker() then
	return 0
	else
    return self:GetAbility():GetSpecialValueFor('slow')
	end
end

function modifier_debate_club_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_debate_club_debuff:StatusEffectPriority()
    return 10
end