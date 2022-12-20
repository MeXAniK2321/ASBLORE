modifier_world_negation = class({})

--------------------------------------------------------------------------------

function modifier_world_negation:IsDebuff()
	return true
end

function modifier_world_negation:IsStunDebuff()
	return true
end
function modifier_world_negation:OnDestroy()
	
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
self:PlayEffects()

end

--------------------------------------------------------------------------------

function modifier_world_negation:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_world_negation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_world_negation:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_world_negation:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_world_negation:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_world_negation:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/pandora_blood_exp.vpcf"
	local sound_cast = "Pandora.exp"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end