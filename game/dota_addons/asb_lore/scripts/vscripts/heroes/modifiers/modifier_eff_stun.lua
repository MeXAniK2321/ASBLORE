modifier_eff_stun = class({})

--------------------------------------------------------------------------------
function modifier_eff_stun:IsHidden()
	return false
end

function modifier_eff_stun:IsDebuff()
	return true
end

function modifier_eff_stun:IsStunDebuff()
	return true
end

function modifier_eff_stun:IsPurgable()
	return false
end

function modifier_eff_stun:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0

		if "Gintoki.R3" then
			StopSoundOn("Gintoki.R3", self:GetParent())
		end
	end
end
--------------------------------------------------------------------------------
function modifier_eff_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end


function modifier_eff_stun:OnDestroy( kv )
	if not IsServer() then return end
end

function modifier_eff_stun:GetModifierBonusStats_Intellect()
    return self.intelligence
end

function modifier_eff_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}

	return state
end
--------------------------------------------------------------------------------
function modifier_eff_stun:GetEffectName()
	return "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_stunned_orbit.vpcf"
end

function modifier_eff_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end