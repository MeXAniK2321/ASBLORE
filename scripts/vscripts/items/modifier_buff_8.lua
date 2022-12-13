modifier_buff_8 = class({})

function modifier_buff_8:IsHidden()
	return false
end
function modifier_buff_8:RemoveOnDeath() return true end
function modifier_buff_8:AllowIllusionDuplicate()
	return true
end

function modifier_buff_8:IsPurgable()
    return false
end

function modifier_buff_8:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_buff_8:GetModifierMoveSpeedBonus_Constant()

	return 60
	
end

function modifier_buff_8:GetTexture()
	return "note"
end
function modifier_buff_8:GetEffectName()
	return "particles/movespeed_chance.vpcf"
end