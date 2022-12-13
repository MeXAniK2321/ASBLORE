LinkLuaModifier("modifier_tanjiro_katana", "items/item_tanjiro_katana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tanjiro_katana_stat", "items/item_tanjiro_katana", LUA_MODIFIER_MOTION_NONE)

item_tanjiro_katana = class({})

function item_tanjiro_katana:GetIntrinsicModifierName()
    return "modifier_tanjiro_katana"
	end


modifier_tanjiro_katana = class({})


function modifier_tanjiro_katana:IsHidden()
    return true
end
function modifier_tanjiro_katana:RemoveOnDeath() return false end
function modifier_tanjiro_katana:IsPurgable()
    return false
end
function modifier_tanjiro_katana:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_tanjiro_katana:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_tanjiro_katana:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_tanjiro_katana:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_tanjiro_katana:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_tanjiro_katana:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_tanjiro_katana:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_tanjiro_katana:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end

function modifier_tanjiro_katana:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

                   