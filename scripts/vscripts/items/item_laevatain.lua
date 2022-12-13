LinkLuaModifier("modifier_laevatain", "items/item_laevatain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_laevatain_stat", "items/item_laevatain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_nightmare2", "modifiers/modifier_nightmare2", LUA_MODIFIER_MOTION_NONE )

item_laevatain = class({})

function item_laevatain:GetIntrinsicModifierName()
    return "modifier_laevatain"
	end

function item_laevatain:OnSpellStart()
 local caster = self:GetCaster()
  if self:GetCaster():HasModifier( "modifier_un_owen_was_her" ) then
  else
 if self:GetCaster():HasModifier( "modifier_nightmare2" ) then
 EmitSoundOn("flandr.rare", caster)
 else
    
	if self:GetCaster():HasModifier( "modifier_nightmare" ) then
    caster:AddNewModifier(caster, self, "modifier_nightmare2", {})
	EmitSoundOn("flandr.6_1", caster)
	else
	end
	end
	end
	
end


modifier_laevatain = class({})


function modifier_laevatain:IsHidden()
    return true
end
function modifier_laevatain:RemoveOnDeath() return false end
function modifier_laevatain:IsPurgable()
    return false
end
function modifier_laevatain:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_laevatain:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_laevatain:DeclareFunctions()
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

function modifier_laevatain:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end
function modifier_laevatain:GetModifierSpellAmplify_Percentage()

	return self:GetAbility():GetSpecialValueFor('attack')
	
end
function modifier_laevatain:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_laevatain:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_laevatain:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_laevatain:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_laevatain:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
                     