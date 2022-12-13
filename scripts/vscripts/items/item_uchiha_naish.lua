LinkLuaModifier("modifier_uchiha_naish", "items/item_uchiha_naish", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_uchiha_naish_stat", "items/item_uchiha_naish", LUA_MODIFIER_MOTION_NONE)

item_uchiha_naish = class({})

function item_uchiha_naish:GetIntrinsicModifierName()
    return "modifier_uchiha_naish"
	end


modifier_uchiha_naish = class({})


function modifier_uchiha_naish:IsHidden()
    return true
end
function modifier_uchiha_naish:RemoveOnDeath() return false end
function modifier_uchiha_naish:IsPurgable()
    return false
end
function modifier_uchiha_naish:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_uchiha_naish:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_uchiha_naish:DeclareFunctions()
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

function modifier_uchiha_naish:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_uchiha_naish:GetModifierManaBonus()
    return 1000
end

function modifier_uchiha_naish:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_uchiha_naish:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_uchiha_naish:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_uchiha_naish:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_uchiha_naish:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         