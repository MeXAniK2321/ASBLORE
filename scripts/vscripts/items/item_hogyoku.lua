LinkLuaModifier("modifier_hogyoku", "items/item_hogyoku", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hogyoku_stat", "items/item_hogyoku", LUA_MODIFIER_MOTION_NONE)

item_hogyoku = class({})

function item_hogyoku:GetIntrinsicModifierName()
    return "modifier_hogyoku"
	end


modifier_hogyoku = class({})


function modifier_hogyoku:IsHidden()
    return true
end
function modifier_hogyoku:RemoveOnDeath() return false end
function modifier_hogyoku:IsPurgable()
    return false
end
function modifier_hogyoku:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_hogyoku:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_hogyoku:DeclareFunctions()
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

function modifier_hogyoku:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_hogyoku:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_hogyoku:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_hogyoku:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_hogyoku:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_hogyoku:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_hogyoku:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         