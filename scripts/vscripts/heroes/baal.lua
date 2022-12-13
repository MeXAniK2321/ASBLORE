narukami_lightning = class({})
LinkLuaModifier( "modifier_generic_arc_lua", "modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_ring_lua", "modifiers/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boooooba", "heroes/baal.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function narukami_lightning:Precache( context )
	PrecacheResource( "particle", "particles/narukami_lightning.vpcf", context )
	PrecacheResource( "particle", "particles/narukami_lightning_hit.vpcf", context )
end

function narukami_lightning:Spawn()
	if not IsServer() then return end
end
function narukami_lightning:GetIntrinsicModifierName()
    return "modifier_boooooba"
end
function narukami_lightning:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("inazuma_weather")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function narukami_lightning:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_baal_20")
	local damage_type = self:GetAbilityDamageType()
	local radius = self:GetSpecialValueFor( "radius" )
	local speed = self:GetSpecialValueFor( "speed" )
	local duration = self:GetSpecialValueFor( "duration" )
	local point = self:GetCursorPosition()
	local width = 250
	local height = 500
	local knock_duration = 0.5

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = damage_type,
		ability = self, --Optional.
	}
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
		ApplyDamage( damageTable )
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration  } -- kv
		)
		
	end

	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua", -- modifier name
		{
			start_radius = width,
			end_radius = radius,
			speed = speed,
			width = width,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	ring = thinker:FindModifierByName( "modifier_generic_ring_lua" )

	ring:SetCallback( function( enemy )
		-- knock upwards
		
	
			damageTable.victim = enemy
			ApplyDamage( damageTable )

			-- play effects
			local sound_target = "baal.1_1"
			EmitSoundOn( sound_target, enemy )
		end)

		-- stun
		

		-- play effects
		self:PlayEffects2( enemy )
	

	-- play effects
	self:PlayEffects1( point, radius, speed )
	self:PlayEffects( point, radius, duration)
end
--------------------------------------------------------------------------------
-- Effects
function narukami_lightning:PlayEffects1( center, radius, speed )
	-- Get Resources
	local particle_cast = "particles/narukami_lightning.vpcf"
	local sound_cast = "baal.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, center )
	for i=1,3 do
		-- local pos = actual_radius/5*i
		local pos = radius/3*i
		ParticleManager:SetParticleControl( effect_cast, i, Vector( pos, 1, 1 ) )
	end
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( center, sound_cast, self:GetCaster() )
end
function narukami_lightning:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/baal_lightning_main.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
function narukami_lightning:PlayEffects2( enemy )
	-- Get Resources
	local particle_cast = "particles/narukami_lightning1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_boooooba = class ({})
function modifier_boooooba:IsHidden() return true end
function modifier_boooooba:IsDebuff() return false end
function modifier_boooooba:IsPurgable() return false end
function modifier_boooooba:IsPurgeException() return false end
function modifier_boooooba:RemoveOnDeath() return false end

function modifier_boooooba:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_boooooba:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_boooooba:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("inazuma_weather")
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



englightened_one = class({})
LinkLuaModifier( "modifier_englightened_one", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function englightened_one:GetIntrinsicModifierName()
	return "modifier_englightened_one"
end










modifier_englightened_one = class({})

--------------------------------------------------------------------------------

function modifier_englightened_one:IsHidden()
	return false
end

function modifier_englightened_one:IsDebuff()
	return false
end

function modifier_englightened_one:IsPurgable()
	return false
end

function modifier_englightened_one:RemoveOnDeath()
	return false
end
function modifier_englightened_one:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_englightened_one:OnCreated( kv )
	-- get references
	

	if IsServer() then
		self:SetStackCount(0)
	end
	self:StartIntervalThink(4)
end


--------------------------------------------------------------------------------

function modifier_englightened_one:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_LANDED,

	}

	return funcs
end
function modifier_englightened_one:OnAttackLanded(params)
if IsServer() then
local caster = self:GetParent()
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
	if IsServer() then
	local damage = self:GetStackCount()
			local damageTable = {
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		local chance_value = self:GetAbility():GetSpecialValueFor('purge_chance_per_stack')
		local chance = damage * chance_value
		if RandomFloat (0,100) < chance then
		if not params.target:IsMagicImmune() then
		if self:GetAbility():IsFullyCastable() then
		self.ability = self:GetAbility()
		local cooldown = (self.ability:GetCooldown(-1) * caster:GetCooldownReduction())
		params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_silenced_lua", {duration = 1 })
		self.ability:StartCooldown(cooldown)
			end
			end
		end
		end
		end
		end
		end
		end
function modifier_englightened_one:OnAbilityFullyCast( params )
	if IsServer() then
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
		self.parent = self:GetParent()
		if params.ability:IsItem() then return end
	
		
		if pass then
		local stack_per_ability = self:GetAbility():GetSpecialValueFor('stack_per_ability')
	self:AddStack(stack_per_ability)
	end
	end
	
end
function modifier_englightened_one:OnStackCountChanged(iStackCount)
	if IsServer() then
	self:ForceRefresh()
	local stacks = self:GetStackCount()
	if self.Charge_FX then
			ParticleManager:DestroyParticle(self.Charge_FX, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX)
			
		end			
if self.Charge_FX2 then 
	ParticleManager:DestroyParticle(self.Charge_FX2, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX2)
			
			end
	if self.Charge_FX3 then 
			ParticleManager:DestroyParticle(self.Charge_FX3, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX3)
			end			
        
    if stacks > 49 and stacks < 100 then
	self.Charge_FX =    ParticleManager:CreateParticle("particles/baal_circle_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	         
	
			               
		elseif stacks > 100 and stacks < 150 then
		self.Charge_FX2 =    ParticleManager:CreateParticle("particles/electro_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		
	
	  		

	  		

		elseif stacks > 150 then
	  		self.Charge_FX3 =    ParticleManager:CreateParticle("particles/electro_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			end

end
		


end

function modifier_englightened_one:OnIntervalThink()
    if IsServer() then
        if self:GetCaster():HasTalent("special_bonus_baal_25") then
		self:AddStack(4)	
		else
self:AddStack(1)		
		end
		end
end


function modifier_englightened_one:AddStack( value )
	local current = self:GetStackCount()
	self.soul_max = 200
	local after = current + value
	if not self:GetParent():HasScepter() then
		if after > self.soul_max then
			after = self.soul_max
		end
	else
		if after > self.soul_max then
			after = self.soul_max
		end
	end
	self:SetStackCount( after )
end




modifier_shock = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shock:IsHidden()
	return false
end

function modifier_shock:IsDebuff()
	return true
end

function modifier_shock:IsStunDebuff()
	return false
end

function modifier_shock:IsPurgable()
	return true
end

function modifier_shock:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_shock:OnRefresh( kv )
	
end

function modifier_shock:OnRemoved()
end

function modifier_shock:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_shock:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_shock:GetEffectName()
	return "particles/baal_shock.vpcf"
end

function modifier_shock:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end








transcendence_baleful_light = class({})
LinkLuaModifier( "modifier_transcendence_baleful_light", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shock", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_transcendence_baleful_light_cd", "heroes/baal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function transcendence_baleful_light:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	local percent = self:GetSpecialValueFor( "damage2" )
	local damage  = percent
	local damage_type = self:GetAbilityDamageType()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor( "duration" )
	local shock = self:GetSpecialValueFor( "shock" )
	local point = self:GetCursorPosition()

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
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
	damageTable.victim = enemy
		ApplyDamage( damageTable )
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_shock", -- modifier name
			{ duration = shock  } -- kv
		)
		
	end
 caster:AddNewModifier(caster, self, "modifier_transcendence_baleful_light", {duration = duration})

	

	-- play effects
local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y
	self:PlayEffects((point-origin):Normalized())
end

function transcendence_baleful_light:PlayEffects( direction )
	-- Get Resources
	local particle_cast = "particles/test241.vpcf"
	local sound_cast = "baal.3"
	
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end


modifier_transcendence_baleful_light = class({})

function modifier_transcendence_baleful_light:IsHidden()
	return false
end
function modifier_transcendence_baleful_light:RemoveOnDeath() return false end
function modifier_transcendence_baleful_light:AllowIllusionDuplicate()
	return false
end

function modifier_transcendence_baleful_light:IsPurgable()
    return false
end
function modifier_transcendence_baleful_light:OnCreated(table)
local percent = self:GetAbility():GetSpecialValueFor( "damage" )
local mana  = self:GetParent():GetMaxMana() * percent
self.damage = mana
end

function modifier_transcendence_baleful_light:DeclareFunctions()
    local funcs = {
MODIFIER_EVENT_ON_TAKEDAMAGE,	  
		
    }

    return funcs
end

function modifier_transcendence_baleful_light:OnTakeDamage(params)
	if IsServer() then
	local caster = self:GetParent()

		if params.attacker == caster then
		if not params.attacker:IsIllusion() then
		if caster:IsAlive() then
		 if not caster:HasModifier("modifier_inazuma_weather") then
		if params.unit == caster then return end
		if not self:GetParent():HasModifier("modifier_transcendence_baleful_light_cd") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_transcendence_baleful_light_cd", {duration = 0.7 })
		local damageTable = {
		victim = params.unit,
		attacker = self:GetParent(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	ApplyDamage(damageTable)
	local point = params.unit:GetOrigin()
	local radius = 300
	local debuffDuration = 2
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("baal.3_hit", caster)
			end
		end
	end
end
end
end
end

function modifier_transcendence_baleful_light:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/baal_cut_11.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_transcendence_baleful_light:GetEffectName()
	return "particles/baal_eye.vpcf"
end
modifier_transcendence_baleful_light_cd = class({})

function modifier_transcendence_baleful_light_cd:IsHidden()
	return true
end
function modifier_transcendence_baleful_light_cd:RemoveOnDeath() return true end
function modifier_transcendence_baleful_light_cd:AllowIllusionDuplicate()
	return false
end























LinkLuaModifier("modifier_bobba_sword", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bobba_sword_damage", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bobba_sword_invul", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bobba_sword_stunned", "heroes/baal", LUA_MODIFIER_MOTION_NONE)



bobba_sword = class({})

function bobba_sword:IsStealable() return true end
function bobba_sword:IsHiddenWhenStolen() return false end

function bobba_sword:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("lightning_cut")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function bobba_sword:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	
	local modifier = caster:FindModifierByNameAndCaster("modifier_englightened_one",caster)
	local current = modifier:GetStackCount()
	local duration = current * 0.1
	local duration1 = duration + fixed_duration

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
		-- damage
		

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_bobba_sword_damage", -- modifier name
			{ duration = 2.6 } -- kv
		)
	end

	

    caster:AddNewModifier(caster, self, "modifier_bobba_sword", {duration = duration1})
	caster:AddNewModifier(caster, self, "modifier_bobba_sword_invul", {duration = 2.0})
    self:EndCooldown()
end

modifier_bobba_sword_invul = class({})
function modifier_bobba_sword_invul:IsHidden() return false end
function modifier_bobba_sword_invul:IsDebuff() return true end
function modifier_bobba_sword_invul:IsPurgable() return false end
function modifier_bobba_sword_invul:IsPurgeException() return false end
function modifier_bobba_sword_invul:RemoveOnDeath() return true end
function modifier_bobba_sword_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_bobba_sword_invul:OnCreated()
if IsServer() then
        --self:SetStackCount(0)
self.screw_fx = ParticleManager:CreateParticle("particles/bobba_sword_effects.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
CustomGameEventManager:Send_ServerToPlayer(Player, "baal_sword", {} )
self:StartIntervalThink(1.45)
       
    end
end
function modifier_bobba_sword_invul:OnIntervalThink()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )

end
function modifier_bobba_sword_invul:OnDestroy()
local caster = self:GetCaster()
if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
		local modifier = caster:FindModifierByNameAndCaster("modifier_englightened_one",caster)
		modifier:SetStackCount(0)
	end
end

function modifier_bobba_sword_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_bobba_sword_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end
modifier_bobba_sword_stunned = class({})
function modifier_bobba_sword_stunned:IsHidden() return false end
function modifier_bobba_sword_stunned:IsDebuff() return true end
function modifier_bobba_sword_stunned:IsPurgable() return false end
function modifier_bobba_sword_stunned:IsPurgeException() return false end
function modifier_bobba_sword_stunned:RemoveOnDeath() return true end
function modifier_bobba_sword_stunned:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end


---------------------------------------------------------------------------------------------------------------------
modifier_bobba_sword = class({})
function modifier_bobba_sword:IsHidden() return false end
function modifier_bobba_sword:IsDebuff() return true end
function modifier_bobba_sword:IsPurgable() return false end
function modifier_bobba_sword:IsPurgeException() return false end
function modifier_bobba_sword:RemoveOnDeath() return true end
function modifier_bobba_sword:AllowIllusionDuplicate() return true end
function modifier_bobba_sword:DeclareFunctions()
    local func = {  
    				
	              
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_EVENT_ON_ATTACK_LANDED,

		}
    return func
end
function modifier_bobba_sword:GetAttackSound()
	return "baal.narukami_hits"
end
function modifier_bobba_sword:OnAttackLanded(params)
if IsServer() then
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
	if IsServer() then
			local damageTable = {
		attacker = self:GetParent(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
			end
		end
		end
		end
		end
function modifier_bobba_sword:GetModifierModelChange()
    return "models/baal/baal_narukami.vmdl"
end
function modifier_bobba_sword:GetModifierModelScale()
	return 1
end


function modifier_bobba_sword:OnCreated(table)
    self.caster = self:GetCaster()
	local caster = self.caster
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()
	local modifier = caster:FindModifierByNameAndCaster("modifier_englightened_one",caster)
	local current = modifier:GetStackCount()
	local damage2 = current * 2
	self.damage = 70 + damage2

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	 

    self.skills_table = {
                            ["bobba_sword"] = "lightning_cut",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/bobba_sword.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		 
        EmitSoundOn("baal.4", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
	end


function modifier_bobba_sword:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_bobba_sword:OnDestroy()
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
             
            end
				if IsServer() then
       
    end
end
end
end
function modifier_bobba_sword:PlayEffects()
	-- Get Resources
	local particle_cast = ""


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound

end










modifier_bobba_sword_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bobba_sword_damage:IsHidden()
	return false
end

function modifier_bobba_sword_damage:IsDebuff()
	return true
end

function modifier_bobba_sword_damage:IsStunDebuff()
	return false
end

function modifier_bobba_sword_damage:IsPurgable()
	return true
end

function modifier_bobba_sword_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bobba_sword_damage:OnCreated( kv )
local caster = self:GetCaster()
	local modifier = caster:FindModifierByNameAndCaster("modifier_englightened_one",caster)
	local current = modifier:GetStackCount()
	self.duration = 1.95
	self.damage2 = current * 10
	self.damage = 250 + self.damage2

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( self.duration )

	-- play effects
	
end

function modifier_bobba_sword_damage:OnRefresh( kv )
	
end

function modifier_bobba_sword_damage:OnRemoved()
end

function modifier_bobba_sword_damage:OnDestroy()
end


function modifier_bobba_sword_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_bobba_sword_damage:Silence()


	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		
	}
	ApplyDamage( damageTable )

	self:PlayEffects()

	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

function modifier_bobba_sword_damage:CheckState()
	local state = {

		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end

function modifier_bobba_sword_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bobba_sword_damage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/baal_cut_11.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end





lightning_cut = class({})
LinkLuaModifier( "modifier_lightning_cut", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shock", "heroes/baal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function lightning_cut:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function lightning_cut:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetCaster():GetMaxMana() * 0.3

	local radius = self:GetSpecialValueFor("radius") 
	
	local debuffDuration = self:GetSpecialValueFor("duration")
	
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	
	

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

	
	caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_lightning_cut", -- modifier name
			{ duration = 0.4 } -- kv
		)
	for _,enemy in pairs(enemies) do
		-- Apply damage
		

		-- Add modifier
			damageTable.victim = enemy
		ApplyDamage(damageTable)
		
		
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_shock", -- modifier name
			{ duration = 1.0 } -- kv
		)
		
		
	end

	


	self:PlayEffects( point, radius, debuffDuration )
	
	
	end



--------------------------------------------------------------------------------
-- Ability Considerations
function lightning_cut:AbilityConsiderations()
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
function lightning_cut:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/test_baal_cuts.vpcf"
	local sound_cast = "baal.4_1"
    local sound_cast2 = "baal.4_1_1"
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( point, sound_cast2, self:GetCaster() )
end



modifier_lightning_cut = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lightning_cut:IsHidden()
	return false
end

function modifier_lightning_cut:IsDebuff()
	return false
end

function modifier_lightning_cut:IsStunDebuff()
	return true
end

function modifier_lightning_cut:IsPurgable()
	return true
end

function modifier_lightning_cut:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lightning_cut:OnCreated( kv )
	
	self:PlayEffects()
	self:GetParent():AddNoDraw()
end




function modifier_lightning_cut:OnRemoved()
end

function modifier_lightning_cut:OnDestroy()
	if not IsServer() then return end


	


	self:GetParent():RemoveNoDraw()

	
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_lightning_cut:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_lightning_cut:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end












































LinkLuaModifier("modifier_enlightenment_of_eternity_thinker", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enlightenment_of_eternity_thinker_out", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enlightenment_of_eternity_thinker_in", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enlightenment_of_eternity_thinker_in_eternal", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enlightenment_of_eternity", "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3.lua", LUA_MODIFIER_MOTION_NONE)
enlightenment_of_eternity = class({})


function enlightenment_of_eternity:IsStealable() return true end
function enlightenment_of_eternity:IsHiddenWhenStolen() return false end
function enlightenment_of_eternity:IsRefreshable() return true end
function enlightenment_of_eternity:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function enlightenment_of_eternity:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function enlightenment_of_eternity:OnSpellStart()
    local caster = self:GetCaster()
    local point = caster:GetOrigin()
    local radius = self:GetAOERadius()

    local duration = self:GetSpecialValueFor("duration") 
  caster:RemoveModifierByName("modifier_bobba_sword")
    caster:AddNewModifier(caster, self, "modifier_enlightenment_of_eternity", {duration = 30})
	
caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 30})

    CreateModifierThinker(caster, self, "modifier_enlightenment_of_eternity_thinker", {duration = duration}, point, caster:GetTeamNumber(), false)
	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, 1250, 4, false )
end
---------------------------------------------------------------------------------------------------------------------
modifier_enlightenment_of_eternity_thinker = class({})
function modifier_enlightenment_of_eternity_thinker:IsHidden() return true end
function modifier_enlightenment_of_eternity_thinker:IsDebuff() return false end
function modifier_enlightenment_of_eternity_thinker:IsPurgable() return false end
function modifier_enlightenment_of_eternity_thinker:IsPurgeException() return false end
function modifier_enlightenment_of_eternity_thinker:RemoveOnDeath() return true end
function modifier_enlightenment_of_eternity_thinker:OnCreated()
    if IsServer() then
        self.radius = self:GetAbility():GetAOERadius()

        EmitSoundOn("baal.5", self:GetParent())

        self.center = self:GetParent():GetAbsOrigin()

       

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_enlightenment_of_eternity_thinker:OnIntervalThink()
local caster = self:GetCaster()
    if IsServer() then
        if not self:GetCaster() or not self:GetCaster():IsAlive() then
self:Destroy()
end
        local units_resolve = FindUnitsInRadius(self:GetParent():GetTeam(),
                                                self:GetParent():GetAbsOrigin(), 
                                                nil, 
                                                99999, 
                                                self:GetAbility():GetAbilityTargetTeam(), 
                                                self:GetAbility():GetAbilityTargetType(), 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                                0, 
                                                false) 

        for _,unit in pairs(units_resolve) do
            if unit and not unit:IsNull() and IsValidEntity(unit) then
                local distance = (self:GetParent():GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
                local special_duration = self:GetDuration() - self:GetElapsedTime()
                if distance > self.radius then
                    if not unit:FindModifierByNameAndCaster("modifier_enlightenment_of_eternity_thinker_out", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_enlightenment_of_eternity_thinker_in", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enlightenment_of_eternity_thinker_out", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})
                    end
                else
				   if caster:HasScepter() then
				    if not unit:FindModifierByNameAndCaster("modifier_enlightenment_of_eternity_thinker_in_eternal", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_enlightenment_of_eternity_thinker_out", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enlightenment_of_eternity_thinker_in_eternal", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})
						end
				   else
                    if not unit:FindModifierByNameAndCaster("modifier_enlightenment_of_eternity_thinker_in", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_enlightenment_of_eternity_thinker_out", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enlightenment_of_eternity_thinker_in", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})

                       
					   end
                    end
                end
            end
        end
    end
	 if caster:HasScepter() then
	 if not self:GetCaster():HasModifier("modifier_enlightenment_of_eternity_thinker_in_eternal")   then
            self:Destroy()
        end
	 else
	if not self:GetCaster():HasModifier("modifier_enlightenment_of_eternity_thinker_in")   then
            self:Destroy()
        end
		end
end
function modifier_enlightenment_of_eternity_thinker:OnDestroy()
    if IsServer() then
       

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
        
        UTIL_Remove(self:GetParent())
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_enlightenment_of_eternity_thinker_in = class({})
function modifier_enlightenment_of_eternity_thinker_in:IsHidden() return true end
function modifier_enlightenment_of_eternity_thinker_in:IsDebuff() return true end
function modifier_enlightenment_of_eternity_thinker_in:IsPurgable() return false end
function modifier_enlightenment_of_eternity_thinker_in:IsPurgeException() return false end
function modifier_enlightenment_of_eternity_thinker_in:RemoveOnDeath() return true end
function modifier_enlightenment_of_eternity_thinker_in:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_enlightenment_of_eternity_thinker_in:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                }
    return func
end
function modifier_enlightenment_of_eternity_thinker_in:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.attacker:HasModifier( "modifier_enlightenment_of_eternity_thinker_out" )  then
           
            return -100
			else
			
        end

       
    end
end

function modifier_enlightenment_of_eternity_thinker_in:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.damage_increase = self:GetAbility():GetSpecialValueFor("damage_increase")

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 100
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID())
             

	-- Create Particle
	
	self.arena_barrier11 = "particles/test_arena.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, self.caster:GetOrigin() )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )

	-- buff particle
	self:AddParticle(
		self.arena_barrier,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
          end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_enlightenment_of_eternity_thinker_in:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance > self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_enlightenment_of_eternity_thinker_in:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
    end
end
modifier_enlightenment_of_eternity_thinker_in_eternal = class({})
function modifier_enlightenment_of_eternity_thinker_in_eternal:IsHidden() return true end
function modifier_enlightenment_of_eternity_thinker_in_eternal:IsDebuff() return true end
function modifier_enlightenment_of_eternity_thinker_in_eternal:IsPurgable() return false end
function modifier_enlightenment_of_eternity_thinker_in_eternal:IsPurgeException() return false end
function modifier_enlightenment_of_eternity_thinker_in_eternal:RemoveOnDeath() return true end
function modifier_enlightenment_of_eternity_thinker_in_eternal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_enlightenment_of_eternity_thinker_in_eternal:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                }
    return func
end
function modifier_enlightenment_of_eternity_thinker_in_eternal:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.attacker:HasModifier( "modifier_enlightenment_of_eternity_thinker_out" )  then
           
            return -100
			else
			
        end

       
    end
end

function modifier_enlightenment_of_eternity_thinker_in_eternal:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.damage_increase = self:GetAbility():GetSpecialValueFor("damage_increase")

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 100
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID())
             

	-- Create Particle
	
	self.arena_barrier11 = "particles/baal_arena_of_eternity.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, self.caster:GetOrigin() )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )

	-- buff particle
	self:AddParticle(
		self.arena_barrier,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
          end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_enlightenment_of_eternity_thinker_in_eternal:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance > self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_enlightenment_of_eternity_thinker_in_eternal:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_enlightenment_of_eternity_thinker_out = class({})
function modifier_enlightenment_of_eternity_thinker_out:IsHidden() return true end
function modifier_enlightenment_of_eternity_thinker_out:IsDebuff() return true end
function modifier_enlightenment_of_eternity_thinker_out:IsPurgable() return false end
function modifier_enlightenment_of_eternity_thinker_out:IsPurgeException() return false end
function modifier_enlightenment_of_eternity_thinker_out:RemoveOnDeath() return true end
function modifier_enlightenment_of_eternity_thinker_out:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_enlightenment_of_eternity_thinker_out:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 150
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID())

        end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_enlightenment_of_eternity_thinker_out:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() or self.parent:IsInvulnerable() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance < self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_enlightenment_of_eternity_thinker_out:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_place_black then
            ParticleManager:DestroyParticle(self.arena_place_black, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_place_black)
        end
    end
end




















modifier_enlightenment_of_eternity = class({})
function modifier_enlightenment_of_eternity:IsHidden() return false end
function modifier_enlightenment_of_eternity:IsDebuff() return true end
function modifier_enlightenment_of_eternity:IsPurgable() return false end
function modifier_enlightenment_of_eternity:IsPurgeException() return false end
function modifier_enlightenment_of_eternity:RemoveOnDeath() return true end
function modifier_enlightenment_of_eternity:AllowIllusionDuplicate() return true end

function modifier_enlightenment_of_eternity:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,					}
    return func
end
function modifier_enlightenment_of_eternity:GetAttackSound()
	return "baal.narukami_hits"
end
function modifier_enlightenment_of_eternity:GetModifierModelChange()
    return "models/baal/baal_narukami.vmdl"
end
function modifier_enlightenment_of_eternity:GetModifierModelScale()
	return 1
end

function modifier_enlightenment_of_eternity:GetModifierBaseAttack_BonusDamage()
    return self.mana
end
function modifier_enlightenment_of_eternity:GetModifierBonusStats_Strength()
    return 50
end

function modifier_enlightenment_of_eternity:GetModifierAttackSpeedBonus_Constant()
    return 100
end


function modifier_enlightenment_of_eternity:GetModifierBonusStats_Intellect()
    return 100
end

function modifier_enlightenment_of_eternity:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.mana = self.parent:GetMaxMana() * 0.04

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["enlightenment_of_eternity"] = "divine_punishment",
							["bobba_sword"] = "lightning_cut",
							["englightened_one"] = "vision_hunt_decree",
                            
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
		if self:GetCaster():HasScepter() then
		 self.particle_time =    ParticleManager:CreateParticle("particles/eternity_aura_true.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		else
            self.particle_time =    ParticleManager:CreateParticle("particles/eternity_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    end
        end

      
		
		
		end
        

        self.parent:Purge(false, true, false, true, true)
		local delay = 0.2

	Timers:CreateTimer(delay,function()
		self:PlayEffects1()
		self:PlayEffects2()
		end)
    end
end

function modifier_enlightenment_of_eternity:PlayEffects2( )
	-- Get Resources
	 if not self.particle_time2 then
            self.particle_time2 =    ParticleManager:CreateParticle("particles/test_light_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_sword1", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time2, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_enlightenment_of_eternity:PlayEffects1( )
	-- Get Resources
	 if not self.particle_time3 then
            self.particle_time3 =    ParticleManager:CreateParticle("particles/test_light_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time3, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_sword2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time3, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_enlightenment_of_eternity:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_enlightenment_of_eternity:OnDestroy()
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
ParticleManager:DestroyParticle(self.particle_time2, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time2)
		ParticleManager:DestroyParticle(self.particle_time3, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time3)
            
 self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
   
        end
    end
end


divine_punishment = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_divine_punishment", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_divine_punishment_invul", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_divine_punishment_astral", "heroes/baal", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function divine_punishment:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()
	local origin = caster:GetAbsOrigin()

    caster:AddNewModifier(caster, self, "modifier_divine_punishment_invul", {duration = 3.0})	
    target:AddNewModifier(caster, self, "modifier_divine_punishment", {duration = 3.8})
	
	
	
	
	self:PlayEffects( origin, radius, debuffDuration )
	EmitSoundOn("baal.5_1", caster)
end
function divine_punishment:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/divine_punishment_1.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end


modifier_divine_punishment_invul = class({})
function modifier_divine_punishment_invul:IsHidden() return false end
function modifier_divine_punishment_invul:IsDebuff() return true end
function modifier_divine_punishment_invul:IsPurgable() return false end
function modifier_divine_punishment_invul:IsPurgeException() return false end
function modifier_divine_punishment_invul:RemoveOnDeath() return true end
function modifier_divine_punishment_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_divine_punishment_invul:OnCreated()
end
function modifier_divine_punishment_invul:OnDestroy()
local caster = self:GetCaster()
self.yamato_fx = 	ParticleManager:CreateParticle("particles/enlight_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
								
	self:PlayEffects()
self:GetParent():AddNewModifier(caster, self, "modifier_divine_punishment_astral", {duration = 0.8})		
end
function modifier_divine_punishment_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"
	

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

function modifier_divine_punishment_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_divine_punishment_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_6
end
modifier_divine_punishment_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_divine_punishment_astral:IsHidden()
	return false
end

function modifier_divine_punishment_astral:IsDebuff()
	return false
end

function modifier_divine_punishment_astral:IsStunDebuff()
	return true
end

function modifier_divine_punishment_astral:IsPurgable()
	return true
end

function modifier_divine_punishment_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_divine_punishment_astral:OnCreated( kv )
	
	self:PlayEffects()
	self:GetParent():AddNoDraw()
end




function modifier_divine_punishment_astral:OnRemoved()
end

function modifier_divine_punishment_astral:OnDestroy()
	if not IsServer() then return end


	


	self:GetParent():RemoveNoDraw()

	
	
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_divine_punishment_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_divine_punishment_astral:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end

modifier_divine_punishment = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_divine_punishment:IsHidden()
	return false
end

function modifier_divine_punishment:IsDebuff()
	return true
end

function modifier_divine_punishment:IsStunDebuff()
	return false
end

function modifier_divine_punishment:IsPurgable()
	return false
end



--------------------------------------------------------------------------------
-- Initializations
function modifier_divine_punishment:OnCreated( kv )
	-- references
	self.duration = 3.7

	self.damage = 9000

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( self.duration )

	-- play effects
	
end

function modifier_divine_punishment:OnRefresh( kv )
	
end

function modifier_divine_punishment:OnRemoved()
end

function modifier_divine_punishment:OnDestroy()
end


function modifier_divine_punishment:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_divine_punishment:Silence()
local caster = self:GetCaster()
local target = self:GetParent()
local blinkDistance = 400
	local blinkDirection = (target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
			--Optional.
	}
	ApplyDamage( damageTable )

	self:PlayEffects()

	StopSoundOn( sound_cast, self:GetParent() )
EmitSoundOn("baal.1", self:GetParent())
	-- destroy
	self:Destroy()
end



function modifier_divine_punishment:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_divine_punishment:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/divine_punishment_crit.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end


vision_hunt_decree = class({})
LinkLuaModifier( "modifier_vision_hunt_decree", "heroes/baal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function vision_hunt_decree:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
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
		if enemy:HasModifier("modifier_enlightenment_of_eternity_thinker_in") or enemy:HasModifier("modifier_enlightenment_of_eternity_thinker_in_eternal") then
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_vision_hunt_decree", -- modifier name
			{ duration = duration } -- kv
		)
		end
	end

	self:PlayEffects( radius )
end

function vision_hunt_decree:PlayEffects( radius )
	local particle_cast = "particles/vision_hunt_decree.vpcf"
	local sound_cast = "baal.5_2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end



modifier_vision_hunt_decree = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vision_hunt_decree:IsDebuff()
	return true
end

function modifier_vision_hunt_decree:IsStunDebuff()
	return false
end

function modifier_vision_hunt_decree:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Modifier State
function modifier_vision_hunt_decree:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics and animations
function modifier_vision_hunt_decree:GetEffectName()
	return "particles/vision_hunt_decree_debuff.vpcf"
end

function modifier_vision_hunt_decree:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end






LinkLuaModifier("modifier_inazuma_weather",   "heroes/baal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_inazuma_weather_thunder",   "heroes/baal", LUA_MODIFIER_MOTION_NONE)

inazuma_weather = class({})



function inazuma_weather:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function inazuma_weather:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("baal.6")
    caster:AddNewModifier(caster, self, "modifier_inazuma_weather", { duration = 12 } )
end






modifier_inazuma_weather = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_inazuma_weather:IsHidden()
	return false
end

function modifier_inazuma_weather:IsDebuff()
	return false
end

function modifier_inazuma_weather:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_inazuma_weather:OnCreated( kv )

	self:StartIntervalThink( 3 )

	-- Play effects

end

function modifier_inazuma_weather:OnRefresh( kv )
	
end

function modifier_inazuma_weather:OnRemoved()
end

function modifier_inazuma_weather:OnDestroy()

end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_inazuma_weather:OnIntervalThink()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_inazuma_weather_thunder", -- modifier name
		{ duration = 1 }, -- kv
		enemy:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local point = enemy:GetOrigin()
	local radius = 350
	local duration = 1
	self:PlayEffects( point, radius, duration )
	end
end


function modifier_inazuma_weather:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/baal_lightning_sign.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_inazuma_weather:GetEffectName()
	return "particles/baal_weather.vpcf"
end

function modifier_inazuma_weather:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_inazuma_weather_thunder = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_inazuma_weather_thunder:IsHidden()
	return true
end

function modifier_inazuma_weather_thunder:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_inazuma_weather_thunder:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()

	-- references
	self.duration = 0.2
	self.radius = 350
	local damage = caster:GetMaxMana() * 0.15

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_inazuma_weather_thunder:OnRefresh( kv )
	
end

function modifier_inazuma_weather_thunder:OnRemoved()
end

function modifier_inazuma_weather_thunder:OnDestroy()
	if not IsServer() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
			"modifier_shock", -- modifier name
			{ duration = 0.2 } -- kv
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
function modifier_inazuma_weather_thunder:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/baal_lightning_main.vpcf"
	local sound_cast = "baal.1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

