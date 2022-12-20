LinkLuaModifier("modifier_rumia_sword", "items/item_rumia_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rumia_sword_stat", "items/item_rumia_sword", LUA_MODIFIER_MOTION_NONE)

item_rumia_sword = class({})

function item_rumia_sword:GetIntrinsicModifierName()
    return "modifier_rumia_sword"
	end


modifier_rumia_sword = class({})


function modifier_rumia_sword:IsHidden()
    return true
end
function modifier_rumia_sword:RemoveOnDeath() return false end
function modifier_rumia_sword:IsPurgable()
    return false
end
function modifier_rumia_sword:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_rumia_sword:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_rumia_sword:DeclareFunctions()
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

function modifier_rumia_sword:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_rumia_sword:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_rumia_sword:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_rumia_sword:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_rumia_sword:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

  function modifier_rumia_sword:GetModifierMagicalResistanceBonus()
return self:GetAbility():GetSpecialValueFor('res')
end                         