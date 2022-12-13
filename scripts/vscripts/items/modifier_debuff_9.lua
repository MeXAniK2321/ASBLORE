modifier_debuff_9 = class({})

function modifier_debuff_9:IsHidden()
	return false
end
function modifier_debuff_9:RemoveOnDeath() return true end
function modifier_debuff_9:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_9:IsPurgable()
    return false
end

function modifier_debuff_9:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_debuff_9:GetModifierAttackSpeedBonus_Constant()
    
    return -80
end

function modifier_debuff_9:GetTexture()
	return "note"
end
function modifier_debuff_9:GetEffectName()
	return "particles/debuff_9.vpcf"
end
