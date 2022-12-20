modifier_c1_centipide = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_c1_centipide:IsHidden()
	return true
end

function modifier_c1_centipide:IsDebuff()
	return true
end

function modifier_c1_centipide:IsStunDebuff()
	return false
end

function modifier_c1_centipide:IsPurgable()
	return true
end

function modifier_c1_centipide:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_c1_centipide:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_c1_centipide:OnRefresh( kv )
	
end

function modifier_c1_centipide:OnRemoved()
end

function modifier_c1_centipide:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_c1_centipide:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_c1_centipide:GetModifierProvidesFOWVision()
	return 1
end

function modifier_c1_centipide:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_c1_centipide:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_c1_centipide:Silence()
	-- add silence
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_c1_centipide_root", -- modifier name
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

	local sound_cast = ""
	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_c1_centipide:GetEffectName()
	return ""
end

function modifier_c1_centipide:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_c1_centipide:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end