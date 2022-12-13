LinkLuaModifier("modifier_billy_bike", "items/item_billy_bike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_billy_bike_stat", "items/item_billy_bike", LUA_MODIFIER_MOTION_NONE)

item_billy_bike = class({})

function item_billy_bike:GetIntrinsicModifierName()
    return "modifier_billy_bike"
	end


modifier_billy_bike = class({})


function modifier_billy_bike:IsHidden()
    return true
end

function modifier_billy_bike:IsPurgable()

    return false
end
function modifier_billy_bike:RemoveOnDeath() return false end
function modifier_billy_bike:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_billy_bike:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_billy_bike:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_billy_bike:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_billy_bike:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_billy_bike:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_billy_bike:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_billy_bike:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_billy_bike:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_billy_bike:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('arm')
end                         