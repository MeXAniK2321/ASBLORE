modifier_buff_6 = class({})

function modifier_buff_6:IsHidden()
	return false
end
function modifier_buff_6:RemoveOnDeath() return true end
function modifier_buff_6:AllowIllusionDuplicate()
	return true
end

function modifier_buff_6:IsPurgable()
    return false
end

function modifier_buff_6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
       
        
		
    }

    return funcs
end

function modifier_buff_6:GetModifierConstantHealthRegen()
    return 50
end

function modifier_buff_6:GetTexture()
	return "note"
end
function modifier_buff_6:GetEffectName()
	return "particles/regen_chance.vpcf"
end