LinkLuaModifier("modifier_eye_seal", "items/item_eye_seal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eye_seal_stat", "items/item_eye_seal", LUA_MODIFIER_MOTION_NONE)

item_eye_seal = class({})

function item_eye_seal:GetIntrinsicModifierName()
    return "modifier_eye_seal"
	end


modifier_eye_seal = class({})


function modifier_eye_seal:IsHidden()
    return true
end
function modifier_eye_seal:RemoveOnDeath() return false end
function modifier_eye_seal:IsPurgable()
    return false
end
function modifier_eye_seal:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_eye_seal:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_eye_seal:DeclareFunctions()
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

function modifier_eye_seal:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_eye_seal:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_eye_seal:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_eye_seal:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_eye_seal:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_eye_seal:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_eye_seal:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         