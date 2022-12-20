modifier_jibril_kurianse_effect = class({})

--------------------------------------------------------------------------------

function modifier_jibril_kurianse_effect:DeclareFunctions()
	local funcs = {
		
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end


function modifier_jibril_kurianse_effect:GetModifierIncomingDamage_Percentage( params )
	 

		return -50
	
end


function modifier_jibril_kurianse_effect:GetTexture()
	return "jin_mori_2"
end


