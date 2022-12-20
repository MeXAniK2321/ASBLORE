freya = class({})
LinkLuaModifier( "modifier_freya", "modifiers/modifier_freya", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_freya_slow", "modifiers/modifier_freya", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jjj", "heroes/freya.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function freya:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function freya:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_freya", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
end
function freya:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/freya_circle.vpcf"
	local sound_cast = "lelouch.freya"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_x_canon_thinker = class ({})

function modifier_x_canon_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end