modifier_horn_3 = class({})

function modifier_horn_3:IsHidden()
	return false
end

function modifier_horn_3:AllowIllusionDuplicate()
	return false
end
function modifier_horn_3:RemoveOnDeath() return false end
function modifier_horn_3:IsPurgable()
    return false
end

function modifier_horn_3:DeclareFunctions()
    local funcs = {
        	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,    
		
    }

    return funcs
end

function modifier_horn_3:GetModifierMoveSpeedBonus_Constant()

	return 60
	end


function modifier_horn_3:GetTexture()
	return "note"
end
function modifier_horn_3:GetEffectName()
	return "particles/armor_great2.vpcf"
end