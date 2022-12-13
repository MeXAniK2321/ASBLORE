modifier_steal_chain_buff = class({})

function modifier_steal_chain_buff:IsHidden()
	return false
end

function modifier_steal_chain_buff:AllowIllusionDuplicate()
	return true
end

function modifier_steal_chain_buff:IsPurgable()
    return false
end

function modifier_steal_chain_buff:DeclareFunctions()
    local funcs = {
        
        
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end


function modifier_steal_chain_buff:GetModifierBonusStats_Strength()
    return 20
end

function modifier_steal_chain_buff:GetModifierBonusStats_Agility()
    return 20
end

function modifier_steal_chain_buff:GetModifierBonusStats_Intellect()
    return 20
end
function modifier_steal_chain_buff:GetEffectName()
	return "particles/steal_chain.vpcf"
end
function modifier_steal_chain_buff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end