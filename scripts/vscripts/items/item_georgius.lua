LinkLuaModifier("modifier_georgius", "items/item_georgius", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_georgius_stat", "items/item_georgius", LUA_MODIFIER_MOTION_NONE)

item_georgius = class({})

function item_georgius:GetIntrinsicModifierName()
    return "modifier_georgius"
	end

modifier_georgius = class({})


function modifier_georgius:IsHidden()
    return true
end
function modifier_georgius:RemoveOnDeath() return false end
function modifier_georgius:IsPurgable()
    return false
end
function modifier_georgius:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_georgius:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_georgius:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end

function modifier_georgius:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_georgius:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_georgius:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_georgius:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
