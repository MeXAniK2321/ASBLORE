LinkLuaModifier("modifier_credit_card", "items/item_credit_card", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_credit_card_stat", "items/item_credit_card", LUA_MODIFIER_MOTION_NONE)

item_credit_card = class({})

function item_credit_card:GetIntrinsicModifierName()
    return "modifier_credit_card"
	end


modifier_credit_card = class({})


function modifier_credit_card:IsHidden()
    return true
end
function modifier_credit_card:RemoveOnDeath() return false end
function modifier_credit_card:IsPurgable()
    return false
end
function modifier_credit_card:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_credit_card:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_credit_card:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
       MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_credit_card:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_credit_card:GetModifierManaBonus()
    return 1000
end

function modifier_credit_card:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_credit_card:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_credit_card:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_credit_card:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_credit_card:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         