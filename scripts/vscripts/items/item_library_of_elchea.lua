LinkLuaModifier("modifier_library_of_elchea", "items/item_library_of_elchea", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_library_of_elchea_stat", "items/item_library_of_elchea", LUA_MODIFIER_MOTION_NONE)

item_library_of_elchea = class({})

function item_library_of_elchea:GetIntrinsicModifierName()
    return "modifier_library_of_elchea"
	end


modifier_library_of_elchea = class({})


function modifier_library_of_elchea:IsHidden()
    return true
end
function modifier_library_of_elchea:RemoveOnDeath() return false end
function modifier_library_of_elchea:IsPurgable()
    return false
end
function modifier_library_of_elchea:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_library_of_elchea:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_library_of_elchea:DeclareFunctions()
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

function modifier_library_of_elchea:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_library_of_elchea:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_library_of_elchea:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_library_of_elchea:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_library_of_elchea:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_library_of_elchea:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end