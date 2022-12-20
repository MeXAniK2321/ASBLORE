LinkLuaModifier("modifier_void_sword", "items/item_void_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_sword_stat", "items/item_void_sword", LUA_MODIFIER_MOTION_NONE)

item_void_sword = class({})

function item_void_sword:GetIntrinsicModifierName()
    return "modifier_void_sword"
	end


modifier_void_sword = class({})


function modifier_void_sword:IsHidden()
    return true
end
function modifier_void_sword:RemoveOnDeath() return false end
function modifier_void_sword:IsPurgable()
    return false
end
function modifier_void_sword:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_void_sword:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_void_sword:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end


function modifier_void_sword:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_void_sword:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_void_sword:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_void_sword:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_void_sword:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
function modifier_void_sword:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end