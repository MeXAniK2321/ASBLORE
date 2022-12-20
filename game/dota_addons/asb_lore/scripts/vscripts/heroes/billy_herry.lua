bondage = class({})
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bondage", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_billy_billy", "heroes/billy_herry.lua", LUA_MODIFIER_MOTION_NONE )

function bondage:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gay_website")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function bondage:GetIntrinsicModifierName()
    return "modifier_billy_billy"
end
function bondage:OnSpellStart() 
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end

	-- set duration
	local bduration = self:GetSpecialValueFor("duration")
	if target:IsCreep() and (target:GetLevel()<=6) then
		bduration = self:GetSpecialValueFor("creep_duration")
	end

	local stun_duration = 0.1

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_bondage", -- modifier name
		{ duration = bduration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = stun_duration } -- kv
	)

	self:PlayEffects( caster, target )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function bondage:AbilityConsiderations()
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
function bondage:PlayEffects( caster, target )
	-- Create Projectile
	local projectile_name = "particles/billy_bondage.vpcf"
	local projectile_speed = 10000
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)

		bDodgeable = false,                                -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
modifier_billy_billy = class ({})
function modifier_billy_billy:IsHidden() return true end
function modifier_billy_billy:IsDebuff() return false end
function modifier_billy_billy:IsPurgable() return false end
function modifier_billy_billy:IsPurgeException() return false end
function modifier_billy_billy:RemoveOnDeath() return false end
function modifier_billy_billy:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_billy_billy:GetModifierBaseAttackTimeConstant()
	return 2.4
end
function modifier_billy_billy:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_billy_billy:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_billy_billy:OnIntervalThink()
    if IsServer() then
        local gay_site = self:GetParent():FindAbilityByName("gay_website")
        if gay_site and not gay_site:IsNull() then
            if self:GetParent():HasScepter() then
                if gay_site:IsHidden() then
                    gay_site:SetHidden(false)
                end
            else
                if not gay_site:IsHidden() then
                    gay_site:SetHidden(true)
                end
            end
        end
    end
end

modifier_bondage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bondage:IsHidden()
	return false
end

function modifier_bondage:IsDebuff()
	return true
end

function modifier_bondage:IsStunDebuff()
	return false
end

function modifier_bondage:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bondage:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) + self:GetCaster():FindTalentValue("special_bonus_billy_20") -- special value
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

		-- Play Effects
		self.sound_target = "billy.1"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_bondage:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) -- special value
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

function modifier_bondage:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_bondage:CheckState()
	local state = {

	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end
function modifier_bondage:DeclareFunctions()
	local funcs = {
		

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end



function modifier_bondage:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
function modifier_bondage:Silence()
	-- add silence
	
self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) * 2
	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	

	local sound_cast = "billy.spanked"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_bondage:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bondage:GetEffectName()
	return "particles/billy_bondage_target.vpcf"
end

function modifier_bondage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end





sexy_body = class({})
LinkLuaModifier( "modifier_sexy_body", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_debuff", "modifiers/modifier_axe_berserkers_call_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function sexy_body:GetIntrinsicModifierName()
	return "modifier_sexy_body"
end



modifier_sexy_body = class({})

--------------------------------------------------------------------------------

function modifier_sexy_body:IsHidden()
	return false
end

function modifier_sexy_body:IsDebuff()
	return false
end

function modifier_sexy_body:IsPurgable()
	return false
end

function modifier_sexy_body:RemoveOnDeath()
	return false
end
function modifier_sexy_body:AllowIllusionDuplicate()
 return false 
 end
 function modifier_sexy_body:DeclareFunctions()
	local func = { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
					MODIFIER_EVENT_ON_ATTACK_LANDED}
	return func
end
function modifier_sexy_body:OnAbilityFullyCast(params)
	if IsServer() then
	self.damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_billy_25")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
			local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end
		
		if params.ability:IsItem() then return end
		 if self:GetAbility():IsFullyCastable() then
		
		if pass then
		self.crit_chance = self:GetAbility():GetSpecialValueFor("chance") 
		if RandomInt(0, 100)<self.crit_chance then
		self.damageTable = {
		victim = target,
		attacker = self:GetParent(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
				local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		
		end
		local radius = 400
		self:PlayEffects(radius)
		self.ability = self:GetAbility()
		local cooldown = self:GetAbility():GetSpecialValueFor("cooldown")
		self.ability:StartCooldown(cooldown)

			
			end
		end
	end
	end
	end

	
function modifier_sexy_body:PlayEffects( radius )
	local particle_cast = "particles/billy_body_damage.vpcf"
	local sound_cast = "billy.2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end








muscule_flex = class({})
LinkLuaModifier( "modifier_muscule_flex", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_billy_disarmed", "modifiers/modifier_billy_disarmed", LUA_MODIFIER_MOTION_NONE )


function muscule_flex:OnSpellStart()
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
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_billy_disarmed", -- modifier name
			{ duration = duration } -- kv
		)
end
		-- silence
		
	
 
	self:PlayEffects( radius )
end

function muscule_flex:PlayEffects( radius )
	local particle_cast = "particles/muscule_flex.vpcf"
	local sound_cast = "billy.3"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_muscule_flex = class({})
 
--------------------------------------------------------------------------------

function modifier_muscule_flex:IsDebuff()
	return false
end

function modifier_muscule_flex:IsStunDebuff()
	return false
end
function modifier_muscule_flex:IsHidden()
	return false
end
function modifier_muscule_flex:IsPurgable()
	return false
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_muscule_flex:DeclareFunctions()
    local funcs = {
        
       
        
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
    }

    return funcs
end


  function  modifier_muscule_flex:GetModifierIncomingPhysicalDamage_Percentage()
return -99999
end  

--------------------------------------------------------------------------------

function modifier_muscule_flex:GetEffectName()
	return "particles/billy_armor.vpcf"
end

function modifier_muscule_flex:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end






















fisting = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fisting", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fisting_immune", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function fisting:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()
    self.hVictim = self:GetCursorTarget()


	local radius = 300
	
	local debuffDuration = 1.5



if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 50
	local target_loc_forward_vector = target:GetForwardVector()
	local final_pos = target:GetAbsOrigin() - target_loc_forward_vector * 150
	


	-- Blink
	caster:SetOrigin( final_pos )
	FindClearSpaceForUnit( caster, final_pos, true )
	caster:SetForwardVector(target_loc_forward_vector)

	
	
	caster:AddNewModifier( self:GetCaster(), self, "modifier_fisting_immune", { duration = self:GetChannelTime() } )
	target:AddNewModifier( self:GetCaster(), self, "modifier_fisting", { duration = self:GetChannelTime() } )
	
	
	
	
	
	EmitSoundOn("billy.4", caster)
end

function fisting:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_fisting" )
		local caster = self:GetCaster()
		caster:RemoveModifierByName( "modifier_fisting_immune" )
		
		StopSoundOn("billy.4", caster)
	end
end




modifier_fisting = class({})

--------------------------------------------------------------------------------

function modifier_fisting:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_fisting:IsStunDebuff()
	return true
end
function modifier_fisting:IsPurgable()
	return false
end

function modifier_fisting:IsPurgeException()
	return false
end
--------------------------------------------------------------------------------

function modifier_fisting:OnCreated( kv )
    self.dismember_damage = self:GetAbility():GetSpecialValueFor("damage")
    self.tick_rate = self:GetAbility():GetSpecialValueFor("int")

    if IsServer() then
        self:GetParent():InterruptChannel()
        self:OnIntervalThink()
        self:StartIntervalThink( self.tick_rate )
    end
end

--------------------------------------------------------------------------------

function modifier_fisting:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_fisting:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage
		

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		
	end
end

--------------------------------------------------------------------------------

function modifier_fisting:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_fisting:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_fisting:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end


modifier_fisting_immune = class({})
function modifier_fisting_immune:IsHidden() return false end
function modifier_fisting_immune:IsDebuff() return false end
function modifier_fisting_immune:IsPurgable() return false end
function modifier_fisting_immune:IsPurgeException() return false end
function modifier_fisting_immune:RemoveOnDeath() return true end
function modifier_fisting_immune:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
	return state
end
function modifier_fisting_immune:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, }
	return func
end
function modifier_fisting_immune:GetModifierModelScale()
	return 1
end
function modifier_fisting_immune:GetModifierMagicalResistanceBonus()
	return 1
end

function modifier_fisting_immune:GetEffectName()
	return "particles/fisting_bkb.vpcf"
end
function modifier_fisting_immune:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_fisting_immune:StatusEffectPriority()
	return 10
end
function modifier_fisting_immune:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end





LinkLuaModifier("modifier_ascend_to_heaven", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
ascend_to_heaven = class({})

function ascend_to_heaven:IsStealable() return true end
function ascend_to_heaven:IsHiddenWhenStolen() return false end

function ascend_to_heaven:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gachi_paradise")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function ascend_to_heaven:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function ascend_to_heaven:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_ascend_to_heaven", {duration = fixed_duration})		
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()

   

end
---------------------------------------------------------------------------------------------------------------------
modifier_ascend_to_heaven = class({})
function modifier_ascend_to_heaven:IsHidden() return false end
function modifier_ascend_to_heaven:IsDebuff() return true end
function modifier_ascend_to_heaven:IsPurgable() return false end
function modifier_ascend_to_heaven:IsPurgeException() return false end
function modifier_ascend_to_heaven:RemoveOnDeath() return true end
function modifier_ascend_to_heaven:AllowIllusionDuplicate() return true end

function modifier_ascend_to_heaven:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end

function modifier_ascend_to_heaven:GetModifierBonusStats_Strength()
    return 75
end

function modifier_ascend_to_heaven:GetModifierSpellAmplify_Percentage()

    return 50

end

function modifier_ascend_to_heaven:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["ascend_to_heaven"] = "gachi_paradise",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/gachi_paradise.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("billy.5", self.parent)
        
		end
self:PlayEffects()
        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_ascend_to_heaven:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/sans_eye_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "sans_eye", self.parent:GetAbsOrigin(), true)
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
function modifier_ascend_to_heaven:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_ascend_to_heaven:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("ascend_to_heaven_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end





gachi_paradise = class({})
LinkLuaModifier( "modifier_gachi_paradise", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ascend_invul", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function gachi_paradise:OnSpellStart()
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
        DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
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
	local knockback = { should_stun = 1,
                        knockback_duration = 3,
                        duration = 2.5,

                        knockback_distance = 0,
                        knockback_height = 1500,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
	for _,enemy in pairs(enemies) do
		 enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_gachi_paradise", -- modifier name
			{ duration = 2.5 } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_ascend_invul", -- modifier name
			{ duration = 2.499 } -- kv
		)
				

	end
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_6)

	self:PlayEffects( radius )
end

function gachi_paradise:PlayEffects( radius )
	local particle_cast = "particles/billy_return_to_heaven.vpcf"
	local sound_cast = "billy.5_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end






modifier_gachi_paradise = class({})

--------------------------------------------------------------------------------

function modifier_gachi_paradise:IsDebuff()
	return true
end

function modifier_gachi_paradise:IsStunDebuff()
	return true
end
function modifier_gachi_paradise:OnDestroy()
if self:GetParent()  == self:GetCaster() then
self:GetParent():Kill(self, self:GetCaster())
else	
self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 	

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
self:PlayEffects()
end
end

--------------------------------------------------------------------------------

function modifier_gachi_paradise:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_gachi_paradise:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_gachi_paradise:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_gachi_paradise:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_gachi_paradise:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_gachi_paradise:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/billy_ascend_end.vpcf"
	local sound_cast = "billy.5_1_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

modifier_ascend_invul = class({})
function modifier_ascend_invul:IsHidden() return false end
function modifier_ascend_invul:IsDebuff() return false end
function modifier_ascend_invul:IsPurgable() return false end
function modifier_ascend_invul:IsPurgeException() return true end
function modifier_ascend_invul:RemoveOnDeath() return true end
function modifier_ascend_invul:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	
	
					
					}
	return func
end
function modifier_ascend_invul:GetModifierIncomingDamage_Percentage( params )
	

		return -200
	end
	
	
	
	
	
	
	
	
	
	
	
gay_website = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gay_website_debuff", "heroes/billy_herry", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function gay_website:OnSpellStart()
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
function gay_website:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data

	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	
self.poison_chance = 25
	self.frost_chance = 25
	self.hell_chance = 25

	
		if RollPercentage(self.poison_chance) then
    	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 2 } -- kv
	)
   
	
	
	elseif RollPercentage(self.frost_chance) then
    	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dark_willow_terrorize_lua", -- modifier name
		{ duration = 2 } -- kv
	)
   	

  
    
     else
	    target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_gay_website_debuff", -- modifier name
		{ duration = 2 } -- kv
	)

	end
	-- stun
	
	local damage = self:GetSpecialValueFor( "damage" ) 
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	
	

	-- Play effects
		local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5
	self:PlayEffects( point, radius, debuffDuration )
	local sound_cast = "billy.6"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function gay_website:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end
function gay_website:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/gay_website.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

modifier_gay_website_debuff = class({})

--------------------------------------------------------------------------------

function modifier_gay_website_debuff:IsHidden()
    return false
end

function modifier_gay_website_debuff:IsPurgable()
    return false
end
function modifier_gay_website_debuff:OnCreated()

	
end

--------------------------------------------------------------------------------

function modifier_gay_website_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end