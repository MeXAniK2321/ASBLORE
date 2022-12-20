jibril_black_rockets = class({})
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function jibril_black_rockets:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end
function jibril_black_rockets:OnSpellStart()
	-- unit identifier
	self.caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local point_caster = self:GetCaster():GetOrigin()
    local duration = self:GetSpecialValueFor("duration")
	-- load data
	local radius = self:GetSpecialValueFor("area_of_effect")
	self.screamDamage = self:GetSpecialValueFor("damage")

	local projectile_name = "particles/jibril_test_missles.vpcf"
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
		bDodgeable = true,                                -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = false,                           -- Optional
	}
	local damage = 2700
	local damageTable = {
		victim = target,
		attacker = self.caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	if self:GetCaster():HasModifier("modifier_jibril_assasination_mode") then
	for _,enemy in pairs(enemies) do
		self.caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
		
		
		
		ApplyDamage(damageTable)
		enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = 2.6})
		self:PlayEffects1(  point, radius, duration )
		
	end
	else
	for _,enemy in pairs(enemies) do
		info.Target = enemy
		self.caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
		
		ProjectileManager:CreateTrackingProjectile(info)
		
		
		self:PlayEffects( point )
	end
	end

	-- Play effects
	
end
--------------------------------------------------------------------------------
-- Projectile
function jibril_black_rockets:OnProjectileHit( target, location )
	-- Apply Damage	 
	if  target:IsMagicImmune() then
	else
	local damageTable = {
		victim = target,
		attacker = self.caster,
		damage = self.screamDamage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	local duration = self:GetSpecialValueFor("duration")
     target:AddNewModifier(self.caster, self, "modifier_root", {duration = duration})
	

	ApplyDamage(damageTable)
	EmitSoundOn("jibril.3_exp", self.caster)
	end
end


--------------------------------------------------------------------------------
-- Ability Considerations
function jibril_black_rockets:AbilityConsiderations()
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
function jibril_black_rockets:PlayEffects( location )
	-- Get Resources
	local particle_cast = "particles/jibril_circle.vpcf"
	local sound_cast = "jibril.3"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function jibril_black_rockets:PlayEffects1( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/jibril_reapers_scythe.vpcf"
	local sound_cast = "jibril.reaper_scythe"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

modifier_bloodly = class ({})
function modifier_bloodly:IsHidden() return true end
function modifier_bloodly:IsDebuff() return false end
function modifier_bloodly:IsPurgable() return false end
function modifier_bloodly:IsPurgeException() return false end
function modifier_bloodly:RemoveOnDeath() return false end

function modifier_bloodly:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bloodly:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_bloodly:OnIntervalThink()
    if IsServer() then
        local bloodsucker = self:GetParent():FindAbilityByName("taboo_spirits_of_the_past")
        if bloodsucker and not bloodsucker:IsNull() then
            if self:GetParent():HasScepter() then
                if bloodsucker:IsHidden() then
                    bloodsucker:SetHidden(false)
                end
            else
                if not bloodsucker:IsHidden() then
                    bloodsucker:SetHidden(true)
                end
            end
        end
    end
end