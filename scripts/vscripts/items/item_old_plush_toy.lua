LinkLuaModifier("modifier_old_plush_toy", "items/item_old_plush_toy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_old_plush_toy_stat", "items/item_old_plush_toy", LUA_MODIFIER_MOTION_NONE)

item_old_plush_toy = class({})

function item_old_plush_toy:GetIntrinsicModifierName()
    return "modifier_old_plush_toy"
	end


modifier_old_plush_toy = class({})


function modifier_old_plush_toy:IsHidden()
    return true
end
function modifier_old_plush_toy:RemoveOnDeath() return false end
function modifier_old_plush_toy:IsPurgable()
    return false
end
function modifier_old_plush_toy:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_old_plush_toy:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_old_plush_toy:DeclareFunctions()
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

function modifier_old_plush_toy:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_old_plush_toy:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_old_plush_toy:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_old_plush_toy:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_old_plush_toy:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

  function modifier_old_plush_toy:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         