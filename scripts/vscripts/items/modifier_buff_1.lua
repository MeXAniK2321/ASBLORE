modifier_buff_1 = class({})

function modifier_buff_1:IsHidden()
	return false
end

function modifier_buff_1:AllowIllusionDuplicate()
	return true
end
function modifier_buff_1:RemoveOnDeath() return true end
function modifier_buff_1:IsPurgable()
    return false
end

function modifier_buff_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,    
		
    }

    return funcs
end

function modifier_buff_1:GetModifierPhysicalArmorBonus()
    return 10
end

function modifier_buff_1:GetTexture()
	return "note"
end
function modifier_buff_1:GetEffectName()
	return "particles/armor_great.vpcf"
end