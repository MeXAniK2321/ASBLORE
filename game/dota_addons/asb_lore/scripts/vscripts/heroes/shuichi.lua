teddy_hug = class({})
LinkLuaModifier( "modifier_teddy_hug", "heroes/shuichi.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_teddy_hug_debuff", "heroes/shuichi.lua" ,LUA_MODIFIER_MOTION_NONE )

function teddy_hug:GetCastRange( location , target)

	return 160
end

function teddy_hug:GetChannelTime()


	
				return 1.5
			
		end


--------------------------------------------------------------------------------

function teddy_hug:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function teddy_hug:OnSpellStart()
local caster = self:GetCaster()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_teddy_hug", { duration = self:GetChannelTime() } )
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

function teddy_hug:OnChannelFinish( bInterrupted )
local broke = GameRules:GetGameTime() - self:GetChannelStartTime()
local point = self:GetCaster():GetAbsOrigin()
local damage = self:GetSpecialValueFor( "full_damage" ) + self:GetCaster():FindTalentValue("special_bonus_shuichi_20")
local caster = self:GetCaster()

	local radius = 300
	
	local debuffDuration = 1.5

self.broke = 1.4

if broke > self.broke then
local damageTable = {
		victim = self.hVictim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	EmitSoundOn( "shuichi.2", self:GetCaster() )
	self:PlayEffects( point, radius, debuffDuration )
 self.hVictim:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.6})
	self.hVictim:AddNewModifier(self:GetCaster(), self, "modifier_teddy_hug_debuff", {duration = 2})
	end
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_teddy_hug" )
	end
end
function teddy_hug:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/shuichi_hug_blood.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_teddy_hug = class({})

--------------------------------------------------------------------------------

function modifier_teddy_hug:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )	
	self.tick_rate = 0.2
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
	
	EmitSoundOn( "shuichi.1", self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	StopSoundOn( "shuichi.1", self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:OnIntervalThink()
	if IsServer() then
	local caster = self:GetCaster()
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )	
local damageTable = {
		victim = self:GetParent(),
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
		
		
				
	end
	
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_teddy_hug:GetEffectName()

	return "particles/shuichi_hug.vpcf"

end


function modifier_teddy_hug:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_teddy_hug:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

modifier_teddy_hug_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_teddy_hug_debuff:IsHidden()
	return false
end

function modifier_teddy_hug_debuff:IsDebuff()
	return true
end

function modifier_teddy_hug_debuff:IsStunDebuff()
	return false
end

function modifier_teddy_hug_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_teddy_hug_debuff:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "bleed" ) -- special value
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

	end
end

function modifier_teddy_hug_debuff:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "bleed" ) -- special value
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
		self.sound_target = ""
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_teddy_hug_debuff:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_teddy_hug_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_teddy_hug_debuff:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_teddy_hug_debuff:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_teddy_hug_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end













kigurumi = class({})
LinkLuaModifier( "modifier_kigurumi", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function kigurumi:GetIntrinsicModifierName()
	return "modifier_kigurumi"
end


modifier_kigurumi = class({})

--------------------------------------------------------------------------------

function modifier_kigurumi:IsHidden()
	return false
end

function modifier_kigurumi:IsDebuff()
	return false
end

function modifier_kigurumi:IsPurgable()
	return false
end

function modifier_kigurumi:RemoveOnDeath()
	return false
end
function modifier_kigurumi:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_kigurumi:OnCreated( kv )
	self.block_passive = self:GetAbility():GetSpecialValueFor("block") * self:GetParent():GetMaxHealth()
	
	self.block_chance = self:GetAbility():GetSpecialValueFor("chance")
	
end

function modifier_kigurumi:OnRefresh( kv )
	-- get references
	self.block_passive = self:GetAbility():GetSpecialValueFor("block") * self:GetParent():GetMaxHealth()
  self.block_chance = self:GetAbility():GetSpecialValueFor("chance")
end

--------------------------------------------------------------------------------

function modifier_kigurumi:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
	}

	return funcs
end
function modifier_kigurumi:GetModifierPhysical_ConstantBlock()

local rand = math.random(1, 100)

if rand <= self.block_chance then
if self:GetAbility():IsFullyCastable() then
	
	
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1))
	return self.block_passive
end

end
end
function modifier_kigurumi:GetModifierMagical_ConstantBlock()

local rand = math.random(1, 100)

if rand <= self.block_chance then
if self:GetAbility():IsFullyCastable() then
	

	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1))
	return self.block_passive
end

end
end





























shuichi_get_in = class({})
LinkLuaModifier( "modifier_shuichi_get_in", "heroes/shuichi.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shuichi_get_in_self", "heroes/shuichi.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "shuichi_get_in_target", "heroes/shuichi.lua",LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )

function shuichi_get_in:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("shuichi_get_out")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function shuichi_get_in:CastFilterResultTarget( target )


local caster = self:GetCaster()
if not caster:HasScepter() then
   if target == caster then
         return UF_FAIL_CUSTOM
    end
	end
 if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
  return UF_FAIL_ENEMY
    end
	return UF_SUCCESS
end

function shuichi_get_in:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor('duration')
	
	if target == self:GetCaster() then
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_shuichi_get_in_self", {duration = duration} )
	else
	if not target:IsIllusion() then
    FlipUnitShareMaskBit(self:GetCaster():GetPlayerID(), target:GetPlayerID(), 1)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"shuichi_get_in_target", -- modifier name
		{
		 } -- kv
	)
	self.bonus_damage = target:GetAttackDamage()
	self.agility = target:GetBaseAgility()
	self.int = target:GetBaseIntellect()
	self.str = target:GetBaseStrength()
	self.target = target:GetPlayerID()
	
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_shuichi_get_in", {damage = self.bonus_damage,
		 stat1 = self.agility,
		 stat2 = self.int,
		 stat3 = self.str,
		 target = self.target} )
		 
		  self:EndCooldown()

    
end
end
self:EmitSound("shuichi.3")

end
modifier_shuichi_get_in_self = class({})

function modifier_shuichi_get_in_self:IsHidden()
    return false
end

function modifier_shuichi_get_in_self:IsPurgable()
    return false
end

function modifier_shuichi_get_in_self:DeclareFunctions()
	local func = {	
					
					 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					 
					}
	return func
end


function modifier_shuichi_get_in_self:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('damage')
end
function modifier_shuichi_get_in_self:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('stats')
end

function modifier_shuichi_get_in_self:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('stats')
end

function modifier_shuichi_get_in_self:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('stats')
end
function modifier_shuichi_get_in_self:GetModifierAttackSpeedBonus_Constant()
	 return self:GetAbility():GetSpecialValueFor('bonus_as')
end
modifier_shuichi_get_in = class({})

function modifier_shuichi_get_in:IsHidden()
    return false
end

function modifier_shuichi_get_in:IsPurgable()
    return false
end
function modifier_shuichi_get_in:OnCreated( kv )
	if not IsServer() then return end
	self.parent = self:GetParent()
	local caster = self:GetCaster()

	local stat_teammate = self:GetAbility():GetSpecialValueFor('bonus_stat_teammate')
	self.damage = kv.damage
	self.agility = kv.stat1 * stat_teammate
	self.int = kv.stat2 * stat_teammate
	self.str = kv.stat3 * stat_teammate
	self.target = kv.target
	
	 self.skills_table = {
                            
							["shuichi_get_in"]="shuichi_get_out",
							
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
		for i = 0, 8 do
		caster.item = self:GetParent():GetItemInSlot(i) 
		if caster.item then
			if caster.item:IsSellable() then
				caster.item:SetSellable(false)
			end
			if caster.item:IsDroppable() then
				caster.item:SetDroppable(false)
			end
			end
			end
		end
end
function modifier_shuichi_get_in:OnDestroy()
local caster = self:GetCaster()
	if not IsServer() then return end
FlipUnitShareMaskBit(self:GetCaster():GetPlayerID(), self.target, 1)
 if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
			for i = 0, 8 do
		caster.item = self:GetParent():GetItemInSlot(i) 
		if caster.item then
			if not caster.item:IsSellable() then
				caster.item:SetSellable(true)
			end
			if not caster.item:IsDroppable() then
				caster.item:SetDroppable(true)
			end
			end
end
end
 local ability = self.parent:FindAbilityByName("shuichi_get_in")
 ability:StartCooldown(70)
end

function modifier_shuichi_get_in:DeclareFunctions()
	local func = {	
					
					 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		  MODIFIER_EVENT_ON_TAKEDAMAGE,
		  MODIFIER_PROPERTY_MIN_HEALTH
					 
					}
	return func
end
function modifier_shuichi_get_in:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() then
		local ability2 = self:GetCaster():FindAbilityByName("pop_up_parade")
			if not ability2:IsFullyCastable() or self:GetParent():HasModifier( "modifier_pop_up_parade_buff" )  then
				if self:GetParent():IsIllusion() then return end
				if self:GetParent():GetHealth() <= 1 then
					self:GetParent():SetHealth(1)
					self:Destroy()
					local delay = 0.1
self.damageTable = {
		victim = self:GetParent(),
		attacker = params.attacker,
		damage = 500,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	Timers:CreateTimer(delay,function()
						
	ApplyDamage(self.damageTable)
	end)
					return
				end

				
			end
		end
	end
end

function modifier_shuichi_get_in:GetMinHealth()

	
 return 1

	end




function modifier_shuichi_get_in:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('damage')
end
function modifier_shuichi_get_in:GetModifierBonusStats_Strength()
    return self.str
end

function modifier_shuichi_get_in:GetModifierBonusStats_Agility()
    return self.agility
end

function modifier_shuichi_get_in:GetModifierBonusStats_Intellect()
    return self.int
end
function modifier_shuichi_get_in:GetModifierAttackSpeedBonus_Constant()
	 return self:GetAbility():GetSpecialValueFor('bonus_as')
end
shuichi_get_in_target = class({})

function shuichi_get_in_target:IsPurgable()
    return false
end

function shuichi_get_in_target:OnCreated( kv )
  
    self:StartIntervalThink(0.2)
    self:GetParent():AddNoDraw()
  
end

function shuichi_get_in_target:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetParent ()
    local target_pos = target:GetAbsOrigin ()
    local caster = self:GetAbility ():GetCaster ()
    target:SetAbsOrigin (self:GetCaster ():GetAbsOrigin ())
    if not caster:IsAlive() then
	 target:RemoveModifierByName ("shuichi_get_in_target")
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"stunned", -- modifier name
		{duration = 2
		 } -- kv
	)
	elseif not self:GetCaster():HasModifier("modifier_shuichi_get_in") then
        target:RemoveModifierByName ("shuichi_get_in_target")
    end
end

function shuichi_get_in_target:OnDestroy( kv )
if not IsServer() then return end
local point = self:GetCaster():GetAbsOrigin()

FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), true)
    local npcName = self:GetParent():GetUnitName()   
    self:GetParent():RemoveNoDraw()  
    local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
    local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
    local bump_point = self:GetCaster():GetAbsOrigin() - direction * distance
    local knockbackProperties =
    {
        center_x = bump_point.x,
        center_y = bump_point.y,
        center_z = bump_point.z,
        duration = 0.5,
        knockback_duration = 0.5,
        knockback_distance = 400,
        knockback_height = 350
    }
    self:GetParent():RemoveModifierByName("modifier_knockback")
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", knockbackProperties)
        local caster = self:GetCaster()
       
end

function shuichi_get_in_target:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }

    return state
end
function shuichi_get_in_target:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
       
        
		
    }

    return funcs
end

function shuichi_get_in_target:GetBonusNightVision()
    return -9999999
end
function shuichi_get_in_target:GetBonusDayVision()

    return -999999

end


shuichi_get_out = class({})

function shuichi_get_out:IsStealable() return true end
function shuichi_get_out:IsHiddenWhenStolen() return false end
function shuichi_get_out:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("shuichi_get_in")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function shuichi_get_out:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_shuichi_get_in", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_shuichi_get_in", caster)

    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("rimuru_slime")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.shuichi_get_out_skills_used, "sss")
        if not self.shuichi_get_out_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.shuichi_get_out_skills_used = nil

  
    EmitSoundOn("shuichi.3", caster)
end

















LinkLuaModifier("modifier_load_revolver", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE)

load_revolver = class({})

function load_revolver:IsStealable() return true end
function load_revolver:IsHiddenWhenStolen() return false end

function load_revolver:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("revolver_shot")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function load_revolver:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function load_revolver:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_load_revolver", {duration = fixed_duration})


    self:EndCooldown()

    EmitSoundOn("shuichi.revolver", caster)
end

---------------------------------------------------------------------------------------------------------------------
modifier_load_revolver = class({})
function modifier_load_revolver:IsHidden() return false end
function modifier_load_revolver:IsDebuff() return true end
function modifier_load_revolver:IsPurgable() return false end
function modifier_load_revolver:IsPurgeException() return false end
function modifier_load_revolver:RemoveOnDeath() return true end
function modifier_load_revolver:AllowIllusionDuplicate() return true end
function modifier_load_revolver:DeclareFunctions()
	local funcs = {

		
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		
	}

	return funcs
end
function modifier_load_revolver:OnAbilityFullyCast( params )
	if IsServer() then
	local ability = self:GetParent():FindAbilityByName("revolver_shot")
		if params.unit~=self:GetParent() or params.ability~=ability then
			return
		end

		self:DecrementStackCount()

		-- destroy if reach zero
		if self:GetStackCount() < 1 then
			self:Destroy()
		end
	end
end
function modifier_load_revolver:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["load_revolver"] = "revolver_shot",
							
                            
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
          
     

        if IsServer() then
		self:SetStackCount(6)

	
	end
		
        
        

       
    end
end

function modifier_load_revolver:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_load_revolver:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
              
                end
            end
			 self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
        end
    end
end



revolver_shot = class({})
LinkLuaModifier( "modifier_revolver_shot_attack", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function revolver_shot:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	if  self:GetCaster():HasModifier( "modifier_pop_up_parade_buff" ) then
	self.pistol_fx = 	ParticleManager:CreateParticle("particles/shuichi_pistol1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.pistol_fx, 0, self:GetCaster(), 5, "attach_left_arm", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.pistol_fx, 1, self:GetCaster(), 5, "attach_left_arm", Vector(0,0,0), true)
       self.pistol2_fx = 	ParticleManager:CreateParticle("particles/shuichi_pistol2.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.pistol2_fx, 0, self:GetCaster(), 5, "attach_right_arm", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.pistol2_fx, 1, self:GetCaster(), 5, "attach_right_arm", Vector(0,0,0), true)
       

	-- get projectile_data
	
	local projectile_name = "particles/shuichi_bullet_model_pop_up.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 250

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
else
local projectile_name = "particles/shuichi_bullet_model.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 250

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
	end
	self:PlayEffects1()
	local delay = 0.15

	Timers:CreateTimer(delay,function()
	if self.pistol_fx then
	    ParticleManager:DestroyParticle(self.pistol_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.pistol_fx)
		ParticleManager:DestroyParticle(self.pistol2_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.pistol2_fx)
		end
		end)
		
		if caster:HasModifier("modifier_kigurumi_overheat") then
		self:EndCooldown()
		self:StartCooldown(0.3)
		end
		
	end


function revolver_shot:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	local modifier = self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_revolver_shot_attack",
		{}
	)
	self:GetCaster():PerformAttack (
		hTarget,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	modifier:Destroy()

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_stunned",
		{duration = self:GetDuration()}
	)

	self:PlayEffects2( hTarget )
end

--------------------------------------------------------------------------------
function revolver_shot:PlayEffects1()
	if  self:GetCaster():HasModifier( "modifier_pop_up_parade_buff" ) then
	self.sound_cast = "shuichi.digle_shot"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	else
	self.sound_cast = "shuichi.4"
	EmitSoundOn( self.sound_cast, self:GetCaster() )
	end

	-- Create Sound
	
end

function revolver_shot:PlayEffects2( target )
	-- Get Resources
	local sound_target = "shuichi.4_1"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

modifier_revolver_shot_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_revolver_shot_attack:IsHidden()
	return true
end
function modifier_revolver_shot_attack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_revolver_shot_attack:OnCreated( kv )
	if  self:GetCaster():HasModifier( "modifier_pop_up_parade_buff" ) then
	self.base_damage = 1700
	else
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" ) + self:GetCaster():FindTalentValue("special_bonus_shuichi_20")
	end
	self.attack_factor = self:GetAbility():GetSpecialValueFor( "attack_factor" )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_revolver_shot_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

	}

	return funcs
end

function modifier_revolver_shot_attack:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() then
		return self.attack_factor
	end
end
function modifier_revolver_shot_attack:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
		-- base damage will get reduced, so multiply it by its inverse
		return self.base_damage * 100/(100+self.attack_factor)
	end
end

















pop_up_parade = class({})
LinkLuaModifier( "modifier_pop_up_parade", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pop_up_parade_invul", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pop_up_parade_astral", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pop_up_parade_buff", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Passive Modifier
function pop_up_parade:GetIntrinsicModifierName()
	return "modifier_pop_up_parade"
end
function pop_up_parade:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pop_up_murder")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end


modifier_pop_up_parade_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pop_up_parade_astral:IsHidden()
	return false
end

function modifier_pop_up_parade_astral:IsDebuff()
	return false
end


function modifier_pop_up_parade_astral:IsPurgable()
	return false
end

function modifier_pop_up_parade_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_pop_up_parade_astral:OnCreated( kv )
	-- references
	
	self:GetParent():AddNoDraw()

	
end


function modifier_pop_up_parade_astral:OnDestroy()
	
	self:GetParent():RemoveNoDraw()
	local sound_cast = "shuichi.scary_sfx"
	self:PlayEffects(radius)
	local radius = 1000
	EmitSoundOn( sound_cast, self:GetCaster() )
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pop_up_parade_invul", {duration = 1.5})
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_pop_up_parade_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_pop_up_parade_astral:PlayEffects( radius )
	local particle_cast = "particles/shuichi_smoke_out.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end













modifier_pop_up_parade = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pop_up_parade:IsHidden()
	return true
end


function modifier_pop_up_parade:OnCreated( kv )
	-- references
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" ) -- special value
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "slow_radius" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value

	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" ) -- special value
end

function modifier_pop_up_parade:OnRefresh( kv )
	-- references
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" ) -- special value
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "slow_radius" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value
	
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" ) -- special value
end

function modifier_pop_up_parade:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_pop_up_parade:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
	}
	return funcs
end


function modifier_pop_up_parade:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
if self:GetParent():HasModifier( "modifier_shuichi_get_in" ) or self:GetParent():HasModifier( "modifier_shuichi_get_in_self" )  then
if not self:GetParent():HasModifier( "modifier_pop_up_parade_buff" ) then
if self:GetAbility():IsFullyCastable() then
				
		   
			
				
				if self:GetParent():GetHealth() <= 20 then
				if not self:GetParent():IsIllusion() then
				local hp = self:GetParent():GetMaxHealth()
				local target = keys.attacker
			     
				 self:GetParent():SetHealth(hp)
				 local radius = 1000
				
				
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pop_up_parade_astral", {duration = 2.5})
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pop_up_parade_buff", {duration = 34})
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_star_tier2", {duration = 34})
					EmitSoundOn("shuichi.5_1", self:GetParent())
					self:PlayEffects(radius)

					
		
					
					
					return
				end
               
		end
			end
		end
	end
	end
	end


function modifier_pop_up_parade:PlayEffects( radius )
	local particle_cast = "particles/shuichi_pop_up_parade_start.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
function modifier_pop_up_parade:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/shuichi_death_screen.vpcf"
	 if not IsServer() then return end
    if not target:IsIllusion() then
        local Player = PlayerResource:GetPlayer(target:GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
modifier_pop_up_parade_invul = class({})
function modifier_pop_up_parade_invul:IsHidden() return false end
function modifier_pop_up_parade_invul:IsDebuff() return true end
function modifier_pop_up_parade_invul:IsPurgable() return false end
function modifier_pop_up_parade_invul:IsPurgeException() return false end
function modifier_pop_up_parade_invul:RemoveOnDeath() return true end
function modifier_pop_up_parade_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_pop_up_parade_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_pop_up_parade_invul:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

modifier_pop_up_parade_buff = class({})
function modifier_pop_up_parade_buff:IsHidden() return false end
function modifier_pop_up_parade_buff:IsDebuff() return true end
function modifier_pop_up_parade_buff:IsPurgable() return false end
function modifier_pop_up_parade_buff:IsPurgeException() return false end
function modifier_pop_up_parade_buff:RemoveOnDeath() return true end
function modifier_pop_up_parade_buff:AllowIllusionDuplicate() return true end

function modifier_pop_up_parade_buff:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND					}
    return func
end
function modifier_pop_up_parade_buff:GetModifierModelChange()
    return "models/shuichi/pop_up_parade.vmdl"
end
function modifier_pop_up_parade_buff:GetModifierModelScale()
	return 1
end
function modifier_pop_up_parade_buff:GetModifierBonusStats_Strength()
    return 100
end

function modifier_pop_up_parade_buff:GetModifierBonusStats_Agility()
    return 100
end

function modifier_pop_up_parade_buff:GetModifierBonusStats_Intellect()
    return 100
end
function modifier_pop_up_parade_buff:GetModifierPreAttack_BonusDamage()
    return 300
end
function modifier_pop_up_parade_buff:GetAttackSound()
return "shuichi.claw"
	
end
function modifier_pop_up_parade_buff:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {                          
                            ["pop_up_parade"] = "pop_up_kick",
							["teddy_hug"] = "pop_up_murder",
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
            self.particle_time =    ParticleManager:CreateParticle("particles/pop_up_parade_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		local delay = 3.5

	Timers:CreateTimer(delay,function()
        EmitSoundOn("shuichi.5_start", self.parent)
		local radius = 1000
		self:PlayEffects(radius)
		local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self.caster,
		damage = 1000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			self.caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 1.5 } -- kv
		)
	end
		end)
		 local HiddenAbilities = 
	{
	
		"shuichi_get_in",
	"shuichi_get_out",
		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_pop_up_parade_buff:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_pop_up_parade_buff:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("pop_up_parade_buff_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
				 local hideit = 
	{
	"shuichi_get_in",
	"shuichi_get_out",
	
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
            end
        end
    end
end

function modifier_pop_up_parade_buff:PlayEffects( radius )
	local particle_cast = "particles/pop_up_parade_shockwave.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end



















pop_up_kick = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function pop_up_kick:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5



if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) 
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
                        knockback_duration = 2,
                        duration = 2,
                        knockback_distance = 500,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
	
	
	
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("shuichi.pop_up_kick", caster)
end
function pop_up_kick:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/shuichi_crit.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end




pop_up_murder = class({})
LinkLuaModifier( "modifier_pop_up_murder", "heroes/shuichi.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pop_up_murder_debuff", "heroes/shuichi.lua" ,LUA_MODIFIER_MOTION_NONE )

function pop_up_murder:GetCastRange( location , target)
	if self:GetCaster():HasItemInInventory("item_power_of_friendship") or self:GetCaster():HasItemInInventory("item_watch") or self:GetCaster():HasItemInInventory("item_octarine_core")  then
		return -150
	end
	return 60
end

function pop_up_murder:GetChannelTime()


	
				return 1.0
			
		end


--------------------------------------------------------------------------------

function pop_up_murder:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function pop_up_murder:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_pop_up_murder", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function pop_up_murder:OnChannelFinish( bInterrupted )
local broke = GameRules:GetGameTime() - self:GetChannelStartTime()
local point = self:GetCaster():GetAbsOrigin()
local damage = self:GetSpecialValueFor( "full_damage" )
local caster = self:GetCaster()

	local radius = 300
	
	local debuffDuration = 1.5

self.broke = 0.9

if broke > self.broke then
local damageTable = {
		victim = self.hVictim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	EmitSoundOn( "shuichi.2", self:GetCaster() )
	self:PlayEffects( point, radius, debuffDuration )
 
	
	end
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_pop_up_murder" )
	end
end
function pop_up_murder:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/shuichi_hug_blood.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
modifier_pop_up_murder = class({})

--------------------------------------------------------------------------------

function modifier_pop_up_murder:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )	
	self.tick_rate = 0.15
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
	
	
end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end

end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:OnIntervalThink()
	if IsServer() then
	local caster = self:GetCaster()
	self:GetCaster():PerformAttack(self:GetParent(), true,
				true,
				true,
				true,
				true,
				false,
				true)
		
		
				
	end
	
end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end
function modifier_pop_up_murder:GetEffectName()

	return "particles/shuichi_hug2.vpcf"

end


function modifier_pop_up_murder:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_pop_up_murder:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end














LinkLuaModifier("modifier_kigurumi_overheat", "heroes/shuichi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_teddy_bear",        "heroes/shuichi", LUA_MODIFIER_MOTION_NONE)

kigurumi_overheat = class({})

function kigurumi_overheat:GetIntrinsicModifierName()
    return "modifier_teddy_bear"
end

function kigurumi_overheat:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function kigurumi_overheat:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("shuichi.overheat")
    caster:AddNewModifier(caster, self, "modifier_kigurumi_overheat", { duration = duration } )
end

modifier_kigurumi_overheat = class({})

function modifier_kigurumi_overheat:IsPurgable()
    return true
end

function modifier_kigurumi_overheat:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
    }

    return funcs
end

function modifier_kigurumi_overheat:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_kigurumi_overheat:GetModifierMoveSpeed_AbsoluteMin()
	 return 550
end

function modifier_kigurumi_overheat:GetEffectName()
    return "particles/shuichi_vaporize.vpcf"
end

function modifier_kigurumi_overheat:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_kigurumi_overheat:GetStatusEffectName()
    return "particles/econ/courier/courier_onibi/courier_onibi_pink_ambient_b.vpcf" 
end

function modifier_kigurumi_overheat:StatusEffectPriority()
    return 5
end


modifier_teddy_bear = class ({})
function modifier_teddy_bear:IsHidden() return true end
function modifier_teddy_bear:IsDebuff() return false end
function modifier_teddy_bear:IsPurgable() return false end
function modifier_teddy_bear:IsPurgeException() return false end
function modifier_teddy_bear:RemoveOnDeath() return false end

function modifier_teddy_bear:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_teddy_bear:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_teddy_bear:OnIntervalThink()
    if IsServer() then
        local lerolero = self:GetParent():FindAbilityByName("kigurumi_overheat")
        if lerolero and not lerolero:IsNull() then
            if self:GetParent():HasScepter() then
                if lerolero:IsHidden() then
                    lerolero:SetHidden(false)
                end
            else
                if not lerolero:IsHidden() then
                    lerolero:SetHidden(true)
                end
            end
        end
    end
end