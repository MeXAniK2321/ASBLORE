LinkLuaModifier("modifier_esdeath_rapier", "items/item_esdeath_rapier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_esdeath_rapier_stat", "items/item_esdeath_rapier", LUA_MODIFIER_MOTION_NONE)

item_esdeath_rapier = class({})

function item_esdeath_rapier:GetIntrinsicModifierName()
    return "modifier_esdeath_rapier"
	end


modifier_esdeath_rapier = class({})


function modifier_esdeath_rapier:IsHidden()
    return true
end
function modifier_esdeath_rapier:RemoveOnDeath() return false end
function modifier_esdeath_rapier:IsPurgable()
    return false
end
function modifier_esdeath_rapier:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_esdeath_rapier:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_esdeath_rapier:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_esdeath_rapier:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_esdeath_rapier:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_esdeath_rapier:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_esdeath_rapier:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_esdeath_rapier:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
