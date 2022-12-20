spirit_bomb = class({})
LinkLuaModifier( "modifier_genkidama", "modifiers/modifier_genkidama", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function spirit_bomb:GetAOERadius()
	return self:GetSpecialValueFor( "destination_radius" )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function spirit_bomb:OnAbilityPhaseStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local vector = point-caster:GetOrigin()
	vector.z = 0

	-- get data
	local radius = self:GetSpecialValueFor( "destination_radius" )
	local height = self:GetSpecialValueFor( "starting_height" )

	-- create wisp
	self.wisp = CreateUnitByName(
		"npc_dummy_unit",
		caster:GetOrigin(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)
	self.wisp:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_genkidama", -- modifier name
		{} -- kv
	)
	self.wisp:SetForwardVector( vector:Normalized() )
	self.wisp:SetOrigin( self.wisp:GetOrigin() + Vector( 0,0,height ) )

	-- create effects
	self:PlayEffects1( point, radius )
	self:PlayEffects2()

	return true -- if success
end
function spirit_bomb:OnAbilityPhaseInterrupted()
	UTIL_Remove( self.wisp )

	self:StopEffects1()
	self:StopEffects2()
end

--------------------------------------------------------------------------------
-- Ability Start
function spirit_bomb:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local vector = point-caster:GetOrigin()
	vector.z = 0
	local origin = caster:GetOrigin()

	-- load data
	local height = self:GetSpecialValueFor( "starting_height" )

	local projectile_name = ""
	local projectile_speed = self:GetSpecialValueFor( "destination_travel_speed" )
	local projectile_distance = vector:Length2D()
	local projectile_direction = vector:Normalized()
	local projectile_height = self:GetSpecialValueFor( "450" )

	-- projectiles don't change height, so better pre-set it to have nice effect
	local spawn_origin = caster:GetOrigin()
	spawn_origin.z = GetGroundHeight( point, caster )
	height = origin.z + height - spawn_origin.z

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = spawn_origin,
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = 0,
	    fEndRadius = 0,
		vVelocity = projectile_direction * projectile_speed,

		ExtraData = {
			origin_x = origin.x,
			origin_y = origin.y,
			origin_z = origin.z,
			distance = projectile_distance,
			height = height,
			returning = 0,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- deactivate ability
	self:SetActivated( true )
	local ability = caster:FindAbilityByName( "dark_willow_bedlam_lua" )
	if ability then ability:SetActivated( false ) end
	
end
--------------------------------------------------------------------------------
-- Projectile
function spirit_bomb:OnProjectileHit_ExtraData( target, location, ExtraData )
	local returning = ExtraData.returning==1

	if returning then
		-- kill the wisp
		UTIL_Remove( self.wisp )

		-- deactivate ability
		self:SetActivated( true )
		local ability = self:GetCaster():FindAbilityByName( "dark_willow_bedlam_lua" )
		if ability then ability:SetActivated( true ) end
		return
	end

	-- get data
	local radius = self:GetSpecialValueFor( "destination_radius" )
	local duration = self:GetSpecialValueFor( "destination_status_duration" )

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
    local damage = self:GetSpecialValueFor( "damage" )
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- add fear
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- create return projectile
	local projectile_speed = self:GetSpecialValueFor( "return_travel_speed" )
	local info = {
		Target = self:GetCaster(),
		Source = self.wisp,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional

		ExtraData = {
			returning = 1,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- set wisp activity
	self.wisp:StartGesture( ACT_DOTA_CAST_ABILITY_5 )

	-- play effects
	self:PlayEffects3( location, radius, #enemies )
end

function spirit_bomb:OnProjectileThink_ExtraData( location, ExtraData )
	local returning = ExtraData.returning==1
	if returning then
		-- get facing direction
		local direction = location
		direction.z = -10000
		direction = direction:Normalized()

		-- set position
		self.wisp:SetOrigin( location )
		self.wisp:SetForwardVector( direction )
		return
	end

	-- get data
	local origin = Vector( ExtraData.origin_x, ExtraData.origin_y, ExtraData.origin_z )
	local distance = ExtraData.distance
	local height = ExtraData.height

	-- interpolate height
	local current_dist = (location-origin):Length2D()

	local current_height = height - (current_dist/distance)*height

	self.wisp:SetOrigin( location + Vector( 0,0,current_height ) )
end

--------------------------------------------------------------------------------
function spirit_bomb:PlayEffects1( point, radius )
	-- Get Resources
	local particle_cast = ""

	-- Create Particle
	-- self.effect_cast1 = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	self.effect_cast1 = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast1, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast1, 1, Vector( radius, 0, 0 ) )

	-- play sound
	local sound_cast1 = "goku.4"
	local sound_cast2 = "goku.4_1"
	local sound_cast3 = "goku.4_1"
	EmitSoundOn( sound_cast1, self:GetCaster() )
	EmitSoundOn( sound_cast2, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast3, self:GetCaster() )
end
function spirit_bomb:StopEffects1()
	-- destroy particle
	ParticleManager:DestroyParticle( self.effect_cast1, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast1 )

	-- stop sound
	local sound_cast1 = "goku.4"
	local sound_cast2 = "goku.4_1"
	local sound_cast3 = "goku.4_1"
	StopSoundOn( sound_cast1, self:GetCaster() )
	StopSoundOn( sound_cast2, self:GetCaster() )
	StopSoundOn( sound_cast3, self:GetCaster() )
end

function spirit_bomb:PlayEffects2()
	if IsASBPatreon(self:GetCaster()) then
	self.particle_cast1 = "particles/supreme_spirit_bomb.vpcf"
	else
	self.particle_cast1 = "particles/spirit_bomb.vpcf"
	end

	-- Create Particle
	-- self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.wisp )
	self.effect_cast2 = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, self.particle_cast1, PATTACH_ABSORIGIN_FOLLOW, self.wisp )
end
function spirit_bomb:StopEffects2()
	-- destroy particle
	ParticleManager:DestroyParticle( self.effect_cast2, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
end

function spirit_bomb:PlayEffects3( point, radius, number )
	if IsASBPatreon(self:GetCaster()) then
		self.particle_cast = "particles/supreme_spirit_bomb_explosion.vpcf"
	else
	self.particle_cast = "particles/spirit_bomb_explosion.vpcf"
	end
	

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, self.particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, radius*2 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end