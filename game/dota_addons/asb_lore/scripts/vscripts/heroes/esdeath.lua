frozen_blood = class({})
LinkLuaModifier( "modifier_frozen_blood", "heroes/esdeath", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frozen_blood_debuff", "heroes/esdeath", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function frozen_blood:GetIntrinsicModifierName()
	return "modifier_frozen_blood"
end

modifier_frozen_blood = class({})

--------------------------------------------------------------------------------

function modifier_frozen_blood:IsHidden()
	return false
end

function modifier_frozen_blood:IsDebuff()
	return false
end

function modifier_frozen_blood:IsPurgable()
	return false
end

function modifier_frozen_blood:RemoveOnDeath()
	return false
end
function modifier_frozen_blood:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_frozen_blood:OnCreated( kv )
	-- get references
	self.damage = self:GetAbility():GetSpecialValueFor("damage_from_hp")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    
	
end

function modifier_frozen_blood:OnRefresh( kv )
self.damage = self:GetAbility():GetSpecialValueFor("damage_from_hp")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

--------------------------------------------------------------------------------

function modifier_frozen_blood:DeclareFunctions()
	local funcs = {


		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_frozen_blood:OnAttackLanded(params)
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	if params.attacker == self:GetParent() then
		if self:GetParent():IsRealHero() then
	    if not params.attacker:IsIllusion() then
			self.record = params.record
			local target = params.target
			local max_health = target:GetMaxHealth()
			local freeze_hp = max_health * 0.5
			local target_hp = target:GetHealth()
			local damage_hp = (max_health - target_hp) * self.damage
			local enemy_hp = max_health - target_hp
			
			local damageTable = {
		attacker = self:GetParent(),
		damage = damage_hp,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:PlayEffects(target)
		
  

                
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_frozen_blood_debuff", {duration = self.duration, damage = self.damage, })
			
			else
			end
		end
	end
	end
	end

	
function modifier_frozen_blood:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/econ/events/frostivus/frostivus_fireworks_ability_illumination.vpcf"



	
	
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


end


function modifier_frozen_blood:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			
		end
	end
end
modifier_frozen_blood_debuff = class({})

--------------------------------------------------------------------------------

function modifier_frozen_blood_debuff:IsDebuff()
	return true
end

function modifier_frozen_blood_debuff:IsStunDebuff()
	return false
end
function modifier_frozen_blood_debuff:IsHidden()
	return false
end
function modifier_frozen_blood_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_frozen_blood_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end
function modifier_frozen_blood_debuff:GetDisableHealing()
	return 1
end


--------------------------------------------------------------------------------

function modifier_frozen_blood_debuff:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_frozen_blood_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
ice_meteor = class({})
LinkLuaModifier( "modifier_ice_meteor", "heroes/esdeath", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ice_meteor_land", "heroes/esdeath", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function ice_meteor:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function ice_meteor:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ice_meteor", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	EmitGlobalSound("Esdeath.4")
end

modifier_ice_meteor = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ice_meteor:IsHidden()
	return true
end

function modifier_ice_meteor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ice_meteor:OnCreated( kv )
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
		--Optional.
	}
	self:PlayEffects1()
end 
function modifier_ice_meteor:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/test_ice_meteor.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 1.0

	-- Get Data
	local height = 1500
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, -500, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_ice_meteor:OnRefresh( kv )
	
end

function modifier_ice_meteor:OnRemoved()
end

function modifier_ice_meteor:OnDestroy()
	if not IsServer() then return end
	local origin = self:GetParent():GetOrigin()
	local caster = self:GetCaster()

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
		

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

		CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_ice_meteor_land", -- modifier name
		{ duration = 5 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects()
	

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ice_meteor:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/ice_meteor_land.vpcf"
	local sound_cast = "Esdeath.4_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_ice_meteor_land = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ice_meteor_land:IsHidden()
	return false
end

function modifier_ice_meteor_land:IsDebuff()
	return true
end

function modifier_ice_meteor_land:IsStunDebuff()
	return false
end

function modifier_ice_meteor_land:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ice_meteor_land:OnCreated( kv )
	-- references
	local interval = 0.2
	local damage = 50
	self.radius = 500

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	-- precache damage
	self.damageTable = {
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )

	self:PlayEffects()
end

function modifier_ice_meteor_land:OnRefresh( kv )
	
end

function modifier_ice_meteor_land:OnRemoved()
end

function modifier_ice_meteor_land:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end


function modifier_ice_meteor_land:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_ice_meteor_land:GetModifierMoveSpeedBonus_Percentage()
	return -20
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ice_meteor_land:OnIntervalThink()
	-- find enemies 
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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

		-- play effects
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ice_meteor_land:IsAura()
	return self.thinker
end

function modifier_ice_meteor_land:GetModifierAura()
	return "modifier_ice_meteor_land"
end

function modifier_ice_meteor_land:GetAuraRadius()
	return 500
end

function modifier_ice_meteor_land:GetAuraDuration()
	return 0.5
end

function modifier_ice_meteor_land:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ice_meteor_land:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ice_meteor_land:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ice_meteor_land:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf"
end

function modifier_ice_meteor_land:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ice_meteor_land:PlayEffects()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "Esdeath.ice_land"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

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
	EmitSoundOn( sound_cast, self:GetParent() )
end
ice_lances = ice_lances or class({})
LinkLuaModifier("modifier_ice_lances", "heroes/esdeath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_lances_particle", "heroes/esdeath", LUA_MODIFIER_MOTION_NONE)

function ice_lances:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function ice_lances:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_ice_lances", {})
	EmitSoundOn("Esdeath.Spike", caster)
end
function ice_lances:OnProjectileHit_ExtraData(hTarget, vLocation, hTable)
    ParticleManager:DestroyParticle(hTable.iBladeParticle, false)
    ParticleManager:ReleaseParticleIndex(hTable.iBladeParticle)

    if IsNotNull(hTarget) then
        local hCaster     = self:GetCaster()
        local iCasterTeam = hCaster:GetTeamNumber()
        local fDamage     = self:GetSpecialValueFor("damage")
        local fDuration   = self:GetSpecialValueFor("duration")

        local hDamageTable =    {
                                    victim       = hTarget,
                                    attacker     = hCaster, 
                                    damage       = fDamage,
                                    damage_type  = self:GetAbilityDamageType(),
                                    ability      = self,
									
                                }

        hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = fDuration})

        ApplyDamage(hDamageTable)

        SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, hTarget, hDamageTable.damage, nil)

    	
    end

    return true
end


modifier_ice_lances_particle = modifier_ice_lances_particle or class({})

function modifier_ice_lances_particle:IsHidden()                                     
return true 
end
function modifier_ice_lances_particle:IsDebuff()                                     
return false 
end
function modifier_ice_lances_particle:IsPurgable()                                  
 return false 
 end
function modifier_ice_lances_particle:IsPurgeException()                             
return false 
end
function modifier_ice_lances_particle:RemoveOnDeath()                                
return true 
end
function modifier_ice_lances_particle:CheckState()
    local state =   {
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    }

    if IsServer()
        and IsNotNull(self.caster)
        and self.caster:HasFlyMovementCapability() then
        state[MODIFIER_STATE_FLYING] = true
    end

    return state
end
function modifier_ice_lances_particle:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
    end
end
function modifier_ice_lances_particle:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ice_lances_particle:OnDestroy()
    if IsServer() then
    end
end
function modifier_ice_lances_particle:GetEffectName()
    return "particles/mars_spear1.vpcf"
end
function modifier_ice_lances_particle:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


modifier_ice_lances = modifier_ice_lances or class({})

function modifier_ice_lances:IsHidden()                                     
return false 
end
function modifier_ice_lances:IsDebuff()                                     
return false 
end
function modifier_ice_lances:IsPurgable()                                   
return true 
end
function modifier_ice_lances:IsPurgeException()                             
return true 
end
function modifier_ice_lances:RemoveOnDeath()                                
return true 
end
function modifier_ice_lances:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.iCASTER_TEAM          = self.caster:GetTeamNumber()
        self.iABILITY_TARGET_TEAM  = self.ability:GetAbilityTargetTeam() 
        self.iABILITY_TARGET_TYPE  = self.ability:GetAbilityTargetType() 
        self.iABILITY_TARGET_FLAGS = self.ability:GetAbilityTargetFlags()
        --=================================--
        self.hSPEARS_TABLE = self.hSPEARS_TABLE or {}
        --=================================--
        self.iDamageBladeLength = 350

        self.vHoldFlyingOffset  = Vector(0, 0, 200)
        self.iHoldFlyingRadius  = 300
        self.iMaxSpears         = self.ability:GetSpecialValueFor("spears") + self:GetCaster():FindTalentValue("special_bonus_esdeath_20")

        self.iSpearsDirection   = 1

        self.fReleaseDelay      = 0.05
        self.iReleaseDistance   = self.ability:GetAOERadius()
        self.iReleaseSpeed      = 2500
        self.iReleaseWidth      = 40
        self.fReleaseInterval   = 0.05
        --=================================--
        self:OnDestroy()
        --=================================--
        local vCasterLoc = self.parent:GetAbsOrigin()
        for iBlade = 1, self.iMaxSpears do
            local hBlade = CreateModifierThinker(self.parent, self.ability, "modifier_ice_lances_particle", {}, vCasterLoc, DOTA_TEAM_NEUTRALS, false)

            table.insert(self.hSPEARS_TABLE, hBlade)
        end
        --=================================--
        self.__fLocalElapsedTime   = 0
        self.__fLocalThinkInterval = 0.01

        self.__fReleaseThinkTime   = -self.fReleaseDelay

        self:OnIntervalThink()
        self:StartIntervalThink(self.__fLocalThinkInterval)

      
    end
end
function modifier_ice_lances:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ice_lances:OnIntervalThink()
    if IsServer()
        and IsNotNull(self.parent) then
        --=================================--
        self.__fLocalElapsedTime = self.__fLocalElapsedTime + self.__fLocalThinkInterval
        self.__fReleaseThinkTime  = self.__fReleaseThinkTime + self.__fLocalThinkInterval
        --=================================--
        local fParentScale = self.parent:GetModelScale()
        local vCasterLoc   = self.parent:GetAbsOrigin() + self.vHoldFlyingOffset * fParentScale
        local vEndPoint    = vCasterLoc + self.parent:GetForwardVector() * self.iReleaseDistance
        local vCasterRight = self.parent:GetRightVector()
        --=================================--
        for iKey, hValue in pairs(self.hSPEARS_TABLE) do
            if IsNotNull(hValue) then
                local vSideDirection = vCasterRight
                local iSideOffset    = iKey
                if iKey%2 == 0 then
                    vSideDirection = -vCasterRight
                    iSideOffset    = (iKey - 1)
                end
				local rand  = RandomFloat(0.1,4) 
                iSideOffset = iSideOffset * 13

                local vBladeLoc = ( vCasterLoc + vSideDirection * ( self.iHoldFlyingRadius - iSideOffset * rand  ) ) + Vector(0, 0, iSideOffset)
                local vBladeFow = GetDirection(vEndPoint, vBladeLoc, true)

                hValue:SetForwardVector(vBladeFow)
                hValue:SetAbsOrigin(vBladeLoc)
            end
        end
        --=================================--
        if self.__fReleaseThinkTime >= self.fReleaseInterval then
            self.__fReleaseThinkTime = 0
            --=================================--
            local iSpearsNow = TableLength(self.hSPEARS_TABLE)
            local hValue     = self.hSPEARS_TABLE[iSpearsNow]
            if IsNotNull(hValue) then
                --=================================--
                local vStartPoint = hValue:GetAbsOrigin()
                local vDirection  = hValue:GetForwardVector()
                
                      vStartPoint = vStartPoint + vDirection * -( self.iDamageBladeLength * 0.7 )

                Speacial_ProjectileCreation(self.parent, self.ability, vStartPoint, vEndPoint, self.iReleaseSpeed, self.iReleaseWidth, self.iReleaseWidth)
                --=================================--
                 hValue:RemoveModifierByNameAndCaster("modifier_ice_lances_particle", self.parent)
                --=================================--
                --UTIL_Remove(hValue) --CAN BUT WANNA MORE SAFTY...
                table.remove(self.hSPEARS_TABLE, iSpearsNow)

                
            end
            --=================================--
            if TableLength(self.hSPEARS_TABLE) <= 0 then
                return self:Destroy()
            end
        end
    end
end
function modifier_ice_lances:OnDestroy()
    if IsServer() then
        local fParentScale = self.parent:GetModelScale()
        local vCasterLoc   = self.parent:GetAbsOrigin() + self.vHoldFlyingOffset * fParentScale
        local vEndPoint    = vCasterLoc + self.parent:GetForwardVector() * self.iReleaseDistance * self.iSpearsDirection
        for iKey, hValue in pairs(self.hSPEARS_TABLE) do
            if IsNotNull(hValue) then
                --=================================--
                local vStartPoint = hValue:GetAbsOrigin()
                local vDirection  = hValue:GetForwardVector()
                      vStartPoint = vStartPoint + vDirection * -( self.iDamageBladeLength * 0.5 )

               Speacial_ProjectileCreation(self.parent, self.ability, vStartPoint, vEndPoint, self.iReleaseSpeed, self.iReleaseWidth, self.iReleaseWidth)
                --=================================--
               hValue:RemoveModifierByNameAndCaster("modifier_ice_lances_particle", self.parent)
                --=================================--
         

              
            end
        end
        self.hSPEARS_TABLE = {}
    end
end