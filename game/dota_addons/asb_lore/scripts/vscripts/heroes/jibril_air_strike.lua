jibril_air_strike = class({})
LinkLuaModifier( "modifier_jibril_air_strike", "modifiers/modifier_jibril_air_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function jibril_air_strike:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function jibril_air_strike:OnSpellStart()
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
		"modifier_jibril_air_strike", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
	EmitGlobalSound("jibril.5_1")
end
function jibril_air_strike:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/jibril_air_strike.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end
