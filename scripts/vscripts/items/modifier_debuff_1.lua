modifier_debuff_1 = class({})

function modifier_debuff_1:IsHidden()
	return false
end
function modifier_debuff_1:RemoveOnDeath() return true end
function modifier_debuff_1:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_1:IsPurgable()
    return false
end

function modifier_debuff_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_debuff_1:GetModifierMoveSpeedBonus_Constant()

	return -60
	
end


function modifier_debuff_1:GetTexture()
	return "note"
end
function modifier_debuff_1:GetEffectName()
	return "particles/debuff_1.vpcf"
end