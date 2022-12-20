LinkLuaModifier("modifier_item_last_star", "items/item_last_star", LUA_MODIFIER_MOTION_NONE)

item_last_star = class({})

function item_last_star:GetIntrinsicModifierName()
    return "modifier_item_last_star"
end

modifier_item_last_star = class({})

function modifier_item_last_star:IsHidden()
	return true
end

function modifier_item_last_star:AllowIllusionDuplicate()
	return true
end

function modifier_item_last_star:IsPurgable()
    return false
end

function modifier_item_last_star:DeclareFunctions()
    local funcs = {
        
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_item_last_star:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_last_star:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_last_star:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end


