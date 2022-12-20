modifier_minya_arrow = class({})

--------------------------------------------------------------------------------

function modifier_minya_arrow:IsDebuff()
	return true
end

function modifier_minya_arrow:IsStunDebuff()
	return true
end
function modifier_minya_arrow:OnDestroy()
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = (5/100)*self:GetParent():GetMaxHealth(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
end

--------------------------------------------------------------------------------

function modifier_minya_arrow:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_minya_arrow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_minya_arrow:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_minya_arrow:GetEffectName()
	return "particles/minya_arrow_effect.vpcf"
end

function modifier_minya_arrow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end