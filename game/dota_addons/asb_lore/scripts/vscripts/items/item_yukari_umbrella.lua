LinkLuaModifier("modifier_yukari_umbrella", "items/item_yukari_umbrella", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yukari_umbrella_stat", "items/item_yukari_umbrella", LUA_MODIFIER_MOTION_NONE)

item_yukari_umbrella = class({})

function item_yukari_umbrella:GetIntrinsicModifierName()
    return "modifier_yukari_umbrella"
	end


modifier_yukari_umbrella = class({})


function modifier_yukari_umbrella:IsHidden()
    return true
end
function modifier_yukari_umbrella:RemoveOnDeath() return false end
function modifier_yukari_umbrella:IsPurgable()
    return false
end
function modifier_yukari_umbrella:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_yukari_umbrella:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_yukari_umbrella:DeclareFunctions()
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

function modifier_yukari_umbrella:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_yukari_umbrella:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_yukari_umbrella:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_yukari_umbrella:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_yukari_umbrella:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_yukari_umbrella:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_yukari_umbrella:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         