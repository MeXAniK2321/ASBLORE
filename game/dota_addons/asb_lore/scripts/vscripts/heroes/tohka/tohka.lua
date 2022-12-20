sandalfon = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function sandalfon:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration") 
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
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		if self:GetCaster():HasTalent("special_bonus_tohka_25") then 
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration } -- kv
		)
		else
			enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_root", -- modifier name
			{ duration = duration } -- kv
		)
		end
	end

if IsASBPatreon(caster) then
	self:PlayEffects3( radius )
	else
		self:PlayEffects( radius )
	end
	end


function sandalfon:PlayEffects( radius )
	local particle_cast = "particles/sandalfon.vpcf"
	local sound_cast = "tohka.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function sandalfon:PlayEffects3( radius )
	local particle_cast = "particles/sandalfon_arcana.vpcf"
	local sound_cast = "tohka.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end



LinkLuaModifier("modifier_adonai_melek", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_purple_dura", "heroes/tohka/tohka.lua", LUA_MODIFIER_MOTION_NONE )

adonai_melek = class({})

function adonai_melek:GetIntrinsicModifierName()
    return "modifier_purple_dura"
end
function adonai_melek:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("tohka_finishing_blow")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	if ability:IsActivated() then
            ability:SetActivated(false)
        end
end



function adonai_melek:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
	if IsASBPatreon(caster) and not caster:HasModifier("modifier_tohka_inversion") then
	 caster:EmitSound("tohka.2_arcana")
	else
    caster:EmitSound("tohka.2")
	end
    caster:AddNewModifier(caster, self, "modifier_adonai_melek", { duration = duration } )
end

modifier_adonai_melek = class({})

function modifier_adonai_melek:IsPurgable()
    return true
end

function modifier_adonai_melek:DeclareFunctions()
    local funcs = {
      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    }

    return funcs
end
function modifier_adonai_melek:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self:GetCaster():HasTalent("special_bonus_tohka_20_alt") then
	if params.attacker:GetAttackCapability()~=DOTA_UNIT_CAP_MELEE_ATTACK then return end
self.cleave = 55
	self.ability = self:GetAbility()
self.radius_start = 150
	self.radius_end = 360
	self.radius_dist = 500
	-- cleave
	DoCleaveAttack(
		params.attacker,
		params.target,
		self.ability,
		self.cleave,
		self.radius_start,
		self.radius_end,
		self.radius_dist,
		"particles/units/heroes/hero_sven/sven_spell_great_cleave_gods_strength.vpcf"
	)
	end
end

function modifier_adonai_melek:OnCreated( kv )
if IsServer() then
	local caster = self:GetParent()
	self.armor = self:GetAbility():GetSpecialValueFor("armor_to_attack")
	self.damage = caster:GetPhysicalArmorValue(false) * self.armor
	if IsASBPatreon(caster) then
	self:PlayEffects()
	end
	end
end
function modifier_adonai_melek:PlayEffects( )
self.parent = self:GetParent()
	 if not self.particle_time2 then
            self.particle_time2 =    ParticleManager:CreateParticle("particles/adonai_melek_arcana_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                   
        end
	
	
end
function modifier_adonai_melek:OnDestroy()
if self.particle_time2 then
		ParticleManager:DestroyParticle(self.particle_time2, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time2)
end
end
function modifier_adonai_melek:GetModifierPreAttack_BonusDamage()
    return self.damage
end
function modifier_adonai_melek:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_adonai_melek:GetEffectName()
    return "particles/adonai_melek.vpcf"
end

function modifier_adonai_melek:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_adonai_melek:StatusEffectPriority()
    return 5
end
modifier_purple_dura = class ({})
function modifier_purple_dura:IsHidden() return true end
function modifier_purple_dura:IsDebuff() return false end
function modifier_purple_dura:IsPurgable() return false end
function modifier_purple_dura:IsPurgeException() return false end
function modifier_purple_dura:RemoveOnDeath() return false end

function modifier_purple_dura:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_purple_dura:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_purple_dura:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_DEATH,

	}

	return funcs
end
function modifier_purple_dura:OnDeath( params )
	local target = params.unit
	local attacker = params.attacker
	local caster = self:GetCaster()
	local pass = false
	if attacker==self:GetParent() and target~=self:GetParent() and attacker:IsAlive() then
		if (not target:IsIllusion()) and (not target:IsBuilding()) then
			pass = true
		end
	end

	-- logic
	if pass  then
	if IsASBPatreon(caster) and params.unit:IsRealHero() then
	if not params.unit:IsCreep() and params.unit:IsHero() and not params.unit:IsBuilding() then
	
	self:PlayEffects(400,target)
	end
	end
	end
end
function modifier_purple_dura:PlayEffects( radius,target )

	local particle_cast = "particles/tohka_smug_kill.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_purple_dura:OnIntervalThink()
    if IsServer() then
        local angry_women = self:GetParent():FindAbilityByName("tohka_inversion")
        if angry_women and not angry_women:IsNull() and not self:GetParent():HasModifier("modifier_tohka_inversion") then
            if self:GetParent():HasScepter() then
                if angry_women:IsHidden() then
                    angry_women:SetHidden(false)
                end
            else
                if not angry_women:IsHidden() then
                    angry_women:SetHidden(true)
                end
            end
        end
		 local angry_women = self:GetParent():FindAbilityByName("tohka_finishing_blow")
        if angry_women and not angry_women:IsNull() then
            if self:GetParent():HasModifier("modifier_item_aghanims_shard") then
                if angry_women:IsHidden() then
                    angry_women:SetHidden(false)
                end
            else
                if not angry_women:IsHidden() then
                    angry_women:SetHidden(true)
                end
            end
        end
    end
end





tohka_combo_strike = class({})
LinkLuaModifier( "modifier_tohka_combo_strike_start", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tohka_combo_strike_attack", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tohka_combo_strike_attack2", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tohka_combo_strike_attack3", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tohka_rage_combo_begin", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function tohka_combo_strike:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tohka_rage_combo_begin", -- modifier name
		{duration = duration} -- kv
	)
	if IsASBPatreon(caster) then
	 caster:EmitSound("tohka.3_arcana")
	else
	   caster:EmitSound("tohka.3")
	   end
	end





modifier_tohka_rage_combo_begin = class({})

function modifier_tohka_rage_combo_begin:IsHidden()
	return true
end
function modifier_tohka_rage_combo_begin:RemoveOnDeath() return true end


function modifier_tohka_rage_combo_begin:IsPurgable()
    return false
end
function modifier_tohka_rage_combo_begin:OnCreated()
if IsServer() then
local ability = self:GetCaster():FindAbilityByName("tohka_finishing_blow")
if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then
 if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
		end
local bat = self:GetAbility():GetSpecialValueFor("bat") - self:GetCaster():FindTalentValue("special_bonus_tohka_25")
    self:StartIntervalThink(bat)
end
end
function modifier_tohka_rage_combo_begin:OnIntervalThink()
if IsServer() then
local caster = self:GetCaster()
if not caster:IsStunned() then
self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local angle = self:GetAbility():GetSpecialValueFor("angle")/2
	local distance = self:GetAbility():GetSpecialValueFor("knockback_distance")
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y
	-- load data
	local rng = RandomInt(1,3)
	if rng == 1 and not caster:HasModifier("modifier_tohka_combo_strike_attack") then
	caster:StartGesture(ACT_DOTA_ATTACK)
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tohka_combo_strike_attack", -- modifier name
		{duration = 0.4} -- kv
	)
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack2")
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack3")
	elseif rng == 2 and not caster:HasModifier("modifier_tohka_combo_strike_attack2") then
		caster:StartGesture(ACT_DOTA_ATTACK2)
local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tohka_combo_strike_attack2", -- modifier name
		{duration = 0.4} -- kv
	)
		caster:RemoveModifierByName("modifier_tohka_combo_strike_attack")
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack3")
	elseif rng == 3 and not caster:HasModifier("modifier_tohka_combo_strike_attack3") then
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tohka_combo_strike_attack3", -- modifier name
		{duration = 0.4} -- kv
	)
		caster:RemoveModifierByName("modifier_tohka_combo_strike_attack2")
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack")
	
	else
	if not caster:HasModifier("modifier_tohka_combo_strike_attack") then
		caster:StartGesture(ACT_DOTA_ATTACK)
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tohka_combo_strike_attack", -- modifier name
		{duration = 0.4} -- kv
	)
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack2")
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack3")
	else
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tohka_combo_strike_attack3", -- modifier name
		{duration = 0.4} -- kv
	)
		caster:RemoveModifierByName("modifier_tohka_combo_strike_attack2")
	caster:RemoveModifierByName("modifier_tohka_combo_strike_attack")
	end
	end
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local damageTable = {
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
damageTable.victim = enemy
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			self:PlayEffects2( enemy, origin, cast_direction )
		end
	end
	end
	end
	end
	function modifier_tohka_rage_combo_begin:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end
 function modifier_tohka_rage_combo_begin:OnDestroy()
 if IsServer() then
local ability = self:GetCaster():FindAbilityByName("tohka_finishing_blow")
if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then
 if ability:IsActivated() then
            ability:SetActivated(false)
			end
			end
			end
			end
function modifier_tohka_rage_combo_begin:PlayEffects( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/tohka_arcana_blood.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_tohka_rage_combo_begin:PlayEffects2( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
modifier_tohka_combo_strike_attack = class({})

function modifier_tohka_combo_strike_attack:IsHidden()
	return true
end
function modifier_tohka_combo_strike_attack:RemoveOnDeath() return true end


function modifier_tohka_combo_strike_attack:IsPurgable()
    return false
end
modifier_tohka_combo_strike_attack2 = class({})

function modifier_tohka_combo_strike_attack2:IsHidden()
	return true
end
function modifier_tohka_combo_strike_attack2:RemoveOnDeath() return true end


function modifier_tohka_combo_strike_attack2:IsPurgable()
    return false
end
modifier_tohka_combo_strike_attack3 = class({})

function modifier_tohka_combo_strike_attack3:IsHidden()
	return true
end
function modifier_tohka_combo_strike_attack3:RemoveOnDeath() return true end


function modifier_tohka_combo_strike_attack3:IsPurgable()
    return false
end

modifier_tohka_combo_strike_start = class({})

function modifier_tohka_combo_strike_start:IsHidden()
	return false
end
function modifier_tohka_combo_strike_start:RemoveOnDeath() return true end
function modifier_tohka_combo_strike_start:AllowIllusionDuplicate()
	return true
end
 function modifier_tohka_combo_strike_start:OnCreated()
local ability = self:GetCaster():FindAbilityByName("tohka_finishing_blow")
 if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
 end
 function modifier_tohka_combo_strike_start:OnDestroy()
local ability = self:GetCaster():FindAbilityByName("tohka_finishing_blow")
 if ability:IsActivated() then
            ability:SetActivated(false)
			end
 self.ability = self:GetAbility()
 self.parent = self:GetParent()
  if self:GetCaster():HasModifier("modifier_tohka_inversion") then
  self.ability:StartCooldown(8)
  else
	 self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
	 end
end	 
function modifier_tohka_combo_strike_start:IsPurgable()
    return false
end




LinkLuaModifier("modifier_halvanhelen", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE)

halvanhelen = class({})

function halvanhelen:IsStealable() return true end
function halvanhelen:IsHiddenWhenStolen() return false end
function halvanhelen:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function halvanhelen:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()

    if point == caster:GetAbsOrigin() then
        point = caster:GetAbsOrigin() + caster:GetForwardVector() * 25
    end

    local distance = self:GetCastRange(caster:GetAbsOrigin(),caster)
    local direction = (point - caster:GetAbsOrigin()):Normalized()

    local width = self:GetSpecialValueFor("width")
    local speed = self:GetSpecialValueFor("speed")
	if IsASBPatreon(caster) then
	self.slash = "particles/tohka_halvanhelen_arcana.vpcf"
	else
	self.slash = "particles/tohka_halvanhelen.vpcf"
	end

    self.slash_projectile = {   Ability = self,
                                EffectName = self.slash,
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
  EmitSoundOn("tohka.4", self:GetCaster())
        EmitSoundOn("tohka.4_1", self:GetCaster())
end
function halvanhelen:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        return nil
    end

    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_halvanhelen", {duration = self:GetSpecialValueFor("slow_duration")})
if self:GetCaster():HasTalent("special_bonus_tohka_20") then
    self.armor = self:GetCaster():GetPhysicalArmorValue(false) * 10
	self.damage = self:GetSpecialValueFor("damage") + self.armor
	else
	self.damage = self:GetSpecialValueFor("damage")
	end
    local damage_table = {  victim = hTarget,
                            attacker = self:GetCaster(),
                            damage = self.damage,
                            damage_type = self:GetAbilityDamageType(),
                            ability = self,
							damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,	}

    self.anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    ApplyDamage(damage_table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_halvanhelen = class({})
function modifier_halvanhelen:IsHidden() return false end
function modifier_halvanhelen:IsDebuff() return true end
function modifier_halvanhelen:IsPurgable() return true end
function modifier_halvanhelen:IsPurgeException() return true end
function modifier_halvanhelen:RemoveOnDeath() return true end
function modifier_halvanhelen:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_halvanhelen:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
    return func
end
function modifier_halvanhelen:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end
function modifier_halvanhelen:OnCreated()
    if IsServer() then
        --self:IncrementStackCount()
    end
end
function modifier_halvanhelen:OnRefresh()
    if IsServer() then
        --self:OnCreated()
    end
end

LinkLuaModifier("modifier_tohka_inversion", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tohka_inversion_invul", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)

tohka_inversion = class({})

function tohka_inversion:IsStealable() return true end
function tohka_inversion:IsHiddenWhenStolen() return false end
function tohka_inversion:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("inversion_sword")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function tohka_inversion:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	local duration = 2.3
	local damage = 1000

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

	

    caster:AddNewModifier(caster, self, "modifier_tohka_inversion", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_tohka_inversion_invul", {duration = 2.0})
-- 		if _G.MusicBox:HasModifier("modifier_star_tier2") then
-- 	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")
-- 	end
-- 	if _G.MusicBox:HasModifier("modifier_star_tier1") then
-- 	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
-- 	end
	
-- 	if not _G.MusicBox:HasModifier("modifier_star_tier3") then
-- _G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
-- end
    self:EndCooldown()
	self:PlayEffects()

    
end
function tohka_inversion:PlayEffects( )

	local particle_cast = "particles/tenka_inversion.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )


end

modifier_tohka_inversion_invul = class({})
function modifier_tohka_inversion_invul:IsHidden() return false end
function modifier_tohka_inversion_invul:IsDebuff() return true end
function modifier_tohka_inversion_invul:IsPurgable() return false end
function modifier_tohka_inversion_invul:IsPurgeException() return false end
function modifier_tohka_inversion_invul:RemoveOnDeath() return true end
function modifier_tohka_inversion_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_tohka_inversion_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_tohka_inversion_invul:GetOverrideAnimation()
	return ACT_DOTA_DIE
end


---------------------------------------------------------------------------------------------------------------------
modifier_tohka_inversion = class({})
function modifier_tohka_inversion:IsHidden() return false end
function modifier_tohka_inversion:IsDebuff() return true end
function modifier_tohka_inversion:IsPurgable() return false end
function modifier_tohka_inversion:IsPurgeException() return false end
function modifier_tohka_inversion:RemoveOnDeath() return true end
function modifier_tohka_inversion:AllowIllusionDuplicate() return true end
function modifier_tohka_inversion:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("tohka_inversion_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_tohka_inversion:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	               	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, }
    return func
end


function modifier_tohka_inversion:GetModifierModelChange()
if IsASBPatreon(self:GetCaster()) then
    return "models/tohka/inversion/inversion_arcana.vmdl"
	else
	return "models/tohka/inversion/inversion.vmdl"
	end
end
function modifier_tohka_inversion:GetModifierModelScale()
	return -70
end
function modifier_tohka_inversion:GetModifierPreAttack_BonusDamage()
    return 125
end

function modifier_tohka_inversion:GetModifierBonusStats_Strength()
    return 50
end


function modifier_tohka_inversion:GetModifierPhysicalArmorBonus()

return 10
end





function modifier_tohka_inversion:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
    self.skills_table = {
                            ["tohka_inversion"] = "inversion_sword",
							
                            
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
		if IsASBPatreon(self.caster) then
		self.particle_time =    ParticleManager:CreateParticle("particles/tenka_inversion_aura_arcana.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		else
            self.particle_time =    ParticleManager:CreateParticle("particles/tenka_inversion_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
end
      
        EmitSoundOn("tohka.5", self.parent)
		

        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_tohka_inversion:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_tohka_inversion:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("tohka_inversion_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end


inversion_sword = class({})

function inversion_sword:IsStealable() return true end
function inversion_sword:IsHiddenWhenStolen() return false end
function inversion_sword:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function inversion_sword:OnAbilityPhaseStart()
    if IsServer() then
	if IsASBPatreon(self:GetCaster()) then
	        self.swing_fx = ParticleManager:CreateParticle("particles/tohka_inversion_sword_start_arcana.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
        local swing = self.swing_fx
        ParticleManager:SetParticleControlEnt(self.swing_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.swing_fx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        
        Timers:CreateTimer(self:GetBackswingTime(), function()
            ParticleManager:DestroyParticle(swing, false)
            ParticleManager:ReleaseParticleIndex(swing)
        end)
	else
        self.swing_fx = ParticleManager:CreateParticle("particles/tohka_inversion_sword_start.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
        local swing = self.swing_fx
        ParticleManager:SetParticleControlEnt(self.swing_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.swing_fx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
        
        Timers:CreateTimer(self:GetBackswingTime(), function()
            ParticleManager:DestroyParticle(swing, false)
            ParticleManager:ReleaseParticleIndex(swing)
        end)
		end

  
        return true
    end
end
function inversion_sword:OnAbilityPhaseInterrupted()
    if IsServer() then
        ParticleManager:DestroyParticle(self.swing_fx, false)


    end
end
function inversion_sword:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    if point == caster:GetAbsOrigin() then
        point = caster:GetAbsOrigin() + caster:GetForwardVector() * 25
    end

    local distance = self:GetCastRange(caster:GetAbsOrigin(),caster)
    local direction = (point - caster:GetAbsOrigin()):Normalized()

    local width = self:GetSpecialValueFor("width")
    local speed = self:GetSpecialValueFor("speed")
	if IsASBPatreon(caster) then
	self.slash = "particles/tohka_inversion_sword_arcana.vpcf"
	else
	self.slash = "particles/tohka_inversion_sword.vpcf"
	end

    self.slash_projectile = {   Ability = self,
                                EffectName = self.slash,
                                vSpawnOrigin = caster:GetAbsOrigin(),
                                vVelocity = Vector(direction.x,direction.y,0) * speed,
                                fDistance = distance,
                                fStartRadius = width,
                                fEndRadius = width,
                                Source = caster,
                                iUnitTargetTeam   = self:GetAbilityTargetTeam(),
                                iUnitTargetType   = self:GetAbilityTargetType(),
                                iUnitTargetFlags  = self:GetAbilityTargetFlags(),
                                bProvidesVision   = true,
                                iVisionRadius     = width,
                                iVisionTeamNumber = caster:GetTeamNumber()}

    ProjectileManager:CreateLinearProjectile(self.slash_projectile)
  EmitSoundOn("tohka.5_1", self:GetCaster())
        EmitSoundOn("tohka.5_1_sfx", self:GetCaster())
end
function inversion_sword:OnProjectileHit(hTarget, vLocation)
    if not hTarget then
        return nil
    end
local caster = self:GetCaster()
local armor = caster:GetPhysicalArmorValue(false)
    
    local damage_table = {  victim = hTarget,
                            attacker = self:GetCaster(),
                            damage = self:GetSpecialValueFor("damage") +( armor * self:GetSpecialValueFor("armor_damage")),
                            damage_type = self:GetAbilityDamageType(),
                            ability = self}

    self.anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    ApplyDamage(damage_table)
end


tohka_finishing_blow = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tohka_finishing_blow", "heroes/tohka/tohka", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function tohka_finishing_blow:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = 400


if not caster:HasModifier("modifier_tohka_rage_combo_begin") then
self:EndCooldown()
else
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

local modifier = self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_tohka_finishing_blow",
		{}
	)
	for _,enemy in pairs(enemies) do
		
			self:GetCaster():PerformAttack (
		enemy,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 0.5 } -- kv
		)
	
	end
modifier:Destroy()
	caster:RemoveModifierByName("modifier_tohka_rage_combo_begin")
if IsASBPatreon(caster) then
	self:PlayEffects3( radius )
	else
		self:PlayEffects( radius )
	end
	end
	end


function tohka_finishing_blow:PlayEffects( radius )
	local particle_cast = "particles/tohka_finishing_blow.vpcf"
	local sound_cast = "tohka.6"
		local sound_cast1 = "tohka.6_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function tohka_finishing_blow:PlayEffects3( radius )
	local particle_cast = "particles/tohka_finishing_blow_arcana.vpcf"
	local sound_cast = "tohka.6"
	local sound_cast1 = "tohka.6_1"
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast1, self:GetCaster() )
end


modifier_tohka_finishing_blow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tohka_finishing_blow:IsHidden()
	return true
end
function modifier_tohka_finishing_blow:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tohka_finishing_blow:OnCreated( kv )
	
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "damage" )	

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_tohka_finishing_blow:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,

	}

	return funcs
end

function modifier_tohka_finishing_blow:GetModifierPreAttack_CriticalStrike( params )
	if IsServer()  then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
			self.record = params.record
			return self.crit_mult
		end
	end

function modifier_tohka_finishing_blow:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil

			-- Play effects
			
		end
	end
end

