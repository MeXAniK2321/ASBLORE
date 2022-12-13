cerceus = class({})

--------------------------------------------------------------------------------
-- Ability Start
function cerceus:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")	
	local targets = self:GetSpecialValueFor("targets")
	if caster:HasScepter() then
		targets = self:GetSpecialValueFor("targets_scepter")
	end
	local projectile_name = "particles/cerceus_missles.vpcf"
	local projectile_speed = self:GetSpecialValueFor("speed")

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- create projectile for each enemy
	local info = {
		Source = caster,
		-- Target = target,
		Ability = self,
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,
		ExtraData = {
			damage = damage,
		}
	}
	for i=1,math.min(targets,#enemies) do
		info.Target = enemies[i]
		ProjectileManager:CreateTrackingProjectile( info )
	end

	-- effects
	
		local sound_cast = "ikaros.6_1"
		EmitSoundOn( sound_cast, caster )
	
end
--------------------------------------------------------------------------------
-- Projectile
function cerceus:OnProjectileHit_ExtraData( target, location, extraData )
	-- Apply damage
	local damage = {
		victim = target,
		attacker = self:GetCaster(),
		damage = extraData.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}
	ApplyDamage( damage )
 target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 1})
 self:GetCaster():PerformAttack(target, true,
				true,
				true,
				true,
				true,
				false,
				true)
	-- effects
	self:PlayEffects1( target )
end

--------------------------------------------------------------------------------
-- Effects
function cerceus:PlayEffects1( target )
	local particle_cast = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
	local sound_cast = "ikaros.rocket"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end

