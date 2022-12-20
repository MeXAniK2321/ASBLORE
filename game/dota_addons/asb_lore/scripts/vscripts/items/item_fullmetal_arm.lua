LinkLuaModifier("modifier_fullmetal_arm", "items/item_fullmetal_arm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fullmetal_arm_stat", "items/item_fullmetal_arm", LUA_MODIFIER_MOTION_NONE)

item_fullmetal_arm = class({})

function item_fullmetal_arm:GetIntrinsicModifierName()
    return "modifier_fullmetal_arm"
	end


modifier_fullmetal_arm = class({})


function modifier_fullmetal_arm:IsHidden()
    return true
end
function modifier_fullmetal_arm:RemoveOnDeath() return false end
function modifier_fullmetal_arm:IsPurgable()
    return false
end
function modifier_fullmetal_arm:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_fullmetal_arm:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_fullmetal_arm:DeclareFunctions()
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

function modifier_fullmetal_arm:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_fullmetal_arm:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_fullmetal_arm:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_fullmetal_arm:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_fullmetal_arm:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_fullmetal_arm:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_fullmetal_arm:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         