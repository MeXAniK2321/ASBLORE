dragon_knight_dragon_tail_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_void_call", "heroes/dragon_knight_dragon_tail_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_void_damage", "heroes/dragon_knight_dragon_tail_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_inoriri","heroes/dragon_knight_dragon_tail_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV
function dragon_knight_dragon_tail_lua:GetCastRange( vLocation, hTarget )
	
		return 600
	
end
function dragon_knight_dragon_tail_lua:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("inori_song")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function dragon_knight_dragon_tail_lua:GetIntrinsicModifierName()
	return "modifier_inoriri"
end
--------------------------------------------------------------------------------
-- Ability Start
function dragon_knight_dragon_tail_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier
	
local sound_cast = "void.soul_proj"
	EmitSoundOn( sound_cast, caster )
	-- dragon form

	-- get data
	local projectile_name = "particles/shu_void_proj.vpcf"
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
function dragon_knight_dragon_tail_lua:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "stun_duration" )
    local buff_duration = self:GetSpecialValueFor( "buff_duration" )
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
		"modifier_void_damage", -- modifier name
		{ duration = 1 } -- kv
	)
	

	-- Play effects
	self:PlayEffects( target, dragonform )
	
end

--------------------------------------------------------------------------------
-- Projectile
function dragon_knight_dragon_tail_lua:OnProjectileHit( target, location )
	if not target then return end
   if  target:IsMagicImmune() then
	else
	self:Hit( target, true )
	local sound_cast = "void.soul"
	EmitSoundOn( sound_cast, target )
end
end

--------------------------------------------------------------------------------
function dragon_knight_dragon_tail_lua:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf"

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
modifier_void_call = class({})
function modifier_void_call:IsHidden() return false end
function modifier_void_call:IsDebuff() return true end
function modifier_void_call:IsPurgable() return false end
function modifier_void_call:IsPurgeException() return false end
function modifier_void_call:RemoveOnDeath() return true end
function modifier_void_call:AllowIllusionDuplicate() return true end
function modifier_void_call:CheckState()
    local state = { 
                }

    return state
end
function modifier_void_call:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, }
    return func
end

function modifier_void_call:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('movespeed')
end
function modifier_void_call:GetModifierBaseDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor('bonus_damage')
end

function modifier_void_call:GetModifierAttackSpeedBonus_Constant()
	
	return self:GetAbility():GetSpecialValueFor('attack_speed')
end

function modifier_void_call:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

   


    
        
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/econ/courier/courier_babyroshan_ti10/courier_babyroshan_ti10_ambient_shine.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_sword", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end

        
		
        
self:PlayEffects()
       
    end

end
function modifier_void_call:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/shu_boots.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_foot", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_void_call:PlayEffects2()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/dev/library/base_fire_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_left_arm", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_void_call:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_void_call:OnDestroy()
    if IsServer() then
        
            
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

            

            
        
    end
end
modifier_void_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_void_damage:IsHidden()
	return false
end

function modifier_void_damage:IsDebuff()
	return true
end

function modifier_void_damage:IsStunDebuff()
	return false
end

function modifier_void_damage:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_void_damage:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor( "damage" )
	local interval = 1

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )

	-- Play effects
	self:PlayEffects()
end

function modifier_void_damage:OnRefresh( kv )
	if not IsServer() then return end
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor( "damage" )
	local interval = 1

	-- Start interval
	self:StartIntervalThink( interval )

	-- Play effects
	self:PlayEffects()
end

function modifier_void_damage:OnRemoved()
end

function modifier_void_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_void_damage:OnIntervalThink()
	-- update damage
	self.damageTable.damage = self.damage 

	-- apply damage
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_damage:GetEffectName()
	return ""
end

function modifier_void_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_void_damage:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
modifier_inoriri = class ({})
function modifier_inoriri:IsHidden() return true end
function modifier_inoriri:IsDebuff() return false end
function modifier_inoriri:IsPurgable() return false end
function modifier_inoriri:IsPurgeException() return false end
function modifier_inoriri:RemoveOnDeath() return false end

function modifier_inoriri:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_inoriri:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_inoriri:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_inoriri:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_inoriri:OnIntervalThink()
    if IsServer() then
        local cool_song = self:GetParent():FindAbilityByName("inori_song")
        if cool_song and not cool_song:IsNull() then
            if self:GetParent():HasScepter() then
                if cool_song:IsHidden() then
                    cool_song:SetHidden(false)
                end
            else
                if not cool_song:IsHidden() then
                    cool_song:SetHidden(true)
                end
            end
        end
    end
end