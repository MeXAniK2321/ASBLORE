modifier_horn_5 = class({})

function modifier_horn_5:IsHidden()
	return false
end
function modifier_horn_5:RemoveOnDeath() return false end
function modifier_horn_5:AllowIllusionDuplicate()
	return false
end

function modifier_horn_5:IsPurgable()
    return false
end

function modifier_horn_5:DeclareFunctions()
    local funcs = {
       
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 		
		
    }

    return funcs
end

function modifier_horn_5:GetModifierMoveSpeedBonus_Constant()

	return 30
	
end
function modifier_horn_5:GetModifierAttackSpeedBonus_Constant()
    
    return 50
end

function modifier_horn_5:GetModifierPhysicalArmorBonus()
    return 10
end
function modifier_horn_5:OnDestroy()
	StopGlobalSound("star.horn_5")
	
end
function modifier_horn_5:GetTexture()
	return "note"
end
function modifier_horn_5:GetEffectName()
	return "particles/armor_great3.vpcf"
end