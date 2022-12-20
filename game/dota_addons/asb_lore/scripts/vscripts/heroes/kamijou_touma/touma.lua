touma_base_combo = class({})
LinkLuaModifier( "modifier_touma_base_combo", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "modifiers/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_touma_base_combo_2nd", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_touma_3rd_base_combo_2nd", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_touma_3rd_base_combo_alt_end", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_right_hand_lover", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_touma_physical_buff", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_BOTH )
function touma_base_combo:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_touma_base_combo") then
	return "touma/1_1"
	elseif caster:HasModifier("modifier_touma_3rd_base_combo") then
	return "touma/1_2"
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_alt") then
	return "touma/1_3"
	else
	return "touma/1"
	end
end
function touma_base_combo:GetIntrinsicModifierName()
    return "modifier_right_hand_lover"
end
--------------------------------------------------------------------------------
-- Ability Start
function touma_base_combo:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	self.damage = self:GetSpecialValueFor("base_damage")
	self.radius = self:GetSpecialValueFor("radius")
	--end
	if caster:HasModifier("modifier_touma_base_combo") then
	self:BaseCombo(point)
	elseif caster:HasModifier("modifier_touma_3rd_base_combo") then
	self:ThirdCombo(point)
	caster:RemoveModifierByName("modifier_touma_3rd_base_combo")
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_alt") then
		self:ThirdComboAlt(point)
	caster:RemoveModifierByName("modifier_touma_3rd_base_combo_alt")
	else
	self:BaseComboStart(point)
	
	end
end
function touma_base_combo:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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


function touma_base_combo:ThirdCombo(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_touma_3rd_base_combo_2nd", -- modifier name
			{ duration = 0.5 } -- kv
		)
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			

			-- knockback if not having spear stun
			local knockback = { should_stun = 1,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 0,
                        knockback_height = 100,
                        center_x = enemy:GetAbsOrigin().x,
                        center_y = enemy:GetAbsOrigin().y,
                        center_z = enemy:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
	
damageTable.victim = enemy
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			self:PlayEffects(enemy)
			self:PlayEffects6( caught, caster:GetForwardVector(),enemy:GetOrigin() )
		end
	end

	
	self:EndCooldown()
	
	end
	
	function touma_base_combo:ThirdComboAlt(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK)
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_touma_3rd_base_combo_alt_end", -- modifier name
			{ duration = 1.0 } -- kv
		)
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			

			-- knockback if not having spear stun
			local knockback = { should_stun = 0,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 0,
                        knockback_height = 100,
                        center_x = enemy:GetAbsOrigin().x,
                        center_y = enemy:GetAbsOrigin().y,
                        center_z = enemy:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end

damageTable.victim = enemy
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			self:PlayEffects(enemy)
			
		end
	end

	self:PlayEffects1( caught, caster:GetForwardVector() )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.3rd_alt_combo_voiceline", self:GetCaster() )
	
	end
function touma_base_combo:BaseComboStart(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK)
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_touma_base_combo", -- modifier name
			{ duration = 1.5 } -- kv
		)
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			

			-- knockback if not having spear stun
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 25,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
	
damageTable.victim = enemy
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			self:PlayEffects(enemy)
		end
	end

	self:PlayEffects1( caught, caster:GetForwardVector() )
	self:EndCooldown()
	
	end


function touma_base_combo:BaseCombo(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_AMBUSH)
caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_touma_base_combo_2nd", -- modifier name
			{ duration = 1.0 } -- kv
		)
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			

			-- knockback if not having spear stun
			local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 25,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end

damageTable.victim = enemy
		ApplyDamage(damageTable)
			caught = true
			-- play effects
			
		end
	end

	self:PlayEffects2( caught, caster:GetForwardVector() )
end

--------------------------------------------------------------------------------
-- Play Effects
function touma_base_combo:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_start.vpcf"
	local sound_cast = "touma.1_fail"
	if caught then
		local sound_cast = "touma.1"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function touma_base_combo:PlayEffects3( caught, direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_start.vpcf"
	local sound_cast = "touma.1_fail"
	if caught then
		local sound_cast = "touma.1"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function touma_base_combo:PlayEffects2( caught, direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_2nd.vpcf"
	local sound_cast = "touma.1_fail"
	if caught then
		local sound_cast = "touma.1_1"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function touma_base_combo:PlayEffects6( caught, direction,origin )
	-- Get Resources
	local particle_cast = "particles/touma_3_alt_combo_2nd.vpcf"
	local sound_cast = "touma.1_fail"
	if caught then
		local sound_cast = "touma.1_2"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_right_hand_lover = class ({})
function modifier_right_hand_lover:IsHidden() return true end
function modifier_right_hand_lover:IsDebuff() return false end
function modifier_right_hand_lover:IsPurgable() return false end
function modifier_right_hand_lover:IsPurgeException() return false end
function modifier_right_hand_lover:RemoveOnDeath() return false end

function modifier_right_hand_lover:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_right_hand_lover:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_right_hand_lover:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	
    }

    return funcs
end
function modifier_right_hand_lover:OnAbilityFullyCast( params )
	if IsServer() then
	if self:GetCaster():HasTalent("special_bonus_touma_25") then
	local ability = self:GetParent():FindAbilityByName("touma_base_combo")

	local ability3 = self:GetParent():FindAbilityByName("touma_second_combo")
		if params.unit~=self:GetParent() then
		return end
		if params.ability == ability or params.ability == ability3 then
		
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_touma_physical_buff", -- modifier name
		{duration = 2.0} -- kv
	)
	end
	end
	end
end
function modifier_right_hand_lover:GetModifierBaseAttackTimeConstant()
	return 2.0
end
function modifier_right_hand_lover:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("touma_dragon_strike")
       	if self:GetParent():HasModifier("modifier_touma_arm_loss") then
			vongolle:SetActivated(true)
			end
     	
		   local vongolle2 = self:GetParent():FindAbilityByName("touma_gender_equality_combo")
        if vongolle2 and not vongolle2:IsNull() then
            if self:GetParent():HasScepter() and not self:GetParent():HasModifier("modifier_touma_gender_equality_combo_true") then
                if vongolle2:IsHidden() then
                    vongolle2:SetHidden(false)
					vongolle2:SetLevel(1)
                end
            else
                if not vongolle2:IsHidden() then
                    vongolle2:SetHidden(true)
                end
            end
        end
		
    end
	
	
end

modifier_touma_base_combo = class({})
function modifier_touma_base_combo:IsHidden() return true end
function modifier_touma_base_combo:IsDebuff() return false end
function modifier_touma_base_combo:IsPurgable() return false end
function modifier_touma_base_combo:IsPurgeException() return false end
function modifier_touma_base_combo:RemoveOnDeath() return true end

function modifier_touma_base_combo:OnDestroy()
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end
 
 
 modifier_touma_physical_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_touma_physical_buff:IsHidden()
	return false
end

function modifier_touma_physical_buff:IsDebuff()
	return true
end

function modifier_touma_physical_buff:IsStunDebuff()
	return false
end

function modifier_touma_physical_buff:IsPurgable()
	return true
end

function modifier_touma_physical_buff:OnCreated( kv )
 if IsServer() then
self:SetStackCount(1)
end
end
function modifier_touma_physical_buff:OnRefresh( kv )
 if IsServer() then
local stack = self:GetStackCount()
if stack > 10 then
self:SetStackCount(10)
else
self:SetStackCount(stack + 1)
end
end
end

function modifier_touma_physical_buff:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_touma_physical_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

	}

	return funcs
end
function modifier_touma_physical_buff:GetModifierPreAttack_BonusDamage(keys)
 
	return 30 * self:GetStackCount()
end

 
 modifier_touma_base_combo_end = class({})
function modifier_touma_base_combo_end:IsHidden() return true end
function modifier_touma_base_combo_end:IsDebuff() return false end
function modifier_touma_base_combo_end:IsPurgable() return false end
function modifier_touma_base_combo_end:IsPurgeException() return false end
function modifier_touma_base_combo_end:RemoveOnDeath() return true end

 
  modifier_touma_base_combo_2nd = class({})
function modifier_touma_base_combo_2nd:IsHidden() return true end
function modifier_touma_base_combo_2nd:IsDebuff() return false end
function modifier_touma_base_combo_2nd:IsPurgable() return false end
function modifier_touma_base_combo_2nd:IsPurgeException() return false end
function modifier_touma_base_combo_2nd:RemoveOnDeath() return true end

 
 
 
 
 
  modifier_touma_alt_combo = class({})
function modifier_touma_alt_combo:IsHidden() return true end
function modifier_touma_alt_combo:IsDebuff() return false end
function modifier_touma_alt_combo:IsPurgable() return false end
function modifier_touma_alt_combo:IsPurgeException() return false end
function modifier_touma_alt_combo:RemoveOnDeath() return true end

  modifier_touma_gender_equality_base = class({})
function modifier_touma_gender_equality_base:IsHidden() return true end
function modifier_touma_gender_equality_base:IsDebuff() return false end
function modifier_touma_gender_equality_base:IsPurgable() return false end
function modifier_touma_gender_equality_base:IsPurgeException() return false end
function modifier_touma_gender_equality_base:RemoveOnDeath() return true end
function modifier_touma_gender_equality_base:CheckState()
	local state = { 
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	--[MODIFIER_STATE_MUTED] = true,
		--[MODIFIER_STATE_SILENCED] = true,
	
	
	}
    

    return state
end

function modifier_touma_alt_combo:OnDestroy() 
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end 
 
   modifier_touma_3rd_base_combo_alt_end = class({})
function modifier_touma_3rd_base_combo_alt_end:IsHidden() return true end
function modifier_touma_3rd_base_combo_alt_end:IsDebuff() return false end
function modifier_touma_3rd_base_combo_alt_end:IsPurgable() return false end
function modifier_touma_3rd_base_combo_alt_end:IsPurgeException() return false end
function modifier_touma_3rd_base_combo_alt_end:RemoveOnDeath() return true end

  modifier_touma_alt_combo_end = class({})
function modifier_touma_alt_combo_end:IsHidden() return true end
function modifier_touma_alt_combo_end:IsDebuff() return false end
function modifier_touma_alt_combo_end:IsPurgable() return false end
function modifier_touma_alt_combo_end:IsPurgeException() return false end
function modifier_touma_alt_combo_end:RemoveOnDeath() return true end

  modifier_touma_3rd_base_combo = class({})
function modifier_touma_3rd_base_combo:IsHidden() return true end
function modifier_touma_3rd_base_combo:IsDebuff() return false end
function modifier_touma_3rd_base_combo:IsPurgable() return false end
function modifier_touma_3rd_base_combo:IsPurgeException() return false end
function modifier_touma_3rd_base_combo:RemoveOnDeath() return true end
 function modifier_touma_3rd_base_combo:OnDestroy() 
 if IsServer() then
local ability = self:GetAbility()
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
end
 end 
 
  modifier_touma_3rd_base_combo_2nd = class({})
function modifier_touma_3rd_base_combo_2nd:IsHidden() return true end
function modifier_touma_3rd_base_combo_2nd:IsDebuff() return false end
function modifier_touma_3rd_base_combo_2nd:IsPurgable() return false end
function modifier_touma_3rd_base_combo_2nd:IsPurgeException() return false end
function modifier_touma_3rd_base_combo_2nd:RemoveOnDeath() return true end
 
function modifier_touma_3rd_base_combo_2nd:OnCreated() 
 if IsServer() then
local ability = self:GetParent():FindAbilityByName("touma_second_combo")
ability:EndCooldown()
end
 end
function modifier_touma_3rd_base_combo_2nd:OnDestroy() 
 if IsServer() then
local ability = self:GetParent():FindAbilityByName("touma_second_combo")
ability:StartCooldown(ability:GetCooldown(-1)* self:GetParent():GetCooldownReduction())
 end
 end

  modifier_imagine_breaker_weaken = class({})
function modifier_imagine_breaker_weaken:IsHidden() return true end
function modifier_imagine_breaker_weaken:IsDebuff() return false end
function modifier_imagine_breaker_weaken:IsPurgable() return false end
function modifier_imagine_breaker_weaken:IsPurgeException() return false end
function modifier_imagine_breaker_weaken:RemoveOnDeath() return true end


  modifier_touma_3rd_base_combo_alt = class({})
function modifier_touma_3rd_base_combo_alt:IsHidden() return true end
function modifier_touma_3rd_base_combo_alt:IsDebuff() return false end
function modifier_touma_3rd_base_combo_alt:IsPurgable() return false end
function modifier_touma_3rd_base_combo_alt:IsPurgeException() return false end
function modifier_touma_3rd_base_combo_alt:RemoveOnDeath() return true end


  modifier_touma_3rd_base_combo_end = class({})
function modifier_touma_3rd_base_combo_end:IsHidden() return true end
function modifier_touma_3rd_base_combo_end:IsDebuff() return false end
function modifier_touma_3rd_base_combo_end:IsPurgable() return false end
function modifier_touma_3rd_base_combo_end:IsPurgeException() return false end
function modifier_touma_3rd_base_combo_end:RemoveOnDeath() return true end
 
 
 touma_imagine_breaker = class({})
LinkLuaModifier( "modifier_touma_imagine_breaker", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "modifiers/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imagine_breaker_weaken", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
function touma_imagine_breaker:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_touma_base_combo_end") then
	return "touma/2_1"
	elseif caster:HasModifier("modifier_touma_alt_combo_end") then
	return "touma/2_2"
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_end") then
	return "touma/2_3"
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_alt_end") then
	return "touma/2_4"
	else
	return "touma/2"
	end
end
--------------------------------------------------------------------------------
-- Ability Start
function touma_imagine_breaker:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin1 = caster:GetOrigin()
	local point = caster:GetOrigin()
	
	
	
	if caster:HasModifier("modifier_touma_base_combo_end") then
	self:BaseCombo(point)
	
	elseif caster:HasModifier("modifier_touma_alt_combo_end") then
	self:AltCombo(point)
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_end") then
	self:ThirdCombo(point)
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_alt_end") then
	self:AltThirdCombo(point)
	else
	self:EndCooldown()
	if caster:HasScepter() then
	caster:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imagine_breaker_weaken", -- modifier name
		{duration = 4.0} -- kv
	)
	end
	end
	
end
function touma_imagine_breaker:ThirdCombo(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
self.damage = self:GetSpecialValueFor("base_damage")
	self.radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			enemy:RemoveModifierByName("modifier_knockback")

			-- knockback if not having spear stun
			local knockback = { should_stun = 0,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 300,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
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
				if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 1.0} -- kv
	)
	end
			caught = true
			-- play effects
			self:PlayEffects1( caught, caster:GetForwardVector(), enemy )
			break
		end
	end

	
end

function touma_imagine_breaker:AltThirdCombo(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK_SPECIAL)
self.damage = self:GetSpecialValueFor("base_damage")
	self.radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			enemy:RemoveModifierByName("modifier_knockback")

			-- knockback if not having spear stun
			local knockback = { should_stun = 1,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 0,
                        knockback_height = 800,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
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
				if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 1.0} -- kv
	)
	end
			caught = true
			-- play effects
			self:PlayEffects5( enemy,caught )
			break
		end
	end

	
end

function touma_imagine_breaker:BaseCombo(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
self.damage = self:GetSpecialValueFor("base_damage")
	self.radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			enemy:RemoveModifierByName("modifier_knockback")

			-- knockback if not having spear stun
			local knockback = { should_stun = 0,
                        knockback_duration = 0.5,
                        duration = 0.5,
                        knockback_distance = 400,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
if not enemy:IsCreep() then
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
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
				if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 1.0} -- kv
	)
	end
			caught = true
			-- play effects
			self:PlayEffects1( caught, caster:GetForwardVector(), enemy )
			break
		end
	end

	
end

function touma_imagine_breaker:AltCombo(point)
local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
self.damage = self:GetSpecialValueFor("base_damage")
	self.radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
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




	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = caster:GetForwardVector()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	for _,enemy in pairs(enemies) do
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
			enemy:RemoveModifierByName("modifier_knockback")
damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{duration = 0.5} -- kv
	)
				if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then

		enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 1.0} -- kv
	)
	end
			-- play effects
			
		end
		self:PlayEffects4(400)
	end

function touma_imagine_breaker:PlayEffects4( radius )

	local particle_cast = "particles/touma_imagine_breaker_ground_pound.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.imagine", self:GetCaster() )
end

function touma_imagine_breaker:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/dev/library/base_dust_hit.vpcf"



	
	
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

EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.imagine", self:GetCaster() )
end

function touma_imagine_breaker:PlayEffects5( target,caught )
	-- Load effects
	local particle_cast = "particles/touma_3_alt_combo_end_air.vpcf"
self.sound_cast12 = "touma.1_fail"
	if caught then
		self.sound_cast12 = "touma.imagine"
	end


	
	
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

EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), self.sound_cast12, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Play Effects
function touma_imagine_breaker:PlayEffects1( caught, direction,target )
	-- Get Resources
	self.particle_cast11 = "particles/touma_base_combo_start.vpcf"
	self.sound_cast11 = "touma.1_fail"
	if caught then
	self.particle_cast11 = "particles/touma_imagine_breaker_base_combo_end.vpcf"
		self.sound_cast11 = "touma.imagine"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( self.particle_cast11, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), self.sound_cast11, self:GetCaster() )
end
function touma_imagine_breaker:PlayEffects3( caught, direction )
	-- Get Resources
	local particle_cast = "particles/touma_imagine_breaker_start.vpcf"
	local sound_cast = "touma.1_fail"
	if not caught then
		local sound_cast = "touma.1"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function touma_imagine_breaker:PlayEffects2( caught, direction )
	-- Get Resources
	local particle_cast = "particles/touma_imagine_breaker_2nd.vpcf"
	local sound_cast = "touma.1_fail"
	if not caught then
		local sound_cast = "touma.1_1"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end


touma_second_combo = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_base_combo_end", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_alt_combo", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_alt_combo_end", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_3rd_base_combo", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_3rd_base_combo_end", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_3rd_base_combo_alt", "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV

function touma_second_combo:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_touma_base_combo_2nd") then
	return "touma/3_1"
	elseif caster:HasModifier("modifier_touma_base_combo") then
	return "touma/3_2"
	elseif caster:HasModifier("modifier_touma_alt_combo") then
	return "touma/3_3"
	elseif caster:HasModifier("modifier_touma_3rd_base_combo") then
	return "touma/3_4"
	elseif caster:HasModifier("modifier_touma_3rd_base_combo_2nd") then
	return "touma/3_5"
	else
	return "touma/3"
	end
end
--------------------------------------------------------------------------------
-- Ability Start
function touma_second_combo:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- check dragon modifier

	-- check if simple form


		-- directly hit
		if caster:HasModifier("modifier_touma_base_combo_2nd") then
		self:Hit2(target)
		elseif caster:HasModifier("modifier_touma_base_combo") then
		self:Hit3(target)
		caster:RemoveModifierByName("modifier_touma_base_combo")
		elseif caster:HasModifier("modifier_touma_alt_combo") then
		self:Hit4(target)
		caster:RemoveModifierByName("modifier_touma_alt_combo")
		elseif caster:HasModifier("modifier_touma_3rd_base_combo") then 
		caster:RemoveModifierByName("modifier_touma_3rd_base_combo")
		self:Hit6(target)
		elseif caster:HasModifier("modifier_touma_3rd_base_combo_2nd") then
		caster:RemoveModifierByName("modifier_touma_3rd_base_combo_2nd")
		self:Hit5(target)
		else
		self:Hit( target)
end
end

-- Helper
function touma_second_combo:Hit( target )
	local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_touma_3rd_base_combo", -- modifier name
		{ duration = 1.0 } -- kv
	)
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

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

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 0.2 } -- kv
	)
caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = "touma.3"
	EmitSoundOn( sound_cast, target )
	self:EndCooldown()
end
function touma_second_combo:Hit2( target )
	local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	-- cancel if linken
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_touma_base_combo_end", -- modifier name
		{ duration = 1.0 } -- kv
	)
	if target:TriggerSpellAbsorb( self ) then return end

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

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 0.2 } -- kv
	)
caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = "touma.3"
	
	EmitSoundOn( sound_cast, target )
	EmitSoundOn( "touma.3_base_voice", caster )
end

function touma_second_combo:Hit3( target )
	local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_ATTACK2)
	-- cancel if linken
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_touma_alt_combo", -- modifier name
		{ duration = 1.0 } -- kv
	)
	if target:TriggerSpellAbsorb( self ) then return end

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

	-- stun
	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = 0.2 } -- kv
	)

	-- Play effects
	self:PlayEffects3( target, dragonform )
	local sound_cast = "touma.3_2"
	
	EmitSoundOn( sound_cast, target )
self:EndCooldown()
end
function touma_second_combo:Hit4( target )
	local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	-- cancel if linken
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_touma_alt_combo_end", -- modifier name
		{ duration = 1.0 } -- kv
	)
	if target:TriggerSpellAbsorb( self ) then return end

	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
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
		"modifier_stunned", -- modifier name
		{ duration = 0.2 } -- kv
	)

	-- Play effects
	self:PlayEffects5( target, dragonform )
	local sound_cast = "touma.3_3"
	
	EmitSoundOn( sound_cast, target )
	local sound_cast2 = "touma.alt_combo_voiceline"
	
	EmitSoundOn( sound_cast2, target )

end
function touma_second_combo:Hit5( target )
	local caster = self:GetCaster()
	self:PlayEffects10(300)
    caster:StartGesture(ACT_DOTA_CAST_COLD_SNAP)
	-- cancel if linken
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_touma_3rd_base_combo_end", -- modifier name
		{ duration = 1.0 } -- kv
	)
	if target:TriggerSpellAbsorb( self ) then return end

	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
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
		"modifier_stunned", -- modifier name
		{ duration = 0.2 } -- kv
	)

	-- Play effects
	self:PlayEffects9( target, dragonform )
	local sound_cast = "touma.3_4"
	
	EmitSoundOn( sound_cast, target )
	local sound_cast2 = "touma.3rd_combo_voiceline"
	
	EmitSoundOn( sound_cast2, target )

end
function touma_second_combo:Hit6( target )
	local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_ATTACK2)
caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_touma_3rd_base_combo_alt", -- modifier name
		{ duration = 1.0 } -- kv
	)
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage * 0.5,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	

	-- Play effects
	self:PlayEffects3( target, dragonform )
	local sound_cast = "touma.3_3"
	EmitSoundOn( sound_cast, target )
end
function touma_second_combo:PlayEffects10( radius )

	local particle_cast = "particles/vergil_blur.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

--------------------------------------------------------------------------------
function touma_second_combo:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/touma_3_base_combo.vpcf"

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
function touma_second_combo:PlayEffects9( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/touma_3rd_combo_fly_crit.vpcf"

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
function touma_second_combo:PlayEffects3( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/touma_3_alt_combo.vpcf"

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
function touma_second_combo:PlayEffects5( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/touma_3_alt_combo_2nd.vpcf"

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








LinkLuaModifier("modifier_touma_imagine_breaker_counter",  "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_punch_invul",  "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_punch_impact",  "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_touma_arm_loss",  "heroes/kamijou_touma/touma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_silenced_lua",  "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE)

touma_imagine_breaker_counter = class({})
function touma_imagine_breaker_counter:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("touma_arm_grow")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function touma_imagine_breaker_counter:GetChannelTime()
if IsServer() then

local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_touma_20") then
		return 3.0
	else
				return 2.0
				
			end
		end
		end
function touma_imagine_breaker_counter:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function touma_imagine_breaker_counter:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("touma.4")
    caster:AddNewModifier(caster, self, "modifier_touma_imagine_breaker_counter", { duration = duration } )
end

function touma_imagine_breaker_counter:OnChannelFinish( bInterrupted )
   if IsServer() then
	 self:GetCaster():Purge(false, true, false, true, true)
	self:GetCaster():RemoveModifierByName("modifier_touma_imagine_breaker_counter")
end
end



modifier_touma_imagine_breaker_counter = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_touma_imagine_breaker_counter:IsHidden()
	return false
end

function modifier_touma_imagine_breaker_counter:IsDebuff()
	return false
end

function modifier_touma_imagine_breaker_counter:IsPurgable()
	return false
end

function modifier_touma_imagine_breaker_counter:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_touma_imagine_breaker_counter:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	self.block = self:GetAbility():GetSpecialValueFor( "damage_absord_limit" )
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_absord_limit" )
    self.reset = 2.0
 
	if not IsServer() then return end
	self.damage = 0
end

function modifier_touma_imagine_breaker_counter:OnRefresh( kv )
	-- references
	self.block = self:GetAbility():GetSpecialValueFor( "damage_absord_limit" )
	self.purge = self:GetAbility():GetSpecialValueFor( "damage_absord_limit" )
	
end
function modifier_touma_imagine_breaker_counter:GetEffectName()
	return "particles/touma_imagine_breaker_counter_visual.vpcf"
end

function modifier_touma_imagine_breaker_counter:OnRemoved()
end

function modifier_touma_imagine_breaker_counter:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_touma_imagine_breaker_counter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
	}

	return funcs
end

function modifier_touma_imagine_breaker_counter:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self.parent then return end
	if self.parent:PassivesDisabled() then return end
local caster = self:GetCaster()
	-- only player-based damage
	if not params.attacker:GetPlayerOwner() then return end

	-- start interval
	self:StartIntervalThink( self.reset )

	-- check if purge
	self.damage = self.damage + params.damage
	if self.damage < self.purge then
	self.point = params.attacker:GetOrigin()
	self.point2 = self:GetParent():GetOrigin()
	local ability = self:GetParent():FindAbilityByName("touma_dragon_strike")
	local distance = (self.point2 - self.point):Length2D()
	if self.damage > 700 and self.damage < self.block and  distance < 1400 then
	if caster:HasScepter() and
   ability and not ability:IsNull() and not ability:IsHidden() and  ability:IsFullyCastable() then
	self.damage = 0

	-- purge
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_touma_arm_loss", -- modifier name
		{} -- kv
	)
	self:GetCaster():RemoveModifierByName("modifier_touma_gender_equality_combo_true")
	self:GetCaster():RemoveModifierByName("modifier_touma_imagine_breaker_counter")
	else
	self:GetParent():InterruptChannel()
	local scale = self:GetAbility():GetSpecialValueFor("agi_scale")
	local agi = self:GetCaster():GetAgility() * scale
	local damage = self:GetAbility():GetSpecialValueFor("damage_return") + agi
	self:GetParent():StartGesture(ACT_DOTA_CAST_ALACRITY)
	self:GetCaster():RemoveModifierByName("modifier_touma_imagine_breaker_counter")
	self:PlayEffects()
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_punch_invul", -- modifier name
		{ duration = 0.7 } -- kv
	)
		params.attacker:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_punch_impact", -- modifier name
		{ duration = 0.8,damage = damage } -- kv
	)
end
	end
	else
	self.damage = 0

	-- purge
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_touma_arm_loss", -- modifier name
		{} -- kv
	)
	self:GetCaster():RemoveModifierByName("modifier_touma_imagine_breaker_counter")
	self:GetCaster():RemoveModifierByName("modifier_touma_gender_equality_combo_true")

	-- effect
	
end
end

function modifier_touma_imagine_breaker_counter:GetModifierMagical_ConstantBlock(params)
local damage = params.damage
local zero = self.damage
self.damage = zero + damage
	return self.block
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_touma_imagine_breaker_counter:OnIntervalThink()
	self:StartIntervalThink( -1 )

	-- reset
	self.damage = 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_touma_imagine_breaker_counter:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/touma_imagine_breaker_counter_flash.vpcf"
	local sound_cast = "touma.imagine_counter"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end

modifier_punch_invul = class({})
function modifier_punch_invul:IsHidden() return false end
function modifier_punch_invul:IsDebuff() return true end
function modifier_punch_invul:IsPurgable() return false end
function modifier_punch_invul:IsPurgeException() return false end
function modifier_punch_invul:RemoveOnDeath() return true end
function modifier_punch_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_punch_invul:OnCreated()
if IsServer() then
EmitSoundOn( "touma.4_voiceline", self:GetParent() )
        --self:SetStackCount(0)
self.screw_fx = 	ParticleManager:CreateParticle("particles/touma_imagine_breaker_hand_glow.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.screw_fx, 0, self:GetCaster(), 5, "right_hand", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.screw_fx, 1, self:GetCaster(), 5, "right_hand", Vector(0,0,0), true)
       
    end
end
function modifier_punch_invul:OnDestroy()
local caster = self:GetCaster()
EmitSoundOn( "touma.4_voiceline_end", self:GetParent() )
if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
	end
	self:PlayEffects()
end
function modifier_punch_invul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create SoundEmitSoundOn( sound_cast, self.parent )
end

modifier_punch_impact = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_punch_impact:IsHidden()
	return false
end

function modifier_punch_impact:IsDebuff()
	return true
end

function modifier_punch_impact:IsStunDebuff()
	return false
end

function modifier_punch_impact:IsPurgable()
	return true
end

function modifier_punch_impact:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_punch_impact:OnRefresh( kv )
	
end
function modifier_punch_impact:OnCreated(kv)
self.damage = kv.damage
end
function modifier_punch_impact:OnRemoved()
end

function modifier_punch_impact:OnDestroy(kv)
if IsServer() then
	local caster = self:GetCaster()
	local damage = self.damage
	local target_loc_forward_vector = self:GetParent():GetForwardVector()
	local final_pos = self:GetParent():GetAbsOrigin() + target_loc_forward_vector * 150
		caster:SetOrigin( final_pos )
	FindClearSpaceForUnit( caster, final_pos, true )
	caster:SetForwardVector(target_loc_forward_vector * -1)
	caster:MoveToTargetToAttack(self:GetParent())
local damageTable = {
		victim = self:GetParent(),
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
	}
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.5 })
	ApplyDamage(damageTable)
	if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 2.0} -- kv
	)
	end
self:PlayEffects()
end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_punch_impact:CheckState()
	local state = {
		
	}

	return state
end
function modifier_punch_impact:PlayEffects( radius )

	local particle_cast = "particles/touma_imagine_breaker_base_combo_end.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "touma.imagine", self:GetCaster() )
end



modifier_touma_arm_loss = class({})
function modifier_touma_arm_loss:IsHidden() return false end
function modifier_touma_arm_loss:IsDebuff() return true end
function modifier_touma_arm_loss:IsPurgable() return false end
function modifier_touma_arm_loss:IsPurgeException() return false end
function modifier_touma_arm_loss:RemoveOnDeath() return true end
function modifier_touma_arm_loss:AllowIllusionDuplicate() return true end

function modifier_touma_arm_loss:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end
function modifier_touma_arm_loss:DeclareFunctions()
    local func = {  
    				
	                  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,					  
		}
    return func
end
function modifier_touma_arm_loss:GetModifierModelChange()
    return "models/kamijou_touma/kamijou_touma_armless.vmdl"
end
function modifier_touma_arm_loss:GetModifierMagicalResistanceBonus()

    return 100
end

function modifier_touma_arm_loss:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()
	self.bonus = 0

	
	 

    self.skills_table = {
                            ["touma_imagine_breaker_counter"] = "touma_arm_grow",
							
                            
                        }
						
					
					
	
 

    if IsServer() then
	self.ability:StartCooldown(3)
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
				self:PlayEffects1(400)
        if not self.screw_fx then
		local delay = 0.1
Timers:CreateTimer(delay,function()
            self.screw_fx = 	ParticleManager:CreateParticle("particles/touma_lost_arm_blood.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.screw_fx, 0, self:GetCaster(), 5, "lost_arm", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.screw_fx, 1, self:GetCaster(), 5, "lost_arm", Vector(0,0,0), true)
                                    end)
        end

      

		
		end
        

        local HiddenAbilities = 
	{
	
		"touma_base_combo",
		"touma_imagine_breaker",
		"touma_second_combo",
		"touma_gender_equality_combo",
		
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
		
			
	   	hideability2 = self:GetParent():FindAbilityByName("touma_dragon_strike")
		  if hideability2 and not hideability2:IsActivated() then
            hideability2:SetActivated(true)
        end
	
    end
	self:StartIntervalThink(0.1)
    end
	end

function modifier_touma_arm_loss:OnIntervalThink()
local r = self.bonus
self.bonus = r + 1
if self:GetCaster():HasTalent("special_bonus_touma_20_alt") then
self.dip = 10 + self.bonus
else
self.dip = 40 + self.bonus
end
     local damageTable = {
		victim = self:GetCaster(),
		attacker = self:GetCaster(),
		damage = self.dip,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	-- update damage
	

	-- apply damage
	ApplyDamage( damageTable )
end
function modifier_touma_arm_loss:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_touma_arm_loss:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.screw_fx, false)
        ParticleManager:ReleaseParticleIndex(self.screw_fx)

           

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("all_fiction_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
				if IsServer() then
				 local hideit = 
	{
	"touma_base_combo",
		"touma_imagine_breaker",
		"touma_second_combo",
		"touma_gender_equality_combo",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
		
			
	   	hideability2 = self:GetParent():FindAbilityByName("touma_dragon_strike")
		  if hideability2 and hideability2:IsActivated() then
            hideability2:SetActivated(false)
        end

       
    end
end
end
end
function modifier_touma_arm_loss:PlayEffects1( radius )

	local particle_cast = "particles/chara_blood2.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "touma.arm_loss", self:GetCaster() )
end


touma_arm_grow = class({})
function touma_arm_grow:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("touma_imagine_breaker_counter")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function touma_arm_grow:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
	if caster:HasModifier("modifier_touma_arm_loss") then
	    caster:EmitSound("touma.grow")
caster:RemoveModifierByName("modifier_touma_arm_loss")
self:PlayEffects(300)
end
end

function touma_arm_grow:PlayEffects( radius )

	local particle_cast = "particles/chara_blood2.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.arm_loss", self:GetCaster() )
end










--------------------------------------







touma_dragon_strike = class({})
LinkLuaModifier("modifier_touma_dragon_strike_enemy", "heroes/kamijou_touma/touma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_touma_dragon_strike_self", "heroes/kamijou_touma/touma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_touma_dragon_strike_enemy_astral_countdown", "heroes/kamijou_touma/touma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_touma_dragon_strike_enemy_astral", "heroes/kamijou_touma/touma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3.lua", LUA_MODIFIER_MOTION_NONE)
function touma_arm_grow:OnUpgrade()
           	HiddenAbility = self:GetCaster():FindAbilityByName("touma_dragon_strike")
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
end
function touma_dragon_strike:OnSpellStart()
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
 
	EmitGlobalSound("touma.dragon_strike_theme")

	target:AddNewModifier(caster, self, "modifier_stunned", {duration = 7.0})
	target:AddNewModifier(caster, self, "modifier_touma_dragon_strike_enemy", {duration = 6.8})
	target:AddNewModifier(caster, self, "modifier_touma_dragon_strike_enemy_astral_countdown", {duration = 6.0})
	caster:AddNewModifier(caster, self, "modifier_touma_dragon_strike_self", {duration = 7.0})
		self.sound_cast = "Touma.5"
	EmitSoundOn( self.sound_cast, caster )
	end
	



modifier_touma_dragon_strike_self = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_touma_dragon_strike_self:IsHidden()
	return false
end

function modifier_touma_dragon_strike_self:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_touma_dragon_strike_self:IsStunDebuff()
	return true
end

function modifier_touma_dragon_strike_self:IsPurgable()
	return false
end

function modifier_touma_dragon_strike_self:RemoveOnDeath()
	return false
end

function modifier_touma_dragon_strike_self:OnDestroy()
if IsServer() then
local caster = self:GetParent()
	caster:RemoveModifierByName("modifier_touma_arm_loss")
	ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
	end
end



function modifier_touma_dragon_strike_self:OnCreated()
if IsServer() then
self:PlayEffects(400)
local delay = 0.1
Timers:CreateTimer(delay,function()
self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_5)
self:PlayEffects2()
end)
self:StartIntervalThink(4)
self.parent  = self:GetParent()
if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/touma_dragon_strike_effects.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
end
end
function modifier_touma_dragon_strike_self:PlayEffects2()
		-- Get Resources
	
	self.radius = 200
	self.parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/white_touma_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "lost_arm", self.parent:GetAbsOrigin(), true)
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
function modifier_touma_dragon_strike_self:OnIntervalThink()
if IsServer() then
EmitSoundOn( "Touma.dragon_cry", self:GetParent() )
end
end
function modifier_touma_dragon_strike_self:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end
function modifier_touma_dragon_strike_self:DeclareFunctions()
    local func = {  
    				
	                
		
                  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,					  
		}
    return func
end
function modifier_touma_dragon_strike_self:GetModifierModelChange()
    return "models/kamijou_touma/kamijou_touma_dragon_strike.vmdl"
end

function modifier_touma_dragon_strike_self:PlayEffects( radius )
	local particle_cast = "particles/touma_dragon_strike_inverted_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_touma_dragon_strike_enemy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_touma_dragon_strike_enemy:IsHidden()
	return false
end

function modifier_touma_dragon_strike_enemy:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_touma_dragon_strike_enemy:IsStunDebuff()
	return true
end

function modifier_touma_dragon_strike_enemy:IsPurgable()
	return false
end

function modifier_touma_dragon_strike_enemy:RemoveOnDeath()
	return false
end




function modifier_touma_dragon_strike_enemy:OnCreated()
self:PlayEffects2(600)
end


function modifier_touma_dragon_strike_enemy:OnDestroy()
if IsServer() then
local caster = self:GetCaster()
self.damage = self:GetAbility():GetSpecialValueFor("damage")
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	self:PlayEffects(600)
end
end
function modifier_touma_dragon_strike_enemy:PlayEffects( radius )
if IsServer() then
	self.sound_cast = "Touma.5_kill"
	EmitSoundOn( self.sound_cast, self:GetParent() )
	local particle_cast = "particles/touma_dragon_strike_blood.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
end
function modifier_touma_dragon_strike_enemy:PlayEffects2( radius )

	if IsServer() then
	local particle_cast = "particles/touma_dragon_strike_dragons.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
end

modifier_touma_dragon_strike_enemy_astral_countdown = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_touma_dragon_strike_enemy_astral_countdown:IsHidden()
	return false
end

function modifier_touma_dragon_strike_enemy_astral_countdown:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_touma_dragon_strike_enemy_astral_countdown:IsStunDebuff()
	return true
end

function modifier_touma_dragon_strike_enemy_astral_countdown:IsPurgable()
	return false
end

function modifier_touma_dragon_strike_enemy_astral_countdown:RemoveOnDeath()
	return false
end




function modifier_touma_dragon_strike_enemy_astral_countdown:OnRemoved()
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_touma_dragon_strike_enemy_astral_countdown:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	
	}

	return state
end

function modifier_touma_dragon_strike_enemy_astral_countdown:OnDestroy()
if IsServer() then
local caster = self:GetCaster()
self:GetParent():AddNewModifier(caster, self, "modifier_touma_dragon_strike_enemy_astral", {duration = 0.7})
end
end












modifier_touma_dragon_strike_enemy_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_touma_dragon_strike_enemy_astral:IsHidden()
	return false
end

function modifier_touma_dragon_strike_enemy_astral:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_touma_dragon_strike_enemy_astral:IsStunDebuff()
	return true
end

function modifier_touma_dragon_strike_enemy_astral:IsPurgable()
	return true
end

function modifier_touma_dragon_strike_enemy_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_touma_dragon_strike_enemy_astral:OnCreated( kv )
	-- references

	if not IsServer() then return end
	
	self:GetParent():AddNoDraw()

	
end



function modifier_touma_dragon_strike_enemy_astral:OnRemoved()
end

function modifier_touma_dragon_strike_enemy_astral:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveNoDraw()
	
end


function modifier_touma_dragon_strike_enemy_astral:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end













touma_gender_equality_combo = class({})
LinkLuaModifier( "modifier_touma_gender_equality_combo", "heroes/kamijou_touma/touma.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_gender_equality_combo_debuff", "heroes/kamijou_touma/touma.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_gender_equality_base", "heroes/kamijou_touma/touma.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua" ,LUA_MODIFIER_MOTION_NONE )

function touma_gender_equality_combo:GetCastRange( location , target)

	return 160
end




--------------------------------------------------------------------------------

function touma_gender_equality_combo:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("touma_true_gender_equality_combo")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------

function touma_gender_equality_combo:OnSpellStart()
local caster = self:GetCaster()

	local target = self:GetCursorTarget()
	self.hVictim  = target
	if self:GetCaster():HasModifier("modifier_touma_gender_equality_combo_true") and IsWoman(target) then
	caster:RemoveModifierByName("modifier_touma_gender_equality_combo_true")
	EmitSoundOn( "touma.punch_theme_true", self:GetCaster() )
	EmitSoundOn( "touma.true_gender_equiality_voiceline", self:GetCaster() )
_G.ToumaGenderCombo = 1
	else
EmitSoundOn( "touma.punch_theme", self:GetCaster() )
end
	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_touma_gender_equality_combo", { duration = self:GetChannelTime() } )
		caster:AddNewModifier( self:GetCaster(), self, "modifier_touma_gender_equality_base", { duration = self:GetChannelTime() } )
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

function touma_gender_equality_combo:OnChannelFinish( bInterrupted )
local broke = GameRules:GetGameTime() - self:GetChannelStartTime()
local point = self:GetCaster():GetAbsOrigin()
local target = self.hVictim
local caster = self:GetCaster()
local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	local radius = 300
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_touma_gender_equality_combo" )
		self:GetCaster():RemoveModifierByName( "modifier_touma_gender_equality_base" )
	end
	local debuffDuration = 1.5
if self:GetCaster():HasModifier("modifier_touma_gender_equality_combo_true_check") and IsWoman(target) then
self.damage = 4000 * channel_pct
self:GetCaster():RemoveModifierByName( "modifier_touma_gender_equality_combo_true_check" )
else
self.damage = self:GetSpecialValueFor( "full_damage" )
end
local damageTable = {
		victim = self.hVictim,
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	--local delay = 0.1
--Timers:CreateTimer(delay,function()
	ApplyDamage(damageTable)
	--end)
		if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then

		self.hVictim:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 2.0} -- kv
	)
	end
	EmitSoundOn( "touma.imagine", self:GetCaster() )
	self:PlayEffects( point, radius, debuffDuration )
 


	
end
function touma_gender_equality_combo:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/touma_imagine_breaker_base_combo_end.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end




modifier_touma_gender_equality_combo = class({})

--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:OnCreated( kv )
	local caster = self:GetCaster()
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( 0.21 )
	end
	

end

--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	_G.ToumaGenderCombo = 0
	StopSoundOn( "touma.punch_theme", self:GetCaster() )
	StopSoundOn( "touma.punch_theme_true", self:GetCaster() )
	StopSoundOn( "touma.true_gender_equiality_voiceline", self:GetCaster() )
	
end

--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:OnIntervalThink()
	if IsServer() then
	local radius = 300
	local caster = self:GetCaster()
    self.hVictim = self:GetParent()
	local final_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100
	

	-- Blink
	self:PlayEffects()
	self:GetCaster():SetOrigin( final_pos )
	FindClearSpaceForUnit( self:GetCaster(), final_pos, true )
	caster:SetForwardVector(self:GetParent():GetForwardVector() * -1)
	if self:GetCaster():HasModifier("modifier_touma_gender_equality_base") then
	local rng = 1,4
	if rng == 1 then
	if _G.ToumaCombo == 1 then
	caster:StartGesture(ACT_DOTA_ATTACK2)
	_G.ToumaCombo = 2
	self:PlayEffects2(radius)
	else
	caster:StartGesture(ACT_DOTA_ATTACK)
	_G.ToumaCombo = 1
	self:PlayEffects1(caster:GetForwardVector())
	end
	elseif rng == 2 then
	if _G.ToumaCombo == 2 then
	_G.ToumaCombo = 3
	caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	self:PlayEffects3(radius)
	else
	caster:StartGesture(ACT_DOTA_ATTACK2)
	_G.ToumaCombo = 2
	self:PlayEffects2(radius)
	end
	elseif rng == 3 then
		if _G.ToumaCombo == 3 then
		caster:StartGesture(ACT_DOTA_AMBUSH)
		_G.ToumaCombo = 4
		self:PlayEffects4(caster:GetForwardVector())
		else
	caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	_G.ToumaCombo = 3
	self:PlayEffects3(radius)
	end
	else
	if _G.ToumaCombo == 4 then
	caster:StartGesture(ACT_DOTA_ATTACK)
	_G.ToumaCombo = 1
	self:PlayEffects1(caster:GetForwardVector())
	else
	caster:StartGesture(ACT_DOTA_AMBUSH)
	_G.ToumaCombo = 4
	self:PlayEffects4(caster:GetForwardVector())
	end
	end
	local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 20,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:GetCaster():PerformAttack(self:GetParent(), true,
				true,
				true,
				true,
				true,
				false,
				true)
				if IsWoman(self:GetParent()) then
				self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 200,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )
		end
	else
	
	
end
end
end


--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_touma_gender_equality_combo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end
function modifier_touma_gender_equality_combo:GetModifierIncomingDamage_Percentage( params )
	
if _G.ToumaGenderCombo == 1 then
	return -85
else

		return -65
		end
	end
	

function modifier_touma_gender_equality_combo:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_touma_gender_equality_combo:PlayEffects3( radius )

	local particle_cast = "particles/touma_3_base_combo.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.3_3", self:GetCaster() )
end
function modifier_touma_gender_equality_combo:PlayEffects2( radius )

	local particle_cast = "particles/touma_gender_equality_combo_2.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.3_4", self:GetCaster() )
end

function modifier_touma_gender_equality_combo:PlayEffects1(direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_start.vpcf"
		local sound_cast = "touma.1"
	local dir = self:GetCaster():GetForwardVector()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, dir )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.1_2", self:GetCaster() )
end
function modifier_touma_gender_equality_combo:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create SoundEmitSoundOn( sound_cast, self.parent )
end
function modifier_touma_gender_equality_combo:PlayEffects4(direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_2nd.vpcf"
		local sound_cast = "touma.1"
	
	local dir = self:GetCaster():GetForwardVector()
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, dir )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end










touma_true_gender_equality_combo = class({})
LinkLuaModifier( "modifier_touma_true_gender_equality_combo", "heroes/kamijou_touma/touma.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_true_gender_equality_combo_debuff", "heroes/kamijou_touma/touma.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_touma_gender_equality_base", "heroes/kamijou_touma/touma.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua" ,LUA_MODIFIER_MOTION_NONE )

function touma_true_gender_equality_combo:GetCastRange( location , target)

	return 160
end


function touma_true_gender_equality_combo:CastFilterResultTarget(target)
    if not IsWoman(target) then
        return UF_FAIL_CUSTOM
    end
    return UF_SUCCESS
end 


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function touma_true_gender_equality_combo:OnSpellStart()
local caster = self:GetCaster()

	local target = self:GetCursorTarget()
	self.hVictim  = target
	if self:GetCaster():HasModifier("modifier_touma_gender_equality_combo_true") and IsWoman(target) then
	caster:RemoveModifierByName("modifier_touma_gender_equality_combo_true")
	EmitSoundOn( "touma.punch_theme_true", self:GetCaster() )
	EmitSoundOn( "touma.true_gender_equiality_voiceline", self:GetCaster() )
_G.ToumaGenderCombo = 1
	
	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_touma_true_gender_equality_combo", { duration = self:GetChannelTime() } )
		caster:AddNewModifier( self:GetCaster(), self, "modifier_touma_gender_equality_base", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
	local blinkDistance = 1
	local blinkDirection = (caster:GetOrigin() - self.hVictim:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = self.hVictim:GetOrigin() + blinkDirection

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )
	else
	end
end


--------------------------------------------------------------------------------

function touma_true_gender_equality_combo:OnChannelFinish( bInterrupted )
local broke = GameRules:GetGameTime() - self:GetChannelStartTime()
local point = self:GetCaster():GetAbsOrigin()
local target = self.hVictim
local caster = self:GetCaster()
local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	local radius = 300
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_touma_true_gender_equality_combo" )
		self:GetCaster():RemoveModifierByName( "modifier_touma_gender_equality_base" )
	end
	local debuffDuration = 1.5
if self:GetCaster():HasModifier("modifier_touma_gender_equality_combo_true_check") and IsWoman(target) then
self.damage = 4000 * channel_pct
self:GetCaster():RemoveModifierByName( "modifier_touma_gender_equality_combo_true_check" )
else
self.damage = self:GetSpecialValueFor( "full_damage" )
end
local damageTable = {
		victim = self.hVictim,
		attacker = caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	--local delay = 0.1
--Timers:CreateTimer(delay,function()
	ApplyDamage(damageTable)
	--end)
		if self:GetCaster():HasTalent("special_bonus_touma_25_alt") then

		self.hVictim:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{duration = 2.0} -- kv
	)
	end
	EmitSoundOn( "touma.imagine", self:GetCaster() )
	self:PlayEffects( point, radius, debuffDuration )
 


	
end
function touma_true_gender_equality_combo:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/touma_imagine_breaker_base_combo_end.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end




modifier_touma_true_gender_equality_combo = class({})

--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:OnCreated( kv )
	local caster = self:GetCaster()
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( 0.21 )
	end
	

end

--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
	_G.ToumaGenderCombo = 0
	StopSoundOn( "touma.punch_theme", self:GetCaster() )
	StopSoundOn( "touma.punch_theme_true", self:GetCaster() )
	StopSoundOn( "touma.true_gender_equiality_voiceline", self:GetCaster() )
	
end

--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:OnIntervalThink()
	if IsServer() then
	local radius = 300
	local caster = self:GetCaster()
    self.hVictim = self:GetParent()
	local final_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100
	

	-- Blink
	self:PlayEffects()
	self:GetCaster():SetOrigin( final_pos )
	FindClearSpaceForUnit( self:GetCaster(), final_pos, true )
	caster:SetForwardVector(self:GetParent():GetForwardVector() * -1)
	if self:GetCaster():HasModifier("modifier_touma_gender_equality_base") then
	local rng = 1,4
	if rng == 1 then
	if _G.ToumaCombo == 1 then
	caster:StartGesture(ACT_DOTA_ATTACK2)
	_G.ToumaCombo = 2
	self:PlayEffects2(radius)
	else
	caster:StartGesture(ACT_DOTA_ATTACK)
	_G.ToumaCombo = 1
	self:PlayEffects1(caster:GetForwardVector())
	end
	elseif rng == 2 then
	if _G.ToumaCombo == 2 then
	_G.ToumaCombo = 3
	caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	self:PlayEffects3(radius)
	else
	caster:StartGesture(ACT_DOTA_ATTACK2)
	_G.ToumaCombo = 2
	self:PlayEffects2(radius)
	end
	elseif rng == 3 then
		if _G.ToumaCombo == 3 then
		caster:StartGesture(ACT_DOTA_AMBUSH)
		_G.ToumaCombo = 4
		self:PlayEffects4(caster:GetForwardVector())
		else
	caster:StartGesture(ACT_DOTA_ATTACK_EVENT)
	_G.ToumaCombo = 3
	self:PlayEffects3(radius)
	end
	else
	if _G.ToumaCombo == 4 then
	caster:StartGesture(ACT_DOTA_ATTACK)
	_G.ToumaCombo = 1
	self:PlayEffects1(caster:GetForwardVector())
	else
	caster:StartGesture(ACT_DOTA_AMBUSH)
	_G.ToumaCombo = 4
	self:PlayEffects4(caster:GetForwardVector())
	end
	end
	local knockback = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 20,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    self:GetParent():AddNewModifier(caster, self, "modifier_knockback", knockback)
	self:GetCaster():PerformAttack(self:GetParent(), true,
				true,
				true,
				true,
				true,
				false,
				true)
				if IsWoman(self:GetParent()) then
				self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 200,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )
		end
	else
	
	
end
end
end


--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_touma_true_gender_equality_combo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end
function modifier_touma_true_gender_equality_combo:GetModifierIncomingDamage_Percentage( params )
	
if _G.ToumaGenderCombo == 1 then
	return -90
else

		return -80
		end
	end
	

function modifier_touma_true_gender_equality_combo:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_touma_true_gender_equality_combo:PlayEffects3( radius )

	local particle_cast = "particles/touma_3_base_combo.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.3_3", self:GetCaster() )
end
function modifier_touma_true_gender_equality_combo:PlayEffects2( radius )

	local particle_cast = "particles/touma_gender_equality_combo_2.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.3_4", self:GetCaster() )
end

function modifier_touma_true_gender_equality_combo:PlayEffects1(direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_start.vpcf"
		local sound_cast = "touma.1"
	local dir = self:GetCaster():GetForwardVector()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, dir )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "touma.1_2", self:GetCaster() )
end
function modifier_touma_true_gender_equality_combo:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/vergil_blur.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create SoundEmitSoundOn( sound_cast, self.parent )
end
function modifier_touma_true_gender_equality_combo:PlayEffects4(direction )
	-- Get Resources
	local particle_cast = "particles/touma_base_combo_2nd.vpcf"
		local sound_cast = "touma.1"
	
	local dir = self:GetCaster():GetForwardVector()
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, dir )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end