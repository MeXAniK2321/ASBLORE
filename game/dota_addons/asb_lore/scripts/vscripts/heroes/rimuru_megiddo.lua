rimuru_megiddo = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rimuru_megiddo", "modifiers/modifier_rimuru_megiddo", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function rimuru_megiddo:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local origin = caster:GetOrigin()
	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")
	
self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_rimuru_megiddo", -- modifier name
		{ duration = 10 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_rimuru_megiddo")
	

	self:PlayEffects( radius )
	self:PlayEffects2(origin,radius,duration)
end
function rimuru_megiddo:PlayEffects2( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/rimuru_megiddo.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end
function rimuru_megiddo:PlayEffects( radius )
	local particle_cast = "particles/megiddo_visible_circle.vpcf"
	local sound_cast = "rimuru.6_5"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end