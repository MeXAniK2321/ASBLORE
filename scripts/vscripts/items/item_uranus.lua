LinkLuaModifier("modifier_uranus", "items/item_uranus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_uranus_stat", "items/item_uranus", LUA_MODIFIER_MOTION_NONE)

item_uranus = class({})

function item_uranus:GetIntrinsicModifierName()
    return "modifier_uranus"
	end


modifier_uranus = class({})


function modifier_uranus:IsHidden()
    return true
end
function modifier_uranus:RemoveOnDeath() return false end
function modifier_uranus:IsPurgable()
    return false
end
function modifier_uranus:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_uranus:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_uranus:DeclareFunctions()
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

function modifier_uranus:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_uranus:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_uranus:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_uranus:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_uranus:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_uranus:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end

                      