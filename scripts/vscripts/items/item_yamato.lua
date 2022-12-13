LinkLuaModifier("modifier_yamato", "items/item_yamato", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yamato_stat", "items/item_yamato", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_motivated", "items/item_yamato", LUA_MODIFIER_MOTION_NONE)
item_yamato = class({})

function item_yamato:GetIntrinsicModifierName()
    return "modifier_yamato"
	end
function item_yamato:OnSpellStart()
 local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_motivated", {duration = 0.8})
	EmitSoundOn("vergil.motivated", caster)
	
	end
	
modifier_motivated = class({})


function modifier_motivated:IsHidden()
    return true
end
function modifier_motivated:RemoveOnDeath() return false end
function modifier_motivated:IsPurgable()
    return false
end


modifier_yamato = class({})


function modifier_yamato:IsHidden()
    return true
end
function modifier_yamato:RemoveOnDeath() return false end
function modifier_yamato:IsPurgable()
    return false
end
function modifier_yamato:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_yamato:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_yamato:DeclareFunctions()
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

function modifier_yamato:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_yamato:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_yamato:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_yamato:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_yamato:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_yamato:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
                     