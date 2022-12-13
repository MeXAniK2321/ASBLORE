modifier_horn_2 = class({})

function modifier_horn_2:IsHidden()
	return false
end
function modifier_horn_2:RemoveOnDeath() return false end
function modifier_horn_2:AllowIllusionDuplicate()
	return false
end

function modifier_horn_2:IsPurgable()
    return false
end

function modifier_horn_2:DeclareFunctions()
    local funcs = {
           MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
		
    }

    return funcs
end

function modifier_horn_2:GetModifierAttackSpeedBonus_Constant()
	 return 60
end

function modifier_horn_2:GetTexture()
	return "note"
end
function modifier_horn_2:GetEffectName()
	return "particles/spd_great2.vpcf"
end