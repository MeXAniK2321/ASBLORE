modifier_ichigoE_target = class({})

--------------------------------------------------------------------------------
function modifier_ichigoE_target:IsHidden()
	return false
end

function modifier_ichigoE_target:IsDebuff()
	return false
end

function modifier_ichigoE_target:IsStunDebuff()
	return false
end

function modifier_ichigoE_target:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ichigoE_target:OnCreated( kv )
    if IsServer() then
		self.intelligence = 0
	end
end

--------------------------------------------------------------------------------
function modifier_ichigoE_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end

function modifier_ichigoE_target:GetModifierBonusStats_Intellect()
    return self.intelligence
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ichigoE_target:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end