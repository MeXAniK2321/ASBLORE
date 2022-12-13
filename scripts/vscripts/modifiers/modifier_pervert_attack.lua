modifier_pervert_attack = class({})

--------------------------------------------------------------------------------

function modifier_pervert_attack:IsDebuff()
	return true
end

function modifier_pervert_attack:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pervert_attack:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_pervert_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_pervert_attack:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_pervert_attack:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
function modifier_pervert_attack:OnDestroy()
 self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_dark_willow_terrorize_lua", -- modifier name
		{ duration = 2.5 } -- kv
	)
end

function modifier_pervert_attack:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end