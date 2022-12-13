LinkLuaModifier("modifier_homuras_shield", "items/item_homuras_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_homuras_shield_stat", "items/item_homuras_shield", LUA_MODIFIER_MOTION_NONE)

item_homuras_shield = class({})

function item_homuras_shield:GetIntrinsicModifierName()
    return "modifier_homuras_shield"
	end


modifier_homuras_shield = class({})


function modifier_homuras_shield:IsHidden()
    return true
end
function modifier_homuras_shield:RemoveOnDeath() return false end
function modifier_homuras_shield:IsPurgable()
    return false
end
function modifier_homuras_shield:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_homuras_shield:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_homuras_shield:DeclareFunctions()
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

function modifier_homuras_shield:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_homuras_shield:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_homuras_shield:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_homuras_shield:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_homuras_shield:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_homuras_shield:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_homuras_shield:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         