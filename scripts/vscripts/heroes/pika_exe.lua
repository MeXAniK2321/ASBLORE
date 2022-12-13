
presence_of_evil = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_presence_of_evil", "modifiers/modifier_presence_of_evil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ooga_booga", "heroes/pika_exe.lua", LUA_MODIFIER_MOTION_NONE )


function presence_of_evil:GetIntrinsicModifierName()
    return "modifier_ooga_booga"
end
function presence_of_evil:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("throw_booga")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	ability = self:GetCaster():FindAbilityByName("pikachu_nit")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
 

function presence_of_evil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

	-- check if simple form
	if not modifier then
		-- cancel if linken
		

		-- directly hit
		self:Hit( target, false )

		-- play effects
		local sound_cast = "pikachu.1_1"
		EmitSoundOn( sound_cast, caster )
		return
	end

	-- dragon form

	-- get data
	local projectile_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		}
	ProjectileManager:CreateTrackingProjectile(info)
end

-- Helper
function presence_of_evil:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_pikachu_20")
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = duration } -- kv
	)
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_presence_of_evil", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = ""
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function presence_of_evil:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function presence_of_evil:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = ""

	-- Get Data
	local vec = target:GetOrigin()-self:GetCaster():GetOrigin()
	local attach = "attach_attack1"
	if dragonform then
		attach = "attach_attack2"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 3, vec )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
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
modifier_ooga_booga= class ({})
function modifier_ooga_booga:IsHidden() return true end
function modifier_ooga_booga:IsDebuff() return false end
function modifier_ooga_booga:IsPurgable() return false end
function modifier_ooga_booga:IsPurgeException() return false end
function modifier_ooga_booga:RemoveOnDeath() return false end

function modifier_ooga_booga:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_ooga_booga:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_ooga_booga:OnIntervalThink()
    if IsServer() then
        local booga = self:GetParent():FindAbilityByName("throw_booga")
        if booga and not booga:IsNull() and not self:GetParent():HasModifier("modifier_pikachu_swap") then
            if self:GetParent():HasScepter() then
                if booga:IsHidden() then
                    booga:SetHidden(false)
                end
            else
                if not booga:IsHidden() then
                    booga:SetHidden(true)
                end
            end
        end
    end
end
LinkLuaModifier("modifier_aura_of_exe", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_aura_of_exe_enemy", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
aura_of_exe = class({})

function aura_of_exe:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pikachu_cry")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end
function aura_of_exe:IsStealable() return true end
function aura_of_exe:IsHiddenWhenStolen() return false end

function aura_of_exe:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()



if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "duration" )

  if not GameRules:IsDaytime() then
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	end
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_aura_of_exe_enemy", -- modifier name
		{ duration = duration } -- kv
	)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_aura_of_exe", -- modifier name
		{ duration = duration } -- kv
	)
 	
	self:PlayEffects(target)
	EmitSoundOn("pikachu.2_cast", caster)
end
function aura_of_exe:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/pika_aura_cast.vpcf"
	local sound_cast = ""

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

modifier_aura_of_exe_enemy = class({})
function modifier_aura_of_exe_enemy:IsHidden() return true end
function modifier_aura_of_exe_enemy:IsDebuff() return false end
function modifier_aura_of_exe_enemy:IsPurgable() return false end
function modifier_aura_of_exe_enemy:IsPurgeException() return false end
function modifier_aura_of_exe_enemy:RemoveOnDeath() return true end
function modifier_aura_of_exe_enemy:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.ms = self.ability:GetSpecialValueFor("ms") * -1


     
    end
	


	 
	 
function modifier_aura_of_exe_enemy:DeclareFunctions()
	local func = { 
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					}
	return func
end

function modifier_aura_of_exe_enemy:GetModifierMoveSpeedBonus_Constant()
    
    return self.ms
end
modifier_aura_of_exe = class({})
function modifier_aura_of_exe:IsHidden() return true end
function modifier_aura_of_exe:IsDebuff() return false end
function modifier_aura_of_exe:IsPurgable() return false end
function modifier_aura_of_exe:IsPurgeException() return false end
function modifier_aura_of_exe:RemoveOnDeath() return true end
function modifier_aura_of_exe:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.ms = self.ability:GetSpecialValueFor("ms")


     
    end
	


	 
	 
function modifier_aura_of_exe:DeclareFunctions()
	local func = { 
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					}
	return func
end

function modifier_aura_of_exe:GetModifierMoveSpeedBonus_Constant()
    
    return self.ms
end



function modifier_aura_of_exe:GetEffectName()
	return "particles/killstreak/killstreak_glow_smoke_topbar.vpcf"
end

function modifier_aura_of_exe:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end





pika_fear = class({})
LinkLuaModifier( "modifier_pika_fear2", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE )                

--------------------------------------------------------------------------------
-- AOE Radius
function pika_fear:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function pika_fear:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("saske_vernis_v_konohu")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end

--------------------------------------------------------------------------------
-- Ability Start
function pika_fear:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local damage = self:GetSpecialValueFor("nova_damage") + self:GetCaster():FindTalentValue("special_bonus_pikachu_25")
	local radius = self:GetSpecialValueFor("radius")
	local debuffDuration = self:GetSpecialValueFor("duration")
	local debuffDuration2 = self:GetSpecialValueFor("duration") -0.1

	local vision_radius = 900
	local vision_duration = 6

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

	-- Precache damage	 


	for _,enemy in pairs(enemies) do
		-- Apply damage
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_dark_willow_terrorize_lua", -- modifier name
			{ duration = debuffDuration } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_pika_fear2", -- modifier name
			{ duration = debuffDuration2 } -- kv
		)
		

		-- Add modifier
		
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )
local sound_cast = "pikachu.3_1"
		EmitSoundOn( sound_cast, caster )
	self:PlayEffects( point, radius, debuffDuration )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function pika_fear:AbilityConsiderations()
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
function pika_fear:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/pika_exe_fear.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_pika_fear2 = class({})

--------------------------------------------------------------------------------

function modifier_pika_fear2:IsHidden()
    return true
end

function modifier_pika_fear2:IsPurgable()
    return false
end
function modifier_pika_fear2:RemoveOnDeath()
    return true
end
function modifier_pika_fear2:OnCreated()
self:PlayEffects()
end
function modifier_pika_fear2:OnDestroy()

self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )









	
end

--------------------------------------------------------------------------------

function modifier_pika_fear2:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/pika_exe_screamer2.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	EmitSoundOnClient("pikachu.2", Player)
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end








LinkLuaModifier("modifier_scary_scary_tale", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scary_scary_tale_damage", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)

scary_scary_tale = class({})




function scary_scary_tale:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dejavu_pikachu")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end

function scary_scary_tale:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("pikachu.4_1")
    caster:AddNewModifier(caster, self, "modifier_scary_scary_tale", { duration = duration  } )
end

modifier_scary_scary_tale = class({})
function modifier_scary_scary_tale:IsHidden() return false end
function modifier_scary_scary_tale:IsDebuff() return false end
function modifier_scary_scary_tale:IsPurgable() return true end
function modifier_scary_scary_tale:IsPurgeException() return true end
function modifier_scary_scary_tale:RemoveOnDeath() return true end
function modifier_scary_scary_tale:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor('damage')
	self.radius = 350

	if not IsServer() then return end
	local interval = 1 
	self.owner = kv.isProvidedByAura~=1

	if not self.owner then return end
	-- precache damage
	

	-- Start interval
	self:StartIntervalThink( 0.1 )

	-- Play effects
	
end
function modifier_scary_scary_tale:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
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
	
		-- apply damage
		if enemy:HasModifier("modifier_scary_scary_tale_damage") then
		else
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_scary_scary_tale_damage", -- modifier name
		{ duration = 4  } -- kv
	)
	end

		-- play effects
		
	end
end
function modifier_scary_scary_tale:CheckState()
    

	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
	
	

    

	return state 
	end



function modifier_scary_scary_tale:GetEffectName()
	return "particles/scary_scary_tale.vpcf"
end
modifier_scary_scary_tale_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_scary_scary_tale_damage:IsHidden()
	return false
end

function modifier_scary_scary_tale_damage:IsDebuff()
	return true
end

function modifier_scary_scary_tale_damage:IsStunDebuff()
	return false
end

function modifier_scary_scary_tale_damage:IsPurgable()
	return true
end

function modifier_scary_scary_tale_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_scary_scary_tale_damage:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
       
        
		
    }

    return funcs
end

function modifier_scary_scary_tale_damage:GetBonusNightVision()
    return -600
end
function modifier_scary_scary_tale_damage:GetBonusDayVision()

    return -600

end
--------------------------------------------------------------------------------
-- Initializations
function modifier_scary_scary_tale_damage:OnCreated( kv )
	-- references

	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 

self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )

	

	-- play effects
	self:PlayEffects2()
	self:StartIntervalThink(1)
end
function modifier_scary_scary_tale_damage:OnIntervalThink()
	
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 

self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )

	

	-- play effects
	self:PlayEffects()
end
function modifier_scary_scary_tale_damage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/pika_exe_screamer3.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
end

end
function modifier_scary_scary_tale_damage:PlayEffects2()
	-- Get Resources
	
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	EmitSoundOnClient("pikachu.3", Player)
	
	
	
end

end






































hunting = class({})
LinkLuaModifier( "modifier_hunting_self", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hunting", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE )

function hunting:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pukachu_pukachu")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end



function hunting:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

	-- check if simple form
	if not modifier then
		-- cancel if linken
		

		-- directly hit
		self:Hit( target, false )

		-- play effects
		

	-- dragon form

	-- get data
	local projectile_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		}
	ProjectileManager:CreateTrackingProjectile(info)
end
end

-- Helper
function hunting:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	

	-- stun
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_hunting_self", -- modifier name
		{} -- kv
	)
		target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_hunting", -- modifier name
		{} -- kv
	)

	-- Play effects
	
end

modifier_hunting = class({})
function modifier_hunting:IsHidden() return true end
function modifier_hunting:IsDebuff() return true end
function modifier_hunting:IsPurgable() return false end
function modifier_hunting:IsPurgeException() return false end
function modifier_hunting:RemoveOnDeath() return false end
function modifier_hunting:AllowIllusionDuplicate() return false end



modifier_hunting_self = class({})
function modifier_hunting_self:IsHidden() return true end
function modifier_hunting_self:IsDebuff() return false end
function modifier_hunting_self:IsPurgable() return false end
function modifier_hunting_self:IsPurgeException() return false end
function modifier_hunting_self:RemoveOnDeath() return false end
function modifier_hunting_self:AllowIllusionDuplicate() return false end




function modifier_hunting_self:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()

   
	
	 

    self.skills_table = {
                            ["hunting"] = "start_hunting",
							
                            
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
           
       local ability2 = self:GetCaster():FindAbilityByName("start_hunting")
	ability2:StartCooldown(20)
    end
	end


function modifier_hunting_self:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_hunting_self:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			

           

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1))
                
                
            end
				if IsServer() then
       
    end
end
end
end





LinkLuaModifier("modifier_start_hunting", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_start_hunting_visual", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_start_hunting_kill", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_exe_awakening", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
start_hunting = class({})

function start_hunting:IsStealable() return true end
function start_hunting:IsHiddenWhenStolen() return false end


function start_hunting:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local heroes = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,hero in pairs(heroes) do
		-- apply damage
		if hero:HasModifier("modifier_hunting") then
		hero:AddNewModifier(caster, self, "modifier_start_hunting_visual", {duration = fixed_duration})
		  hero:RemoveModifierByName("modifier_hunting")
		  end

		-- play overhead event
		
	end

    caster:AddNewModifier(caster, self, "modifier_start_hunting", {duration = fixed_duration})
		
	  caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})
    self:EndCooldown()
end


---------------------------------------------------------------------------------------------------------------------
modifier_start_hunting = class({})
function modifier_start_hunting:IsHidden() return false end
function modifier_start_hunting:IsDebuff() return true end
function modifier_start_hunting:IsPurgable() return false end
function modifier_start_hunting:IsPurgeException() return false end
function modifier_start_hunting:RemoveOnDeath() return true end
function modifier_start_hunting:AllowIllusionDuplicate() return true end
function modifier_start_hunting:CheckState()
    local state = { [MODIFIER_STATE_INVISIBLE] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_MUTED] = true,
                }



    return state
end
function modifier_start_hunting:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,					}
    return func
end
function modifier_start_hunting:GetModifierInvisibilityLevel()
	return 1
end
function modifier_start_hunting:GetBonusNightVision()
    return -99999
end
function modifier_start_hunting:GetBonusDayVision()

    return -99999

end
function modifier_start_hunting:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
   self.caster:RemoveModifierByName("modifier_hunting_self")
   local ability2 = self:GetCaster():FindAbilityByName("hunting")
	ability2:StartCooldown(150)
    
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/pika_hunting_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("pikachu.2", self.parent)
        


        self.parent:Purge(false, true, false, true, true)
		self:StartIntervalThink(0.1)
    end
end
function modifier_start_hunting:OnIntervalThink()
	
local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		420,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	
		-- apply damage
		if enemy:HasModifier("modifier_start_hunting_kill") then
		elseif enemy:HasModifier("modifier_start_hunting_visual") then
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_start_hunting_kill", -- modifier name
		{ duration = 2  } -- kv
	)
	 enemy:RemoveModifierByName("modifier_start_hunting_visual")
	end
	end
end
function modifier_start_hunting:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_start_hunting:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
           
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

         
       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                
                    
                end
            end
        end
    end
	modifier_start_hunting_visual = class({})
function modifier_start_hunting_visual:IsHidden() return false end
function modifier_start_hunting_visual:IsDebuff() return true end
function modifier_start_hunting_visual:IsPurgable() return false end
function modifier_start_hunting_visual:IsPurgeException() return false end
function modifier_start_hunting_visual:RemoveOnDeath() return false end
function modifier_start_hunting_visual:AllowIllusionDuplicate() return false end

function modifier_start_hunting_visual:GetEffectName()
	return "particles/pika_hunting_target.vpcf"
end

function modifier_start_hunting_visual:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_start_hunting_visual:OnCreated()
	if IsServer() then
	self.caster = self:GetCaster()
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_start_hunting_visual:OnIntervalThink()
	if IsServer() then
		AddFOWViewer(self.caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), 800, FrameTime(), false)

		
	end
end





modifier_start_hunting_kill = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_start_hunting_kill:IsHidden()
	return false
end

function modifier_start_hunting_kill:IsDebuff()
	return true
end

function modifier_start_hunting_kill:IsStunDebuff()
	return false
end

function modifier_start_hunting_kill:IsPurgable()
	return true
end

function modifier_start_hunting_kill:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_start_hunting_kill:OnCreated( kv )
	-- references
	self.duration = 1.9
	

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	self:PlayEffects()
end

function modifier_start_hunting_kill:OnRefresh( kv )
	
end

function modifier_start_hunting_kill:OnRemoved()
end

function modifier_start_hunting_kill:OnDestroy()
end



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_start_hunting_kill:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_start_hunting_kill:Silence()
	local caster = self:GetCaster()
	self:PlayEffects2()
      self:GetParent():Kill(self, caster)
	   caster:RemoveModifierByName("modifier_start_hunting")
	   caster:AddNewModifier(caster, self, "modifier_exe_awakening", {duration = 30})
	self:Destroy()
end
function modifier_start_hunting_kill:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_start_hunting_kill:GetEffectName()
	return "particles/pika_exe_kill.vpcf"
end

function modifier_start_hunting_kill:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_start_hunting_kill:PlayEffects( )
	-- Get Resources
	
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	
        CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_start2", {} )
	

	-- Create Particle
	EmitSoundOnClient("pikachu.5", Player)

	
	
end

end
function modifier_start_hunting_kill:PlayEffects2( )
	-- Get Resources
	
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )

	-- Create Particle
	EmitSoundOnClient("pikachu.5_1", Player)
	
	
	
end

end


modifier_exe_awakening = class({})
function modifier_exe_awakening:IsHidden() return false end
function modifier_exe_awakening:IsDebuff() return true end
function modifier_exe_awakening:IsPurgable() return false end
function modifier_exe_awakening:IsPurgeException() return false end
function modifier_exe_awakening:RemoveOnDeath() return true end
function modifier_exe_awakening:AllowIllusionDuplicate() return true end
function modifier_exe_awakening:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_exe_awakening:GetModifierEvasion_Constant()
    return 100
end
function modifier_exe_awakening:GetModifierBonusStats_Strength()
    return 150
end

function modifier_exe_awakening:GetModifierSpellAmplify_Percentage()

    return 50
end






function modifier_exe_awakening:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

   
	 self.caster:RemoveModifierByName("modifier_star_tier3")
	 self.caster:AddNewModifier(self.caster, self, "modifier_star_tier3", {duration = 30})
	  GameRules:BeginNightstalkerNight(30)

    self.skills_table = {
                            ["hunting"] = "death_exe",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/pikachu_exe_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        
		end

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_exe_awakening:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_exe_awakening:OnDestroy()
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

          
       

            
        end
    end
end


death_exe = class({})
LinkLuaModifier( "modifier_death_exe", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function death_exe:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function death_exe:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetSpecialValueFor("nova_damage")

	local radius = self:GetSpecialValueFor("radius") 
	
	local debuffDuration = self:GetSpecialValueFor("duration")
	
	
	
	

	local vision_radius = 900
	local vision_duration = 6

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

	-- Precache damage	 
	
	for _,enemy in pairs(enemies) do
		-- Apply damage
		

		-- Add modifier
		
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_death_exe", -- modifier name
			{ duration = 0.7 } -- kv
		)
	
		
		
		
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )


	self:PlayEffects( point, radius, debuffDuration )
	
	
	end



--------------------------------------------------------------------------------
-- Ability Considerations
function death_exe:AbilityConsiderations()
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
function death_exe:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/exe_death.vpcf"
	local sound_cast = "pikachu.6"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end


modifier_death_exe = class({})

--------------------------------------------------------------------------------

function modifier_death_exe:IsDebuff()
	return true
end
function modifier_death_exe:OnCreated()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_start2", {} )
end
function modifier_death_exe:IsStunDebuff()
	return true
end
function modifier_death_exe:OnDestroy()
	
self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
self:PlayEffects()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )

end

--------------------------------------------------------------------------------

function modifier_death_exe:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_death_exe:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_death_exe:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_death_exe:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_death_exe:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_death_exe:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/pandora_blood_exp.vpcf"
	local sound_cast = "pikachu.7"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

throw_booga = class({})
LinkLuaModifier( "modifier_ooooooga", "heroes/pika_exe", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function throw_booga:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	-- load data
	local projectile_name = "particles/oooga_booga_throw.vpcf"
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
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Effects
	
	EmitSoundOn( "pikachu.ooga", caster )
end


--------------------------------------------------------------------------------
-- Projectile
function throw_booga:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end

	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)

	-- damage
	if (not hTarget:IsConsideredHero()) and (not hTarget:IsAncient()) and (not hTarget:IsMagicImmune()) then
		local damageTable = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = hTarget:GetHealth() + 1,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self, --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
		}
		ApplyDamage(damageTable)
		return true
	end

	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_ooooooga", -- modifier name
		{ duration = self:GetSpecialValueFor( "arrow_max_stun" )  } -- kv
	)

	AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, 500, 3, false )

	-- effects
	local sound_cast = "pikachu.ooga"
	EmitSoundOn( sound_cast, hTarget )

	return true
end

modifier_ooooooga = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ooooooga:IsHidden()
	return false
end

function modifier_ooooooga:IsDebuff()
	return true
end

function modifier_ooooooga:IsStunDebuff()
	return false
end

function modifier_ooooooga:IsPurgable()
	return true
end

function modifier_ooooooga:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ooooooga:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
        CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_start1", {} )
end

function modifier_ooooooga:OnRefresh( kv )
	
end

function modifier_ooooooga:OnRemoved()
end

function modifier_ooooooga:OnDestroy()
	if not IsServer() then return end

    if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	else
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	end
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
        CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end", {} )
	 
	
	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ooooooga:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ooooooga:GetEffectName()
	return ""
end

function modifier_ooooooga:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ooooooga:GetStatusEffectName()
	return ""
end

function modifier_ooooooga:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end
function modifier_ooooooga:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/oooga.vpcf"
	local sound_target = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
function modifier_ooooooga:PlayEffects2( )
	-- Get Resources
	local particle_cast = "particles/oogabooga.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	
    EmitSoundOnClient("pikachu.1", Player)

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end