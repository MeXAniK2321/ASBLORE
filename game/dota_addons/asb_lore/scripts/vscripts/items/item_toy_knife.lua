LinkLuaModifier("modifier_toy_knife", "items/item_toy_knife", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_toy_knife_stat", "items/item_toy_knife", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_true_hero", "modifiers/modifier_true_hero", LUA_MODIFIER_MOTION_NONE )

item_toy_knife = class({})

function item_toy_knife:GetIntrinsicModifierName()
    return "modifier_toy_knife"
	end

function item_toy_knife:OnSpellStart()
 local caster = self:GetCaster()
 if self:GetCaster():HasModifier( "modifier_hopes_and_dreams" ) then
 else
    if self:GetCaster():HasModifier( "modifier_true_hero" ) then
	else
	if self:GetCaster():HasModifier( "modifier_storyshift" ) then
    caster:AddNewModifier(caster, self, "modifier_true_hero", {})
	EmitSoundOn("frisk.1_1", caster)
	else
	end
	end
	
end
EmitSoundOn("frisk.1", caster)
end
modifier_toy_knife = class({})


function modifier_toy_knife:IsHidden()
    return true
end
function modifier_toy_knife:RemoveOnDeath() return false end
function modifier_toy_knife:IsPurgable()
    return false
end
function modifier_toy_knife:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_toy_knife:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_toy_knife:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end

function modifier_toy_knife:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_toy_knife:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_toy_knife:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_toy_knife:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_toy_knife:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_toy_knife:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
function modifier_toy_knife:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end