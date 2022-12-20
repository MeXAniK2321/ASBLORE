modifier_vampire_bite = class({})
 
--------------------------------------------------------------------------------

function modifier_vampire_bite:IsDebuff()
	return true
end

function modifier_vampire_bite:IsStunDebuff()
	return false
end
function modifier_vampire_bite:IsHidden()
	return false
end
function modifier_vampire_bite:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_vampire_bite:DeclareFunctions()
    local funcs = {
        
       
        
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
    }

    return funcs
end


  function  modifier_vampire_bite:GetModifierIncomingPhysicalDamage_Percentage()
return self:GetAbility():GetSpecialValueFor( "damage" )
end  

--------------------------------------------------------------------------------

function modifier_vampire_bite:GetEffectName()
	return "particles/broken_armor.vpcf"
end

function modifier_vampire_bite:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end