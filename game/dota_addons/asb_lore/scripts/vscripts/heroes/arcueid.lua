energy_wave = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_moon_princesse", "heroes/arcueid.lua", LUA_MODIFIER_MOTION_NONE )
function energy_wave:GetIntrinsicModifierName()
    return "modifier_moon_princesse"
end
function energy_wave:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("blood_combo")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function energy_wave:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	if target then
		point = target:GetOrigin()
	end

if self:GetCaster():HasModifier("modifier_red_arcueid") then
local projectile_name = "particles/blood_wave.vpcf"
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
	local sound_cast = "arcueid.5_1"
	EmitSoundOn( sound_cast, self:GetCaster() )
elseif self:GetCaster():HasModifier("modifier_neko_arc") then
local projectile_name = "particles/test_neko_paw.vpcf"
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
	local sound_cast = "arcueid.neko_2"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
elseif self:GetCaster():HasModifier("modifier_archetype_earth") then
local projectile_name = "particles/archetype_holy_wave.vpcf"
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
	local sound_cast = "archetype.1"
	EmitSoundOn( sound_cast, self:GetCaster() )
else
	local projectile_name = "particles/energy_wave.vpcf"
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
	local sound_cast = "arcueid.1"
	EmitSoundOn( sound_cast, self:GetCaster() )
end
end
--------------------------------------------------------------------------------
-- Projectile
function energy_wave:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	local caster = self:GetCaster()
	local bduration = self:GetSpecialValueFor("bleed")
	if self:GetCaster():HasModifier("modifier_archetype_earth") then
self.damage = self:GetSpecialValueFor("damage") * 2
	elseif self:GetCaster():HasModifier("modifier_red_arcueid") or self:GetCaster():HasModifier("modifier_neko_arc") then
	self.damage = self:GetSpecialValueFor("damage") * 2  + self:GetCaster():FindTalentValue("special_bonus_arcueid_20")
	else
	self.damage = self:GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_arcueid_20")
	end
	

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	if self:GetCaster():HasModifier("modifier_archetype_earth") then
	local knockback = { should_stun = 0,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 0,
                        knockback_height = 500,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	else
	target:AddNewModifier(self:GetCaster(), self, "modifier_generic_slow", {duration = 1 })
end
	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
    
	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function energy_wave:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_moon_princesse = class ({})
function modifier_moon_princesse:IsHidden() return true end
function modifier_moon_princesse:IsDebuff() return false end
function modifier_moon_princesse:IsPurgable() return false end
function modifier_moon_princesse:IsPurgeException() return false end
function modifier_moon_princesse:RemoveOnDeath() return false end

function modifier_moon_princesse:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_moon_princesse:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_moon_princesse:OnIntervalThink()
    if IsServer() then
	local caster = self:GetParent()
        local vongolle = self:GetParent():FindAbilityByName("blood_combo")
		if not caster:HasModifier("modifier_archetype_earth") then
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
end

melty_blood = class({})
LinkLuaModifier( "modifier_melty_blood", "heroes/arcueid.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earth_princess", "heroes/arcueid.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earth_princess_awakened", "heroes/arcueid.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_melty_blood_debuff", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function melty_blood:GetIntrinsicModifierName()
	return "modifier_melty_blood"
end



function melty_blood:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	EmitGlobalSound("arcueid.neko_2")
	local Player = PlayerResource:GetPlayer(caster:GetPlayerID())
	   local kills = PlayerResource:GetKills(caster:GetPlayerID())
if kills > 14 and caster:HasScepter() and not caster:HasModifier("modifier_earth_princess_awakened") then
if not caster:HasModifier("modifier_neko_arc") and not caster:HasModifier("modifier_red_arcueid") then
caster:AddNewModifier(caster, self, "modifier_earth_princess", {})
 local modifier = caster:FindModifierByNameAndCaster("modifier_earth_princess",caster)
	local current = modifier:GetStackCount()
	if current == 5 then
	caster:AddNewModifier(caster, self, "modifier_earth_princess_awakened", {})
	end
	end
	end

end




modifier_earth_princess = class({})
function modifier_earth_princess:IsHidden() return false end
function modifier_earth_princess:IsDebuff() return false end
function modifier_earth_princess:IsPurgable() return false end
function modifier_earth_princess:IsPurgeException() return false end
function modifier_earth_princess:RemoveOnDeath() return false end

function modifier_earth_princess:OnCreated( kv )
	-- get references
	self.kill = 10
	

	if IsServer() then
		self:SetStackCount(1)
	end
end


function modifier_earth_princess:OnRefresh( kv )

	local max_stack = 10

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
end
modifier_earth_princess_awakened = class({})
function modifier_earth_princess_awakened:IsHidden() return false end
function modifier_earth_princess_awakened:IsDebuff() return true end
function modifier_earth_princess_awakened:IsPurgable() return false end
function modifier_earth_princess_awakened:IsPurgeException() return false end
function modifier_earth_princess_awakened:RemoveOnDeath() return false end
function modifier_earth_princess_awakened:AllowIllusionDuplicate() return true end

function modifier_earth_princess_awakened:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            
							["red_arcueid"] = "archetype_earth"
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
           
        
end
end

function modifier_earth_princess_awakened:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_earth_princess_awakened:GetEffectName()
	return "particles/archetype_awaken_passive.vpcf"
end

function modifier_earth_princess_awakened:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


LinkLuaModifier("modifier_archetype_earth", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)


archetype_earth = class({})

function archetype_earth:IsStealable() return true end
function archetype_earth:IsHiddenWhenStolen() return false end

function archetype_earth:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
   EmitSoundOn("archetype.start", caster)
    caster:AddNewModifier(caster, self, "modifier_archetype_earth", {})
caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})
    self:EndCooldown()
self:PlayEffects(400)
    
end
function archetype_earth:PlayEffects( radius )

	local particle_cast = "particles/archetype_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_archetype_earth = class({})
function modifier_archetype_earth:IsHidden() return false end
function modifier_archetype_earth:IsDebuff() return true end
function modifier_archetype_earth:IsPurgable() return false end
function modifier_archetype_earth:IsPurgeException() return false end
function modifier_archetype_earth:RemoveOnDeath() return false end
function modifier_archetype_earth:AllowIllusionDuplicate() return true end

function modifier_archetype_earth:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_archetype_earth:GetModifierModelChange()

    
	return "models/arcueid/archetype_earth.vmdl"

end


function modifier_archetype_earth:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["archetype_earth"] = "archetype_last_arc",
							["blood_combo"] = "archetype_light_collumn",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/archetype_earth_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
     
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_archetype_earth:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_archetype_earth:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("archetype_earth_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
modifier_melty_blood = class({})

--------------------------------------------------------------------------------

function modifier_melty_blood:IsHidden()
	return false
end

function modifier_melty_blood:IsDebuff()
	return false
end

function modifier_melty_blood:IsPurgable()
	return false
end

function modifier_melty_blood:RemoveOnDeath()
	return false
end
function modifier_melty_blood:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_melty_blood:OnCreated( kv )
	-- get references
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")

	
end

function modifier_melty_blood:OnRefresh( kv )
self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

--------------------------------------------------------------------------------

function modifier_melty_blood:DeclareFunctions()
	local funcs = {


		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end
function modifier_melty_blood:GetAttackSound()
return "arcueid.attack"
	
end
function modifier_melty_blood:OnAttackLanded(params)
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	if params.attacker == self:GetParent() then
		if self:GetParent():IsRealHero() then
	    if not params.attacker:IsIllusion() then
			self.record = params.record
			local target = params.target
			local heal = self:GetParent():GetAttackDamage()
  
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_melty_blood_debuff", {duration = self.duration, damage = self.damage, })
			else
			end
		end
	end
	end
	end

	


function modifier_melty_blood:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			
		end
	end
end


modifier_melty_blood_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_melty_blood_debuff:IsHidden()
	return false
end

function modifier_melty_blood_debuff:IsDebuff()
	return true
end

function modifier_melty_blood_debuff:IsStunDebuff()
	return false
end

function modifier_melty_blood_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_melty_blood_debuff:OnCreated( kv )
	-- references
	self.damage = kv.damage + self:GetCaster():FindTalentValue("special_bonus_arcueid_25")


	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_melty_blood_debuff:OnRefresh( kv )
	self.damage = kv.damage  + self:GetCaster():FindTalentValue("special_bonus_arcueid_25")
self:IncrementStackCount()	
	if self:GetStackCount() == 8 then
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 500,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	ApplyDamage( damageTable )
	self:Destroy()
	end
end

function modifier_melty_blood_debuff:OnDestroy( kv )
local stack = self:GetStackCount()
local damage = self.damage * stack
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	self:PlayEffects()
end
function modifier_melty_blood_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/melty_blood_effect.vpcf"
	local sound_cast = "arcueid.swoosh"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_melty_blood_debuff:GetEffectName()
	return "particles/melty_blood_debuff.vpcf"
end

function modifier_melty_blood_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end





chain_phantasm = class({})
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chain_phantasm", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_phantasm", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start

function chain_phantasm:OnSpellStart() 
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end


	-- set duration
	local bduration = self:GetSpecialValueFor("duration") 
	

	local stun_duration = 0.1
	if caster:HasModifier("modifier_archetype_earth") then
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_archetype_phantasm", -- modifier name
		{ duration = bduration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = bduration } -- kv
	)
	else
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_chain_phantasm", -- modifier name
		{ duration = bduration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = bduration } -- kv
	)
	end


end
modifier_archetype_phantasm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_archetype_phantasm:IsHidden()
	return false
end

function modifier_archetype_phantasm:IsDebuff()
	return true
end

function modifier_archetype_phantasm:IsStunDebuff()
	return true
end

function modifier_archetype_phantasm:IsPurgable()
return false 
	
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_archetype_phantasm:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) * 2
	self.interval = 0.3

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
		

		-- Play Effects
		self.sound_target2 = "archetype.3_sfx"
		EmitSoundOn( self.sound_target2, self:GetParent() )
		self.sound_target = "archetype.3"
		EmitSoundOn( self.sound_target, self:GetParent() )
		self.sound_target1 = "arcueid.3_1"
		EmitSoundOn( self.sound_target1, self:GetParent() )
	end
end

function modifier_archetype_phantasm:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) 
	self.interval = 0.3

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
		

		-- Play Effects
		self.sound_target = ""
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_archetype_phantasm:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_archetype_phantasm:OnIntervalThink()
	ApplyDamage( self.damageTable )
	
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_archetype_phantasm:GetEffectName()
	return "particles/holy_phantasm.vpcf"
end

function modifier_archetype_phantasm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
modifier_chain_phantasm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chain_phantasm:IsHidden()
	return false
end

function modifier_chain_phantasm:IsDebuff()
	return true
end

function modifier_chain_phantasm:IsStunDebuff()
	return true
end

function modifier_chain_phantasm:IsPurgable()
return false 
	
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chain_phantasm:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) 
	self.interval = 0.3

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
		

		-- Play Effects
		self.sound_target = "arcueid.3"
		EmitSoundOn( self.sound_target, self:GetParent() )
		self.sound_target1 = "arcueid.3_1"
		EmitSoundOn( self.sound_target1, self:GetParent() )
	end
end

function modifier_chain_phantasm:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) 
	self.interval = 0.3

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
		

		-- Play Effects
		self.sound_target = ""
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_chain_phantasm:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_chain_phantasm:OnIntervalThink()
	ApplyDamage( self.damageTable )
	
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_chain_phantasm:GetEffectName()
	return "particles/test_chains.vpcf"
end

function modifier_chain_phantasm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

















moon_fall = class({})
LinkLuaModifier( "modifier_moon_fall_invul", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_moon_fall", "modifiers/modifier_moon_fall", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_chains_palace", "modifiers/modifier_blood_chains_palace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_moon_fall_astral", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_chains_palace_damage", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_moon_fall_invul_2", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )


function moon_fall:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")
	local point = self:GetCaster():GetOrigin()


caster:AddNewModifier(caster, self, "modifier_moon_fall_invul", {duration = 1.0})	
if caster:HasModifier("modifier_archetype_earth") then
	self.sound_cast = "archetype.4"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
else
	self.sound_cast = "arcueid.4"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	end
		
end



modifier_moon_fall_invul = class({})
function modifier_moon_fall_invul:IsHidden() return false end
function modifier_moon_fall_invul:IsDebuff() return true end
function modifier_moon_fall_invul:IsPurgable() return false end
function modifier_moon_fall_invul:IsPurgeException() return false end
function modifier_moon_fall_invul:RemoveOnDeath() return true end
function modifier_moon_fall_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_moon_fall_invul:OnCreated()
if IsServer() then
if self:GetCaster():HasModifier("modifier_archetype_earth") then
self:PlayEffects2()
else
        self:PlayEffects1()
      end
    end
end
function modifier_moon_fall_invul:OnDestroy()
	self.damage2 = self:GetCaster():GetAgility()	* 10
	if self:GetCaster():HasModifier("modifier_archetype_earth") then
	self.damage = self.damage2 * 1.5
	self:PlayEffects3()
	else
	self.damage = self.damage2
	self:PlayEffects()
	end
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
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.	 --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 0.3 } -- kv
		)
	end
	if self.particle_time1 then
	    ParticleManager:DestroyParticle(self.particle_time1, false)
	    ParticleManager:ReleaseParticleIndex(self.particle_time1)
	end
 self.sound_cast = "arcueid.4_1"
	EmitSoundOn( self.sound_cast, self:GetParent() )	
end
function modifier_moon_fall_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/moon_fall_explosion.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end
function modifier_moon_fall_invul:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/holy_bomb_explosion.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end
function modifier_moon_fall_invul:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/arcueid_moon_fall.vpcf"
	

	-- Create Particle
	self.particle_time1 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time1, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time1, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end
function modifier_moon_fall_invul:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/archetype_holy_bomb.vpcf"
	

	-- Create Particle
	self.particle_time1 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time1, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time1, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end
function modifier_moon_fall_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_moon_fall_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end


LinkLuaModifier("modifier_red_arcueid", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)

red_arcueid = class({})

function red_arcueid:IsStealable() return true end
function red_arcueid:IsHiddenWhenStolen() return false end

function red_arcueid:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("blood_moon")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function red_arcueid:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = 600
	
    caster:AddNewModifier(caster, self, "modifier_red_arcueid", {duration = fixed_duration})	
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()
	self:PlayEffects(radius)
end
function red_arcueid:PlayEffects( radius )
	local particle_cast = "particles/red_arc_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_red_arcueid = class({})
function modifier_red_arcueid:IsHidden() return false end
function modifier_red_arcueid:IsDebuff() return true end
function modifier_red_arcueid:IsPurgable() return false end
function modifier_red_arcueid:IsPurgeException() return false end
function modifier_red_arcueid:RemoveOnDeath() return true end
function modifier_red_arcueid:AllowIllusionDuplicate() return true end

function modifier_red_arcueid:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, }
    return func
end


function modifier_red_arcueid:GetModifierModelChange()

	return "models/arcueid/arcueid_red.vmdl"
	end

function modifier_red_arcueid:GetModifierModelScale()

	return -25
	
end
function modifier_red_arcueid:GetModifierBonusStats_Agility()

    return 100
	
end
function modifier_red_arcueid:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_red_arcueid:GetModifierBonusStats_Strength()

    return 50


	
end


function modifier_red_arcueid:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()



    self.skills_table = {
                            ["red_arcueid"] = "blood_moon_rise",
							["chain_phantasm"] = "blood_chains_palace",
							["moon_fall"] = "blood_arc",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/red_arcueid_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

   
		
        EmitSoundOn("arcueid.5", self.parent)
		
		
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_red_arcueid:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_red_arcueid:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("red_arcueid_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end






blood_chains_palace = class({})
LinkLuaModifier( "modifier_blood_chains_palace_invul", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_moon_palace_combo", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_chains_palace_shockwave", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_chains_palace_damage", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start

function blood_chains_palace:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
caster:AddNewModifier(caster, self, "modifier_blood_chains_palace_invul", {duration = 5})	
caster:AddNewModifier(caster, self, "modifier_blood_chains_palace_damage", {duration = 3})	
	self.sound_cast = "arcueid.5_3"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	

end



modifier_blood_chains_palace_invul = class({})
function modifier_blood_chains_palace_invul:IsHidden() return false end
function modifier_blood_chains_palace_invul:IsDebuff() return true end
function modifier_blood_chains_palace_invul:IsPurgable() return false end
function modifier_blood_chains_palace_invul:IsPurgeException() return false end
function modifier_blood_chains_palace_invul:RemoveOnDeath() return true end
function modifier_blood_chains_palace_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_blood_chains_palace_invul:OnCreated()
self:PlayEffects()
end
function modifier_blood_chains_palace_invul:OnDestroy()
	
end
function modifier_blood_chains_palace_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/blood_palace_chains.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end

function modifier_blood_chains_palace_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_blood_chains_palace_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end
function modifier_blood_chains_palace_invul:IsAura()
	return true
end

function modifier_blood_chains_palace_invul:GetModifierAura()
	return "modifier_generic_stunned_lua"
end

function modifier_blood_chains_palace_invul:GetAuraRadius()
	return 500
end

function modifier_blood_chains_palace_invul:GetAuraDuration()
	return 0.01
end

function modifier_blood_chains_palace_invul:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_blood_chains_palace_invul:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end


modifier_blood_chains_palace_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_chains_palace_damage:IsHidden()
	return false
end

function modifier_blood_chains_palace_damage:IsDebuff()
	return true
end

function modifier_blood_chains_palace_damage:IsStunDebuff()
	return false
end

function modifier_blood_chains_palace_damage:IsPurgable()
	return true
end

function modifier_blood_chains_palace_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_blood_chains_palace_damage:OnCreated( kv )


	self.damage = 100

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( 0.2 )

	-- play effects
	
end

function modifier_blood_chains_palace_damage:OnRefresh( kv )
	
end

function modifier_blood_chains_palace_damage:OnRemoved()
end

function modifier_blood_chains_palace_damage:OnDestroy()
local caster = self:GetCaster()
if caster:HasModifier("modifier_blood_moon_rise_combo") then
CreateModifierThinker(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_blood_moon_palace_combo", -- modifier name
		{ duration = 1.3 }, -- kv
		self:GetParent():GetOrigin(),
		self:GetParent():GetTeamNumber(),
		false
	)
self.sound_cast = "arcueid.5_5"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
else
caster:AddNewModifier(caster, self, "modifier_blood_chains_palace_shockwave", {duration = 2})	
	radius = 500
	self:PlayEffects(radius)
		self.sound_cast = "arcueid.5_3_3"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	end
end


function modifier_blood_chains_palace_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_blood_chains_palace_damage:Silence()
local caster = self:GetCaster()
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	--Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
end

function modifier_blood_chains_palace_damage:PlayEffects( radius )

	local particle_cast = "particles/blood_palace_shockwave.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end




modifier_blood_chains_palace_shockwave = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_chains_palace_shockwave:IsHidden()
	return false
end

function modifier_blood_chains_palace_shockwave:IsDebuff()
	return true
end

function modifier_blood_chains_palace_shockwave:IsStunDebuff()
	return false
end

function modifier_blood_chains_palace_shockwave:IsPurgable()
	return true
end

function modifier_blood_chains_palace_shockwave:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_blood_chains_palace_shockwave:OnCreated( kv )


	self.damage = 250

	if not IsServer() then return end

	self:Silence()
	self:StartIntervalThink( 0.2 )

	-- play effects
	
end

function modifier_blood_chains_palace_shockwave:OnRefresh( kv )
	
end

function modifier_blood_chains_palace_shockwave:OnRemoved()
end

function modifier_blood_chains_palace_shockwave:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_blood_chains_palace_shockwave:Silence()
local caster = self:GetCaster()
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	--Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end
end






modifier_blood_moon_palace_combo = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_moon_palace_combo:IsHidden()
	return true
end

function modifier_blood_moon_palace_combo:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_blood_moon_palace_combo:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = 1.3
	self.radius = 600
	local damage = 8000

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
		--Optional.
	}
	self:PlayEffects1()
end 
function modifier_blood_moon_palace_combo:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/falling_moon.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 1.3

	-- Get Data
	local height = 1500
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

function modifier_blood_moon_palace_combo:OnRefresh( kv )
	
end

function modifier_blood_moon_palace_combo:OnRemoved()
end

function modifier_blood_moon_palace_combo:OnDestroy()
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
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_blood_moon_palace_combo:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/blood_moon_explosion.vpcf"
	local sound_cast = "arcueid.4_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end




blood_arc = class({})
LinkLuaModifier( "modifier_blood_arc", "heroes/arcueid" ,LUA_MODIFIER_MOTION_NONE )


function blood_arc:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function blood_arc:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end


function blood_arc:GetChannelTime()
	self.creep_duration = self:GetSpecialValueFor( "creep_duration" )
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" )

	if IsServer() then
		if self.hVictim ~= nil then
			if self.hVictim:IsConsideredHero() then
				return self.hero_duration
			else
				return self.creep_duration
			end
		end

		return 0.0
	end

	return self.hero_duration
end

--------------------------------------------------------------------------------

function blood_arc:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function blood_arc:OnSpellStart()
local caster = self:GetCaster()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_blood_arc", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
	local radius = 250
	EmitSoundOn( "arcueid.5_4", caster )
end


--------------------------------------------------------------------------------

function blood_arc:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
	self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = 1.1 } )
		self.hVictim:RemoveModifierByName( "modifier_blood_arc" )
	end
		local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	local radius = 500
	local caster = self:GetCaster()
	local damage1 = 3000
	local damage = damage1*channel_pct
    local point = caster:GetOrigin()
	local duration = 1
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
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
                 	--Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
self:PlayEffects(point, radius, duration  )
end
end

function blood_arc:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/blood_moon_arc_explosion.vpcf"
	local sound_cast = "arcueid.4_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end



modifier_blood_arc = class({})

--------------------------------------------------------------------------------

function modifier_blood_arc:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_blood_arc:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_blood_arc:OnCreated( kv )
	self.dismember_damage = 100
	self.tick_rate = 0.1


	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_blood_arc:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_blood_arc:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage 

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}

		ApplyDamage( damage )
		
		
				
	end
	
end

--------------------------------------------------------------------------------

function modifier_blood_arc:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_blood_arc:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_blood_arc:GetEffectName()
	return "particles/blood_moon_arc.vpcf"
end

function modifier_blood_arc:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_blood_arc:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end








blood_moon_rise = class({})
LinkLuaModifier( "modifier_blood_moon_rise", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_moon_rise_combo", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function blood_moon_rise:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function blood_moon_rise:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	if target == caster then
	caster:AddNewModifier(caster, self, "modifier_blood_moon_rise_combo", {duration = 10})
	else
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_blood_moon_rise", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
	EmitGlobalSound("arcueid.5_5")
	end
	
end

function blood_moon_rise:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/blood_moon_chains.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end

modifier_blood_moon_rise_combo = class({})


function modifier_blood_moon_rise_combo:IsHidden()
    return true
end
function modifier_blood_moon_rise_combo:RemoveOnDeath() return true end
function modifier_blood_moon_rise_combo:IsPurgable()
    return false
end

modifier_blood_moon_rise = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_moon_rise:IsHidden()
	return true
end

function modifier_blood_moon_rise:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_blood_moon_rise:OnCreated( kv )
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
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	self:PlayEffects1()
end 
function modifier_blood_moon_rise:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/falling_moon.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 1.3

	-- Get Data
	local height = 1500
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

function modifier_blood_moon_rise:OnRefresh( kv )
	
end

function modifier_blood_moon_rise:OnRemoved()
end

function modifier_blood_moon_rise:OnDestroy()
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
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_blood_moon_rise:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/blood_moon_explosion.vpcf"
	local sound_cast = "arcueid.4_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

























blood_combo = class({})
LinkLuaModifier( "modifier_blood_combo", "heroes/arcueid.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_combo_debuff", "heroes/arcueid.lua" ,LUA_MODIFIER_MOTION_NONE )

function blood_combo:GetCastRange( location , target)

	return 160
end

function blood_combo:GetChannelTime()


	
				return 1.5
			
		end


--------------------------------------------------------------------------------

function blood_combo:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function blood_combo:OnSpellStart()
local caster = self:GetCaster()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_blood_combo", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
	local blinkDistance = 1
	local blinkDirection = (caster:GetOrigin() - self.hVictim:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = self.hVictim:GetOrigin() + blinkDirection

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
end


--------------------------------------------------------------------------------

function blood_combo:OnChannelFinish( bInterrupted )
local broke = GameRules:GetGameTime() - self:GetChannelStartTime()
local point = self:GetCaster():GetAbsOrigin()
local damage = self:GetSpecialValueFor( "full_damage" )
local caster = self:GetCaster()

	local radius = 300
	
	local debuffDuration = 1.5

local damageTable = {
		victim = self.hVictim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	EmitSoundOn( "arcueid.swoosh", self:GetCaster() )
	self:PlayEffects( point, radius, debuffDuration )
 


	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_blood_combo" )
	end
end
function blood_combo:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/shuichi_hug_blood.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_blood_combo = class({})

--------------------------------------------------------------------------------

function modifier_blood_combo:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_blood_combo:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_blood_combo:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	local caster = self:GetCaster()
if self:GetCaster():HasModifier("modifier_red_arcueid") then
local knockback = { should_stun = 1,
                        knockback_duration = 1,5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = -180,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	EmitSoundOn( "arcueid.5_6", self:GetParent() )
self.tick_rate = 0.15
elseif self:GetCaster():HasModifier("modifier_neko_arc") then
EmitSoundOn( "arcueid.neko_brawl", self:GetParent() )
self.tick_rate = 0.3
else	
	self.tick_rate = 0.5
		EmitSoundOn( "arcueid.6", self:GetParent() )
	end
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
	

end

--------------------------------------------------------------------------------

function modifier_blood_combo:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	StopSoundOn( "arcueid.neko_brawl", self:GetParent() )
	
end

--------------------------------------------------------------------------------

function modifier_blood_combo:OnIntervalThink()
	if IsServer() then
	local radius = 300
	if self:GetCaster():HasModifier("modifier_neko_arc") then
	self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 400,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )
		self:PlayEffects2(radius)
	else
	
	local caster = self:GetCaster()
	self:GetCaster():PerformAttack(self:GetParent(), true,
				true,
				true,
				true,
				true,
				false,
				true)
		
		
				
	
	if self:GetCaster():HasModifier("modifier_red_arcueid") then
	self:PlayEffects1(radius)
	else
	self:PlayEffects(radius)
	end
	
end
end
end

--------------------------------------------------------------------------------

function modifier_blood_combo:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_blood_combo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end


function modifier_blood_combo:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_blood_combo:PlayEffects( radius )

	local particle_cast = "particles/blood_combo_base.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_blood_combo:PlayEffects1( radius )

	local particle_cast = "particles/blood_combo_red_arc.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

function modifier_blood_combo:PlayEffects2( radius )
EmitSoundOn( "arcueid.neko_brawl_puches", self:GetParent() )
	local particle_cast = "particles/rainbow_smoke_brawl.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end










neko_punch = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neko_screen", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function neko_punch:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()



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
 local knockback = { should_stun = 1,
                        knockback_duration = 1.5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = 5000,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	target:AddNewModifier(caster, self, "modifier_neko_screen", {duration = 1.5})
	
	
	self:PlayEffects(target)
	EmitSoundOn("arcueid.neko_1", caster)
	EmitSoundOn("arcueid.neko_1_1", caster)
end
function neko_punch:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/neko_punch.vpcf"
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




modifier_neko_screen = class({})

--------------------------------------------------------------------------------

function modifier_neko_screen:IsHidden()
    return false
end

function modifier_neko_screen:IsPurgable()
    return false
end
function modifier_neko_screen:OnCreated()
self:PlayEffects()
	
end

--------------------------------------------------------------------------------

function modifier_neko_screen:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
function modifier_neko_screen:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/neko_screen.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	EmitSoundOnClient("arcueid.neko_2_2", Player)
	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end



neko_jump = class({})
LinkLuaModifier( "modifier_neko_jump", "modifiers/modifier_neko_jump", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

function neko_jump:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )
	local radius = self:GetSpecialValueFor( "radius" )
	local distance = (caster_pos - point):Length2D()
	local duration = 1
	local height = 3000

	-- arc
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			distance = distance,
			duration = duration,
			height = height,
			fix_duration = false,
			isForward = true,
			isStun = true,
			activity = ACT_DOTA_CAST_ABILITY_7,
		} -- kv
	)
	arc:SetEndCallback(function()
		-- find enemies
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
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		local stack = 0
		for _,enemy in pairs(enemies) do
			-- damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 1.5})

			-- count stack
			if enemy:IsHero() and not enemy:IsIllusion() then
				stack = stack + 1
			end

			-- play effects
			self:PlayEffects4( enemy )
		end

		-- add buff
		

		-- play effects
		self:PlayEffects2()
		
	end)

	-- play effects
	self:PlayEffects1( arc )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function neko_jump:PlayEffects1( modifier )
	-- Get Resources
	
	local caster = self:GetCaster()
	
	
	   
	local particle_cast = "particles/neko_rocket_launch.vpcf"
	local sound_cast = "arcueid.neko_4_launch"
	local sound_cast1 = "arcueid.neko_4"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	-- buff particle
	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_cast1, self:GetCaster() )
end

function neko_jump:PlayEffects2()
	-- Get Resources
	local caster = self:GetCaster()

	local particle_cast = "particles/neko_rocket_explosion.vpcf"
	local sound_cast = "arcueid.neko_exp"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	end

function neko_jump:PlayEffects4( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end






chibi_army = class({})

function chibi_army:IsStealable() return true end
function chibi_army:IsHiddenWhenStolen() return false end
function chibi_army:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function chibi_army:OnSpellStart()
    local caster = self:GetCaster()
    local target_loc = self:GetCursorPosition()

    if caster:GetAbsOrigin() == target_loc then
        target_loc = caster:GetAbsOrigin() + caster:GetForwardVector() * 100 + 400
    end

    local caster_loc = caster:GetAbsOrigin()
    local direction = (target_loc - caster_loc):Normalized()

    local radius = self:GetSpecialValueFor("radius")
    local distance = self:GetSpecialValueFor("distance")
    local spears = self:GetSpecialValueFor("spears") 
    local speed = self:GetSpecialValueFor("speed")
    local duration = self:GetSpecialValueFor("duration") 

    local spawn_line_direction = RotateVector2D(direction,90,true)

    EmitSoundOn("arcued.neko_army", caster)

    for i=0, duration * spears, 1 do
        Timers:CreateTimer(i*(1/spears), function()
            local position_ran = (math.random() - 0.5) * distance
            local spear_projectile = {  Ability = self,
                                        EffectName = "particles/test_chibi_army.vpcf",
                                        vSpawnOrigin = target_loc  - (direction * radius) + (spawn_line_direction * position_ran),
                                        fDistance = distance,
                                        fStartRadius = 50,
                                        fEndRadius = 50,
                                        Source = caster,
                                        bHasFrontalCone = false,
                                        bReplaceExisting = false,
                                        bProvidesVision = false,
                                        iUnitTargetTeam = self:GetAbilityTargetTeam(),
                                        iUnitTargetType = self:GetAbilityTargetType(),
                                        iUnitTargetFlags = self:GetAbilityTargetFlags(),
                                        vVelocity = Vector(direction.x,direction.y,0) * speed, }

            ProjectileManager:CreateLinearProjectile(spear_projectile)
        end)
    end
end
function chibi_army:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        return nil
    end

    EmitSoundOn("arcueid.neko_army_hit", hTarget)

    
    local damage_table = {  attacker = self:GetCaster(),
                            victim = hTarget, 
                            ability = self, 
                            damage = self:GetSpecialValueFor("damage"), 
                            damage_type = self:GetAbilityDamageType() }

    ApplyDamage(damage_table)
end













































archetype_last_arc = class({})
LinkLuaModifier( "modifier_archetype_last_arc_invul", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc_thinker", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc_effect", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc_visual", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc_visual_planet", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc", "modifiers/modifier_archetype_last_arc", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_chains_palace", "modifiers/modifier_blood_chains_palace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc_astral", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blood_chains_palace_damage", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_archetype_last_arc_invul_2", "heroes/arcueid", LUA_MODIFIER_MOTION_NONE )


function archetype_last_arc:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = 9999
	local duration = 10
	local damage = 99999
	local point = self:GetCaster():GetOrigin()


caster:AddNewModifier(caster, self, "modifier_archetype_last_arc_invul", {duration = 8.0})
caster:AddNewModifier(caster, self, "modifier_archetype_last_arc_visual", {duration = 3.0})		

	self.sound_cast = "archetype.last_arc"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
		
end

modifier_archetype_last_arc_visual = class({})
function modifier_archetype_last_arc_visual:IsHidden() return false end
function modifier_archetype_last_arc_visual:IsDebuff() return true end
function modifier_archetype_last_arc_visual:IsPurgable() return false end
function modifier_archetype_last_arc_visual:IsPurgeException() return false end
function modifier_archetype_last_arc_visual:RemoveOnDeath() return true end
function modifier_archetype_last_arc_visual:OnCreated()
if IsServer() then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_5)
       self:PlayEffects()
    end
end
function modifier_archetype_last_arc_visual:OnDestroy()
local caster = self:GetCaster()
local point = caster:GetOrigin()
self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_archetype_last_arc_thinker", -- modifier name
		{ duration = 5 }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
caster:AddNewModifier(caster, self, "modifier_archetype_last_arc_visual_planet", {duration = 5})	
end
function modifier_archetype_last_arc_visual:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/archetype_last_arc_start.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)


end

function modifier_archetype_last_arc_visual:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_archetype_last_arc_visual:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end
modifier_archetype_last_arc_visual_planet = class({})
function modifier_archetype_last_arc_visual_planet:IsHidden() return false end
function modifier_archetype_last_arc_visual_planet:IsDebuff() return true end
function modifier_archetype_last_arc_visual_planet:IsPurgable() return false end
function modifier_archetype_last_arc_visual_planet:IsPurgeException() return false end
function modifier_archetype_last_arc_visual_planet:RemoveOnDeath() return true end
function modifier_archetype_last_arc_visual_planet:OnCreated()
if IsServer() then
      self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/test_planet1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "attach_planet", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "attach_planet", Vector(0,0,0), true)
       self:PlayEffects()
    end
end
function modifier_archetype_last_arc_visual_planet:OnDestroy()
local caster = self:GetCaster()
if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end
end
function modifier_archetype_last_arc_visual_planet:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/archetype_ray.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)


end


modifier_archetype_last_arc_invul = class({})
function modifier_archetype_last_arc_invul:IsHidden() return false end
function modifier_archetype_last_arc_invul:IsDebuff() return true end
function modifier_archetype_last_arc_invul:IsPurgable() return false end
function modifier_archetype_last_arc_invul:IsPurgeException() return false end
function modifier_archetype_last_arc_invul:RemoveOnDeath() return true end
function modifier_archetype_last_arc_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end

function modifier_archetype_last_arc_invul:OnCreated()
if IsServer() then

    end
end
function modifier_archetype_last_arc_invul:OnDestroy()
	self.damage2 = 99999
	self.damage = 99999
	self:PlayEffects()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		99999,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,	 --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		
	end


end
function modifier_archetype_last_arc_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/last_arc_explosion.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end


function modifier_archetype_last_arc_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
					MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
                   
                    
                     }
    return func
end

function modifier_archetype_last_arc_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end

function modifier_archetype_last_arc_invul:GetModifierProvidesFOWVision()
	return 1
end
function modifier_archetype_last_arc_invul:GetModifierModelChange()
	return "models/arcueid/archetype_earth.vmdl"
end






modifier_archetype_last_arc_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_archetype_last_arc_thinker:OnCreated( kv )
	-- references
	self.radius = 999999

	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_archetype_last_arc_thinker:OnRefresh( kv )
	
end

function modifier_archetype_last_arc_thinker:OnRemoved()
end

function modifier_archetype_last_arc_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_archetype_last_arc_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_archetype_last_arc_thinker:IsAura()
	return true
end

function modifier_archetype_last_arc_thinker:GetModifierAura()
	return "modifier_archetype_last_arc_effect"
end

function modifier_archetype_last_arc_thinker:GetAuraRadius()
	return 99999
end

function modifier_archetype_last_arc_thinker:GetAuraDuration()
	return 0.01
end

function modifier_archetype_last_arc_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_archetype_last_arc_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_archetype_last_arc_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_archetype_last_arc_thinker:GetAuraEntityReject( hEntity )
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
-- Graphics & Animations
function modifier_archetype_last_arc_thinker:PlayEffects()
	-- Get Resources
	
local particle_cast = "particles/last_arc_thinker.vpcf"


	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound


	
end




modifier_archetype_last_arc_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_archetype_last_arc_effect:IsHidden()
	return false
end

function modifier_archetype_last_arc_effect:IsDebuff()
	return not self:NotAffected()
end

function modifier_archetype_last_arc_effect:IsStunDebuff()
	return not self:NotAffected()
end

function modifier_archetype_last_arc_effect:IsPurgable()
	return false
end

function modifier_archetype_last_arc_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_archetype_last_arc_effect:NotAffected()
	-- true owner
	if self:GetParent()==self:GetCaster() then return true end

	-- true if owner controlled
	if self:GetParent():GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_archetype_last_arc_effect:OnCreated( kv )
	self.speed = 400

	if IsServer() then
		if not self:NotAffected() then
			self:GetParent():InterruptMotionControllers( false )
		else
		
		end
	end
end

function modifier_archetype_last_arc_effect:OnRefresh( kv )
	
end

function modifier_archetype_last_arc_effect:OnRemoved()
end

function modifier_archetype_last_arc_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_archetype_last_arc_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}

	return funcs
end

function modifier_archetype_last_arc_effect:GetModifierMoveSpeed_AbsoluteMin()
	if self:NotAffected() then return self.speed end
end
function modifier_archetype_last_arc_effect:GetModifierProcAttack_BonusDamage_Pure()
    return self:GetAbility():GetSpecialValueFor('pure')
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_archetype_last_arc_effect:CheckState()
	local state1 = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	local state2 = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	if self:NotAffected() then return state1 else return state2 end
end







archetype_light_collumn = class({})


--------------------------------------------------------------------------------
-- Ability Start
function archetype_light_collumn:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    self:PlayEffects(target)
	-- check dragon modifier
	local modifier = caster:FindModifierByNameAndCaster( "modifier_dragon_knight_elder_dragon_form_lua", caster )

	-- check if simple form
	if not modifier then
		-- cancel if linken
		if target:TriggerSpellAbsorb( self ) then return end

		-- directly hit
		self:Hit( target, false )

		-- play effects
		local sound_cast = ""
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
function archetype_light_collumn:Hit( target, dragonform )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("stun_duration")
   local duration2 = self:GetSpecialValueFor("duration")
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end
 local damage =  self:GetSpecialValueFor("damage")
	-- load data
	
local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	ApplyDamage(damageTable)
	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 0.1 } -- kv
	)

	-- Play effects

	local sound_cast = "archetype.6"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function archetype_light_collumn:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end


function archetype_light_collumn:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/light_collumn.vpcf"

	-- Get Data
	local vec = target:GetOrigin()-self:GetCaster():GetOrigin()
	local attach = "attach_attack1"


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

