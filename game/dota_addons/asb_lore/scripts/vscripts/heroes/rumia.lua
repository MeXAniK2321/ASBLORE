rumia_energy_blast = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_baka_vampire", "heroes/rumia.lua", LUA_MODIFIER_MOTION_NONE )
function rumia_energy_blast:GetIntrinsicModifierName()
    return "modifier_baka_vampire"
end
function rumia_energy_blast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local projectile_name = "particles/rumia_energy_blast.vpcf"
	local projectile_distance = 1100
	local projectile_start_radius = self:GetSpecialValueFor( "blast_width_initial" )/2
	local projectile_end_radius = self:GetSpecialValueFor( "blast_width_end" )/2
	local projectile_speed = self:GetSpecialValueFor( "blast_speed" )
	local projectile_direction = point-origin
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()	

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = self:GetAbilityTargetFlags(),
	    iUnitTargetType = self:GetAbilityTargetType(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = false,
		ExtraData = {
			pos_x = origin.x,
			pos_y = origin.y,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- play sound
	local sound_cast = "rumia.1"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function rumia_energy_blast:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end

	-- load data
	local caster = self:GetCaster()
	local location = target:GetOrigin()
	local point_blank_range = self:GetSpecialValueFor( "point_blank_range" )
	local point_blank_mult = self:GetSpecialValueFor( "point_blank_dmg_bonus_pct" )/100
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_rumia_20")
	local slow = self:GetSpecialValueFor( "debuff_duration" )

	-- check position
	local origin = Vector( extraData.pos_x, extraData.pos_y, 0 )
	local length = (location-origin):Length2D()

	-- manual check due to projectile's circle shape
	-- if length>self:GetCastRange( location, nil )+150 then return end

	local point_blank = (length<=point_blank_range)
	if point_blank then damage = damage + point_blank_mult*damage end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_slow", -- modifier name
		{ duration = slow } -- kv
	)

	-- effect
	self:PlayEffects( target, point_blank )
end

--------------------------------------------------------------------------------
function rumia_energy_blast:PlayEffects( target, point_blank )
	-- Get Resources
	local particle_cast = "particles/rumia_energy_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf"
	local particle_cast3 = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf"
	local sound_target = "rumia.1_impact"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if point_blank then
		local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			3,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( particle_cast3, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			4,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Create Sound
	EmitSoundOn( sound_target, target )
end


modifier_baka_vampire = class ({})
function modifier_baka_vampire:IsHidden() return true end
function modifier_baka_vampire:IsDebuff() return false end
function modifier_baka_vampire:IsPurgable() return false end
function modifier_baka_vampire:IsPurgeException() return false end
function modifier_baka_vampire:RemoveOnDeath() return false end

function modifier_baka_vampire:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_baka_vampire:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_baka_vampire:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("rumia_night_time")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
end

night_sign_night_bird = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )





function night_sign_night_bird:OnSpellStart()
	-- get references
	local soul_per_line = self:GetSpecialValueFor("requiem_soul_conversion")

	-- get number of souls
	local lines = self:GetSpecialValueFor("lines") + self:GetCaster():FindTalentValue("special_bonus_rumia_25")
	

	-- explode
	self:Explode( lines )

	
	
end

--------------------------------------------------------------------------------
-- Projectile Hit
function night_sign_night_bird:OnProjectileHit_ExtraData( hTarget, vLocation, params )
	if hTarget ~= nil then
		-- filter
		pass = false
		if hTarget:GetTeamNumber()~=self:GetCaster():GetTeamNumber() then
			pass = true
		end

		if pass then
			-- check if it is from explode or implode
			if params and params.scepter then

				-- reduce the damage
				damage = self.damage * (self.damage_pct/100)

				-- add to heal calculation
				
			end

			-- damage target
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = this,
			}
			ApplyDamage( damage )

			-- apply modifier
			hTarget:AddNewModifier(
				self:GetCaster(),
				self,
				"modifier_generic_silenced_lua",
				{ duration = self.duration }
			)
		end
	end

	return false
end



function night_sign_night_bird:Explode( lines )
	-- get references
	self.damage =  self:GetAbilityDamage()
	self.duration = self:GetSpecialValueFor("requiem_slow_duration")

	-- get projectile
	local particle_line = "particles/night_sign_night_bird_effect.vpcf"
	local line_length = self:GetSpecialValueFor("requiem_radius")
	local width_start = self:GetSpecialValueFor("requiem_line_width_start")
	local width_end = self:GetSpecialValueFor("requiem_line_width_end")
	local line_speed = self:GetSpecialValueFor("requiem_line_speed")

	-- create linear projectile
	local initial_angle_deg = self:GetCaster():GetAnglesAsVector().y
	local delta_angle = 360/lines
	for i=0,lines-1 do
		-- Determine velocity
		local facing_angle_deg = initial_angle_deg + delta_angle * i
		if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
		local facing_angle = math.rad(facing_angle_deg)
		local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
		local velocity = facing_vector * line_speed

		-- create projectile
		local info = {
			Source = self:GetCaster(),
			Ability = self,
			EffectName = particle_line,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fDistance = line_length,
			vVelocity = velocity,
			fStartRadius = width_start,
			fEndRadius = width_end,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_SPELL_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bReplaceExisting = false,
			bProvidesVision = false,
		}
		ProjectileManager:CreateLinearProjectile( info )
	end


	EmitSoundOn("rumia.3_sfx", self:GetCaster())
	self:PlayEffects2( lines )
end

function night_sign_night_bird:PlayEffects2( lines )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
	local sound_cast = "rumia.3"

	-- Create Particles
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( lines, 0, 0 ) )	-- Lines
	ParticleManager:SetParticleControlForward( effect_cast, 2, self:GetCaster():GetForwardVector() )		-- initial direction
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Play Sounds
	EmitSoundOn(sound_cast, self:GetCaster())
end

--------------------------------------------------------------------------------
-- Helper: Ability Table (AT)
function night_sign_night_bird:GetAT()
	if self.abilityTable==nil then
		self.abilityTable = {}
	end
	return self.abilityTable
end

function night_sign_night_bird:GetATEmptyKey()
	local table = self:GetAT()
	local i = 1
	while table[i]~=nil do
		i = i+1
	end
	return i
end

function night_sign_night_bird:AddATValue( value )
	local table = self:GetAT()
	local i = self:GetATEmptyKey()
	table[i] = value
	return i
end

function night_sign_night_bird:RetATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	return ret
end

function night_sign_night_bird:DelATValue( key )
	local table = self:GetAT()
	local ret = table[key]
	table[key] = nil
end


rumia_ex_slash = class({})
LinkLuaModifier( "modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rumia_ex_slash", "heroes/rumia", LUA_MODIFIER_MOTION_NONE )

function rumia_ex_slash:GetIntrinsicModifierName()
	return "modifier_rumia_ex_slash"
end

modifier_rumia_ex_slash = class({})

--------------------------------------------------------------------------------

function modifier_rumia_ex_slash:IsHidden()
	return true
end

function modifier_rumia_ex_slash:IsDebuff()
	return false
end

function modifier_rumia_ex_slash:IsPurgable()
	return false
end

function modifier_rumia_ex_slash:RemoveOnDeath()
	return false
end
function modifier_rumia_ex_slash:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_rumia_ex_slash:OnCreated( kv )
	-- get references

    




end

function modifier_rumia_ex_slash:OnRefresh( kv )
	-- get references
	
   
	self.crit_bonus = 250

end

--------------------------------------------------------------------------------

function modifier_rumia_ex_slash:DeclareFunctions()
	local funcs = {

	
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_rumia_ex_slash:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
		 if self:GetCaster():HasModifier("modifier_rumia_awake") then
			self:GetParent():Heal(params.damage * 0.2, nil)
		 if self:GetAbility():IsFullyCastable() then
		 if self:GetCaster():HasModifier("modifier_rumia_awake") then
		 local target = params.target
			self.record = params.record
			self.ability = self:GetAbility()
			local hp = target:GetMaxHealth()
		local enemy_hp = hp * 0.2
		if target:GetHealth() <= enemy_hp and target:IsHero() and not target:IsIllusion()  then
			local damage  = self:GetParent():GetBaseDamageMax() * 2.5
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_dark_willow_terrorize_lua", {duration = 1.5 })
			self.ability:StartCooldown(10)
			self:PlayEffects( params.target )
			self.damageTable = {
		-- victim = target,
		attacker = params.attacker,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
		}
self.damageTable.victim = params.target
		ApplyDamage( self.damageTable )		--Optional.
	
			end
		end
	end
	end
	end
	end
	end




function modifier_rumia_ex_slash:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/rumia_ex_crit.vpcf"
	local sound_cast = "rumia.1_ex"


	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end




rumia_guilty = class({})


--------------------------------------------------------------------------------
-- Ability Start
function rumia_guilty:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")

	self:PlayEffects( radius )
end


function rumia_guilty:PlayEffects( radius )
	local particle_cast = "particles/dev/library/base_dust_hit_smoke.vpcf"
	local sound_cast = "rumia_ex.2_pre"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, self:GetCaster() )
end

function rumia_guilty:OnChannelFinish( bInterrupted )

local caster = self:GetCaster()

	-- load data
	local radius = 400
	local duration = 2
	local damage = 800
local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_6)
	
	local slash_damage = damage*channel_pct
	local stun = duration*channel_pct
	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = slash_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = stun } -- kv
		)
	end

	self:PlayEffects2( radius )

local sound_cast = "rumia_ex.2_pre"
StopSoundOn( sound_cast, self:GetCaster() )

end

function rumia_guilty:PlayEffects2( radius )
	local particle_cast = "particles/rumia_guilty.vpcf"
	local sound_cast = "rumia_ex.2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end















rumia_step_of_darkness = class({})
LinkLuaModifier( "modifier_rumia_step_of_darkness", "heroes/rumia", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function rumia_step_of_darkness:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5



if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) 
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)


  	target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_rumia_step_of_darkness", -- modifier name
			{ duration = 3 } -- kv
		)
	
	
	
	
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("rumia_ex.3_1", caster)
	EmitSoundOn("rumia_ex.3", caster)
end
function rumia_step_of_darkness:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/rumia_step_of_darkness.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end




modifier_rumia_step_of_darkness = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rumia_step_of_darkness:IsHidden()
	return false
end

function modifier_rumia_step_of_darkness:IsDebuff()
	return true
end

function modifier_rumia_step_of_darkness:IsStunDebuff()
	return false
end

function modifier_rumia_step_of_darkness:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rumia_step_of_darkness:OnCreated( kv )
	-- references
	local tick_damage = 150
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()


	end
end

function modifier_rumia_step_of_darkness:OnRefresh( kv )
	-- references
	local tick_damage = 150
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
	
	end
end

function modifier_rumia_step_of_darkness:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_rumia_step_of_darkness:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rumia_step_of_darkness:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rumia_step_of_darkness:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_rumia_step_of_darkness:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



LinkLuaModifier("modifier_rumia_backwark_slash", "heroes/rumia", LUA_MODIFIER_MOTION_NONE)

rumia_backwark_slash = class({})

function rumia_backwark_slash:IsStealable() return true end
function rumia_backwark_slash:IsHiddenWhenStolen() return false end
function rumia_backwark_slash:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function rumia_backwark_slash:OnAbilityPhaseStart()
    if IsServer() then
        self.swing_fx = ParticleManager:CreateParticle("particles/rumia_ex_slash_start.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
        local swing = self.swing_fx
        ParticleManager:SetParticleControlEnt(self.swing_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.swing_fx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        
        Timers:CreateTimer(self:GetBackswingTime(), function()
            ParticleManager:DestroyParticle(swing, false)
            ParticleManager:ReleaseParticleIndex(swing)
        end)

        EmitSoundOn("rumia_ex.2_pre", self:GetCaster())
        return true
    end
end
function rumia_backwark_slash:OnAbilityPhaseInterrupted()
    if IsServer() then
        ParticleManager:DestroyParticle(self.swing_fx, false)

        StopSoundOn("rumia_ex.2_pre", self:GetCaster())
    end
end
function rumia_backwark_slash:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    if point == caster:GetAbsOrigin() then
        point = caster:GetAbsOrigin() + caster:GetForwardVector() * 25
    end

    local distance = self:GetCastRange(caster:GetAbsOrigin(),caster)
    local direction = (point - caster:GetAbsOrigin()):Normalized()

    local width = self:GetSpecialValueFor("width")
    local speed = self:GetSpecialValueFor("speed")

    self.slash_projectile = {   Ability = self,
                                EffectName = "particles/rumia_ex_slash.vpcf",
                                vSpawnOrigin = caster:GetAbsOrigin(),
                                vVelocity = Vector(direction.x,direction.y,0) * speed,
                                fDistance = distance,
                                fStartRadius = width,
                                fEndRadius = width,
                                Source = caster,
                                iUnitTargetTeam   = self:GetAbilityTargetTeam(),
                                iUnitTargetType   = self:GetAbilityTargetType(),
                                iUnitTargetFlags  = self:GetAbilityTargetFlags(),
                                bProvidesVision   = false,
                                iVisionRadius     = width,
                                iVisionTeamNumber = caster:GetTeamNumber()}

    ProjectileManager:CreateLinearProjectile(self.slash_projectile)
  EmitSoundOn("rumia.ex_5_start", self:GetCaster())
        EmitSoundOn("rumia_ex.2", self:GetCaster())
end
function rumia_backwark_slash:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        return nil
    end

    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_rumia_backwark_slash", {duration = self:GetSpecialValueFor("slow_duration")})

    
    local damage_table = {  victim = hTarget,
                            attacker = self:GetCaster(),
                            damage = self:GetSpecialValueFor("damage"),
                            damage_type = self:GetAbilityDamageType(),
                            ability = self}

    self.anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    ApplyDamage(damage_table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_rumia_backwark_slash = class({})
function modifier_rumia_backwark_slash:IsHidden() return false end
function modifier_rumia_backwark_slash:IsDebuff() return true end
function modifier_rumia_backwark_slash:IsPurgable() return true end
function modifier_rumia_backwark_slash:IsPurgeException() return true end
function modifier_rumia_backwark_slash:RemoveOnDeath() return true end
function modifier_rumia_backwark_slash:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_rumia_backwark_slash:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
    return func
end
function modifier_rumia_backwark_slash:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end
function modifier_rumia_backwark_slash:OnCreated()
    if IsServer() then
        --self:IncrementStackCount()
    end
end
function modifier_rumia_backwark_slash:OnRefresh()
    if IsServer() then
        --self:OnCreated()
    end
end





LinkLuaModifier("modifier_rumia_night_time", "heroes/rumia", LUA_MODIFIER_MOTION_NONE)
rumia_night_time = class({})
function rumia_night_time:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

caster:AddNewModifier(caster, self, "modifier_rumia_night_time", {duration = 30})
 GameRules:BeginNightstalkerNight(30)
	
	 EmitSoundOn("rumia_ex.6", self:GetCaster())
   

end

modifier_rumia_night_time = class({})

function modifier_rumia_night_time:IsHidden()
	return false
end
function modifier_rumia_night_time:RemoveOnDeath() return false end


function modifier_rumia_night_time:IsPurgable()
    return false
end

function modifier_rumia_night_time:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		 MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					
       
        
		
    }

    return funcs
end

function modifier_rumia_night_time:GetModifierSpellAmplify_Percentage()
return 35
end
function modifier_rumia_night_time:GetBonusNightVision()

    return 0

end