modifier_debuff_7 = class({})

function modifier_debuff_7:IsHidden()
	return false
end
function modifier_debuff_7:RemoveOnDeath() return true end
function modifier_debuff_7:AllowIllusionDuplicate()
	return true
end

function modifier_debuff_7:IsPurgable()
    return false
end

function modifier_debuff_7:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
       
        
		
    }

    return funcs
end

function modifier_debuff_7:GetModifierPhysicalArmorBonus()
    return -10
end


function modifier_debuff_7:GetTexture()
	return "note"
end
function modifier_debuff_7:GetEffectName()
	return "particles/debuff_7.vpcf"
end