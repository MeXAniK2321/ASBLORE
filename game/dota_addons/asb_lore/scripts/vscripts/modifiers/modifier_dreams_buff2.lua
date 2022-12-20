
modifier_dreams_buff2 = class({})

function modifier_dreams_buff2:IsHidden()
	return true
end

function modifier_dreams_buff2:AllowIllusionDuplicate()
	return true
end

function modifier_dreams_buff2:IsPurgable()
    return false
end

function modifier_dreams_buff2:DeclareFunctions()
    local funcs = {
        
        
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end

function modifier_dreams_buff2:GetModifierMagicalResistanceBonus()
    return 25
end
function modifier_dreams_buff2:GetModifierBonusStats_Strength()
    return 50
end

function modifier_dreams_buff2:GetModifierBonusStats_Agility()
    return 50
end

function modifier_dreams_buff2:GetModifierBonusStats_Intellect()
    return 50
end
function modifier_dreams_buff2:GetEffectName()
	return "particles/buff2.vpcf"
end
function modifier_dreams_buff2:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end

