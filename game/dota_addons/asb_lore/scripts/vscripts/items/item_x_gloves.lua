LinkLuaModifier("modifier_x_gloves", "items/item_x_gloves", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_x_gloves_stat", "items/item_x_gloves", LUA_MODIFIER_MOTION_NONE)

item_x_gloves = class({})

function item_x_gloves:GetIntrinsicModifierName()
    return "modifier_x_gloves"
	end


modifier_x_gloves = class({})


function modifier_x_gloves:IsHidden()
    return true
end
function modifier_x_gloves:RemoveOnDeath() return false end
function modifier_x_gloves:IsPurgable()
    return false
end
function modifier_x_gloves:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_x_gloves:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_x_gloves:DeclareFunctions()
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

function modifier_x_gloves:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_x_gloves:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_x_gloves:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_x_gloves:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_x_gloves:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_x_gloves:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_x_gloves:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         