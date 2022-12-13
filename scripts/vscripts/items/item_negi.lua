LinkLuaModifier("modifier_negi", "items/item_negi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_negi_stat", "items/item_negi", LUA_MODIFIER_MOTION_NONE)

item_negi = class({})

function item_negi:GetIntrinsicModifierName()
    return "modifier_negi"
	end


modifier_negi = class({})


function modifier_negi:IsHidden()
    return true
end
function modifier_negi:RemoveOnDeath() return false end
function modifier_negi:IsPurgable()
    return false
end
function modifier_negi:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_negi:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_negi:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_negi:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_negi:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_negi:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_negi:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_negi:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_negi:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
                     