LinkLuaModifier("modifier_all_fiction_screw", "items/item_all_fiction_screw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_screw_stat", "items/item_all_fiction_screw", LUA_MODIFIER_MOTION_NONE)

item_all_fiction_screw = class({})

function item_all_fiction_screw:GetIntrinsicModifierName()
    return "modifier_all_fiction_screw"
	end


modifier_all_fiction_screw = class({})


function modifier_all_fiction_screw:IsHidden()
    return true
end
function modifier_all_fiction_screw:RemoveOnDeath() return false end
function modifier_all_fiction_screw:IsPurgable()
    return false
end
function modifier_all_fiction_screw:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_all_fiction_screw:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_all_fiction_screw:DeclareFunctions()
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

function modifier_all_fiction_screw:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_all_fiction_screw:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_all_fiction_screw:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_all_fiction_screw:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_all_fiction_screw:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

  function modifier_all_fiction_screw:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         