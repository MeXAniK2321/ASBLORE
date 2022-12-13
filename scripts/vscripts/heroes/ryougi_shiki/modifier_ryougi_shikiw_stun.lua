modifier_ryougi_shikiW_stun = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shikiW_stun:IsHidden()
	return false
end

function modifier_ryougi_shikiW_stun:IsDebuff()
	return false
end

function modifier_ryougi_shikiW_stun:IsStunDebuff()
	return false
end

function modifier_ryougi_shikiW_stun:IsPurgable()
	return false
end

function modifier_ryougi_shikiW_stun:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0
	end
end
--------------------------------------------------------------------------------
function modifier_ryougi_shikiW_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end


function modifier_ryougi_shikiW_stun:OnDestroy( kv )
end

function modifier_ryougi_shikiW_stun:GetModifierBonusStats_Intellect()
    return self.intelligence
end

function modifier_ryougi_shikiW_stun:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end
