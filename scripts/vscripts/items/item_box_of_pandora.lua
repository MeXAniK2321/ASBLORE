LinkLuaModifier("modifier_box_of_pandora", "items/item_box_of_pandora", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_box_of_pandora_stat", "items/item_box_of_pandora", LUA_MODIFIER_MOTION_NONE)

item_box_of_pandora = class({})

function item_box_of_pandora:GetIntrinsicModifierName()
    return "modifier_box_of_pandora"
	end


modifier_box_of_pandora = class({})


function modifier_box_of_pandora:IsHidden()
    return true
end
function modifier_box_of_pandora:RemoveOnDeath() return false end
function modifier_box_of_pandora:IsPurgable()
    return false
end
function modifier_box_of_pandora:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_box_of_pandora:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_box_of_pandora:DeclareFunctions()
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
 
function modifier_box_of_pandora:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_box_of_pandora:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_box_of_pandora:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_box_of_pandora:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_box_of_pandora:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_box_of_pandora:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_box_of_pandora:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         