LinkLuaModifier("modifier_kanade_piano", "items/item_kanade_piano", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kanade_piano_stat", "items/item_kanade_piano", LUA_MODIFIER_MOTION_NONE)

item_kanade_piano = class({})

function item_kanade_piano:GetIntrinsicModifierName()
    return "modifier_kanade_piano"
	end


modifier_kanade_piano = class({})


function modifier_kanade_piano:IsHidden()
    return true
end
function modifier_kanade_piano:RemoveOnDeath() return false end
function modifier_kanade_piano:IsPurgable()
    return false
end
function modifier_kanade_piano:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_kanade_piano:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_kanade_piano:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_kanade_piano:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_kanade_piano:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_kanade_piano:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_kanade_piano:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_kanade_piano:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_kanade_piano:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
  function modifier_kanade_piano:GetModifierMagicalResistanceBonus()
return self:GetAbility():GetSpecialValueFor('res')
end                         