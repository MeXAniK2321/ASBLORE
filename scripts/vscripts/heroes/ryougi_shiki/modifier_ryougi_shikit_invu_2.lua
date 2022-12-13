modifier_ryougi_shikiT_invu_2 = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shikiT_invu_2:IsHidden()
	return false
end

function modifier_ryougi_shikiT_invu_2:IsDebuff()
	return true
end

function modifier_ryougi_shikiT_invu_2:IsStunDebuff()
	return true
end

function modifier_ryougi_shikiT_invu_2:IsPurgable()
	return false
end

function modifier_ryougi_shikiT_invu_2:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0
	end
end
--------------------------------------------------------------------------------75

function modifier_ryougi_shikiT_invu_2:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}

	return state
end

function modifier_ryougi_shikiT_invu_2:GetModifierHPRegenAmplify_Percentage()
	return -75.0
end


function modifier_ryougi_shikiT_invu_2:OnDestroy( kv )
end

