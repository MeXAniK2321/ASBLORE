modifier_debuff_2 = class({})

function modifier_debuff_2:IsHidden()
	return false
end
function modifier_debuff_2:RemoveOnDeath() return true end
function modifier_debuff_2:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_2:IsPurgable()
    return false
end

function modifier_debuff_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_debuff_2:GetModifierConstantHealthRegen()
    return -50
end

function modifier_debuff_2:GetTexture()
	return "note"
end
function modifier_debuff_2:GetEffectName()
	return "particles/debuff_2.vpcf"
end