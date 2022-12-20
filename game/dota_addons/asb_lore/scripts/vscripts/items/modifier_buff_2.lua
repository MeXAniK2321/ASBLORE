modifier_buff_2 = class({})

function modifier_buff_2:IsHidden()
	return false
end
function modifier_buff_2:RemoveOnDeath() return true end
function modifier_buff_2:AllowIllusionDuplicate()
	return true
end

function modifier_buff_2:IsPurgable()
    return false
end

function modifier_buff_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end

function modifier_buff_2:GetModifierPreAttack_BonusDamage()
    return 100
end


function modifier_buff_2:GetTexture()
	return "note"
end
function modifier_buff_2:GetEffectName()
	return "particles/attack_great.vpcf"
end