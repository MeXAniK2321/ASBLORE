modifier_subaru_emt2 = class({})

function modifier_subaru_emt2:IsHidden()
	return true
end

function modifier_subaru_emt2:AllowIllusionDuplicate()
	return true
end

function modifier_subaru_emt2:IsPurgable()
    return false
end

function modifier_subaru_emt2:DeclareFunctions()
    local funcs = {
        
      
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_subaru_emt2:GetModifierMagicalResistanceBonus()
    return 50
end



