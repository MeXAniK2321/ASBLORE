homura_rpg = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_homura_rpg", "modifiers/modifier_homura_rpg", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function homura_rpg:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_devil_homura") then
		return "homura_5_3"
	end
	return "homura_3"
end
function homura_rpg:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
    
    self.damage = self:GetSpecialValueFor( "damage" ) + caster:FindTalentValue("special_bonus_homura_25")
    
	local projectile_name = "particles/homura_rpg.vpcf"
	local projectile_speed = self:GetSpecialValueFor("arrow_speed")
	local projectile_distance = self:GetSpecialValueFor("arrow_range")
	local projectile_start_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_end_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_vision = self:GetSpecialValueFor("arrow_vision")

	local min_damage = self:GetAbilityDamage()
	local bonus_damage = self:GetSpecialValueFor( "arrow_bonus_damage" )
	local min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
	local max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
	local max_distance = self:GetSpecialValueFor( "arrow_max_stunrange" )
    
	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()
    
	local sound_cast = "homura.3"
    

    if self:GetCaster():HasModifier("modifier_devil_homura") then
    
	projectile_name = "particles/homura_rpg_devil.vpcf"

	-- Effects
	sound_cast = "homura.attack"

	end
    
	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = min_stun,
			max_stun = max_stun,

			min_damage = min_damage,
			bonus_damage = bonus_damage,
            
			iprojectile_number = 1,
		}
	}
    
    self.iprojectile_number = nil
    
	Timers:CreateTimer(0, function()
	EmitSoundOn( sound_cast, caster )
    self.iprojectile_number = self.iprojectile_number and (self.iprojectile_number + 1) or 1
    info.ExtraData.iprojectile_number = self.iprojectile_number
	ProjectileManager:CreateLinearProjectile(info)
    
	if caster:HasShard() then
	return (self.iprojectile_number % 3) ~= 0 and 0.15
	end
	end)
end

--------------------------------------------------------------------------------
-- Projectile
function homura_rpg:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end
local caster = self:GetCaster()
	-- damage

	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage/(extraData.iprojectile_number or 1),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		hTarget:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )

		-- play overhead event
		
	end
	
    self:PlayEffects(hTarget)

	-- stun
	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = self:GetSpecialValueFor( "arrow_max_stun" )  } -- kv
	)

	AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, 500, 3, false )

	-- effects
	local sound_cast = "homura.3_1"
	EmitSoundOn( sound_cast, hTarget )

	return true
end
function homura_rpg:PlayEffects(hTarget)
	-- stop sound
	
	
	-- Get Resources
	local particle_cast = "particles/deidara_c1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 300, 300, 300 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
