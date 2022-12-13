modifier_doki_doki = class({})

function modifier_doki_doki:IsHidden()
	return false
end
function modifier_doki_doki:RemoveOnDeath() return true end
function modifier_doki_doki:AllowIllusionDuplicate()
	return true
end

function modifier_doki_doki:IsPurgable()
    return false
end

function modifier_doki_doki:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       
        
		
    }

    return funcs
end

function modifier_doki_doki:GetBonusNightVision()
    return -800
end
function modifier_doki_doki:GetBonusDayVision()

    return -800

end
function modifier_doki_doki:GetModifierIncomingDamage_Percentage( params )
	

		return 15
	end


function modifier_doki_doki:GetEffectName()
	return "particles/altair_explosion2.vpcf"
end