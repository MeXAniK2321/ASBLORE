sin_blood_pact = class({})
LinkLuaModifier( "modifier_sins", "heroes/sin_blood_pact.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start

function sin_blood_pact:OnSpellStart()
	-- unit identifier
	self.caster = self:GetCaster()
	local point = self:GetCaster():GetOrigin()
	local point_caster = self:GetCaster():GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("area_of_effect")
	self.screamDamage = self:GetAbilityDamage()

	local projectile_name = "particles/flandr_try2.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Prebuilt Projectile info
	local info = {
		-- Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		vSourceLoc= point_caster,                -- Optional (HOW)
		bDodgeable = false,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = false,                           -- Optional
	}

	-- create projectile to all enemies hit
	for _,enemy in pairs(enemies) do
		info.Target = enemy
		ProjectileManager:CreateTrackingProjectile(info)
	end

	-- Play effects
	self:PlayEffects( point )
end
--------------------------------------------------------------------------------
-- Projectile
function sin_blood_pact:OnProjectileHit( target, location )
	-- Apply Damage	 
	local damageTable = {
		victim = target,
		attacker = self.caster,
		damage = self.screamDamage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	EmitSoundOn("flandr.4_1", self.caster)
	
	    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	  if not IsServer() then return nil end
    local caster = self:GetCaster()
    local duration = 3
    local incoming = 100
    local outgoing = 100
    local clones = 1



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, target:GetAbsOrigin() + RandomVector(200), duration, 1, incoming, outgoing)
    end
	end
	

--------------------------------------------------------------------------------
-- Ability Considerations
function sin_blood_pact:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
function sin_blood_pact:PlayEffects( location )
	-- Get Resources
	local particle_cast = "particles/flandr_sin_owner.vpcf"
	local sound_cast = "flandr.6_2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
