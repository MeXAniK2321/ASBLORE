black_destroy = black_destroy or class({})

--------------------------------------------------------------------------------
-- Ability Start

function black_destroy:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	
	-- load data
	local projectile_name = "particles/aksel_tornado.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,

		bHasFrontalCone		= false,
		bReplaceExisting	= false,
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		fExpireTime = GameRules:GetGameTime() + 1.5,
        vSpawnOrigin		= caster:GetAbsOrigin() + Vector(0,0,220),
		vVelocity			= Vector(direction.x,direction.y,0) * projectile_speed,
		bProvidesVision = false,
	}
	
	local direction   = (point - caster:GetAbsOrigin()):Normalized()
	info.vSpawnOrigin = caster:GetAbsOrigin() + direction * 125
	info.vVelocity = Vector(direction.x,direction.y,0) * projectile_speed
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
	self.sound_cast = "Accel.ikaraga"
	else
	self.sound_cast = "Black.tornado"
	end
	local sound_projectile = ""
	EmitSoundOn(self.sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Projectile
function black_destroy:OnProjectileHitHandle( target, location, projectile )
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

	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function black_destroy:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
