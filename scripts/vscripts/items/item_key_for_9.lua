LinkLuaModifier("modifier_key_for_9", "items/item_key_for_9", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_key_for_9_stat", "items/item_key_for_9", LUA_MODIFIER_MOTION_NONE)

item_key_for_9 = class({})

function item_key_for_9:GetIntrinsicModifierName()
    return "modifier_key_for_9"
	end


modifier_key_for_9 = class({})


function modifier_key_for_9:IsHidden()
    return true
end

function modifier_key_for_9:IsPurgable()

    return false
end
function modifier_key_for_9:RemoveOnDeath() return false end
function modifier_key_for_9:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_key_for_9:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_key_for_9:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_key_for_9:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_key_for_9:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_key_for_9:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_key_for_9:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_key_for_9:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_key_for_9:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_key_for_9:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('arm')
end                         