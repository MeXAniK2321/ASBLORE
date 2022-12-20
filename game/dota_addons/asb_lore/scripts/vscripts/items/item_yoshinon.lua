LinkLuaModifier("modifier_yoshinon", "items/item_yoshinon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yoshinon_stat", "items/item_yoshinon", LUA_MODIFIER_MOTION_NONE)

item_yoshinon = class({})

function item_yoshinon:GetIntrinsicModifierName()
    return "modifier_yoshinon"
	end


modifier_yoshinon = class({})


function modifier_yoshinon:IsHidden()
    return true
end
function modifier_yoshinon:RemoveOnDeath() return false end
function modifier_yoshinon:IsPurgable()
    return false
end
function modifier_yoshinon:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_yoshinon:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_yoshinon:DeclareFunctions()
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

function modifier_yoshinon:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_yoshinon:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_yoshinon:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_yoshinon:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_yoshinon:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_yoshinon:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_yoshinon:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         