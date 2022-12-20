modifier_buff_3 = class({})

function modifier_buff_3:IsHidden()
	return false
end
function modifier_buff_3:RemoveOnDeath() return true end
function modifier_buff_3:AllowIllusionDuplicate()
	return true
end

function modifier_buff_3:IsPurgable()
    return false
end

function modifier_buff_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,    
		
    }

    return funcs
end

function modifier_buff_3:GetModifierSpellAmplify_Percentage()
    return 30
end

function modifier_buff_3:GetTexture()
	return "note"
end
function modifier_buff_3:GetEffectName()
	return "particles/spd_great.vpcf"
end