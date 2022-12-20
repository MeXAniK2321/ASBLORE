modifier_silent_kill = class({})

--------------------------------------------------------------------------------

function modifier_silent_kill:IsDebuff()
	return true
end

function modifier_silent_kill:IsStunDebuff()
	return true
end
function modifier_silent_kill:OnDestroy()
if self:GetCaster():HasModifier( "modifier_little_nightmare" ) then
self.damage = 3000
else
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.2 } -- kv
	)
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
function modifier_silent_kill:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/silent_kill_death.vpcf"
	local sound_cast = "chara.41"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_silent_kill:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_silent_kill:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_silent_kill:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_silent_kill:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_silent_kill:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end