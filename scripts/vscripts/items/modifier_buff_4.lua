modifier_buff_4 = class({})

function modifier_buff_4:IsHidden()
	return false
end
function modifier_buff_4:RemoveOnDeath() return true end
function modifier_buff_4:AllowIllusionDuplicate()
	return true
end

function modifier_buff_4:IsPurgable()
    return false
end

function modifier_buff_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,    
		
    }

    return funcs
end

function modifier_buff_4:GetModifierMagicalResistanceBonus()
    return 10
end


function modifier_buff_4:GetTexture()
	return "note"
end
function modifier_buff_4:GetEffectName()
	return "particles/spell_resist_chance.vpcf"
end