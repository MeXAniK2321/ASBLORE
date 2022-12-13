modifier_ryougi_shiki_T_target = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shiki_T_target:IsHidden()
	return false
end

function modifier_ryougi_shiki_T_target:IsDebuff()
	return false
end

function modifier_ryougi_shiki_T_target:IsStunDebuff()
	return false
end

function modifier_ryougi_shiki_T_target:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ryougi_shiki_T_target:OnCreated( kv )
    if IsServer() then
		self.intelligence = 0
	end
end

--------------------------------------------------------------------------------
function modifier_ryougi_shiki_T_target:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end

function modifier_ryougi_shiki_T_target:GetModifierBonusStats_Intellect()
    return self.intelligence
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ryougi_shiki_T_target:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end