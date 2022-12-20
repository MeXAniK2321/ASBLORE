LinkLuaModifier("modifier_sandalphon", "items/item_sandalphon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandalphon_stat", "items/item_sandalphon", LUA_MODIFIER_MOTION_NONE)

item_sandalphon = class({})

function item_sandalphon:GetIntrinsicModifierName()
    return "modifier_sandalphon"
	end


modifier_sandalphon = class({})


function modifier_sandalphon:IsHidden()
    return true
end
function modifier_sandalphon:RemoveOnDeath() return false end
function modifier_sandalphon:IsPurgable()
    return false
end
function modifier_sandalphon:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_sandalphon:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_sandalphon:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_sandalphon:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_sandalphon:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_sandalphon:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

  function modifier_sandalphon:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         