LinkLuaModifier("modifier_naofumi_shield", "items/item_naofumi_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wraith_shield_activation", "items/item_naofumi_shield", LUA_MODIFIER_MOTION_NONE)


item_naofumi_shield = class({})

function item_naofumi_shield:GetIntrinsicModifierName()
    return "modifier_naofumi_shield"
	end

function item_naofumi_shield:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_wraith_shield_activation", {duration = 5})
end
modifier_wraith_shield_activation = class({})
function modifier_wraith_shield_activation:IsHidden()
    return true
end
function modifier_wraith_shield_activation:RemoveOnDeath() return false end
function modifier_wraith_shield_activation:IsPurgable()
    return false
end
modifier_naofumi_shield = class({})


function modifier_naofumi_shield:IsHidden()
    return true
end

function modifier_naofumi_shield:IsPurgable()

    return false
end
function modifier_naofumi_shield:RemoveOnDeath() return false end
function modifier_naofumi_shield:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_naofumi_shield:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_naofumi_shield:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		 MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_naofumi_shield:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_naofumi_shield:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_naofumi_shield:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_naofumi_shield:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_naofumi_shield:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_naofumi_shield:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_naofumi_shield:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         