modifier_esdeath_ice_path = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_esdeath_ice_path:IsHidden()
	return false
end

function modifier_esdeath_ice_path:IsDebuff()
	return true
end

function modifier_esdeath_ice_path:IsStunDebuff()
	return true
end

function modifier_esdeath_ice_path:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_esdeath_ice_path:OnCreated( kv )
end

function modifier_esdeath_ice_path:OnRefresh( kv )
	end

function modifier_esdeath_ice_path:OnRemoved()
end

function modifier_esdeath_ice_path:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_esdeath_ice_path:CheckState()
	local state = {
		
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_esdeath_ice_path:GetEffectName()
	return "particles/jakiro_icepath_debuff1.vpcf"
end

function modifier_esdeath_ice_path:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end