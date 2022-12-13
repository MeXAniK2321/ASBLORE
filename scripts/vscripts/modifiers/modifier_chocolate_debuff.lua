modifier_chocolate_debuff = class({})

--------------------------------------------------------------------------------

function modifier_chocolate_debuff:IsDebuff()
	return true
end

function modifier_chocolate_debuff:IsStunDebuff()
	return true
end
function modifier_chocolate_debuff:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

end

--------------------------------------------------------------------------------

function modifier_chocolate_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_chocolate_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_chocolate_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_chocolate_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_chocolate_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end