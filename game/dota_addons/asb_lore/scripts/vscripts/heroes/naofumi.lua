air_shield = class({})
LinkLuaModifier( "modifier_air_shield", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_air_shield_aura", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_air_shield_buff", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_air_shield_charges", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function air_shield:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function air_shield:GetIntrinsicModifierName()
    return "modifier_air_shield_charges"
end
function air_shield:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local target = self:GetCursorTarget()
		local modifier = caster:FindModifierByNameAndCaster("modifier_air_shield_charges",caster)
	local current = modifier:GetStackCount()
	
if current == 2 then
self.sound_target = "naofumi.1"
else
self.sound_target = "naofumi.1_1"
end

	EmitSoundOn( self.sound_target, caster )
if not target then 
	local delay = self:GetSpecialValueFor("duration")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_air_shield", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
	else
	if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
	target:AddNewModifier(self:GetCaster(), self, "modifier_air_shield_buff", {duration = self:GetSpecialValueFor("duration")})
	else
local projectile_name = "particles/air_shield_projectile.vpcf"
	local projectile_speed = 800
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
	end
	end
end
function air_shield:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end
if target == caster then return end
	self:Hit( target, true )
	
	

	

	self:PlayEffects2( hTarget )
end
function air_shield:Hit( target, dragonform )
	local caster = self:GetCaster()
	  local gold = caster:GetGold()
	 
	if target:TriggerSpellAbsorb( self ) then return end

	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_naofumi_25")

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	local knockback = { should_stun = 1,
                        knockback_duration = 0.4,
                        duration = 0.4,
                        knockback_distance = 350,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
	

	
end
function air_shield:PlayEffects2( target )
	-- Get Resources
	local sound_target = "naofumi.1_impact"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

modifier_air_shield_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_air_shield_charges:IsHidden()
	return not self.active
end

function modifier_air_shield_charges:IsDebuff()
	return false
end

function modifier_air_shield_charges:IsPurgable()
	return false
end

function modifier_air_shield_charges:DestroyOnExpire()
	return false
end

function modifier_air_shield_charges:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_air_shield_charges:OnCreated( kv )
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.max_charges = 2
	self.charge_time = self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction()
	self.active = true

	if not IsServer() then return end
	self:SetStackCount( self.max_charges )
	self:CalculateCharge()
end

function modifier_air_shield_charges:OnRefresh( kv )
	-- references
	self.max_charges = 2
	self.charge_time = self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction()

	if not IsServer() then return end
	self:CalculateCharge()
end

function modifier_air_shield_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_air_shield_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_air_shield_charges:OnAbilityFullyCast( params )
	if IsServer() then
	local ability = self:GetParent():FindAbilityByName("air_shield")
		if params.unit~=self:GetParent() or params.ability~=ability then
			return
		end

		self:DecrementStackCount()
		self:CalculateCharge()
	end
end
function modifier_air_shield_charges:GetTexture()
	return "naofumi/1"
end
-----
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_air_shield_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_air_shield_charges:CalculateCharge()
local ability = self:GetParent():FindAbilityByName("air_shield")
	if self.active then
		ability:EndCooldown()
	end
	if self:GetStackCount()>=self.max_charges then
		-- stop charging
		self:SetDuration( -1, false )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time = ability:GetCooldown( -1 ) * self.parent:GetCooldownReduction()
			if self.charge_time and self.active then
				charge_time = self.charge_time
			end
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount()==0 then
			ability:StartCooldown( self:GetRemainingTime() * self.parent:GetCooldownReduction() )
		end
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_air_shield_charges:SetActive( active )
	-- for server
	self.active = active

	-- todo: self.active should be known to client
end



modifier_air_shield = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_air_shield:IsHidden()
	return false
end

function modifier_air_shield:IsDebuff()
	return false
end

function modifier_air_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_air_shield:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "ensnare_duration" )
	self.pit_damage = self:GetAbility():GetSpecialValueFor( "pit_damage" ) + self:GetCaster():FindTalentValue("special_bonus_kumagawa_25")

	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- start interval
	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects()
	
	
		

end

function modifier_air_shield:OnRefresh( kv )
	
end

function modifier_air_shield:OnRemoved()

end
function modifier_air_shield:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end
function modifier_air_shield:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_air_shield:OnIntervalThink()
	-- Using aura's sticky duration doesn't allow it to be purged, so here we are

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	 local knockback = { should_stun = 0,
                        knockback_duration = 0.4,
                        duration = 0.4,
                        knockback_distance = -550,
                        knockback_height = 400,
                        center_x = self.parent:GetAbsOrigin().x,
                        center_y = self.parent:GetAbsOrigin().y,
                        center_z = self.parent:GetAbsOrigin().z }
						if not enemy:HasModifier("modifier_air_shield_cd") then
		enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
		enemy:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_air_shield_cd",
		{duration = 0.5}
	)
	self:Destroy()
	end
		end
	end

function modifier_air_shield:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/air_shield_thinker.vpcf"
	

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetDuration(), 0, 0 ) )

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

modifier_air_shield_cd = class({})
function modifier_air_shield_cd:IsHidden() return true end
function modifier_air_shield_cd:IsDebuff() return false end
function modifier_air_shield_cd:IsPurgable() return false end
function modifier_air_shield_cd:IsPurgeException() return false end
function modifier_air_shield_cd:RemoveOnDeath() return false end
function modifier_air_shield_cd:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,

	}

	return state
end


modifier_air_shield_buff = modifier_air_shield_buff or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end
})

function modifier_air_shield_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_air_shield_buff:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()
		local target_origin = target:GetAbsOrigin()
		local attach_hitloc = "attach_hitloc"

		self.shield_init_value = self:GetAbility():GetSpecialValueFor("damage_absorb")
		self.shield_remaining = self.shield_init_value
		self.target_current_health = target:GetHealth()

		-- Talent : During the first second of Aphotic Shield, it absorbs all damage done to it and adds it to it's health/damage
		

		local particle = ParticleManager:CreateParticle("particles/air_shield_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local common_vector = Vector(shield_size,0,shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)

	
		
	end
end

function modifier_air_shield_buff:OnDestroy()
	if IsServer() then
		local target 				= self:GetParent()
		local caster 				= self:GetCaster()
		local ability 				= self:GetAbility()
		local ability_level 		= ability:GetLevel()
		local radius 				= 400
		local explode_target_team 	= DOTA_UNIT_TARGET_TEAM_BOTH
		local explode_target_type 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_vector			= target:GetAbsOrigin()

		target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		-- Explosion particle is shown by default when the particle is to be removed, however that does not work for illusions. Hence this added explosion is to make the particle show when illusions die
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_vector)
		ParticleManager:ReleaseParticleIndex(particle)

		
	
	end
end


--Block damage
function modifier_air_shield_buff:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local target 					= self:GetParent()
		local original_shield_amount	= self.shield_remaining
		local shield_hit_particle 		= "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf"
		-- Avoid blocking when borrowed time is active						--No need for block when there is no damage
		if not target:HasModifier("modifier_imba_borrowed_time_buff_hot_caster")  and kv.damage > 0 and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then

			if self.has_talent and not self.invulnerability_expired then
				-- damage_absorbtion_end is calculated in OnCreated
				if GameRules:GetGameTime() <= self.damage_absorption_end then
					self.shield_remaining = self.shield_remaining + kv.damage
					original_shield_amount = self.shield_remaining
					-- Increase the max capacity. The if check is just for sanity
					if self.shield_remaining > self.shield_init_value then
						self.shield_init_value = self.shield_remaining
					end
				else
					-- copy-paste of code, but that allows skipping on GetGameTime calls in the if
					self.shield_remaining = self.shield_remaining - kv.damage
					self.invulnerability_expired = true
				end
			else
				--Reduce the amount of shield remaining
				self.shield_remaining = self.shield_remaining - kv.damage
			end


			--If there is enough shield to block everything, then block everything.
			if kv.damage < original_shield_amount then
				--Emit damage blocking effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
				return kv.damage
					--Else, reduce what you can and blow up the shield
			else
				--Emit damage block effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, original_shield_amount, nil)
				self:Destroy()
				return original_shield_amount
			end

		end
	end

end

function modifier_air_shield_buff:ResetAndExtendBy(seconds)
	self.shield_remaining = self.shield_init_value
	self:SetDuration(self:GetRemainingTime() + seconds, true)
end


shield_hero = class({})
LinkLuaModifier( "modifier_shield_hero", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shield_hero_aura", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function shield_hero:GetIntrinsicModifierName()
	return "modifier_shield_hero"
end
function shield_hero:OnHeroLevelUp()
local caster = self:GetCaster()
	local modifier = caster:FindModifierByNameAndCaster("modifier_shield_hero",caster)
	if modifier == nil then return end
	local current = modifier:GetStackCount()
	modifier:SetStackCount(current + 1)
end


modifier_shield_hero = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shield_hero:IsHidden()
	return true
end

function modifier_shield_hero:IsDebuff()
	return false
end

function modifier_shield_hero:IsPurgable()
	return false
end

function modifier_shield_hero:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_shield_hero:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	self.block = self:GetAbility():GetSpecialValueFor( "armor_per_level" )
	self.block2 = self:GetAbility():GetSpecialValueFor( "magic_resist_per_level" )
   self.stack = self:GetStackCount()

	if not IsServer() then return end
	self:SetStackCount(0)
end

function modifier_shield_hero:OnRefresh( kv )
	-- references
	self.block = self:GetAbility():GetSpecialValueFor( "armor_per_level" )
	self.block2 = self:GetAbility():GetSpecialValueFor( "magic_resist_per_level" )
	self.stack = self:GetStackCount()

end

function modifier_shield_hero:OnRemoved()
end

function modifier_shield_hero:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_shield_hero:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
	}

	return funcs
end
function modifier_shield_hero:GetModifierMagicalResistanceBonus()
    return self.block * self.stack
end
function modifier_shield_hero:GetModifierDamageOutgoing_Percentage()
	return -100
end
function modifier_shield_hero:GetModifierPhysicalArmorBonus()
return self.block2 * self.stack
end  
function modifier_shield_hero:OnStackCountChanged(iStackCount)
	if IsServer() then
		self:ForceRefresh()  
		self:OnRefresh()
		end
		end
function modifier_shield_hero:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_shield_hero:GetModifierAura()
	return "modifier_shield_hero_aura"
end

function modifier_shield_hero:GetAuraRadius()
	return 1000
end

function modifier_shield_hero:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_shield_hero:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
modifier_shield_hero_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shield_hero_aura:IsHidden()
	return false
end

function modifier_shield_hero_aura:IsDebuff()
	return false
end

function modifier_shield_hero_aura:IsPurgable()
	return false
end

function modifier_shield_hero_aura:AllowIllusionDuplicate()
	return true
end

function modifier_shield_hero_aura:OnRemoved()
end

function modifier_shield_hero_aura:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_shield_hero_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
	}

	return funcs
end
function modifier_shield_hero_aura:GetModifierMagicalResistanceBonus()
    return 5
end
function modifier_shield_hero_aura:GetModifierPhysicalArmorBonus()
return 5
end









------------------------------

dog_bite = class({})
LinkLuaModifier( "modifier_shield_ability", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_root","modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE)
function dog_bite:GetIntrinsicModifierName()
    return "modifier_shield_ability"
end
function dog_bite:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("chimera_shield")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function dog_bite:IsStealable() return true end
function dog_bite:IsHiddenWhenStolen() return false end
function dog_bite:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function dog_bite:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() 

	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus()
	local width = self:GetSpecialValueFor("width")

	if point == caster:GetOrigin() then
		self:EndCooldown()
		return nil
	end
	
	self.vChainOffset = Vector( 0, 0, 96 )

	self.vStartPosition = caster:GetOrigin()

	local vDirection = self:GetCursorPosition() - self.vStartPosition
	vDirection.z = 0.0

	local vDirection = ( vDirection:Normalized() ) * distance

	self.vTargetPosition = self.vStartPosition + vDirection

	local vChainTarget = self.vTargetPosition + self.vChainOffset
	local vKillswitch = Vector( ( ( distance / speed ) * 2 ), 0, 0 )

	self.chain_particle = 	ParticleManager:CreateParticle( "particles/naofumi_dog_bite.vpcf", PATTACH_CUSTOMORIGIN, caster )
								ParticleManager:SetParticleAlwaysSimulate( self.chain_particle )
								ParticleManager:SetParticleControlEnt( self.chain_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_shield", caster:GetOrigin() + self.vChainOffset, true )
								ParticleManager:SetParticleControl( self.chain_particle, 1, vChainTarget )
								ParticleManager:SetParticleControl( self.chain_particle, 2, Vector( speed, distance, width ) )
								ParticleManager:SetParticleControl( self.chain_particle, 3, vKillswitch )
								ParticleManager:SetParticleControl( self.chain_particle, 4, Vector( 1, 0, 0 ) )
								ParticleManager:SetParticleControl( self.chain_particle, 5, Vector( 0, 0, 0 ) )
								ParticleManager:SetParticleControlEnt( self.chain_particle, 7, caster, PATTACH_CUSTOMORIGIN, nil, caster:GetOrigin(), true )
	
	self.chain_projectile = {	Ability = self,
									vSpawnOrigin = caster:GetOrigin(),
									vVelocity = vDirection:Normalized() * speed,
									fDistance = distance,
									fStartRadius = width,
									fEndRadius = width,
									Source = caster,
									iUnitTargetTeam   = self:GetAbilityTargetTeam(),
									iUnitTargetType   = self:GetAbilityTargetType(),
									iUnitTargetFlags  = self:GetAbilityTargetFlags(),
									bProvidesVision	  = true,
									iVisionRadius	  = width,
									iVisionTeamNumber = caster:GetTeamNumber()}

	ProjectileManager:CreateLinearProjectile(self.chain_projectile)

	EmitSoundOn("naofumi.3_1", caster)

	self.first_hit = false
end
function dog_bite:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		ParticleManager:SetParticleControlEnt( self.chain_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin() + self.vChainOffset, true)
		return nil
	end

	if self.first_hit == false then
		local nFXIndex = 	ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_mid.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
							ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
							ParticleManager:ReleaseParticleIndex( nFXIndex )

		
		local damage_table = {	victim = hTarget,
								attacker = self:GetCaster(),
								damage = self:GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_naofumi_20"),
								damage_type = self:GetAbilityDamageType(),
								ability = self }

		ApplyDamage(damage_table)
		local duration = self:GetSpecialValueFor("duration")
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_root", {duration = duration})
		EmitSoundOn("naofumi.3_1_1", hTarget)
	    EmitSoundOn("naofumi.3_1_1_1", hTarget)
		ParticleManager:SetParticleControlEnt( self.chain_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_shield", self:GetCaster():GetOrigin() + self.vChainOffset, true)
	
		self.first_hit = true
	end
end




modifier_shield_ability = class ({})
function modifier_shield_ability:IsHidden() return true end
function modifier_shield_ability:IsDebuff() return false end
function modifier_shield_ability:IsPurgable() return false end
function modifier_shield_ability:IsPurgeException() return false end
function modifier_shield_ability:RemoveOnDeath() return false end

function modifier_shield_ability:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_shield_ability:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_shield_ability:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("naofumi_fast_heal")
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



chimera_shield = class({})
LinkLuaModifier( "modifier_chimera_poison", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
function chimera_shield:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("meteor_shield")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function chimera_shield:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local sound_cast = "naofumi.3_4"
	EmitSoundOn( sound_cast, target )

		local projectile_name = "particles/test_proj_chimera.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")
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
end

-- Helper
function chimera_shield:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "duration" )

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
		"modifier_chimera_poison", -- modifier name
		{ duration = duration } -- kv
	)
	
	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = "naofumi.3_4_impact"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function chimera_shield:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function chimera_shield:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/chara_blood.vpcf"

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








modifier_chimera_poison = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chimera_poison:IsHidden()
	return false
end

function modifier_chimera_poison:IsDebuff()
	return true
end

function modifier_chimera_poison:IsStunDebuff()
	return false
end

function modifier_chimera_poison:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chimera_poison:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "dot_damage" )
	self.interval = 1

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
		
	end
end

function modifier_chimera_poison:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "dot_damage" )
	self.interval = 1

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



--------------------------------------------------------------------------------
-- Status Effects
function modifier_chimera_poison:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_chimera_poison:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_chimera_poison:GetEffectName()
	return "particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf"
end

function modifier_chimera_poison:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end










------------------------

LinkLuaModifier("modifier_meteor_shield",  "heroes/naofumi", LUA_MODIFIER_MOTION_NONE)

meteor_shield = class({})

function meteor_shield:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end
function meteor_shield:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("soul_eater_shield")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function meteor_shield:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("naofumi.3_2")
    caster:AddNewModifier(caster, self, "modifier_meteor_shield", { duration = duration } )
end






modifier_meteor_shield = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_meteor_shield:IsHidden()
	return true
end

function modifier_meteor_shield:IsDebuff()
	return false
end

function modifier_meteor_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_meteor_shield:OnCreated( kv )
	-- references
	self.reduction_back = self:GetAbility():GetSpecialValueFor( "physical_damage_block" )	
	self.angle_back = 110

self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/naofumi_meteor_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "attach_shield", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "attach_shield", Vector(0,0,0), true)

	self.threshold = 0
end

function modifier_meteor_shield:OnRefresh( kv )
	-- references
	self.reduction_back = self:GetAbility():GetSpecialValueFor( "physical_damage_block" )
	
	self.angle_back = 110


end

function modifier_meteor_shield:OnDestroy( kv )
	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
end
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_meteor_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_meteor_shield:GetModifierPhysical_ConstantBlock( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		local parent = self:GetParent()
		local attacker = params.attacker
		local reduction = 0

		

		-- Check target position
		local facing_direction = parent:GetAnglesAsVector().y
		local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin()):Normalized()
		local attacker_direction = VectorToAngles( attacker_vector ).y
		local angle_diff = AngleDiff( facing_direction, attacker_direction )
		angle_diff = math.abs(angle_diff)

		-- calculate damage reduction
		if angle_diff < (180-self.angle_back) then
			reduction = self.reduction_back
		end

		return reduction
	end
end
function modifier_meteor_shield:GetModifierMagical_ConstantBlock( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		local parent = self:GetParent()
		local attacker = params.attacker
		local reduction = 0

		

		-- Check target position
		local facing_direction = parent:GetAnglesAsVector().y
		local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin()):Normalized()
		local attacker_direction = VectorToAngles( attacker_vector ).y
		local angle_diff = AngleDiff( facing_direction, attacker_direction )
		angle_diff = math.abs(angle_diff)

		-- calculate damage reduction
		if angle_diff < (180-self.angle_back) then
			reduction = self.reduction_back * 0.5
		end

		return reduction
	end
end











----------------------------------------







soul_eater_shield = class({})
LinkLuaModifier( "modifier_soul_eater_shield", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )
function soul_eater_shield:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("shield_book")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
soul_eater_shield.modifiers = {}
function soul_eater_shield:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		caster:Interrupt()
		return
	end

	-- load data
	local duration = self:GetChannelTime()

	-- register modifier (in case for multi-target)
	local modifier = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_soul_eater_shield", -- modifier name
		{ duration = duration } -- kv
	)
	self.modifiers[modifier] = true

	-- play effects
	self.sound_cast = "Naofumi.3_3"
	EmitSoundOn( self.sound_cast, caster )
end

function soul_eater_shield:OnChannelFinish( bInterrupted )
	-- destroy all modifier
	for modifier,_ in pairs(self.modifiers) do
		if not modifier:IsNull() then
			modifier.forceDestroy = bInterrupted
			modifier:Destroy()
		end
	end
	self.modifiers = {}

	-- end sound
	StopSoundOn( self.sound_cast, self:GetCaster() )
end

function soul_eater_shield:Unregister( modifier )
	-- unregister modifier
	self.modifiers[modifier] = nil

	-- check if there are no modifier left
	local counter = 0
	for modifier,_ in pairs(self.modifiers) do
		if not modifier:IsNull() then
			counter = counter+1
		end
	end

	-- stop channelling if no other target exist
	if counter==0 and self:IsChanneling() then
		self:EndChannel( false )
	end
end
modifier_soul_eater_shield = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_soul_eater_shield:IsHidden()
	return false
end

function modifier_soul_eater_shield:IsDebuff()
	return true
end

function modifier_soul_eater_shield:IsStunDebuff()
	return false
end

function modifier_soul_eater_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_soul_eater_shield:OnCreated( kv )
	-- references
	self.mana = self:GetAbility():GetSpecialValueFor( "mana_per_second" )
	self.radius = self:GetAbility():GetSpecialValueFor( "break_distance" )
	self.percent = self:GetAbility():GetSpecialValueFor( "mana_additional_percent" )
	local interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )

	self.mana = self.mana * interval

	if IsServer() then
		self.parent = self:GetParent()

		-- Start interval
		self:StartIntervalThink( interval )

		-- play effects
		self:PlayEffects()
	end
end

function modifier_soul_eater_shield:OnRefresh( kv )
	
end

function modifier_soul_eater_shield:OnRemoved()
end

function modifier_soul_eater_shield:OnDestroy()
	if not IsServer() then return end

	-- unregister if not forced destroy
	if not self.forceDestroy then
		self:GetAbility():Unregister( self )
	end

	-- instantly kill illusion
	if self.parent:IsIllusion() then
		self.parent:Kill( self:GetAbility(), self:GetCaster() )
	end
end

function modifier_soul_eater_shield:OnIntervalThink()
	-- check illusion, magic immune, or invulnerable
	if self.parent:IsMagicImmune() or self.parent:IsInvulnerable() or self.parent:IsIllusion() then
		self:Destroy()
		return
	end

	-- check distance
	if (self:GetParent():GetOrigin()-self:GetCaster():GetOrigin()):Length2D()>self.radius then
		self:Destroy()
		return
	end

	-- check mana
	local mana = self:GetParent():GetMana()
	local mana_max = self:GetParent():GetMaxMana()
	local mana_percent = mana_max * self.percent
	local mana_given = mana_percent + self.mana
	local empty = false
	if mana<mana_given then	
	local mana_drained = mana
	self:GetParent():Script_ReduceMana( mana_drained , self:GetAbility())
	self:GetCaster():GiveMana( mana_drained )
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = mana_given * 0.7,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	else
		local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = mana_given * 0.4,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	self:GetParent():Script_ReduceMana( mana_given,  self:GetAbility() )
	self:GetCaster():GiveMana( mana_given )

	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_soul_eater_shield:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/naofumi_soul_eater_shield.vpcf"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_shield",
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







LinkLuaModifier("modifier_shield_book", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)

shield_book = class({})

function shield_book:IsStealable() return true end
function shield_book:IsHiddenWhenStolen() return false end

function shield_book:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dog_bite")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function shield_book:OnSpellStart()
    local caster = self:GetCaster()

    caster:AddNewModifier(caster, self, "modifier_shield_book", {})

end
---------------------------------------------------------------------------------------------------------------------
modifier_shield_book = class({})
function modifier_shield_book:IsHidden() return false end
function modifier_shield_book:IsDebuff() return true end
function modifier_shield_book:IsPurgable() return false end
function modifier_shield_book:IsPurgeException() return false end
function modifier_shield_book:RemoveOnDeath() return true end
function modifier_shield_book:AllowIllusionDuplicate() return true end


function modifier_shield_book:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

	

    self.skills_table = {
                            
							["shield_book"]="chimera_shield",
							["air_shield"]="dog_bite",
							["shield_hero"]="soul_eater_shield",
							["shield_prison"]="meteor_shield",
							["rage_shield"]="shield_book_close",
							
                        }

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        end
		
           
        
		
      

  
    end
end
function modifier_shield_book:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_shield_book:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("shield_book_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


shield_book_close = class({})

function shield_book_close:IsStealable() return true end
function shield_book_close:IsHiddenWhenStolen() return false end
function shield_book_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_shield_book", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_shield_book", caster)

        --return nil
    end
end
shield_prison = class({})
LinkLuaModifier("modifier_shield_prison_change", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_prison_invul", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_iron_maiden", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_iron_maiden_cd", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield_prison", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield_prison1", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield_prison_check", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shield_prison_enemy", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
function shield_prison:GetBehavior()
	if self:GetCaster():HasModifier("modifier_shield_prison_change") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
		
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
function shield_prison:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_shield_prison_change") then
	return "naofumi/5_3"
	else
	return "naofumi/4"
	end
end
function shield_prison:OnSpellStart()
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    
    self.idiot_prison = self.idiot_prison or {}
	
	if caster:HasModifier("modifier_shield_prison_change") then
	
        local knockback = { should_stun = 0,
                            knockback_duration = 24,
                            duration = 24,
                            knockback_distance = 0,
                            knockback_height = 550,
                            center_x = caster:GetAbsOrigin().x,
                            center_y = caster:GetAbsOrigin().y,
                            center_z = caster:GetAbsOrigin().z }

        local bCheck = false

        local tPrisonCopy = TableCopy(self.idiot_prison)
        for iEntIndex, hPrison in pairs(tPrisonCopy) do
            if not caster:HasShard() then break end
            
            local hTarget = iEntIndex and EntIndexToHScript(iEntIndex)
            if IsNotNull(hTarget) and IsNotNull(hPrison) and hTarget:HasModifier("modifier_shield_prison_enemy") then
                hPrison:AddNewModifier(caster, self, "modifier_knockback", knockback)
                hPrison:AddNewModifier(caster, self, "modifier_kill", {duration = 11})
                hPrison:AddNewModifier(caster, self, "modifier_prison_invul", {duration = 10.9})
                hPrison:AddNewModifier(caster, self, "modifier_shield_prison1", {duration = 16})
                hTarget:AddNewModifier(caster, self, "modifier_iron_maiden", {duration = 12})
                hTarget:AddNewModifier(caster, self, "modifier_shield_prison_enemy", {duration = 16})
                self.idiot_prison[iEntIndex] = nil
                bCheck = true
                print(self.idiot_prison[iEntIndex])
            end
        end
        
        if not caster:HasShard() then
            if IsNotNull(self.idiot) and IsNotNull(self.idiot_prison2) then
                self.idiot_prison2:AddNewModifier(caster, self, "modifier_knockback", knockback)
                self.idiot_prison2:AddNewModifier(caster, self, "modifier_kill", {duration = 11})
                self.idiot_prison2:AddNewModifier(caster, self, "modifier_prison_invul", {duration = 10.9})
                self.idiot_prison2:AddNewModifier(caster, self, "modifier_shield_prison1", {duration = 16})
                self.idiot:AddNewModifier(caster, self, "modifier_iron_maiden", {duration = 12})
                self.idiot:AddNewModifier(caster, self, "modifier_shield_prison_enemy", {duration = 16})
                bCheck = true
            end
        end
         
        if bCheck then
            caster:AddNewModifier(caster, self, "modifier_shield_prison_change", {duration = 12})
            caster:RemoveModifierByNameAndCaster("modifier_star_tier3", caster)
            caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 24})
            caster:AddNewModifier(caster, self, "modifier_iron_maiden_cd", {duration = 160 * self:GetCaster():GetCooldownReduction()})
        end
	
    else
        self.sound_cast = "Naofumi.4"
        EmitSoundOn( self.sound_cast, caster )
	
        if caster:GetTeamNumber() == target:GetTeamNumber() then
            local point = target:GetOrigin()
            local prison = CreateUnitByName("npc_dota_shield_prison", point, true, caster, caster, caster:GetTeamNumber())
            caster:AddNewModifier(caster, self, "modifier_shield_prison_check", {duration = duration})

            prison:AddNewModifier(caster, self, "modifier_shield_prison1", {duration = duration})
            prison:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
            target:AddNewModifier(caster, self, "modifier_shield_prison", {duration = duration})
	
        elseif caster:HasModifier("modifier_rage_shield") or caster:HasModifier("modifier_wraith_shield") then
            if not caster:HasModifier("modifier_iron_maiden_cd") then
                local point = target:GetOrigin()
                self.idiot = target
                self:EndCooldown()
                self.prison = CreateUnitByName("npc_dota_shield_prison", point, true, caster, caster, caster:GetTeamNumber())
                
                caster:AddNewModifier(caster, self, "modifier_shield_prison_change", {duration = 4})
                caster:AddNewModifier(caster, self, "modifier_shield_prison_check", {duration = 16})
                self.prison:AddNewModifier(caster, self, "modifier_shield_prison1", {duration = 16})
                self.prison:AddNewModifier(caster, self, "modifier_kill", {duration = 4})
                self.idiot_prison[target:entindex()] = self.prison
                self.idiot_prison2 = self.prison
                target:AddNewModifier(caster, self, "modifier_shield_prison_enemy", {duration = 16})
	
	
            else
                local point = target:GetOrigin()
                local prison = CreateUnitByName("npc_dota_shield_prison", point, true, caster, caster, caster:GetTeamNumber())
                caster:AddNewModifier(caster, self, "modifier_shield_prison_check", {duration = duration})

                prison:AddNewModifier(caster, self, "modifier_shield_prison1", {duration = duration})
                prison:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
                self.idiot_prison[target:entindex()] = prison
                target:AddNewModifier(caster, self, "modifier_shield_prison_enemy", {duration = duration})
            end
        else
            local point = target:GetOrigin()
            local prison = CreateUnitByName("npc_dota_shield_prison", point, true, caster, caster, caster:GetTeamNumber())
            caster:AddNewModifier(caster, self, "modifier_shield_prison_check", {duration = duration})

            prison:AddNewModifier(caster, self, "modifier_shield_prison1", {duration = duration})
            prison:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
            self.idiot_prison[target:entindex()] = prison
            target:AddNewModifier(caster, self, "modifier_shield_prison_enemy", {duration = duration})
        end
    end
end


modifier_prison_invul = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_prison_invul:IsHidden()
	return false
end

function modifier_prison_invul:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_prison_invul:IsStunDebuff()
	return false
end

function modifier_prison_invul:IsPurgable()
	return false
end

function modifier_prison_invul:RemoveOnDeath()
	return false
end




function modifier_prison_invul:OnRemoved()
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_prison_invul:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end

modifier_iron_maiden_cd = class({})

function modifier_iron_maiden_cd:IsPurgable()
    return false
end
function modifier_iron_maiden_cd:RemoveOnDeath()
    return false
end
function modifier_iron_maiden_cd:IsPurgeException()
    return false
end
function modifier_iron_maiden_cd:IsHidden()
    return false
end


modifier_shield_prison_check = class({})

function modifier_shield_prison_check:IsPurgable()
    return false
end
function modifier_shield_prison_check:RemovedOnDeath()
    return true
end
modifier_shield_prison1 = class({})

function modifier_shield_prison1:IsPurgable()
    return false
end
function modifier_shield_prison1:RemovedOnDeath()
    return true
end
function modifier_shield_prison1:OnCreated( kv )
  
    self:StartIntervalThink(0.1)

  
end
function modifier_shield_prison1:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetParent ()
if not self:GetCaster():IsAlive() then
       self:Destroy()
	   self:GetParent():Kill(self,self:GetCaster())
    end
    end
function modifier_shield_prison1:OnDestroy( kv )
if not IsServer() then return end
  local caster = self:GetCaster()
--caster:RemoveModifierByName("modifier_shield_prison_check")
      
end
function modifier_shield_prison1:GetEffectName()
	return "particles/shield_prison.vpcf"
end

function modifier_shield_prison1:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_shield_prison_change = class({})

function modifier_shield_prison_change:IsPurgable()
    return false
end
function modifier_shield_prison_change:RemovedOnDeath()
    return true
end
function modifier_shield_prison_change:OnCreated( kv )
  
    self:StartIntervalThink(0.1)

  
end
function modifier_shield_prison_change:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetParent ()
if not self:GetCaster():IsAlive()  then
       self:Destroy()
	   
    end
    end
function modifier_shield_prison_change:OnDestroy( kv )
if not IsServer() then return end
  local caster = self:GetCaster()
caster:RemoveModifierByName("modifier_shield_prison_check")
local ability = self:GetAbility()
 ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
      
end
modifier_shield_prison = class({})

function modifier_shield_prison:IsPurgable()
    return false
end

function modifier_shield_prison:OnCreated( kv )
  
    self:StartIntervalThink(0.1)
    self:GetParent():AddNoDraw()
  
end

function modifier_shield_prison:OnIntervalThink()
    if not IsServer() then return end
    local target = self:GetParent ()
if not self:GetCaster():HasModifier("modifier_shield_prison_check") then
       self:Destroy()
    end
    end

function modifier_shield_prison:OnDestroy( kv )
if not IsServer() then return end
  local caster = self:GetCaster()
local point = self:GetCaster():GetAbsOrigin()
 self:GetParent():RemoveNoDraw() 
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
      
end

function modifier_shield_prison:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
		 [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,

    }

    return state
end
function modifier_shield_prison:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
       
        
		
    }

    return funcs
end

function modifier_shield_prison:GetBonusNightVision()
    return -9999999
end
function modifier_shield_prison:GetBonusDayVision()

    return -999999

end


modifier_iron_maiden = class({})

function modifier_iron_maiden:IsPurgable()
    return false
end

function modifier_iron_maiden:OnCreated( kv )
  local caster = self:GetCaster()
  local origin = self:GetParent():GetAbsOrigin()
    self:StartIntervalThink(11)
self:PlayEffects(600, origin)
	
  
end
function modifier_iron_maiden:PlayEffects( radius,origin )

	local particle_cast = "particles/iron_maiden.vpcf"
	local sound_cast = "Naofumi.5_3"
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), sound_cast, self:GetCaster() )
end
function modifier_iron_maiden:OnIntervalThink()
    if not IsServer() then return end
	local caster = self:GetCaster()
    local target = self:GetParent()
	   		  local damageTable = {
		attacker = caster,
		damage = 4000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
		}
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
self.iron_sound = "Naofumi.5_3_death"
	EmitSoundOn( self.iron_sound, caster )
	for _,enemy in pairs(enemies) do
		-- check for normal or inside astral
		if enemy:HasModifier( "modifier_iron_maiden" ) then
		

	
		
				damageTable.victim = enemy

	

				ApplyDamage(damageTable)

			end
		end
	end
	
    

function modifier_iron_maiden:OnDestroy( kv )
if not IsServer() then return end
  local caster = self:GetCaster()
local point = self:GetCaster():GetAbsOrigin()
caster:RemoveModifierByNameAndCaster("modifier_rage_shield", caster)
      
end

function modifier_iron_maiden:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
    }

    return state
end


modifier_shield_prison_enemy = class({})

function modifier_shield_prison_enemy:IsPurgable()
    return false
end

function modifier_shield_prison_enemy:OnCreated( kv )
  local caster = self:GetCaster()
  
    if not IsServer() then return end
    self:GetParent():AddNoDraw()
    self:StartIntervalThink(0.1)
 --Optional.
	
  
end

function modifier_shield_prison_enemy:OnIntervalThink()
    if not IsServer() then return end
	local caster = self:GetCaster()
    local target = self:GetParent()
    
    target:AddNoDraw()
if not self:GetCaster():HasModifier("modifier_shield_prison_check") then
       self:Destroy()
	   else
	   		  local damageTable = {
		attacker = caster,
		damage = 30,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
		}
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- check for normal or inside astral
		if enemy:HasModifier( "modifier_shield_prison_enemy" ) and not enemy:HasModifier("modifier_iron_maiden") then
		

	
		
				damageTable.victim = enemy

	

				ApplyDamage(damageTable)

			end
		end
	end
	end
   
    

function modifier_shield_prison_enemy:OnDestroy( kv )
if not IsServer() then return end
  local caster = self:GetCaster()
local point = self:GetCaster():GetAbsOrigin()
 self:GetParent():RemoveNoDraw() 
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
      
end

function modifier_shield_prison_enemy:CheckState()
    local state = {
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
function modifier_shield_prison_enemy:DeclareFunctions()
    local funcs = {
      	 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
       
        
		
    }

    return funcs
end

function modifier_shield_prison_enemy:GetBonusNightVision()
    return -9999999
end
function modifier_shield_prison_enemy:GetBonusDayVision()

    return -999999

end









-----------------------


LinkLuaModifier("modifier_rage_shield", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wraith_shield", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
rage_shield = class({})

function rage_shield:IsStealable() return true end
function rage_shield:IsHiddenWhenStolen() return false end

function rage_shield:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dog_bite")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rage_shield:OnSpellStart()
    local caster = self:GetCaster()
	if caster:HasModifier("modifier_wraith_shield_activation") then
	self.sound_cast = "Naofumi.5_rage"
	EmitSoundOn( self.sound_cast, caster )
	caster:AddNewModifier(caster, self, "modifier_wraith_shield", {Duration = 30})
    caster:AddNewModifier(caster, self, "modifier_star_tier3", {Duration = 30})
self:PlayEffects2(300)
	else
	if caster:HasScepter() then
	self.sound_cast = "naofumi.5_alt"
	else
self.sound_cast = "Naofumi.5"
end
	EmitSoundOn( self.sound_cast, caster )
    caster:AddNewModifier(caster, self, "modifier_rage_shield", {})
    if caster:HasShard() then
        local hPrison = caster:FindAbilityByName("shield_prison")
        if IsNotNull(hPrison) then
            hPrison:EndCooldown()
        end
    end
self:PlayEffects(300)
end
end
function rage_shield:PlayEffects( radius )

	local particle_cast = "particles/rage_shield_activation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function rage_shield:PlayEffects2( radius )

	local particle_cast = "particles/wraith_shield_activation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_wraith_shield = class({})
function modifier_wraith_shield:IsHidden() return false end
function modifier_wraith_shield:IsDebuff() return true end
function modifier_wraith_shield:IsPurgable() return false end
function modifier_wraith_shield:IsPurgeException() return false end
function modifier_wraith_shield:RemoveOnDeath() return true end
function modifier_wraith_shield:AllowIllusionDuplicate() return true end

function modifier_wraith_shield:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
							 MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
							 	MODIFIER_PROPERTY_HEALTH_BONUS,
	                 }
    return func
end
function modifier_wraith_shield:GetModifierHealthBonus()
    return 1500
end
function modifier_wraith_shield:GetModifierModelChange()

    return "models/naofumi/naofumi_ira_shield.vmdl"

end
function modifier_wraith_shield:GetModifierSpellAmplify_Percentage()
return 30
end
  function modifier_wraith_shield:GetModifierPhysicalArmorBonus()
return 20
end  
  
function modifier_wraith_shield:GetModifierModelScale()

	return 1
	
end
function modifier_wraith_shield:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
 self:StartIntervalThink( 1 )
    self.ability_level = self.ability:GetLevel()

	
    self.skills_table = {
                            
							["shield_book"]="black_gas_burning",							
							["shield_hero"]="wrath_fire",							
							["rage_shield"]="blood_sacrifice",
							
                        }

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        end
		
           
        
		
      

  
    end
end
function modifier_wraith_shield:OnIntervalThink()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	self.damageTable.damage = 6/100*self:GetParent():GetHealth()


		self.damageTable.victim = self:GetParent()
		ApplyDamage( self.damageTable )

		
		
	end
	


function modifier_wraith_shield:GetEffectName()

	return "particles/wraith_shield.vpcf"
	end
function modifier_wraith_shield:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_wraith_shield:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rage_shield_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end
---------------------------------------------------------------------------------------------------------------------
modifier_rage_shield = class({})
function modifier_rage_shield:IsHidden() return false end
function modifier_rage_shield:IsDebuff() return true end
function modifier_rage_shield:IsPurgable() return false end
function modifier_rage_shield:IsPurgeException() return false end
function modifier_rage_shield:RemoveOnDeath() return true end
function modifier_rage_shield:AllowIllusionDuplicate() return true end

function modifier_rage_shield:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                 }
    return func
end
function modifier_rage_shield:GetModifierModelChange()

    return "models/naofumi/naofumi_ira_shield.vmdl"

end
function modifier_rage_shield:GetModifierModelScale()

	return 1
	
end
function modifier_rage_shield:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()

	
    self.skills_table = {
                            
							["shield_book"]="black_gas_burning",							
							["shield_hero"]="wrath_fire",							
							["rage_shield"]="rage_shield_close",
							
                        }

    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  
                end
            end
        end
		
           
        
 self:StartIntervalThink( 1 )
      

  
    end
end
function modifier_rage_shield:OnIntervalThink()
self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	self.damageTable.damage = 4/100*self:GetParent():GetHealth()


		self.damageTable.victim = self:GetParent()
		ApplyDamage( self.damageTable )

		
		
	end
	


function modifier_rage_shield:GetEffectName()

	return "particles/rage_shield_base.vpcf"
	end
function modifier_rage_shield:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_rage_shield:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rage_shield_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	
end


rage_shield_close = class({})

function rage_shield_close:IsStealable() return true end
function rage_shield_close:IsHiddenWhenStolen() return false end
function rage_shield_close:OnSpellStart()
    local caster = self:GetCaster() 

    if caster:FindModifierByNameAndCaster("modifier_rage_shield", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_rage_shield", caster)

        --return nil
    end
end







black_gas_burning = class({})
LinkLuaModifier( "modifier_black_gas_burning_thinker", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function black_gas_burning:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Phase Start


--------------------------------------------------------------------------------
-- Ability Start
function black_gas_burning:OnSpellStart()
	-- release cast effect
	
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("damage")
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		450,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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

	
	end


	local duration = self:GetSpecialValueFor( "pit_duration" )
	
	

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_black_gas_burning_thinker", -- modifier name
		{ duration = duration },		-- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point )

end

--------------------------------------------------------------------------------
function black_gas_burning:PlayEffects( point )

	local sound_cast = "Naofumi.5_2"

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end



modifier_black_gas_burning_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_black_gas_burning_thinker:IsHidden()
	return false
end

function modifier_black_gas_burning_thinker:IsDebuff()
	return false
end

function modifier_black_gas_burning_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_black_gas_burning_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "ensnare_duration" )
	self.pit_damage = self:GetAbility():GetSpecialValueFor( "pit_damage" )

	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- start interval
	self:StartIntervalThink( 0.2 )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects()
	
	
		

end

function modifier_black_gas_burning_thinker:OnRefresh( kv )
	
end

function modifier_black_gas_burning_thinker:OnRemoved()

end

function modifier_black_gas_burning_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_black_gas_burning_thinker:OnIntervalThink()
	-- Using aura's sticky duration doesn't allow it to be purged, so here we are

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- check if not cooldown
		local damage_table = {	victim = enemy, 
									attacker = self:GetCaster(), 
									damage = self.pit_damage, 
									damage_type = DAMAGE_TYPE_MAGICAL,
									--damage_flags = self.ability:GetAbilityTargetFlags(),
									ability = self:GetAbility() }

			ApplyDamage(damage_table)
		end
	end

function modifier_black_gas_burning_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/black_gas_burning1.vpcf"
	local sound_cast = "naofumi.5_2_impact"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetDuration(), 0, 0 ) )

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
	EmitSoundOn( sound_cast, parent )
end








wrath_fire = class({})
LinkLuaModifier( "modifier_wrath_fire", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function wrath_fire:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local projectile_name = "particles/wrath_fire_projectile.vpcf"
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


function wrath_fire:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_wrath_fire",
		{duration = self:GetDuration()}
	)
	local caster = self:GetCaster()
self:Hit(target)
	self:PlayEffects2( hTarget )
	end

function wrath_fire:Hit( target)
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


	
end
--------------------------------------------------------------------------------
function wrath_fire:PlayEffects1()
	-- Get Resources
	local sound_cast = "Naofumi.5_1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function wrath_fire:PlayEffects2()
	-- Get Resources
	local sound_cast = "naofumi.5_1_exp"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end



modifier_wrath_fire = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_wrath_fire:IsHidden()
	return false
end

function modifier_wrath_fire:IsDebuff()
	return true
end

function modifier_wrath_fire:IsStunDebuff()
	return false
end

function modifier_wrath_fire:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_wrath_fire:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_wrath_fire:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_wrath_fire:OnRemoved()
end

function modifier_wrath_fire:OnDestroy()
end

-- Interval Effects
function modifier_wrath_fire:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wrath_fire:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_wrath_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


naofumi_fast_heal = class({})


function naofumi_fast_heal:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local hp = target:GetMaxHealth()
	local heal = hp * 0.2 + 1000



	-- heal
	target:Heal( heal, self )
	
self:PlayEffects(target)
	local sound_cast = "Naofumi.6"
	EmitSoundOn( sound_cast, target )
end
function naofumi_fast_heal:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/naofumi_shield_heal.vpcf"



	
	
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
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end





blood_sacrifice = class({})
LinkLuaModifier("modifier_blood_sacrifice_enemy", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blood_sacrifice_self", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_prison_damage", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_prison_invul", "heroes/naofumi.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blood_sacrifice_debuff", "heroes/naofumi", LUA_MODIFIER_MOTION_NONE)

function blood_sacrifice:OnSpellStart()
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
	caster:RemoveModifierByNameAndCaster("modifier_star_tier3", caster)
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 7})
	target:AddNewModifier(caster, self, "modifier_blood_sacrifice_enemy", {duration = 6.2})
	caster:AddNewModifier(caster, self, "modifier_blood_sacrifice_self", {duration = 6.2})
		caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 24})
		self.sound_cast = "Naofumi.5_4"
	EmitSoundOn( self.sound_cast, caster )
	end
	







modifier_blood_sacrifice_enemy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_sacrifice_enemy:IsHidden()
	return false
end

function modifier_blood_sacrifice_enemy:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_blood_sacrifice_enemy:IsStunDebuff()
	return true
end

function modifier_blood_sacrifice_enemy:IsPurgable()
	return false
end

function modifier_blood_sacrifice_enemy:RemoveOnDeath()
	return false
end




function modifier_blood_sacrifice_enemy:OnRemoved()
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_blood_sacrifice_enemy:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end

function modifier_blood_sacrifice_enemy:OnDestroy()
local caster = self:GetCaster()
local knockback = { should_stun = 1,
                        knockback_duration = 4,
                        duration = 4,
                        knockback_distance = 0,
                        knockback_height = 3000,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:GetParent():AddNewModifier(caster, self, "modifier_prison_damage", {duration = 1.65})
	self:GetParent():AddNewModifier(caster, self, "modifier_prison_invul", {duration = 1.64})
	self:PlayEffects(600)
end
function modifier_blood_sacrifice_enemy:PlayEffects( radius )
	self.sound_cast = "Naofumi.5_4_close"
	EmitSoundOn( self.sound_cast, self:GetParent() )
	local particle_cast = "particles/blood_sacrifice.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_prison_damage = class({})

--------------------------------------------------------------------------------

function modifier_prison_damage:IsDebuff()
	return true
end
function modifier_prison_damage:IsPurgable()
	return false
end
function modifier_prison_damage:IsStunDebuff()
	return true
end
function modifier_prison_damage:OnDestroy()	
self.damage = 10000	
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )


end

modifier_blood_sacrifice_self = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_sacrifice_self:IsHidden()
	return false
end

function modifier_blood_sacrifice_self:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_blood_sacrifice_self:IsStunDebuff()
	return true
end

function modifier_blood_sacrifice_self:IsPurgable()
	return false
end

function modifier_blood_sacrifice_self:RemoveOnDeath()
	return false
end




function modifier_blood_sacrifice_self:OnCreated()
self:PlayEffects2()
end


function modifier_blood_sacrifice_self:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_blood_sacrifice_self:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_blood_sacrifice_self:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end

function modifier_blood_sacrifice_self:OnDestroy()
local caster = self:GetCaster()
local damage = caster:GetHealth() * 0.6
self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(),
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
		self.damageTable.victim = self:GetCaster()
		ApplyDamage( self.damageTable )
		self:PlayEffects()
		self:GetParent():AddNewModifier(caster, self, "modifier_blood_sacrifice_debuff", {duration = 15})
end
function modifier_blood_sacrifice_self:PlayEffects( radius )

	local particle_cast = "particles/iron_maiden_blood.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_blood_sacrifice_self:PlayEffects2( radius )

	local particle_cast = "particles/naofumi_glist_effects.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
modifier_blood_sacrifice_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blood_sacrifice_debuff:IsHidden()
	return false
end

function modifier_blood_sacrifice_debuff:IsDebuff()
	return true
end

function modifier_blood_sacrifice_debuff:IsStunDebuff()
	return false
end
function modifier_blood_sacrifice_debuff:DeclareFunctions()
    local funcs = {
        
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
    }

    return funcs
end

function modifier_blood_sacrifice_debuff:GetModifierBonusStats_Strength()
    return -self.str
end

function modifier_blood_sacrifice_debuff:GetModifierBonusStats_Agility()
    return -self.agi
end

function modifier_blood_sacrifice_debuff:GetModifierBonusStats_Intellect()
    return -self.int
end
function modifier_blood_sacrifice_debuff:IsPurgable()
	return false
end

function modifier_blood_sacrifice_debuff:RemoveOnDeath()
	return false
end

function modifier_blood_sacrifice_debuff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
 self.str = self.parent:GetBaseStrength() * 0.5
 self.int = self.parent:GetBaseIntellect() * 0.5
 self.agi = self.parent:GetBaseAgility() * 0.5
end