modifier_debuff_6 = class({})

function modifier_debuff_6:IsHidden()
	return false
end
function modifier_debuff_6:RemoveOnDeath() return true end
function modifier_debuff_6:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_6:IsPurgable()
    return false
end

function modifier_debuff_6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING,    
		
    }

    return funcs
end

function modifier_debuff_6:GetDisableHealing()
	return 1
end


function modifier_debuff_6:GetTexture()
	return "note"
end
function modifier_debuff_6:GetEffectName()
	return "particles/debuff_6.vpcf"
end