modifier_frisk_analys = class({})

--------------------------------------------------------------------------------

function modifier_frisk_analys:IsDebuff()
	return true
end

function modifier_frisk_analys:IsStunDebuff()
	return false
end
function modifier_frisk_analys:IsHidden()
	return false
end
function modifier_frisk_analys:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_frisk_analys:DeclareFunctions()
    local funcs = {
        
       
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end


  function  modifier_frisk_analys:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end  

--------------------------------------------------------------------------------

function modifier_frisk_analys:GetEffectName()
	return "particles/frisk_thinking_debuff.vpcf"
end

function modifier_frisk_analys:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end