modifier_generic_pause = class({})

--------------------------------------------------------------------------------
function modifier_generic_pause:IsHidden()
	return true
end

function modifier_generic_pause:IsDebuff()
	return false
end

function modifier_generic_pause:IsStunDebuff()
	return false
end

function modifier_generic_pause:IsPurgable()
	return false
end

function modifier_generic_pause:OnCreated(kv)
	if IsServer() then
	end
end

function modifier_generic_pause:OnDestroy( kv )
	if not IsServer() then return end
end

function modifier_generic_pause:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}

	return state
end