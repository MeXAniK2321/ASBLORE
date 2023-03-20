LinkLuaModifier("modifier_national_contract", "items/item_national_contract", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_national_contract_stat", "items/item_national_contract", LUA_MODIFIER_MOTION_NONE)

item_national_contract = class({})

function item_national_contract:GetIntrinsicModifierName()
    return "modifier_national_contract"
	end


modifier_national_contract = class({})


function modifier_national_contract:IsHidden()
    return true
end
function modifier_national_contract:RemoveOnDeath() return false end
function modifier_national_contract:IsPurgable()
    return false
end
function modifier_national_contract:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_national_contract:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_national_contract:DeclareFunctions()
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

function modifier_national_contract:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_national_contract:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_national_contract:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
                  