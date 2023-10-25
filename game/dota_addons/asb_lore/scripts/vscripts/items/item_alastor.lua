LinkLuaModifier("modifier_alastor", "items/item_alastor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alastor_stat", "items/item_alastor", LUA_MODIFIER_MOTION_NONE)

item_alastor = item_alastor or class({})

function item_alastor:GetIntrinsicModifierName()
    return "modifier_alastor"
end


modifier_alastor = modifier_alastor or class({})

function modifier_alastor:IsHidden() return true end
function modifier_alastor:RemoveOnDeath() return false end
function modifier_alastor:IsPurgable() return false end
function modifier_alastor:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_alastor:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_alastor:DeclareFunctions()
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
function modifier_alastor:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end
function modifier_alastor:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_alastor:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_alastor:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_alastor:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_alastor:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor('amp')
end
function modifier_alastor:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor('arm')
end                         