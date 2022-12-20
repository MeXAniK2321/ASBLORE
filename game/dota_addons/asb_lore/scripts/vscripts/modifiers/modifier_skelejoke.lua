modifier_skelejoke = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_skelejoke:IsHidden()
	return false
end

function modifier_skelejoke:IsDebuff()
	return true
end

function modifier_skelejoke:IsStunDebuff()
	return false
end

function modifier_skelejoke:IsPurgable()
	return true
end

function modifier_skelejoke:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_skelejoke:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	local sound_cast = "Joke.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_skelejoke:OnRefresh( kv )
	
end

function modifier_skelejoke:OnRemoved()
end

function modifier_skelejoke:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_skelejoke:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_skelejoke:GetModifierProvidesFOWVision()
	return 1
end

function modifier_skelejoke:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_skelejoke:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_skelejoke:Silence()
	-- add silence
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{ duration = self.duration } -- kv
	)

	-- damage
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

	local sound_cast = "Joke.Cast"
	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_skelejoke:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
end

function modifier_skelejoke:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_skelejoke:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_silencer/silencer_last_word_dmg.vpcf"
	local sound_cast = "Joke.End"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end