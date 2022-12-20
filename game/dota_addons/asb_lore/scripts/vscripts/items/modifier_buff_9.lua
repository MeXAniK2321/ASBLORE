modifier_buff_9 = class({})

function modifier_buff_9:IsHidden()
	return false
end
function modifier_buff_9:RemoveOnDeath() return true end
function modifier_buff_9:AllowIllusionDuplicate()
	return true
end

function modifier_buff_9:IsPurgable()
    return false
end

function modifier_buff_9:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_buff_9:GetModifierAttackSpeedBonus_Constant()
    
    return 50
end

function modifier_buff_9:GetTexture()
	return "note"
end
function modifier_buff_9:GetEffectName()
	return "particles/attackspeed_chance.vpcf"
end