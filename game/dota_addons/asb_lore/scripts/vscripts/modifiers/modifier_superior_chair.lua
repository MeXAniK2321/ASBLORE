modifier_superior_chair = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_superior_chair:IsHidden()
	return false
end

function modifier_superior_chair:IsDebuff()
	return false
end

function modifier_superior_chair:IsPurgable()
	return false
end

function modifier_superior_chair:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_superior_chair:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_superior_chair:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end


function modifier_superior_chair:GetModifierIncomingDamage_Percentage( params )
	 

		return -100

end

