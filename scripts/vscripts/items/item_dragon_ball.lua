LinkLuaModifier("modifier_dragon_ball", "items/item_dragon_ball", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dragon_ball_stat", "items/item_dragon_ball", LUA_MODIFIER_MOTION_NONE)

item_dragon_ball = class({})

function item_dragon_ball:GetIntrinsicModifierName()
    return "modifier_dragon_ball"
	end


modifier_dragon_ball = class({})


function modifier_dragon_ball:IsHidden()
    return true
end
function modifier_dragon_ball:RemoveOnDeath() return false end
function modifier_dragon_ball:IsPurgable()
    return false
end
function modifier_dragon_ball:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_dragon_ball:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_dragon_ball:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end

function modifier_dragon_ball:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_dragon_ball:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_dragon_ball:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_dragon_ball:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_dragon_ball:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end

function modifier_dragon_ball:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

  function modifier_dragon_ball:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         