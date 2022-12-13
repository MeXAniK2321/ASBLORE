modifier_debuff_3 = class({})

function modifier_debuff_3:IsHidden()
	return false
end
function modifier_debuff_3:RemoveOnDeath() return true end
function modifier_debuff_3:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_3:IsPurgable()
    return false
end

function modifier_debuff_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       
        
		
    }

    return funcs
end

function modifier_debuff_3:GetModifierIncomingDamage_Percentage( params )
		return 15
end

function modifier_debuff_3:GetTexture()
	return "note"
end
function modifier_debuff_3:GetEffectName()
	return "particles/debuff_3.vpcf"
end