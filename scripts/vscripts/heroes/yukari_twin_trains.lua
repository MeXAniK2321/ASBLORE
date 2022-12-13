yukari_twin_trains = class({})
LinkLuaModifier( "modifier_train_1", "heroes/yukari_twin_trains", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_train_2", "heroes/yukari_twin_trains", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_untarget2", "modifiers/modifier_untarget2", LUA_MODIFIER_MOTION_NONE )

function yukari_twin_trains:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("yukari_mass_tp")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function yukari_twin_trains:CastFilterResultLocation(location)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self

		-- Ability specials
		local mine_distance = 600
		local trigger_range = 600

		-- #1 Talent: Trigger range increase
		trigger_range = trigger_range 

		-- Radius
		local radius = 1100

		-- Look for nearby mines
		local friendly_units = FindUnitsInRadius(caster:GetTeamNumber(),
												location,
												nil,
												radius,
												DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												DOTA_UNIT_TARGET_OTHER,
												DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
												FIND_ANY_ORDER,
												false)

		local mine_found = false

		-- Search and see if mines were found
		for _,unit in pairs(friendly_units) do
			local unitName = unit:GetUnitName()
			if unitName == "npc_dota_yukari_debugg" then
				mine_found = true
				break
			end
		end

		if mine_found then
			return UF_FAIL_CUSTOM
		else
			return UF_SUCCESS
		end
	end
end
function yukari_twin_trains:OnSpellStart()
	-- unit identifier
local caster = self:GetCaster()
	

if caster:HasModifier("modifier_train_1") then
self.point2 = self:GetCursorPosition()
	local projectile_name = "particles/yukari_twin_train.vpcf"
	local distance = (self.point2 - self.point):Length2D()
	local projectile_distance = distance * 0.45
 	local projectile_speed = 1000
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )
    local life  = projectile_distance * 0.001
	local direction = self.point2-self.point
	self.point3 = (self.point + self.point2) * 0.5
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = self.point,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)
	
	local direction2 = self.point-self.point2
	direction2.z = 0
	local projectile_direction2 = direction2:Normalized()

	-- create projectile
	local info2 = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = self.point2,
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction2 * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info2)
	EmitSoundOn( "yukari.twin_trains", caster )
local radius = 600
local delay = life

	Timers:CreateTimer(delay,function()

local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self.point3,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = 9000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
end		
	self:PlayEffects(radius)
	end)
	self:PlayEffects2(radius)
	EmitSoundOn( "i.like.trains", caster ) 
	EmitSoundOn( "yukari.train", caster ) 
else
self.point = self:GetCursorPosition()
caster:AddNewModifier(caster, self, "modifier_train_1", { duration = 15})
self:EndCooldown()
   local player = caster:GetPlayerID()
self.len = CreateUnitByName("npc_dota_yukari_debugg", self.point, true, caster, caster, caster:GetTeamNumber())
        self.len:SetControllableByPlayer(player, true)
		self.len:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_untarget2", -- modifier name
		{ duration = 15 } -- kv
	)
	self.len:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 15})
   local radius = 300
	self:PlayEffects1(radius)
	
	
	
	
	
	
	
end
end
function yukari_twin_trains:PlayEffects( radius )
	local particle_cast = "particles/yukari_twin_train_explosion.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.point3 )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOn( "yukari.trains_explosion", self:GetCaster() ) 
	
end
function yukari_twin_trains:PlayEffects1( radius )
	local particle_cast = "particles/yukari_portal_trains.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
function yukari_twin_trains:PlayEffects2( radius )
	local particle_cast = "particles/yukari_portal228.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.point2 )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
function yukari_twin_trains:OnProjectileHitHandle( target, location, projectile )
	if not target then return end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

end
modifier_train_1 = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_train_1:OnDestroy( kv )
	local ability = self:GetParent():FindAbilityByName("yukari_twin_trains")
	ability:StartCooldown(ability:GetCooldown(-1) * self:GetParent():GetCooldownReduction())
end





modifier_train_2 = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_train_2:OnCreated( kv )
	local caster = self:GetParent()
	local projectile_name = "particles/yukari_train.vpcf"
	local projectile_distance = 1000
	local projectile_speed = 1000
	local projectile_start_radius = 350
	local projectile_end_radius = 350
	local point = kv.place

	-- get direction
	local direction = point-self:GetParent():GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = self:GetParent():GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)
	local radius = 600
	local debuffDuration = 1
	self:PlayEffects1( caster, radius, debuffDuration )
end

function modifier_train_2:OnProjectileHitHandle( target, location, projectile )
	if not target then return end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = 9999,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()


end
function modifier_train_2:PlayEffects1( caster, radius, duration )
	-- Get Resources
	local particle_cast = "particles/yukari_portal3.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end