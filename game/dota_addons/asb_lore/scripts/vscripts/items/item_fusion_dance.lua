LinkLuaModifier("modifier_fusion_dance", "items/item_fusion_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fusion_dance_kamehameha", "items/item_fusion_dance", LUA_MODIFIER_MOTION_NONE)

item_fusion_dance = item_fusion_dance or class({})

function item_fusion_dance:GetIntrinsicModifierName()
    return "modifier_fusion_dance"
end

function item_fusion_dance:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_fusion_dance_kamehameha", { duration = 10 } )
end


modifier_fusion_dance_kamehameha = modifier_fusion_dance_kamehameha or class({})

function modifier_fusion_dance_kamehameha:IsHidden() return false end
function modifier_fusion_dance_kamehameha:RemoveOnDeath() return true end
function modifier_fusion_dance_kamehameha:IsPurgable() return false end


modifier_fusion_dance = modifier_fusion_dance or class({})

function modifier_fusion_dance:IsHidden() return true end
function modifier_fusion_dance:RemoveOnDeath() return false end
function modifier_fusion_dance:IsPurgable() return false end
function modifier_fusion_dance:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_fusion_dance:OnCreated(table)
    self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end
function modifier_fusion_dance:DeclareFunctions()
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
function modifier_fusion_dance:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end
function modifier_fusion_dance:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_fusion_dance:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_fusion_dance:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_fusion_dance:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor('amp')
end
function modifier_fusion_dance:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_fusion_dance:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor('arm')
end                     