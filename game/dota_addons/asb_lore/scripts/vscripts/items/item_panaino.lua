LinkLuaModifier("modifier_panaino", "items/item_panaino", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_panaino_stat", "items/item_panaino", LUA_MODIFIER_MOTION_NONE)

item_panaino = class({})

function item_panaino:GetIntrinsicModifierName()
    return "modifier_panaino"
	end


modifier_panaino = class({})


function modifier_panaino:IsHidden()
    return true
end
function modifier_panaino:RemoveOnDeath() return false end
function modifier_panaino:IsPurgable()
    return false
end
function modifier_panaino:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_panaino:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_panaino:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_panaino:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_panaino:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_panaino:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_panaino:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_panaino:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
  function modifier_panaino:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         