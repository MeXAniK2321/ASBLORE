modifier_frisk_mercy = class({})

--------------------------------------------------------------------------------

function modifier_frisk_mercy:IsDebuff()
	return false
end

function modifier_frisk_mercy:IsStunDebuff()
	return false
end
function modifier_frisk_mercy:IsHidden()
	return false
end
function modifier_frisk_mercy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_frisk_mercy:DeclareFunctions()
    local funcs = {
        
       
     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end

function modifier_frisk_mercy:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats') 
end

function modifier_frisk_mercy:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_frisk_mercy:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats') 
end
function modifier_frisk_mercy:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor('resist')
end


--------------------------------------------------------------------------------

function modifier_frisk_mercy:GetEffectName()
	return "particles/frostivus_herofx/frisk_mercy.vpcf"
end

function modifier_frisk_mercy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end