modifier_frisk_return_debuff = class({})

--------------------------------------------------------------------------------

function modifier_frisk_return_debuff:IsDebuff()
	return true
end

function modifier_frisk_return_debuff:IsStunDebuff()
	return true
end
function  modifier_frisk_return_debuff:OnCreated(table)

end
--------------------------------------------------------------------------------

function modifier_frisk_return_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_frisk_return_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_frisk_return_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_frisk_return_debuff:GetEffectName()
	return "particles/econ/items/spirit_breaker/spirit_breaker_weapon_ti8/spirit_breaker_bash_ti8.vpcf"
end

function modifier_frisk_return_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end