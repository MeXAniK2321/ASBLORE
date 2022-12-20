modifier_danku_debuff = class({})

--------------------------------------------------------------------------------

function modifier_danku_debuff:IsDebuff()
	return true
end

function modifier_danku_debuff:IsStunDebuff()
	return true
end
function modifier_danku_debuff:OnCreated()

  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	

	local sound_cast = "aizen.2_1"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy
	
end

--------------------------------------------------------------------------------

function modifier_danku_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_danku_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_danku_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_danku_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_danku_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end