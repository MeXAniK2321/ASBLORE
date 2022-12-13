modifier_cor_leonis = class({})

function modifier_cor_leonis:IsHidden()
	return false
end

function modifier_cor_leonis:AllowIllusionDuplicate()
	return true
end

function modifier_cor_leonis:IsPurgable()
    return false
end

function modifier_cor_leonis:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        
        
		
    }

    return funcs
end

function modifier_cor_leonis:GetModifierSpellAmplify_Percentage()
    return 30
end
function modifier_cor_leonis:GetEffectName()
	return "particles/cor_leonis_buff.vpcf"
end
function modifier_cor_leonis:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
