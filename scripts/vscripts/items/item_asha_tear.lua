LinkLuaModifier("modifier_item_asha_tear", "items/item_asha_tear", LUA_MODIFIER_MOTION_NONE)

item_asha_tear = class({})

function item_asha_tear:GetIntrinsicModifierName()
    return "modifier_item_asha_tear"
end

modifier_item_asha_tear = class({})

function modifier_item_asha_tear:IsHidden()
	return true
end

function modifier_item_asha_tear:AllowIllusionDuplicate()
	return true
end

function modifier_item_asha_tear:IsPurgable()
    return false
end

function modifier_item_asha_tear:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        
		
    }

    return funcs
end

function modifier_item_asha_tear:GetModifierSpellAmplify_Percentage()
 if self:GetParent():HasItemInInventory("item_vongolla_primo_ring") or self:GetParent():HasItemInInventory("item_crucible_of_the_executioner") then self.dmg = 0 return end
  self.dmg = self:GetAbility():GetSpecialValueFor('dmg')
    return self.dmg
end

function modifier_item_asha_tear:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end


function modifier_item_asha_tear:GetModifierCastRangeBonus()
	return 300
end