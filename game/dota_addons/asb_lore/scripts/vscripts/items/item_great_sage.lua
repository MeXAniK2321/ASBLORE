LinkLuaModifier("modifier_great_sage", "items/item_great_sage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_great_sage_stat", "items/item_great_sage", LUA_MODIFIER_MOTION_NONE)

item_great_sage = class({})

function item_great_sage:GetIntrinsicModifierName()
    return "modifier_great_sage"
	end


modifier_great_sage = class({})


function modifier_great_sage:IsHidden()
    return true
end
function modifier_great_sage:RemoveOnDeath() return false end
function modifier_great_sage:IsPurgable()
    return false
end
function modifier_great_sage:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_great_sage:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_great_sage:DeclareFunctions()
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

function modifier_great_sage:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_great_sage:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_great_sage:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_great_sage:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_great_sage:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_great_sage:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_great_sage:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         