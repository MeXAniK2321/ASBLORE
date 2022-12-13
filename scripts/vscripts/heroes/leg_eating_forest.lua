leg_eating_forest = class({})
LinkLuaModifier( "modifier_leg_eating_forest_aura", "modifiers/modifier_leg_eating_forest_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leg_eating_forest_thinker", "modifiers/modifier_leg_eating_forest_thinker", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function leg_eating_forest:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Phase Start


--------------------------------------------------------------------------------
-- Ability Start
function leg_eating_forest:OnSpellStart()
	-- release cast effect
	
	
	

	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "pit_duration" )
	
	

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_leg_eating_forest_thinker", -- modifier name
		{ duration = duration },		-- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point )

end

--------------------------------------------------------------------------------
function leg_eating_forest:PlayEffects( point )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "kumagawa.3"

	-- Get Data
	local radius = self:GetSpecialValueFor( "radius" )

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, 1, 1 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
