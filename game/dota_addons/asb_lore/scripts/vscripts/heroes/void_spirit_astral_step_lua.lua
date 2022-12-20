void_spirit_astral_step_lua = class({})
LinkLuaModifier( "modifier_void_spirit_astral_step_lua", "modifiers/modifier_void_spirit_astral_step_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier


--------------------------------------------------------------------------------
-- Ability Start
function void_spirit_astral_step_lua:OnAbilityPhaseStart()
    local caster = self:GetCaster()
	local point = caster:GetOrigin()
	local radius = 400
	local debuffDuration = 1
	self:PlayEffects3(point, radius, debuffDuration)
	return true 
end
function void_spirit_astral_step_lua:OnAbilityPhaseInterrupted()
    local caster = self:GetCaster()
	local point = caster:GetOrigin()
	local radius = 400
	local debuffDuration = 1
	self:StopEffects3(point, radius, debuffDuration)
end
function void_spirit_astral_step_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local min_dist = self:GetSpecialValueFor( "min_travel_distance" )
	local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
	local radius = self:GetSpecialValueFor( "radius" )
	local delay = self:GetSpecialValueFor( "pop_damage_delay" )

	-- find destination
	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )

	-- teleport
	FindClearSpaceForUnit( caster, target, true )

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
		caster:PerformAttack( enemy, true, true, true, false, true, false, true )

		-- add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_void_spirit_astral_step_lua", -- modifier name
			{ duration = delay } -- kv
		)

		-- play effects
		self:PlayEffects2( enemy )
	end

	-- play effects
	self:PlayEffects1( origin, target )
end

--------------------------------------------------------------------------------
function void_spirit_astral_step_lua:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/void_spirit_astral_step1.vpcf"
	local sound_start = "ikki.raiko"
	local sound_end = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function void_spirit_astral_step_lua:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/void_spirit_astral_step_impact1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
function void_spirit_astral_step_lua:PlayEffects3( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/raiko_pre.vpcf"
	local sound_cast = ""

	-- Create Particle
	self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast2, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast2, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( self.effect_cast2 )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function void_spirit_astral_step_lua:StopEffects3( point, radius, duration )
	ParticleManager:DestroyParticle( self.effect_cast2, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
end

