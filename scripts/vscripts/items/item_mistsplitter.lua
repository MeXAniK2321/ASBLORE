LinkLuaModifier("modifier_mistsplitter", "items/item_mistsplitter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mistsplitter_stat", "items/item_mistsplitter", LUA_MODIFIER_MOTION_NONE)

item_mistsplitter = class({})

function item_mistsplitter:GetIntrinsicModifierName()
    return "modifier_mistsplitter"
	end


modifier_mistsplitter = class({})


function modifier_mistsplitter:IsHidden()
    return true
end
function modifier_mistsplitter:RemoveOnDeath() return false end
function modifier_mistsplitter:IsPurgable()
    return false
end
function modifier_mistsplitter:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_mistsplitter:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_mistsplitter:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_mistsplitter:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_mistsplitter:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_mistsplitter:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_mistsplitter:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_mistsplitter:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_mistsplitter:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end