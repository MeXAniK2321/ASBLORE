modifier_buff_10 = class({})

function modifier_buff_10:IsHidden()
	return false
end
function modifier_buff_10:RemoveOnDeath() return true end
function modifier_buff_10:AllowIllusionDuplicate()
	return true
end

function modifier_buff_10:IsPurgable()
    return false
end

function modifier_buff_10:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EVASION_CONSTANT
       
        
		
    }

    return funcs
end

  function modifier_buff_10:GetModifierEvasion_Constant()
return 40
end  

function modifier_buff_10:GetTexture()
	return "note"
end
function modifier_buff_10:GetEffectName()
	return "particles/evasion_chance.vpcf"
end