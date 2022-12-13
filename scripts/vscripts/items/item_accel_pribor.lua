LinkLuaModifier("modifier_accel_pribor", "items/item_accel_pribor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_accel_pribor_stat", "items/item_accel_pribor", LUA_MODIFIER_MOTION_NONE)

item_accel_pribor = class({})

function item_accel_pribor:GetIntrinsicModifierName()
    return "modifier_accel_pribor"
	end


modifier_accel_pribor = class({})


function modifier_accel_pribor:IsHidden()
    return true
end
function modifier_accel_pribor:RemoveOnDeath() return false end
function modifier_accel_pribor:IsPurgable()
    return false
end
function modifier_accel_pribor:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_accel_pribor:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_accel_pribor:DeclareFunctions()
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

function modifier_accel_pribor:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_accel_pribor:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_accel_pribor:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_accel_pribor:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_accel_pribor:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_accel_pribor:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_accel_pribor:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         