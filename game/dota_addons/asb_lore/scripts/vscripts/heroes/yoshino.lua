yoshino_snowball = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_state", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_state_bad", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_state_good", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_state_normal", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_state_inversion", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_crying_run", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheer_cold", "modifiers/modifier_sheer_cold", LUA_MODIFIER_MOTION_NONE )

function yoshino_snowball:GetIntrinsicModifierName()
	return "modifier_yoshino_state"
end

function yoshino_snowball:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self.damage = self:GetSpecialValueFor("wtf") + self:GetCaster():FindTalentValue("special_bonus_yoshino_20")

if caster:HasModifier("modifier_yoshino_state_inversion") then
local projectile_name = "particles/yoshino_dark_ice_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 450

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
	self:PlayEffects3()
else
	local projectile_name = "particles/yoshino_snowball_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 450

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	self:PlayEffects1()
end
end
function yoshino_snowball:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	
	local caster = self:GetCaster()
	

	
 if caster:HasModifier("modifier_yoshino_state_inversion") then
 self:Hit2( target, true )
 self:PlayEffects4( hTarget )
 else
	self:PlayEffects2( hTarget )
	self:Hit( target, true )
	end
end
function yoshino_snowball:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	target:AddNewModifier(self.caster, self, "modifier_generic_slow", {duration = 0.5})
	
end
	
function yoshino_snowball:Hit2( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
 
 target:AddNewModifier(self.caster, self, "modifier_sheer_cold", {duration = 2.0})

	
end
	

--------------------------------------------------------------------------------
function yoshino_snowball:PlayEffects1()
	-- Get Resources
	local sound_cast = "yoshino.snowball"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function yoshino_snowball:PlayEffects3()
	-- Get Resources
	local sound_cast = "yoshino.frost_explosion"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function yoshino_snowball:PlayEffects2( target )
	-- Get Resources
	local sound_target = "yoshino.snowball_hit"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
function yoshino_snowball:PlayEffects4( target )
	-- Get Resources
	local sound_target = "yoshino.frost_explosion"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

modifier_yoshino_state = class({})

--------------------------------------------------------------------------------

function modifier_yoshino_state:IsHidden()
	return true
end

function modifier_yoshino_state:IsDebuff()
	return false
end

function modifier_yoshino_state:IsPurgable()
	return false
end

function modifier_yoshino_state:RemoveOnDeath()
	return false
end
function modifier_yoshino_state:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_yoshino_state:OnCreated( kv )
	-- get references
	

	if IsServer() then
		self:SetStackCount(425)
	end
	
	self:StartIntervalThink(10)
end

--------------------------------------------------------------------------------

function modifier_yoshino_state:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		
	}

	return funcs
end

function modifier_yoshino_state:OnDeath( params )
	if IsServer() then
		self:KillLogic( params )
		self:DeathLogic( params )
	end
end

function modifier_yoshino_state:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
		self:AddStack(5)
	end
end

function modifier_yoshino_state:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	

	-- only player-based damage
	if not params.attacker == self:GetParent() then return end


	

	self.damage = params.damage
	if self.damage < 600 then return end
	self.damage = 0


	self:AddStack(-1)

	
	
end
function modifier_yoshino_state:OnAbilityFullyCast( params )
	if IsServer() then
	local ability = self:GetParent():FindAbilityByName("yoshino_cry")
		if params.unit~=self:GetParent() or params.ability~=ability then
			return
		end

		self:AddStack(-4)
	end
end

function modifier_yoshino_state:OnIntervalThink()
	local stack = self:GetStackCount()
	if not self:GetParent():HasModifier( "modifier_yoshino_state_inversion" )  then
		if stack > 250  and not self:GetParent():HasModifier( "modifier_yoshino_state_good" )  then
		
		self:GetParent():RemoveModifierByName("modifier_yoshino_state_normal")
		
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_yoshino_state_good", -- modifier name
		{} -- kv
	)
	elseif stack < 250 and stack > 150 and not self:GetParent():HasModifier( "modifier_yoshino_state_normal" ) then
		
		self:GetParent():RemoveModifierByName("modifier_yoshino_state_good")
		self:GetParent():RemoveModifierByName("modifier_yoshino_state_bad")
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_yoshino_state_normal", -- modifier name
		{} -- kv
	)
	
	
	elseif stack < 150 and stack > 5 and not self:GetParent():HasModifier( "modifier_yoshino_state_bad" ) then
	self:GetParent():RemoveModifierByName("modifier_yoshino_state_normal")
	self:GetParent():RemoveModifierByName("modifier_yoshino_state_good")
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_yoshino_state_bad", -- modifier name
		{} -- kv
	)
	elseif stack < 5 and not self:GetParent():HasModifier( "modifier_zayac" ) then 
	self:GetParent():RemoveModifierByName("modifier_yoshino_state_bad")
	self:GetParent():RemoveModifierByName("modifier_yoshino_state_good")
	self:GetParent():RemoveModifierByName("modifier_yoshino_state_normal")
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_yoshino_state_inversion", -- modifier name
		{} -- kv
	)
	EmitSoundOn("yoshino.inversion_start", self:GetParent())
	self:PlayEffects()
		end
		self:AddStack(1)
		end
		end
function modifier_yoshino_state:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/yoshino_inversion_explosion.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

function modifier_yoshino_state:KillLogic( params )
      
	local target = params.unit
	local attacker = params.attacker
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass and (not self:GetParent():PassivesDisabled()) then
		self:AddStack(0)
		-- check if it is a hero
		if target:IsRealHero() then
	
			self:AddStack(-10)
			end
		
		
		
		
		

		end
	end

function modifier_yoshino_state:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value

	self:SetStackCount( after )
end






modifier_yoshino_state_good = class({})

--------------------------------------------------------------------------------

function modifier_yoshino_state_good:IsHidden()
	return false
end

function modifier_yoshino_state_good:IsDebuff()
	return false
end

function modifier_yoshino_state_good:IsPurgable()
	return false
end

function modifier_yoshino_state_good:RemoveOnDeath()
	return false
end







modifier_yoshino_state_bad = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_state_bad:IsHidden()
	return false
end

function modifier_yoshino_state_bad:IsDebuff()
	return false
end

function modifier_yoshino_state_bad:IsPurgable()
	return false
end
function modifier_yoshino_state_bad:AllowIllusionDuplicate() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_state_bad:OnCreated( kv )
	-- references
	self.chance1 = 50
	
	
	self:StartIntervalThink( 60 )
end

function modifier_yoshino_state_bad:OnRefresh( kv )
	-- references
	self.chance1 = 50
	
	
end

function modifier_yoshino_state_bad:OnRemoved()
end

function modifier_yoshino_state_bad:OnDestroy()
end
function modifier_yoshino_state_bad:OnIntervalThink()
	local caster = self:GetParent()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	local ability = self:GetParent():FindAbilityByName("yoshino_cry")
	
	if RollPercentage(self.chance1) then
	
	
	
	caster:AddNewModifier(caster, self, "modifier_yoshino_crying_run", {duration = 3})
	self:PlayEffects()
	
		else
		end
		end
		
		


function modifier_yoshino_state_bad:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf"
	local sound_cast = "yoshino.cry"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

modifier_yoshino_state_inversion = class({})
function modifier_yoshino_state_inversion:IsHidden() return false end
function modifier_yoshino_state_inversion:IsDebuff() return false end
function modifier_yoshino_state_inversion:IsPurgable() return false end
function modifier_yoshino_state_inversion:IsPurgeException() return false end
function modifier_yoshino_state_inversion:RemoveOnDeath() return false end
function modifier_yoshino_state_inversion:AllowIllusionDuplicate() return true end

function modifier_yoshino_state_inversion:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_yoshino_state_inversion:GetModifierModelChange()
	return "models/yoshinon/yoshino_inverse.vmdl"
end
function modifier_yoshino_state_inversion:GetModifierModelScale()

	return 1
	end





function modifier_yoshino_state_inversion:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()



    self.skills_table = {
                             ["yoshino_cry"] = "yoshino_black_blizzard",

                            
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/econ/items/nightstalker/nightstalker_ti10_silence/nightstalker_ti10_aura_corrupt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
        
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_yoshino_state_inversion:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_yoshino_state_inversion:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

         

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("yoshino_state_inversion_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end








modifier_yoshino_state_normal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_state_normal:IsHidden()
	return false
end

function modifier_yoshino_state_normal:IsDebuff()
	return false
end

function modifier_yoshino_state_normal:IsPurgable()
	return false
end
function modifier_yoshino_state_normal:AllowIllusionDuplicate() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_state_normal:OnCreated( kv )
	-- references
	self.chance1 = 25
	
	
	self:StartIntervalThink( 60 )
end

function modifier_yoshino_state_normal:OnRefresh( kv )
	-- references
	self.chance1 = 25
	
	
end

function modifier_yoshino_state_normal:OnRemoved()
end

function modifier_yoshino_state_normal:OnDestroy()
end
function modifier_yoshino_state_normal:OnIntervalThink()
	local caster = self:GetParent()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	if RollPercentage(self.chance1) then
	
	caster:AddNewModifier(caster, self, "modifier_yoshino_crying_run", {duration = 3})
	self:PlayEffects()
		else
		end
	
end

function modifier_yoshino_state_normal:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/econ/courier/courier_kunkka_parrot/courier_kunkka_parrot_splash.vpcf"
	local sound_cast = "yoshino.cry"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end





























yoshino_blizzard = class({})
LinkLuaModifier( "modifier_yoshino_blizzard", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_blizzard_inversion", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_blizzard_delay_damage", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheer_cold", "modifiers/modifier_sheer_cold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_yoshirite","heroes/zayac", LUA_MODIFIER_MOTION_NONE)

function yoshino_blizzard:GetIntrinsicModifierName()
	return "modifier_yoshirite"
end
function yoshino_blizzard:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function yoshino_blizzard:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")


  if caster:HasModifier("modifier_yoshino_state_inversion") then
  CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_yoshino_blizzard_inversion", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects1( point, radius, duration )
  else
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_yoshino_blizzard", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
end
end
function yoshino_blizzard:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/yoshino_magic_circle.vpcf"
	local sound_cast = "yoshino.tornado_pre"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
function yoshino_blizzard:PlayEffects1( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/yoshino_magic_circle_black.vpcf"
	local sound_cast = "yoshino.tornado_pre"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

modifier_yoshino_blizzard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_blizzard:IsHidden()
	return true
end

function modifier_yoshino_blizzard:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_blizzard:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_yoshino_blizzard:OnRefresh( kv )
	
end

function modifier_yoshino_blizzard:OnRemoved()
end

function modifier_yoshino_blizzard:OnDestroy()
	if not IsServer() then return end
	
	

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
	local knockback = { should_stun = 1,
                        knockback_duration = self.duration,
                        duration = self.duration,
                        knockback_distance = 0,
                        knockback_height = 400,
                        center_x = self:GetParent():GetAbsOrigin().x,
                        center_y = self:GetParent():GetAbsOrigin().y,
                        center_z = self:GetParent():GetAbsOrigin().z }

    enemy:AddNewModifier(self:GetParent(), self, "modifier_knockback", knockback)
	
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		end
	

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_yoshino_blizzard:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/yoshino_tornado.vpcf"
	local sound_cast = "yoshino.tornado"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_yoshino_blizzard_inversion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_blizzard_inversion:IsHidden()
	return true
end

function modifier_yoshino_blizzard_inversion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_blizzard_inversion:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage +150,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_yoshino_blizzard_inversion:OnRefresh( kv )
	
end

function modifier_yoshino_blizzard_inversion:OnRemoved()
end

function modifier_yoshino_blizzard_inversion:OnDestroy()
	if not IsServer() then return end
	
	

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
	local knockback = { should_stun = 1,
                        knockback_duration = self.duration,
                        duration = self.duration,
                        knockback_distance = 0,
                        knockback_height = 400,
                        center_x = self:GetParent():GetAbsOrigin().x,
                        center_y = self:GetParent():GetAbsOrigin().y,
                        center_z = self:GetParent():GetAbsOrigin().z }

    enemy:AddNewModifier(self:GetParent(), self, "modifier_knockback", knockback)
	enemy:AddNewModifier(self:GetParent(), self, "modifier_black_blizzard_delay_damage", {duration = 1.9})
	enemy:AddNewModifier(self:GetParent(), self, "modifier_sheer_cold", {duration = 3.0})
	local delay = 1.9

	Timers:CreateTimer(delay,function()
	self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end)
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_yoshino_blizzard_inversion:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/yoshino_black_tornado.vpcf"
	local sound_cast = "yoshino.black_tornado"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end
function modifier_yoshino_blizzard_inversion:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/yoshino_black_spikes_with_blood.vpcf"
	local sound_cast = "yoshino.spikes"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_black_blizzard_delay_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_black_blizzard_delay_damage:IsHidden()
	return false
end

function modifier_black_blizzard_delay_damage:IsDebuff()
	return true
end

function modifier_black_blizzard_delay_damage:IsStunDebuff()
	return false
end

function modifier_black_blizzard_delay_damage:IsPurgable()
	return true
end

function modifier_black_blizzard_delay_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_black_blizzard_delay_damage:OnCreated( kv )
	-- references
	self.duration = 1.9
	self.damage = 600

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end

function modifier_black_blizzard_delay_damage:OnRefresh( kv )
	
end

function modifier_black_blizzard_delay_damage:OnRemoved()
end

function modifier_black_blizzard_delay_damage:OnDestroy()
end

function modifier_black_blizzard_delay_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_black_blizzard_delay_damage:Silence()
	-- add silence
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 0.1 } -- kv
	)

	-- damage
	

	-- play effects
	self:PlayEffects()



	-- destroy
	self:Destroy()
end

function modifier_black_blizzard_delay_damage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/kyoka_suigetsu_blood.vpcf"
	local sound_cast = "yoshino.spikes"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end






LinkLuaModifier( "modifier_yoshino_rink", "heroes/yoshino.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_inversion_rink_aura", "heroes/yoshino.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_rink_debuff", "heroes/yoshino.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_inversion_rink", "heroes/yoshino.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_rink_debuff_target", "heroes/yoshino.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheer_cold", "modifiers/modifier_sheer_cold", LUA_MODIFIER_MOTION_NONE )

yoshino_rink = class({})

function yoshino_rink:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function yoshino_rink:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function yoshino_rink:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end

function yoshino_rink:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function yoshino_rink:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_yoshino_state_inversion") then
		return "yoshino/yoshino_inverse_rite"
	end
	return "novaa"
end

function yoshino_rink:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor( "duration" )
 if caster:HasModifier("modifier_yoshino_state_inversion") then
 caster:EmitSound("yoshino.black_rite")
 CreateModifierThinker( caster, self, "modifier_inversion_rink", { duration = duration }, point, caster:GetTeamNumber(), false )
 else
    CreateModifierThinker( caster, self, "modifier_yoshino_rink", { duration = duration }, point, caster:GetTeamNumber(), false )
	 caster:EmitSound("yoshino.rite2")
    caster:EmitSound("yoshino.rite")
	end
    caster:EmitSound("yoshino.rite2")
    
end

modifier_yoshino_rink = class({})

function modifier_yoshino_rink:IsPurgable()
    return false
end

function modifier_yoshino_rink:OnCreated( kv )
    self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    if not IsServer() then return end
    local particle = ParticleManager:CreateParticle( "particles/yoshino_ice_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
    self:AddParticle(particle, false, false, -1, false, false )
end

function modifier_yoshino_rink:IsAura()
    return true
end

function modifier_yoshino_rink:GetModifierAura()
    return "modifier_yoshino_rink_debuff"
end

function modifier_yoshino_rink:GetAuraRadius()
    return self.radius
end

function modifier_yoshino_rink:GetAuraDuration()
    return 0.5
end

function modifier_yoshino_rink:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_yoshino_rink:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_yoshino_rink:GetAuraSearchFlags()
    return 0
end

modifier_yoshino_rink_debuff = class({})

function modifier_yoshino_rink_debuff:IsPurgable()
    return false
end

function modifier_yoshino_rink_debuff:IsHidden()
    return true
end

function modifier_yoshino_rink_debuff:OnCreated()
    if not IsServer() then return end
    if self:GetParent():IsBoss() then return end
    self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_ice_slide", {} )
    self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_yoshino_rink_debuff_target", {} )
end

function modifier_yoshino_rink_debuff:OnDestroy()
    if not IsServer() then return end
  
    self:GetParent():RemoveModifierByName("modifier_ice_slide")
    self:GetParent():RemoveModifierByName("modifier_yoshino_rink_debuff_target")
end

modifier_yoshino_rink_debuff_target = class({})

function modifier_yoshino_rink_debuff_target:IsPurgable()
    return false
end

function modifier_yoshino_rink_debuff_target:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink( 0.5 )
end

function modifier_yoshino_rink_debuff_target:OnIntervalThink()
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_yoshino_25")
    if not IsServer() then return end
    local damageTable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        ability = self:GetAbility(),
    }
    ApplyDamage( damageTable )
end


function modifier_yoshino_rink_debuff_target:GetEffectName()
    return "particles/units/heroes/hero_lich/lich_ice_spire_debuff.vpcf"
end

function modifier_yoshino_rink_debuff_target:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end



modifier_inversion_rink = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_inversion_rink:IsHidden()
	return false
end

function modifier_inversion_rink:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_inversion_rink:OnCreated( kv )
	-- references
	self.radius = 500
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0
	

	if IsServer() then
		-- precache damage
		local damage = 200 + self:GetCaster():FindTalentValue("special_bonus_yoshino_25")
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}

  
    if not IsServer() then return end
    local particle = ParticleManager:CreateParticle( "particles/black_rite.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
    self:AddParticle(particle, false, false, -1, false, false )

		-- Start interval
		self:StartIntervalThink( self.interval )
	end
end

function modifier_inversion_rink:OnRefresh( kv )
	
end

function modifier_inversion_rink:OnRemoved()
	if IsServer() then
		-- ensure last tick damage happens
		if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
			self:OnIntervalThink()
		end

		UTIL_Remove( self:GetParent() )
	end


end


function modifier_inversion_rink:OnIntervalThink()
	-- aoe damage
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier(self:GetParent(), self, "modifier_sheer_cold", {duration = 0.6})
	end

	-- tick
	self.tick = self.tick+1
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_inversion_rink:IsAura()
	return true
end

function modifier_inversion_rink:GetModifierAura()
	return "modifier_inversion_rink_aura"
end

function modifier_inversion_rink:GetAuraRadius()
	return self.radius
end

function modifier_inversion_rink:GetAuraDuration()
	return 0.1
end

function modifier_inversion_rink:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_inversion_rink:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end






modifier_inversion_rink_aura = class({})
function modifier_inversion_rink_aura:IsHidden() return false end
function modifier_inversion_rink_aura:IsDebuff() return true end
function modifier_inversion_rink_aura:IsPurgable() return true end
function modifier_inversion_rink_aura:IsPurgeException() return true end
function modifier_inversion_rink_aura:RemoveOnDeath() return true end
function modifier_inversion_rink_aura:GetPriority() return MODIFIER_PRIORITY_NORMAL end
function modifier_inversion_rink_aura:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_inversion_rink_aura:CheckState()
    local state = { --[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                   
					}

    if not self.parent:IsNull() and self.pull_leash then
        state[MODIFIER_STATE_TETHERED] = true
    end

    return state
end

function modifier_inversion_rink_aura:OnCreated(kv)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	 self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
    
    self.pull_speed = 150 * 0.2

    
    if IsServer() then
        self.rotate_speed = 1

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_inversion_rink_aura:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_inversion_rink_aura:OnIntervalThink()
  
    if IsServer() then
        self:UpdateHorizontalMotion(self.parent, FrameTime())
    end
end
function modifier_inversion_rink_aura:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        self:Charge(me, dt)
    end
end
function modifier_inversion_rink_aura:Charge(me, dt)
    if IsServer() then
        
        
        -- get vector
        local target = self.parent:GetAbsOrigin() - self.center
        target.z = 0

        -- reduce length by pull speed
        local targetL = target:Length2D() - self.pull_speed*dt
        self.targetLSpec = targetL

        -- rotate by rotate speed
        local targetN = target:Normalized()
        local deg = math.atan2( targetN.y, targetN.x )
        local targetN = Vector( math.cos(deg + self.rotate_speed * dt), math.sin(deg + self.rotate_speed * dt), 0 );

        local move_loc = self.center + targetN * targetL
        local max_distance = target:Length2D()
        local PathLength = GridNav:FindPathLength(self.parent:GetAbsOrigin(), move_loc)
        if not GridNav:IsTraversable(move_loc) or GetGroundHeight(move_loc, self.parent) ~= GetGroundHeight(self.center, self:GetAuraOwner()) or PathLength == -1 or PathLength > max_distance then
            self.targetLSpec = self.targetLSpec - 10
        end

        self.parent:SetOrigin( self.center + targetN * self.targetLSpec )
    end
end
function modifier_inversion_rink_aura:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_inversion_rink_aura:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end
        --self.parent:InterruptMotionControllers(true)
    end
end


















yoshino_cry = class({})
LinkLuaModifier( "modifier_yoshino_cry", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yoshino_cry_effect", "heroes/yoshino", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function yoshino_cry:OnSpellStart()
	-- Effects
	local duration = self:GetDuration()
	local caster = self:GetCaster()
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_yoshino_cry", -- modifier name
		{ duration = duration } -- kv
	)
	local sound_cast = "yoshino.cry"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

modifier_yoshino_cry = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_cry:IsHidden()
	return true
end

function modifier_yoshino_cry:IsDebuff()
	return false
end

function modifier_yoshino_cry:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_yoshino_cry:IsAura()
	return true
end

function modifier_yoshino_cry:GetModifierAura()
	return "modifier_yoshino_cry_effect"
end

function modifier_yoshino_cry:GetAuraRadius()
	return self.slow_radius
end

function modifier_yoshino_cry:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_yoshino_cry:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_yoshino_cry:GetAuraDuration()
	return self.slow_duration
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_cry:OnCreated( kv )
	-- references
	self.slow_radius = 500
	self.slow_duration = 1
	self.explosion_radius = 600
	self.explosion_interval = 0.25
	self.explosion_min_dist = 100
	self.explosion_max_dist = 600
	local explosion_damage = 300

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()

		-- Play Effects
		self:PlayEffects1()
	end
end

function modifier_yoshino_cry:OnRefresh( kv )
	-- references
	self.slow_radius = 500
	self.slow_duration = 1
	self.explosion_radius = 600
	self.explosion_interval = 0.25
	self.explosion_min_dist = 100
	self.explosion_max_dist = 600
	local explosion_damage = 300

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()
	end
end

function modifier_yoshino_cry:OnDestroy( kv )
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_yoshino_cry:OnIntervalThink()
	-- Set explosion quartal
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end

	-- determine explosion relative position
	local a = RandomInt(0,90) + self.quartal*90
	local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	-- actual position
	point = self:GetCaster():GetOrigin() + point

	-- Explode at point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage units
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- Play effects
	self:PlayEffects2( point )
end

--------------------------------------------------------------------------------
-- Effects
function modifier_yoshino_cry:PlayEffects1()
	local particle_cast = "particles/yoshino_cry_aura.vpcf"
	self.sound_cast = "yoshino.cry_loop"

	-- Create Particle
	-- self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self.effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Play sound
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_yoshino_cry:PlayEffects2( point )
	-- Play particles
	local particle_cast = "particles/yoshino_icecle.vpcf"

	-- Create particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )

	-- Play sound
	local sound_cast = "yoshino.frost_explosion"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function modifier_yoshino_cry:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end



modifier_yoshino_cry_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_cry_effect:IsHidden()
	return false
end

function modifier_yoshino_cry_effect:IsDebuff()
	return true
end

function modifier_yoshino_cry_effect:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_cry_effect:OnCreated( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
end

function modifier_yoshino_cry_effect:OnRefresh( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )	
end

function modifier_yoshino_cry_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_yoshino_cry_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_yoshino_cry_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_yoshino_cry_effect:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_yoshino_cry_effect:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_yoshino_cry_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




--------------------------------------------------------------------------------
modifier_yoshino_crying_run = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_crying_run:IsHidden()
	return false
end

function modifier_yoshino_crying_run:IsDebuff()
	return true
end

function modifier_yoshino_crying_run:IsStunDebuff()
	return false
end

function modifier_yoshino_crying_run:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_crying_run:OnCreated( kv )
	if not IsServer() then return end
	-- play effects
	

	-- if neutral, set disarm to run back towards camp
	if self:GetParent():IsNeutralUnitType() then
		self.neutral = true
	end

	-- find enemy fountain
	local buildings = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		Vector(0,0,0),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local fountain = nil
	for _,building in pairs(buildings) do
		if building:GetClassname()=="ent_dota_fountain" then
			fountain = building
			break
		end
	end

	-- if no fountain, just don't do anything
	if not fountain then return end

	-- for lane creep, MoveToPosition won't work, so use this
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( fountain ) -- for creeps
	end

	-- for others, order to run to fountain
	self:GetParent():MoveToPosition( fountain:GetOrigin() )
end

function modifier_yoshino_crying_run:OnRefresh( kv )
	
end

function modifier_yoshino_crying_run:OnRemoved()
end

function modifier_yoshino_crying_run:OnDestroy()
	if not IsServer() then return end

	-- stop running
	self:GetParent():Stop()
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( nil ) -- for creeps
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_yoshino_crying_run:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

function modifier_yoshino_crying_run:GetModifierProvidesFOWVision()
	return 1
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_yoshino_crying_run:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = self.neutral,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_yoshino_crying_run:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf"
end





