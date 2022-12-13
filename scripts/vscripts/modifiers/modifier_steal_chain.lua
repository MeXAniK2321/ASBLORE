modifier_steal_chain = class({})

function modifier_steal_chain:IsHidden()
	return false
end

function modifier_steal_chain:AllowIllusionDuplicate()
	return true
end

function modifier_steal_chain:IsPurgable()
    return false
end

function modifier_steal_chain:DeclareFunctions()
    local funcs = {
        
        
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end


function modifier_steal_chain:GetModifierBonusStats_Strength()
    return -20
end

function modifier_steal_chain:GetModifierBonusStats_Agility()
    return -20
end

function modifier_steal_chain:GetModifierBonusStats_Intellect()
    return -20
end
function modifier_steal_chain:GetEffectName()
	return "particles/steal_chain.vpcf"
end
function modifier_steal_chain:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end