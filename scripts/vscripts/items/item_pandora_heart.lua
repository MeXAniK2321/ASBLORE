LinkLuaModifier("modifier_item_pandora_heart", "items/item_pandora_heart", LUA_MODIFIER_MOTION_NONE)

item_pandora_heart = class({})

function item_pandora_heart:GetIntrinsicModifierName()
    return "modifier_item_pandora_heart"
end

modifier_item_pandora_heart = class({})

function modifier_item_pandora_heart:IsHidden()
	return true
end

function modifier_item_pandora_heart:AllowIllusionDuplicate()
	return true
end

function modifier_item_pandora_heart:IsPurgable()
    return false
end

function modifier_item_pandora_heart:DeclareFunctions()
    local funcs = {
        
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_item_pandora_heart:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_pandora_heart:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_pandora_heart:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_item_pandora_heart:GetModifierPreAttack_BonusDamage()
    return 100
end

