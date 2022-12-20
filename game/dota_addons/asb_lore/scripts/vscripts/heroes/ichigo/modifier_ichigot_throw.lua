modifier_ichigoT_throw = class({})

--------------------------------------------------------------------------------
function modifier_ichigoT_throw:IsHidden()
	return false
end

function modifier_ichigoT_throw:IsDebuff()
	return false
end

function modifier_ichigoT_throw:IsStunDebuff()
	return false
end

function modifier_ichigoT_throw:IsPurgable()
	return false
end

function modifier_ichigoT_throw:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0
	end
end
--------------------------------------------------------------------------------
function modifier_ichigoT_throw:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end

function modifier_ichigoT_throw:OnDestroy( kv )
	if not IsServer() then return end
end

function modifier_ichigoT_throw:GetModifierBonusStats_Intellect()
    return self.intelligence
end

function modifier_ichigoT_throw:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}

	return state
end