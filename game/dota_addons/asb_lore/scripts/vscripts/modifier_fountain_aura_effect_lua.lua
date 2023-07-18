
modifier_fountain_aura_effect_lua = class({})

function modifier_fountain_aura_effect_lua:IsHidden() return false end
function modifier_fountain_aura_effect_lua:IsDebuff() return false end
function modifier_fountain_aura_effect_lua:IsPurgable() return true end
function modifier_fountain_aura_effect_lua:IsPurgeException() return true end
function modifier_fountain_aura_effect_lua:RemoveOnDeath() return true end
function modifier_fountain_aura_effect_lua:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_fountain_aura_effect_lua:GetModifierIncomingDamage_Percentage( params )
	  if self:GetParent():HasModifier("modifier_the_one_ultimate_d") or self:GetParent():HasModifier("modifier_muscule_flex") or self:GetParent():HasModifier("modifier_death_cd")  then
	    return 0
	  else
        return -35
	  end
end
function modifier_fountain_aura_effect_lua:GetTexture()
	return "jin_mori_2"
end
function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage( params )
	return 25
end
function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen( params )
	return 20
end
function modifier_fountain_aura_effect_lua:GetModifierConstantManaRegen( params )
	return 30
end
function modifier_fountain_aura_effect_lua:GetModifierMoveSpeedBonus_Percentage(keys)
	return 25
end
function modifier_fountain_aura_effect_lua:GetEffectName()
	return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end
function modifier_fountain_aura_effect_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
