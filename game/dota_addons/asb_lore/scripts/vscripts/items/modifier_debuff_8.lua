modifier_debuff_8 = class({})

function modifier_debuff_8:IsHidden()
	return false
end
function modifier_debuff_8:RemoveOnDeath() return true end
function modifier_debuff_8:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_8:IsPurgable()
    return false
end

function modifier_debuff_8:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
       
        
		
    }

    return funcs
end

function modifier_debuff_8:GetModifierPreAttack_BonusDamage()
    return -100
end

function modifier_debuff_8:GetTexture()
	return "note"
end
function modifier_debuff_8:GetEffectName()
	return "particles/debuff_8.vpcf"
end