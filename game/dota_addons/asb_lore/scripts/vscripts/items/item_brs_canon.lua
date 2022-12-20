LinkLuaModifier("modifier_brs_canon", "items/item_brs_canon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brs_canon_stat", "items/item_brs_canon", LUA_MODIFIER_MOTION_NONE)

item_brs_canon = class({})

function item_brs_canon:GetIntrinsicModifierName()
    return "modifier_brs_canon"
	end


modifier_brs_canon = class({})


function modifier_brs_canon:IsHidden()
    return true
end
function modifier_brs_canon:RemoveOnDeath() return false end
function modifier_brs_canon:IsPurgable()
    return false
end
function modifier_brs_canon:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_brs_canon:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_brs_canon:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_brs_canon:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_brs_canon:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_brs_canon:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_brs_canon:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_brs_canon:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_brs_canon:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
  function modifier_brs_canon:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('res')
end
                      