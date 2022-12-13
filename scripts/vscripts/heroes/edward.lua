LinkLuaModifier("modifier_edward_create_wall", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_edward_create_wall_ground", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_edward_spear_reveal", "heroes/edward.lua", LUA_MODIFIER_MOTION_NONE )
edward_create_wall = class({})
function edward_create_wall:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function edward_create_wall:GetIntrinsicModifierName()
    return "modifier_edward_spear_reveal"
end
function edward_create_wall:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("edward_create_spear")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function edward_create_wall:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_edward_20")
    local target = self:GetCursorTarget()
	local caster_vector = caster:GetForwardVector()
    local duration = self:GetSpecialValueFor("duration")
    local vision = self:GetSpecialValueFor("vision_range")


    local radius = self:GetSpecialValueFor("radius")


  
        local position = point
        
        local ice_unit = CreateModifierThinker(caster, self, "modifier_edward_create_wall", {duration = duration}, position, caster:GetTeamNumber(), true)
		ice_unit:SetForwardVector(caster_vector)
		
		local ice_unit2 = CreateModifierThinker(caster, self, "modifier_edward_create_wall_ground", {duration = duration}, position, caster:GetTeamNumber(), true)
		ice_unit2:SetForwardVector(caster_vector)
        --CreateTempTreeWithModel(position, duration, nil)
        
    ResolveNPCPositions(point, self:GetAOERadius())
	
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	local knockback = { should_stun = 0,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 150,
                        knockback_height = 600,
                        center_x = point,
                        center_y = point,
                        center_z = point}
	for _,enemy in pairs(enemies) do
	if enemy:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
	else
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end

   EmitSoundOn("edward.clap", caster)
    EmitSoundOn("edward.1", caster)
	self:PlayEffects( radius, point )
end
function edward_create_wall:PlayEffects( radius , point )
	local particle_cast = "particles/edward_create_wall_dust.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, point)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

modifier_edward_create_wall = class({})
function modifier_edward_create_wall:IsHidden() return true end
function modifier_edward_create_wall:IsDebuff() return false end
function modifier_edward_create_wall:IsPurgable() return false end
function modifier_edward_create_wall:IsPurgeException() return false end
function modifier_edward_create_wall:RemoveOnDeath() return true end
function modifier_edward_create_wall:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,}
    return state
end
function modifier_edward_create_wall:OnCreated()
    if IsServer() then
        self:GetParent():SetOriginalModel("models/custom_game/units/edward_units/edward_wall.vmdl")
        self:GetParent():SetModelScale(2)
        self:GetParent():SetHullRadius(self:GetParent():GetHullRadius()*7)
    end
end


modifier_edward_spear_reveal = class ({})
function modifier_edward_spear_reveal:IsHidden() return true end
function modifier_edward_spear_reveal:IsDebuff() return false end
function modifier_edward_spear_reveal:IsPurgable() return false end
function modifier_edward_spear_reveal:IsPurgeException() return false end
function modifier_edward_spear_reveal:RemoveOnDeath() return false end

function modifier_edward_spear_reveal:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_edward_spear_reveal:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_edward_spear_reveal:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_edward_spear_reveal:GetModifierBaseAttackTimeConstant()
	return 1.7
end
function modifier_edward_spear_reveal:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("edward_create_spear")
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

modifier_edward_create_wall_ground = class({})
function modifier_edward_create_wall_ground:IsHidden() return true end
function modifier_edward_create_wall_ground:IsDebuff() return false end
function modifier_edward_create_wall_ground:IsPurgable() return false end
function modifier_edward_create_wall_ground:IsPurgeException() return false end
function modifier_edward_create_wall_ground:RemoveOnDeath() return true end
function modifier_edward_create_wall_ground:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
    return state
end
function modifier_edward_create_wall_ground:OnCreated()
    if IsServer() then
        self:GetParent():SetOriginalModel("models/custom_game/units/edward_units/edward_wall_ground.vmdl")
        self:GetParent():SetModelScale(2)
    end
end














edward_alchemy_circle = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_edward_alchemy_circle_thinker", "heroes/edward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_edward_alchemy_circle_damage", "heroes/edward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_edward_alchemy_circle_count", "heroes/edward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_full_circles", "heroes/edward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_edward_alchemy_circle_end", "heroes/edward", LUA_MODIFIER_MOTION_NONE )
function edward_alchemy_circle:GetBehavior()
	if self:GetCaster():HasModifier("modifier_full_circles") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		
	end
	return DOTA_ABILITY_BEHAVIOR_POINT
end
function edward_alchemy_circle:GetIntrinsicModifierName()
	return "modifier_edward_alchemy_circle_count"
end
function edward_alchemy_circle:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function edward_alchemy_circle:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_full_circles") then
		return "edward/edward_2_1"
	end
	return "edward/edward_2"
end
--------------------------------------------------------------------------------
-- Ability Start
function edward_alchemy_circle:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	if self:GetCaster():HasModifier("modifier_full_circles") then
	 caster:RemoveModifierByName("modifier_full_circles")
	 caster:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_edward_alchemy_circle_end", -- modifier name
		{duration = 1.0} -- kv
	)

	local sound_cast = "edward.clap"
	EmitSoundOn( sound_cast, caster )
	else
	
	CreateModifierThinker(
		caster,
		self,
		"modifier_edward_alchemy_circle_thinker",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = "edward.clap"
	EmitSoundOn( sound_cast, caster )
	EmitSoundOn( "edward.transmute", caster )
	end
end











modifier_edward_alchemy_circle_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_edward_alchemy_circle_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_edward_alchemy_circle_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_edward_25")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.duration = self:GetAbility():GetSpecialValueFor("stun")
		local vision = 200

		-- Start interval
		self:StartIntervalThink( 0.1 )




	
		self:PlayEffects1()
		end
	end


function modifier_edward_alchemy_circle_thinker:OnDestroy( kv )
	if IsServer() then
	local location = self:GetParent():GetOrigin()
	local caster = self:GetCaster()
	local point = location
	local damage = self.damage
	if caster:HasModifier("modifier_full_circles") then
	caster:RemoveModifierByName("modifier_full_circles") 
	end
		local modifier = caster:FindModifierByNameAndCaster("modifier_edward_alchemy_circle_count",caster)
		local current = modifier:GetStackCount()
		local minus = current - 1
	modifier:SetStackCount(minus)
CreateModifierThinker(
		caster,
		self,
		"modifier_edward_alchemy_circle_damage",
		{duration = 0.5,
		damage = damage,
		stun = self.duration},
		point,
		caster:GetTeamNumber(),
		false
	)
		self:PlayEffects4()
		UTIL_Remove(self:GetParent())
		self:PlayEffects2()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_edward_alchemy_circle_thinker:OnIntervalThink()
	if self:GetCaster():HasModifier("modifier_edward_alchemy_circle_end") then
	self:Destroy()
	else
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
		self:Destroy()		
	end
end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_edward_alchemy_circle_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/edward_transmutation_circle.vpcf"


	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	assert(loadfile("modifiers/rubick_spell_steal_lua_color"))(self,self.effect_cast)

	-- Create Sound

end

function modifier_edward_alchemy_circle_thinker:PlayEffects2()
	-- Get Resources
	-- local sound_cast = 

	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Sound
	-- EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_edward_alchemy_circle_thinker:PlayEffects4()
	-- Get Resources
	local particle_cast = "particles/edward_stone_fist.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 0.5

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end



modifier_edward_alchemy_circle_damage = class({})


function modifier_edward_alchemy_circle_damage:IsPurgable()
	return false
end
function modifier_edward_alchemy_circle_damage:OnCreated( kv )
self.damage = kv.damage
self.radius = 300
self.stun = kv.stun

self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
end
function modifier_edward_alchemy_circle_damage:OnDestroy( kv )
	if IsServer() then
	local location = self:GetParent():GetOrigin()
	local caster = self:GetCaster()
	local point = location
	local damage = self.damage
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
	enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.stun } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end
	local radius = 300
		self:PlayEffects(radius)
		UTIL_Remove(self:GetParent())
end
end


function modifier_edward_alchemy_circle_damage:PlayEffects( radius)

	local particle_cast = "particles/edward_stone_fist_impact.vpcf"
local sound_cast = "edward.fallen_stone"
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn(  sound_cast, self:GetParent() )
end




modifier_edward_alchemy_circle_count = class({})

--------------------------------------------------------------------------------

function modifier_edward_alchemy_circle_count:IsHidden()
	return false
end

function modifier_edward_alchemy_circle_count:IsDebuff()
	return false
end

function modifier_edward_alchemy_circle_count:IsPurgable()
	return false
end

function modifier_edward_alchemy_circle_count:RemoveOnDeath()
	return false
end
function modifier_edward_alchemy_circle_count:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_edward_alchemy_circle_count:OnCreated( kv )
	-- get references
	

	if IsServer() then
		self:SetStackCount(0)
	end
	

end

--------------------------------------------------------------------------------

function modifier_edward_alchemy_circle_count:DeclareFunctions()
	local funcs = {


		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		
	}

	return funcs
end

function modifier_edward_alchemy_circle_count:OnAbilityFullyCast( params )
	if IsServer() then
	local stack = self:GetStackCount()
	local ability = self:GetParent():FindAbilityByName("edward_alchemy_circle")
		if params.unit~=self:GetParent() or params.ability~=ability then
			return
		end
		if stack == 4 or self:GetParent():HasModifier("modifier_edward_alchemy_circle_end") then 
        elseif stack == 3 then
		self:AddStack(1)
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_full_circles", -- modifier name
		{} -- kv
	)
	else
	self:AddStack(1)
	end
end
end
function modifier_edward_alchemy_circle_count:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value

	self:SetStackCount( after )
end

modifier_edward_alchemy_circle_end = class({})

--------------------------------------------------------------------------------

function modifier_edward_alchemy_circle_end:IsHidden()
	return true
end

function modifier_edward_alchemy_circle_end:IsDebuff()
	return false
end

function modifier_edward_alchemy_circle_end:IsPurgable()
	return false
end

function modifier_edward_alchemy_circle_end:RemoveOnDeath()
	return false
end
function modifier_edward_alchemy_circle_end:AllowIllusionDuplicate()
 return false 
 end
 
 
 
 
 
 
 
 
 
 
 
 
 LinkLuaModifier("modifier_edward_create_canon", "heroes/edward", LUA_MODIFIER_MOTION_NONE)

edward_create_canon = class({})

function edward_create_canon:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("damage")
    local target = self:GetCursorTarget()
	local caster_loc = caster:GetOrigin()
	local caster_vector = caster:GetForwardVector()
    local duration = self:GetSpecialValueFor("duration")
    local vision = self:GetSpecialValueFor("vision_range")


   


  
        local position = point
        
        local ice_unit = CreateModifierThinker(caster, self, "modifier_edward_create_canon", {duration = 0.9, point = point}, position, caster:GetTeamNumber(), true)
		ice_unit:SetForwardVector(caster_vector)
		
	
    
        
    ResolveNPCPositions(point, self:GetAOERadius())
	
	
   EmitSoundOn("edward.clap", caster)
   local radius = 200
	self:PlayEffects( radius, point )
	
	local delay = 0.5
		Timers:CreateTimer(delay,function()
	local projectile_name = "particles/edward_canon_particle.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "distance" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "width_end" )

	-- get direction
	local direction = ice_unit:GetForwardVector()
	direction.z = 0
	local projectile_direction = direction:Normalized()


	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = ice_unit:GetAbsOrigin(),
		
	    bDeleteOnHit = true,
	    
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
	end)
end
function edward_create_canon:OnProjectileHitHandle( target, location, projectile )
	if not target then return end

	local damage = self:GetSpecialValueFor( "damage" )
	

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration") })

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
self:PlayEffects1( target, direction )
end

function edward_create_canon:PlayEffects( radius , point )
	local particle_cast = "particles/edward_create_wall_dust.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, point)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function edward_create_canon:PlayEffects1( target, direction )
	-- Get Resources
	local particle_cast = "particles/homura_grenade_explosion.vpcf"
 EmitSoundOn("edward.3_1", caster)
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
modifier_edward_create_canon = class({})
function modifier_edward_create_canon:IsHidden() return true end
function modifier_edward_create_canon:IsDebuff() return false end
function modifier_edward_create_canon:IsPurgable() return false end
function modifier_edward_create_canon:IsPurgeException() return false end
function modifier_edward_create_canon:RemoveOnDeath() return true end
function modifier_edward_create_canon:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,}
    return state
end
function modifier_edward_create_canon:OnCreated(kv)
    if IsServer() then
	self.point = kv.point
        self:GetParent():SetOriginalModel("models/edward_elrik/canon.vmdl")
        self:GetParent():SetModelScale(0.5)
        self:GetParent():SetHullRadius(self:GetParent():GetHullRadius()*1)
		self:StartIntervalThink(0.5)
    end
end
function modifier_edward_create_canon:OnIntervalThink()
EmitSoundOn("edward.3", self:GetParent())
self:PlayEffects()
end

function modifier_edward_create_canon:PlayEffects()
	local particle_cast = "particles/canon_smoke.vpcf"
	local radius = 300

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end











LinkLuaModifier("modifier_edward_steel_blade", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
edward_steel_blade = class({})

function edward_steel_blade:IsStealable() return true end
function edward_steel_blade:IsHiddenWhenStolen() return false end


function edward_steel_blade:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("downsing_chain")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function edward_steel_blade:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function edward_steel_blade:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_edward_steel_blade", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()


end
---------------------------------------------------------------------------------------------------------------------
modifier_edward_steel_blade = class({})
function modifier_edward_steel_blade:IsHidden() return false end
function modifier_edward_steel_blade:IsDebuff() return true end
function modifier_edward_steel_blade:IsPurgable() return false end
function modifier_edward_steel_blade:IsPurgeException() return false end
function modifier_edward_steel_blade:RemoveOnDeath() return true end
function modifier_edward_steel_blade:AllowIllusionDuplicate() return true end
function modifier_edward_steel_blade:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,  
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,					
                    MODIFIER_EVENT_ON_ATTACK_LANDED,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end

function modifier_edward_steel_blade:GetModifierModelChange()
    return "models/edward_elrik/edward_fullmetal.vmdl"
end

function modifier_edward_steel_blade:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_edward_steel_blade:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			local damageTable = {
		attacker = self:GetParent(),
		damage = 200,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:GetParent():EmitSound("edward.attack")
			end
		end
	end
	end
function modifier_edward_steel_blade:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["edward_steel_blade"] = "edward_armor_alchemy",
							["edward_alchemy_circle"] = "edward_stone_spikes",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/edward_aura.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_head", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
						
			end
		

        
		
        EmitSoundOn("edward.4", self.parent)
        
		

        self.parent:Purge(false, true, false, true, true)
    end
end
end

function modifier_edward_steel_blade:OnRefresh(table)
    self:OnCreated(table)
end

function modifier_edward_steel_blade:OnDestroy()
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

            StopSoundOn("edward.4", self.parent)
			
			
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("edward_steel_blade_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end








edward_armor_alchemy = class({})
LinkLuaModifier( "modifier_edward_armor_alchemy", "heroes/edward", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function edward_armor_alchemy:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


		self:Hit( target, false )

		-- play effects
		local sound_cast = "edward.transmute"
		EmitSoundOn( sound_cast, caster )
		
	end


-- Helper
function edward_armor_alchemy:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
   local duration2 = 0.5
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_edward_armor_alchemy", -- modifier name
		{ duration = duration } -- kv
	)
	


end

modifier_edward_armor_alchemy = class({})

--------------------------------------------------------------------------------

function modifier_edward_armor_alchemy:IsDebuff()
	return true
end

function modifier_edward_armor_alchemy:IsStunDebuff()
	return false
end
function modifier_edward_armor_alchemy:IsHidden()
	return false
end
function modifier_edward_armor_alchemy:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function  modifier_edward_armor_alchemy:OnCreated()
self.armor = self:GetParent():GetPhysicalArmorValue(false)
	self.armor1 = self.armor * -0.5

end

--------------------------------------------------------------------------------

function modifier_edward_armor_alchemy:DeclareFunctions()
    local funcs = {
        
       
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_edward_armor_alchemy:GetModifierMagicalResistanceBonus()
    return -35
end
  function  modifier_edward_armor_alchemy:GetModifierPhysicalArmorBonus()
return self.armor1
end  

--------------------------------------------------------------------------------

function modifier_edward_armor_alchemy:GetEffectName()
	return "particles/edward_armor_debuff.vpcf"
end

function modifier_edward_armor_alchemy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end








edward_stone_spikes = class({})

function edward_stone_spikes:IsStealable() return true end
function edward_stone_spikes:IsHiddenWhenStolen() return false end
function edward_stone_spikes:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end

function edward_stone_spikes:OnSpellStart()
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
                                EffectName = "particles/test_stone_spikes.vpcf",
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
  EmitSoundOn("edward.4_2", self:GetCaster())
    
end
function edward_stone_spikes:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        return nil
    end

    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")})

    
    local damage_table = {  victim = hTarget,
                            attacker = self:GetCaster(),
                            damage = self:GetSpecialValueFor("damage"),
                            damage_type = self:GetAbilityDamageType(),
                            ability = self}

    self.anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    ApplyDamage(damage_table)
end



















LinkLuaModifier("modifier_gates_of_truth_start", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_bomba", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_damage", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_damage_aura", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_dead", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_main", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_vacuum", "heroes/edward", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_invul_lua", "modifiers/modifier_generic_stunned_invul_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gates_of_truth_astral",        "heroes/edward", LUA_MODIFIER_MOTION_NONE)

gates_of_truth = class({})


function gates_of_truth:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
	local point = caster:GetOrigin()

    local duration = self:GetSpecialValueFor("duration") 

    EmitGlobalSound("edward.5_theme")
  CreateModifierThinker(
		caster,
		self,
		"modifier_gates_of_truth_start",
		{duration = 3.0,
		},
		point,
		caster:GetTeamNumber(),
		false
	)
	CreateModifierThinker(
		caster,
		self,
		"modifier_gates_of_truth_damage_aura",
		{duration = 16.0,
		},
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects(600)
end

function gates_of_truth:PlayEffects( radius )
	local particle_cast = "particles/gates_of_truth_begin.vpcf"
	local sound_cast = "edward.5_begin"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_gates_of_truth_damage_aura = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_gates_of_truth_damage_aura:OnCreated( kv )
	-- references

self.radius = 600
	if IsServer() then
		
	end
end

function modifier_gates_of_truth_damage_aura:OnRefresh( kv )
	
end

function modifier_gates_of_truth_damage_aura:OnRemoved()
end

function modifier_gates_of_truth_damage_aura:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end

end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_gates_of_truth_damage_aura:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_gates_of_truth_damage_aura:IsAura()
	return true
end

function modifier_gates_of_truth_damage_aura:GetModifierAura()
	return "modifier_gates_of_truth_damage"
end

function modifier_gates_of_truth_damage_aura:GetAuraRadius()
	return self.radius
end

function modifier_gates_of_truth_damage_aura:GetAuraDuration()
	return 0.01
end

function modifier_gates_of_truth_damage_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gates_of_truth_damage_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_gates_of_truth_damage_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_gates_of_truth_damage_aura:GetAuraEntityReject( hEntity )
	if IsServer() then
		-- -- reject if owner
		-- if hEntity==self:GetCaster() then return true end

		-- -- reject if owner controlled
		-- if hEntity:GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end

		-- reject if unit is named faceless void
		

	return false
end
end

--------------------------------------------------------------------------------



modifier_gates_of_truth_start = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_gates_of_truth_start:OnCreated( kv )
	-- references

self.radius = 600
	if IsServer() then
		
	end
end

function modifier_gates_of_truth_start:OnRefresh( kv )
	
end

function modifier_gates_of_truth_start:OnRemoved()
end

function modifier_gates_of_truth_start:OnDestroy()
	if IsServer() then
	self:PlayEffects(self.radius)
	  CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_gates_of_truth_main",
		{duration = 6.0,
		},
		self:GetParent():GetOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
	)
		UTIL_Remove( self:GetParent() )
	end

end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_gates_of_truth_start:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_gates_of_truth_start:IsAura()
	return true
end

function modifier_gates_of_truth_start:GetModifierAura()
	return "modifier_generic_stunned_invul_lua"
end

function modifier_gates_of_truth_start:GetAuraRadius()
	return self.radius
end

function modifier_gates_of_truth_start:GetAuraDuration()
	return 0.01
end

function modifier_gates_of_truth_start:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_gates_of_truth_start:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_gates_of_truth_start:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_gates_of_truth_start:GetAuraEntityReject( hEntity )
	if IsServer() then
		-- -- reject if owner
		-- if hEntity==self:GetCaster() then return true end

		-- -- reject if owner controlled
		-- if hEntity:GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end

		-- reject if unit is named faceless void
		

	return false
end
end

--------------------------------------------------------------------------------

function modifier_gates_of_truth_start:PlayEffects( radius )
	local particle_cast = "particles/gate_of_truth_wtf.vpcf"
	local sound_cast = "edward.5_truth_speak"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end






modifier_gates_of_truth_main = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gates_of_truth_main:IsHidden()
	return false
end

function modifier_gates_of_truth_main:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gates_of_truth_main:OnCreated( kv )
	-- references
	self.radius = 600
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0
self:GetParent():EmitSound("edward.5_gate_open")
	if IsServer() then
		-- precache damage
		

		-- Start interval
		
			local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self:PlayEffects(enemy)
	end
	end
end

function modifier_gates_of_truth_main:OnRefresh( kv )
	
end

function modifier_gates_of_truth_main:OnRemoved()
	if IsServer() then
	
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_gates_of_truth_main:OnDestroy()
	if IsServer() then
	local caster = self:GetCaster()
	end
	StopGlobalSound("edward.5_theme")
	self:GetParent():EmitSound("edward.5_gate_close")
			local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	     if self:GetCaster():HasScepter() then
	      enemy:AddNewModifier(caster, self, "modifier_gates_of_truth_bomba", { duration = 9,} )
		  end
		  enemy:AddNewModifier(caster, self, "modifier_gates_of_truth_astral", { duration = 2,} )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects


--------------------------------------------------------------------------------
-- Aura Effects
function modifier_gates_of_truth_main:IsAura()
	return true
end

function modifier_gates_of_truth_main:GetModifierAura()
	return "modifier_gates_of_truth_vacuum"
end

function modifier_gates_of_truth_main:GetAuraRadius()
	return 600
end

function modifier_gates_of_truth_main:GetAuraDuration()
	return 0.1
end

function modifier_gates_of_truth_main:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gates_of_truth_main:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_gates_of_truth_main:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gates_of_truth_main:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/test_pull_hand.vpcf"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,200), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end



modifier_gates_of_truth_vacuum = class({})
function modifier_gates_of_truth_vacuum:IsHidden() return false end
function modifier_gates_of_truth_vacuum:IsDebuff() return true end
function modifier_gates_of_truth_vacuum:IsPurgable() return true end
function modifier_gates_of_truth_vacuum:IsPurgeException() return true end
function modifier_gates_of_truth_vacuum:RemoveOnDeath() return true end
function modifier_gates_of_truth_vacuum:GetPriority() return MODIFIER_PRIORITY_NORMAL end
function modifier_gates_of_truth_vacuum:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_gates_of_truth_vacuum:CheckState()
    local state = { [MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
                   
					}

    if not self.parent:IsNull() and self.pull_leash then
        state[MODIFIER_STATE_TETHERED] = true
    end

    return state
end

function modifier_gates_of_truth_vacuum:OnCreated(kv)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	 self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
    
    self.pull_speed = 250 * 1

    
    if IsServer() then
        self.rotate_speed = 1

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_gates_of_truth_vacuum:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gates_of_truth_vacuum:OnIntervalThink()
  
    if IsServer() then
        self:UpdateHorizontalMotion(self.parent, FrameTime())
    end
end
function modifier_gates_of_truth_vacuum:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        self:Charge(me, dt)
    end
end
function modifier_gates_of_truth_vacuum:Charge(me, dt)
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
function modifier_gates_of_truth_vacuum:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_gates_of_truth_vacuum:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end
        --self.parent:InterruptMotionControllers(true)
    end
end


modifier_gates_of_truth_dead = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gates_of_truth_dead:IsHidden()
	return false
end

function modifier_gates_of_truth_dead:IsDebuff()
	return true
end

function modifier_gates_of_truth_dead:IsStunDebuff()
	return false
end

function modifier_gates_of_truth_dead:IsPurgable()
	return false
end

function modifier_gates_of_truth_dead:RemoveOnDeath()
	return true
end


modifier_gates_of_truth_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gates_of_truth_astral:IsHidden()
	return false
end

function modifier_gates_of_truth_astral:IsDebuff()
	return true
end

function modifier_gates_of_truth_astral:IsStunDebuff()
	return true
end

function modifier_gates_of_truth_astral:IsPurgable()
	return true
end

function modifier_gates_of_truth_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gates_of_truth_astral:OnCreated( kv )
	-- references
self.caster = self:GetCaster()
	self.radius = 100
	
	self:GetParent():AddNoDraw()

	
end


function modifier_gates_of_truth_astral:OnRefresh( kv )
	-- references
	end

function modifier_gates_of_truth_astral:OnRemoved()
end

function modifier_gates_of_truth_astral:OnDestroy()
	if not IsServer() then return end

	local caster = self:GetCaster()

	-- play effects
	self:GetParent():RemoveNoDraw()

	local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 0,
                        knockback_height = 300,
                        center_x = self:GetParent():GetAbsOrigin().x,
                        center_y = self:GetParent():GetAbsOrigin().y,
                        center_z = self:GetParent():GetAbsOrigin().z }

    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_knockback", knockback)
	 self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_gates_of_truth_dead", { duration = 1,})
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_gates_of_truth_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

modifier_gates_of_truth_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gates_of_truth_damage:IsHidden()
	return false
end

function modifier_gates_of_truth_damage:IsDebuff()
	return false
end

function modifier_gates_of_truth_damage:IsStunDebuff()
	return false
end

function modifier_gates_of_truth_damage:IsPurgable()
	return false
end
function modifier_gates_of_truth_damage:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gates_of_truth_damage:OnCreated( kv )


	if not IsServer() then return end
self:OnIntervalThink()
	self:StartIntervalThink(0.5)

	
end

function modifier_gates_of_truth_damage:OnRefresh( kv )
	
end

function modifier_gates_of_truth_damage:OnRemoved()
end

function modifier_gates_of_truth_damage:OnDestroy()
	if not IsServer() then return end
end



-------------------------------------------------------------------------------
-- Interval Effects
function modifier_gates_of_truth_damage:OnIntervalThink()
	local caster = self:GetCaster()

	
if self:GetParent():HasModifier("modifier_gates_of_truth_dead") then

   self:GetParent():Kill(self, caster)
   end

end


modifier_gates_of_truth_bomba = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gates_of_truth_bomba:IsHidden()
	return false
end

function modifier_gates_of_truth_bomba:IsDebuff()
	return true
end

function modifier_gates_of_truth_bomba:IsStunDebuff()
	return true
end

function modifier_gates_of_truth_bomba:IsPurgable()
	return true
end

function modifier_gates_of_truth_bomba:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gates_of_truth_bomba:OnCreated( kv )
	

	self:PlayEffects()
end


function modifier_gates_of_truth_bomba:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_gates_of_truth_bomba:OnRemoved()
end

function modifier_gates_of_truth_bomba:OnDestroy()
	if not IsServer() then return end
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )
	
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gates_of_truth_bomba:PlayEffects()

local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "emit_bomba", {} )
end









edward_create_spear = class({})



--------------------------------------------------------------------------------
-- Ability Start
function edward_create_spear:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/test_edward_spear.vpcf"
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

function edward_create_spear:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	self:Hit( target, true )
	
	

	

	self:PlayEffects2( hTarget )
end
function edward_create_spear:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	 local knockback = { should_stun = 0,
                        knockback_duration = 1.0,
                        duration = 1.0,
                        knockback_distance = 500,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	

	
end

--------------------------------------------------------------------------------
function edward_create_spear:PlayEffects1()
	-- Get Resources
	local sound_cast = "edward.spear_throw"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function edward_create_spear:PlayEffects2( target )
	-- Get Resources
	local sound_target = "edward.spear_throw_impact"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end