modifier_buff_5 = class({})

function modifier_buff_5:IsHidden()
	return false
end
function modifier_buff_5:RemoveOnDeath() return true end
function modifier_buff_5:AllowIllusionDuplicate()
	return true
end

function modifier_buff_5:IsPurgable()
    return false
end

function modifier_buff_5:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
    }

    return funcs
end

function modifier_buff_5:GetModifierBonusStats_Strength()
    return 15
end

function modifier_buff_5:GetModifierBonusStats_Agility()
    return 15
end

function modifier_buff_5:GetModifierBonusStats_Intellect()
    return 15
end


function modifier_buff_5:GetTexture()
	return "note"
end
function modifier_buff_5:GetEffectName()
	return "particles/stats_chance.vpcf"
end