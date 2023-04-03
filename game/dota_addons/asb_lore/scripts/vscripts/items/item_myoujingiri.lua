LinkLuaModifier("modifier_myoujingiri", "items/item_myoujingiri", LUA_MODIFIER_MOTION_NONE)

item_myoujingiri = class({})

function item_myoujingiri:GetIntrinsicModifierName()
    return "modifier_myoujingiri"
	end


    modifier_myoujingiri = class({})


function modifier_myoujingiri:IsHidden()
    return true
end
function modifier_myoujingiri:RemoveOnDeath() return false end
function modifier_myoujingiri:IsPurgable()
    return false
end
function modifier_myoujingiri:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_myoujingiri:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_myoujingiri:DeclareFunctions()
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

function modifier_myoujingiri:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_myoujingiri:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_myoujingiri:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
                  