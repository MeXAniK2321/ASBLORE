shana_shinpan = class({})
LinkLuaModifier( "modifier_shana_shinpan_aura", "modifiers/modifier_shana_shinpan_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shana_shinpan_thinker", "modifiers/modifier_shana_shinpan_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_urusai","heroes/shinpon", LUA_MODIFIER_MOTION_NONE)

function shana_shinpan:GetIntrinsicModifierName()
    return "modifier_urusai"
end
function shana_shinpan:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("angry_loli_urusai")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function shana_shinpan:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Phase Start


--------------------------------------------------------------------------------
-- Ability Start
function shana_shinpan:OnSpellStart()
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
		"modifier_shana_shinpan_thinker", -- modifier name
		{ duration = duration },		-- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point )

end

--------------------------------------------------------------------------------
function shana_shinpan:PlayEffects( point )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "shana.2"

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
