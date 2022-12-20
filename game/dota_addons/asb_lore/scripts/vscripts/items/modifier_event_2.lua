modifier_event_2 = class({})

function modifier_event_2:IsHidden()
	return false
end
function modifier_event_2:RemoveOnDeath() return true end
function modifier_event_2:AllowIllusionDuplicate()
	return false
end

function modifier_event_2:IsPurgable()
    return false
end

function modifier_event_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,

		
	}

	return funcs
end

function modifier_event_2:GetModifierProvidesFOWVision()
	return 1
end
function modifier_event_2:GetModifierIncomingDamage_Percentage( params )
		return 100
end
function modifier_event_2:OnDestroy()
	StopGlobalSound("star.event_2")
	
end

function modifier_event_2:GetTexture()
	return "note"
end
function modifier_event_2:GetEffectName()
	return "particles/event_2.vpcf"
end