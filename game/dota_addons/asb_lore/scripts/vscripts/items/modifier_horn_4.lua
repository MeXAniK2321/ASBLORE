modifier_horn_4 = class({})

function modifier_horn_4:IsHidden()
	return false
end
function modifier_horn_4:RemoveOnDeath() return false end
function modifier_horn_4:AllowIllusionDuplicate()
	return false
end

function modifier_horn_4:IsPurgable()
    return false
end

function modifier_horn_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
    }

    return funcs
end

function modifier_horn_4:GetModifierPreAttack_BonusDamage()
    return 0
end
function modifier_horn_4:GetModifierBonusStats_Strength()
    return 10
end

function modifier_horn_4:GetModifierBonusStats_Agility()
    return 10
end

function modifier_horn_4:GetModifierBonusStats_Intellect()
    return 10
end

function modifier_horn_4:GetTexture()
	return "note"
end
function modifier_horn_4:GetEffectName()
	return "particles/attack_great3.vpcf"
end