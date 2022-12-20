LinkLuaModifier("modifier_boosted_gear", "items/item_boosted_gear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boosted_gear_stat", "items/item_boosted_gear", LUA_MODIFIER_MOTION_NONE)

item_boosted_gear = class({})

function item_boosted_gear:GetIntrinsicModifierName()
    return "modifier_boosted_gear"
	end


modifier_boosted_gear = class({})


function modifier_boosted_gear:IsHidden()
    return true
end
function modifier_boosted_gear:RemoveOnDeath() return false end
function modifier_boosted_gear:IsPurgable()
    return false
end
function modifier_boosted_gear:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_boosted_gear:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_boosted_gear:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_boosted_gear:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_boosted_gear:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_boosted_gear:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_boosted_gear:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_boosted_gear:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

  function modifier_boosted_gear:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         