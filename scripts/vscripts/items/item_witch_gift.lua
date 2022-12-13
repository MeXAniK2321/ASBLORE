LinkLuaModifier("modifier_witch_gift", "items/item_witch_gift", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_gift_stat", "items/item_witch_gift", LUA_MODIFIER_MOTION_NONE)

item_witch_gift = class({})

function item_witch_gift:GetIntrinsicModifierName()
    return "modifier_witch_gift"
	end


modifier_witch_gift = class({})


function modifier_witch_gift:IsHidden()
    return true
end
function modifier_witch_gift:RemoveOnDeath() return false end
function modifier_witch_gift:IsPurgable()
    return false
end
function modifier_witch_gift:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_witch_gift:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_witch_gift:DeclareFunctions()
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

function modifier_witch_gift:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_witch_gift:GetModifierManaBonus()
    return 1000
end

function modifier_witch_gift:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_witch_gift:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_witch_gift:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_witch_gift:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_witch_gift:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         