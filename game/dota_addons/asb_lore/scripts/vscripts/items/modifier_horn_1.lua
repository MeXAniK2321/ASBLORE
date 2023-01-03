modifier_horn_1 = class({})

function modifier_horn_1:IsHidden()
	return false
end
function modifier_horn_1:RemoveOnDeath() return false end
function modifier_horn_1:AllowIllusionDuplicate()
	return false
end

function modifier_horn_1:IsPurgable()
    return false
end

function modifier_horn_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,   
		
    }

    return funcs
end

function modifier_horn_1:GetModifierPreAttack_BonusDamage()
    return 100
end


function modifier_horn_1:GetTexture()
	return "note"
end
function modifier_horn_1:GetEffectName()
	return "particles/attack_great2.vpcf"
end