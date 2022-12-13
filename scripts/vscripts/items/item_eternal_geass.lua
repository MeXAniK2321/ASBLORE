LinkLuaModifier("modifier_eternal_geass", "items/item_eternal_geass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eternal_geass_stat", "items/item_eternal_geass", LUA_MODIFIER_MOTION_NONE)

item_eternal_geass = class({})

function item_eternal_geass:GetIntrinsicModifierName()
    return "modifier_eternal_geass"
end

item_eternal_geass_2 = class({})

function item_eternal_geass_2:GetIntrinsicModifierName()
    return "modifier_eternal_geass"
end


modifier_eternal_geass = class({})


function modifier_eternal_geass:IsHidden()
    return true
end
function modifier_eternal_geass:RemoveOnDeath() return false end
function modifier_eternal_geass:IsPurgable()
    return false
end
function modifier_eternal_geass:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_eternal_geass:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_eternal_geass:DeclareFunctions()
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

function modifier_eternal_geass:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_eternal_geass:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_eternal_geass:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_eternal_geass:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_eternal_geass:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_eternal_geass:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_eternal_geass:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         