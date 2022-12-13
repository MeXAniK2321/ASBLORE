pikachu_nit = class({})

LinkLuaModifier("modifier_puka_puka",        "heroes/pikachu", LUA_MODIFIER_MOTION_NONE)
function pikachu_nit:GetIntrinsicModifierName()
    return "modifier_puka_puka"
end
function pikachu_nit:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gayrang")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function pikachu_nit:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")

	local int = self:GetSpecialValueFor("int_scale")
local int_scale = caster:GetIntellect() * int	
	local damage = self:GetSpecialValueFor("damage") + int_scale
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
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
	
	end

	self:PlayEffects( radius )
end

function pikachu_nit:PlayEffects( radius )
	local particle_cast = "particles/pikachu1_1.vpcf"
	local sound_cast = "gachichu.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_puka_puka = class ({})
function modifier_puka_puka:IsHidden() return true end
function modifier_puka_puka:IsDebuff() return false end
function modifier_puka_puka:IsPurgable() return false end
function modifier_puka_puka:IsPurgeException() return false end
function modifier_puka_puka:RemoveOnDeath() return false end

function modifier_puka_puka:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_puka_puka:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_puka_puka:OnIntervalThink()
    if IsServer() then
        local jebroni = self:GetParent():FindAbilityByName("gayrang")
        if jebroni and not jebroni:IsNull() then
            if self:GetParent():HasModifier("modifier_pikachu_swap") then
                if jebroni:IsHidden() then
                    jebroni:SetHidden(false)
                end
            else
                if not jebroni:IsHidden() then
                    jebroni:SetHidden(true)
                end
            end
        end
    end
end
LinkLuaModifier("modifier_pikachu_reduction", "heroes/pikachu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE)

pikachu_cry = class({})

function pikachu_cry:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("gachichu.2")
    caster:AddNewModifier(caster, self, "modifier_pikachu_reduction", { duration = duration } )
	 caster:AddNewModifier(caster, self, "modifier_dark_willow_terrorize_lua", { duration = 2 } )
end
modifier_pikachu_reduction = class({})
function modifier_pikachu_reduction:IsHidden() return true end
function modifier_pikachu_reduction:IsDebuff() return false end
function modifier_pikachu_reduction:IsPurgable() return false end
function modifier_pikachu_reduction:IsPurgeException() return false end
function modifier_pikachu_reduction:RemoveOnDeath() return false end
function modifier_pikachu_reduction:OnCreated() 
if IsServer() then
self.em = 1

local caster = self:GetCaster()
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage

	for _,enemy in pairs(enemies) do
	local jm = self.em
	self.em = jm + 1
	
	end
	end
	local heal = self:GetAbility():GetSpecialValueFor("heal") * self.em 
	self.reduct = -1 * self.em * 15
	local caster = self:GetCaster()
	 caster:Heal( heal, self:GetParent() )
 end

function modifier_pikachu_reduction:DeclareFunctions()
	local func = {	
					
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
	return func
end

function modifier_pikachu_reduction:GetModifierIncomingDamage_Percentage( params )

		return self.reduct
	end
function modifier_pikachu_reduction:GetEffectName()
	return "particles/pikachu_evade_buff.vpcf"
end
saske_vernis_v_konohu = class({})
LinkLuaModifier( "modifier_do_you_wanna_touch_the_child", "modifiers/modifier_do_you_wanna_touch_the_child", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function saske_vernis_v_konohu:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

	-- check if simple form
	if not modifier then
		-- cancel if linken
		if target:TriggerSpellAbsorb( self ) then return end

		-- directly hit
		self:Hit( target, false )

		-- play effects
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
function saske_vernis_v_konohu:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetAbilityDamage()
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

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_do_you_wanna_touch_the_child", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = "chatwheel.91"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function saske_vernis_v_konohu:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function saske_vernis_v_konohu:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/saske_konoha.vpcf"

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
LinkLuaModifier("modifier_angeloid_speed", "heroes/pikachu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_angeloid_speed_damage", "heroes/pikachu", LUA_MODIFIER_MOTION_NONE)

dejavu_pikachu = class({})






function dejavu_pikachu:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("chatwheel.45")
    caster:AddNewModifier(caster, self, "modifier_angeloid_speed", { duration = duration} )
end

modifier_angeloid_speed = class({})
function modifier_angeloid_speed:IsHidden() return false end
function modifier_angeloid_speed:IsDebuff() return false end
function modifier_angeloid_speed:IsPurgable() return true end
function modifier_angeloid_speed:IsPurgeException() return true end
function modifier_angeloid_speed:RemoveOnDeath() return true end
function modifier_angeloid_speed:OnCreated( kv )
	-- references
	local caster = self:GetCaster() 
	local scale = self:GetAbility():GetSpecialValueFor('int_scale')
	local int = caster:GetIntellect() * scale
	local damage = self:GetAbility():GetSpecialValueFor('damage') + int
	self.radius = 350

	if not IsServer() then return end
	local interval = 1 
	self.owner = kv.isProvidedByAura~=1

	if not self.owner then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( 0.1 )

	-- Play effects
	
end
function modifier_angeloid_speed:OnIntervalThink()
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
		if enemy:HasModifier("modifier_angeloid_speed_damage") then
		else
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_angeloid_speed_damage", -- modifier name
		{ duration = 2  } -- kv
	)
	end

		-- play effects
		
	end
end
function modifier_angeloid_speed:CheckState()
    

	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
	
	

    

	return state 
	end

function modifier_angeloid_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_angeloid_speed:GetModifierMoveSpeed_AbsoluteMin()
	 return self:GetAbility():GetSpecialValueFor('bonus_movement_speed')
end
function modifier_angeloid_speed:GetEffectName()
	return "particles/pukachu_speed.vpcf"
end
modifier_angeloid_speed_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_angeloid_speed_damage:IsHidden()
	return false
end

function modifier_angeloid_speed_damage:IsDebuff()
	return true
end

function modifier_angeloid_speed_damage:IsStunDebuff()
	return false
end

function modifier_angeloid_speed_damage:IsPurgable()
	return true
end

function modifier_angeloid_speed_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_angeloid_speed_damage:OnCreated( kv )
	-- references
	local int = self:GetCaster():GetIntellect()
	local scale = self:GetAbility():GetSpecialValueFor( "int_scale" ) * int 
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + scale

self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )




	-- play effects
	
	
end















LinkLuaModifier("modifier_pukachu_pukachu", "heroes/pikachu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)

pukachu_pukachu = class({})

function pukachu_pukachu:IsStealable() return true end
function pukachu_pukachu:IsHiddenWhenStolen() return false end
function pukachu_pukachu:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("oooga_booga")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function pukachu_pukachu:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function pukachu_pukachu:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = 30

    caster:AddNewModifier(caster, self, "modifier_pukachu_pukachu", {duration = fixed_duration})
 

    self:EndCooldown()


end

---------------------------------------------------------------------------------------------------------------------
modifier_pukachu_pukachu = class({})
function modifier_pukachu_pukachu:IsHidden() return false end
function modifier_pukachu_pukachu:IsDebuff() return true end
function modifier_pukachu_pukachu:IsPurgable() return false end
function modifier_pukachu_pukachu:IsPurgeException() return false end
function modifier_pukachu_pukachu:RemoveOnDeath() return true end
function modifier_pukachu_pukachu:AllowIllusionDuplicate() return true end

function modifier_pukachu_pukachu:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					 MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_HEALTH_BONUS,					}
    return func
end


function modifier_pukachu_pukachu:GetModifierHealthBonus()
    return 1000
end


function modifier_pukachu_pukachu:GetModifierSpellAmplify_Percentage()

return 50


end

function modifier_pukachu_pukachu:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()



    self.skills_table = {
                            ["pukachu_pukachu"] = "oooga_booga",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/pukachu_aura_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		EmitSoundOn("gachichu.theme"  ,self.caster)
        
		
 
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_pukachu_pukachu:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_pukachu_pukachu:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("pukachu_pukachu_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
oooga_booga = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oooga_booga", "modifiers/modifier_oooga_booga", LUA_MODIFIER_MOTION_NONE )




function oooga_booga:OnSpellStart()
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
		local sound_cast = "gachichu.3"
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
function oooga_booga:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	

	-- load data
	local damage = self:GetAbilityDamage()
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
		"modifier_oooga_booga", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = ""
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function oooga_booga:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function oooga_booga:PlayEffects( target, dragonform )
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
gayrang = class({})
LinkLuaModifier( "modifier_muken", "modifiers/modifier_muken", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start


function gayrang:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	if target then
		point = target:GetOrigin()
	end

	-- load data
	local projectile_name = "particles/gayrang.vpcf"
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
		vSpawnOrigin = caster:GetAbsOrigin(),
		
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

	-- Play effects
	local sound_cast = "chatwheel.47"
	local sound_projectile = "chatwheel.47"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Projectile
function gayrang:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	local bduration = self:GetSpecialValueFor("bleed")
	
	

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	target:AddNewModifier(self:GetCaster(), self, "modifier_muken", {duration = self:GetSpecialValueFor("bleed") })

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
    
	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function gayrang:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end