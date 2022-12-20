LinkLuaModifier("modifier_nen_contract", "items/item_nen_contract", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nen_contract_stat", "items/item_nen_contract", LUA_MODIFIER_MOTION_NONE)

item_nen_contract = class({})

function item_nen_contract:GetIntrinsicModifierName()
    return "modifier_nen_contract"
	end


modifier_nen_contract = class({})


function modifier_nen_contract:IsHidden()
    return true
end
function modifier_nen_contract:RemoveOnDeath() return false end
function modifier_nen_contract:IsPurgable()
    return false
end
function modifier_nen_contract:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_nen_contract:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_nen_contract:DeclareFunctions()
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



function modifier_nen_contract:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_nen_contract:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_nen_contract:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_nen_contract:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_nen_contract:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
                   