pikachu_thunderbolt = class({})
LinkLuaModifier( "modifier_generic_root", "modifiers/modifier_generic_root", LUA_MODIFIER_MOTION_NONE )
function pikachu_thunderbolt:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pikachu_nit")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end


function pikachu_thunderbolt:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	self.parent = self:GetCaster()
	self.point = point

	-- Play effects
	local sound_cast = "pikachu.1"
	if IsServer() then
	
			   self.particle_time =    ParticleManager:CreateParticle("particles/pikachu_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                  
						
			end
		
			
	EmitSoundOn(sound_cast, caster )
			end
	



--------------------------------------------------------------------------------
-- Ability Channeling
function pikachu_thunderbolt:OnChannelFinish( bInterrupted )
if IsServer() then
local caster = self:GetCaster()
StopSoundOn("pikachu.1", self:GetCaster() )
if self.particle_time then
		ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		end
	local mana = self:GetCaster():GetIntellect()
	local int_scale = self:GetSpecialValueFor( "int_scale")
	self.damage_bonus = mana * int_scale
	
--------
	local caster = self:GetCaster()
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	local damage = (self:GetSpecialValueFor( "damage") + self.damage_bonus) * channel_pct
    local duration = self:GetSpecialValueFor( "duration") * channel_pct
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self.point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
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
		self:PlayEffects2(enemy)
       if self:GetCaster():HasTalent("special_bonus_pikachu_20") then
	   enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = duration } -- kv
		)
	   else
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_root", -- modifier name
			{ duration = duration } -- kv
		)
		end
	end

	self:PlayEffects( 400, self.point )


end
end


function pikachu_thunderbolt:PlayEffects( radius, point )
	local particle_cast = "particles/pikachu_thunderbolt_aor.vpcf"
	local sound_cast = "pikachu.1_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
function pikachu_thunderbolt:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_static_field.vpcf"



	
	
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



-------------------------------


voltage = class({})
LinkLuaModifier( "modifier_voltage", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_voltage_stack", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE )

function voltage:GetIntrinsicModifierName()
	return "modifier_voltage" 
end

function voltage:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pikachu_cry")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end
function voltage:OnSpellStart()
local sound_cast = "pikachu.2"
	if IsServer() then
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_item_aghanims_shard") then
	self.damageTable = {
		attacker = self:GetCaster(),
		damage = self:GetCaster():GetIntellect() * 2,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects

	end
			self:PlayEffects(400)
	end
	EmitSoundOn(sound_cast, caster )
	
	end
end

function voltage:PlayEffects( radius )

	local particle_cast = "particles/voltage_electrowave.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
modifier_voltage = class({})

--------------------------------------------------------------------------------

function modifier_voltage:IsHidden()
	return false
end

function modifier_voltage:IsDebuff()
	return false
end

function modifier_voltage:IsPurgable()
	return false
end

function modifier_voltage:RemoveOnDeath()
	return false
end
function modifier_voltage:AllowIllusionDuplicate()
 return true 
 end
--------------------------------------------------------------------------------

function modifier_voltage:OnCreated( kv )

	if IsServer() then
	self:StartIntervalThink(1)
	end
	self:SetStackCount(0)
end

function modifier_voltage:OnIntervalThink()
	if IsServer() then
	if self:GetParent():HasModifier("modifier_voltage_stack") then
	local damage = self:GetAbility():GetSpecialValueFor("damage_per_stack") * self:GetStackCount()
		self.damageTable = {
		attacker = self:GetParent(),
		damage = damage + self:GetCaster():FindTalentValue("special_bonus_pikachu_25_alt"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
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
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		self:PlayEffects2( enemy )
	end
	else
	
	self:SetStackCount(0)
	
	end
	end
end
function modifier_voltage:DeclareFunctions()
	local funcs = {

	
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		
	}

	return funcs
end

function modifier_voltage:OnAbilityFullyCast( params )
	if IsServer() then
	if params.ability:IsItem() then return end
		if params.unit~=self:GetParent() then
			return
		end
			local caster = self:GetCaster()
			local duration = self:GetAbility():GetSpecialValueFor("stack_duration")
			if self:GetCaster():HasTalent("special_bonus_pikachu_25") then
			 if self:GetStackCount() > 9  then
	   self:SetStackCount(10)
	   caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_voltage_stack", -- modifier name
			{ duration = duration} -- kv
		)
	   else
		self:SetStackCount(self:GetStackCount() + 1)
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_voltage_stack", -- modifier name
			{ duration = duration} -- kv
		)
		end
			else
       if self:GetStackCount() > 4  then
	   self:SetStackCount(5)
	   caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_voltage_stack", -- modifier name
			{ duration = duration} -- kv
		)
	   else
		self:SetStackCount(self:GetStackCount() + 1)
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_voltage_stack", -- modifier name
			{ duration = duration} -- kv
		)
		end
	end
end

end
function modifier_voltage:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_static_field.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_voltage_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_voltage_stack:IsHidden()
	return false
end

function modifier_voltage_stack:IsDebuff()
	return false
end

function modifier_voltage_stack:IsStunDebuff()
	return false
end

function modifier_voltage_stack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_voltage_stack:OnCreated( kv )

end

function modifier_voltage_stack:OnRefresh( kv )

end

function modifier_voltage_stack:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_voltage_stack:GetEffectName()
	return "particles/pikachu_voltage_buff.vpcf"
end

function modifier_voltage_stack:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end





volt_tackle = class({})
volt_tackle_release = class({})
LinkLuaModifier( "modifier_volt_tackle_charge", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_volt_tackle", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_generic_arc_lua", "modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------


function volt_tackle:Spawn()
	if not IsServer() then return end
end
function volt_tackle:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("saske_vernis_v_konohu")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end
--------------------------------------------------------------------------------
-- Ability Start
function volt_tackle:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "chargeup_time" )

	-- add modifier
	local mod = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_volt_tackle_charge", -- modifier name
		{ duration = duration } -- kv
	)
	-- mod.direction = direction

	self.sub = caster:FindAbilityByName( "volt_tackle_release" )
	if not self.sub or self.sub:IsNull() then
		self.sub = caster:AddAbility( "volt_tackle_release" )
	end
	self.sub.main = self
	self.sub:SetLevel( self:GetLevel() )

	caster:SwapAbilities(
		self:GetAbilityName(),
		self.sub:GetAbilityName(),
		false,
		true
	)
EmitSoundOn( "pikachu.3", caster )
	-- set cooldown
	self.sub:UseResources( false, false, true )
end

function volt_tackle:OnChargeFinish( interrupt )
	-- unit identifier
	local caster = self:GetCaster()
StopSoundOn( "pikachu.3", caster )
	caster:SwapAbilities(
		self:GetAbilityName(),
		self.sub:GetAbilityName(),
		true,
		false
	)

	-- load data
	local max_duration = self:GetSpecialValueFor( "chargeup_time" )
	local max_distance = self:GetSpecialValueFor( "max_distance" )
	local speed = self:GetSpecialValueFor( "charge_speed" )

	-- find charge modifier
	local charge_duration = max_duration
	local mod = caster:FindModifierByName( "modifier_volt_tackle_charge" )
	if mod then
		charge_duration = mod:GetElapsedTime()

		mod.charge_finish = true
		mod:Destroy()
	end

	local distance = max_distance * charge_duration/max_duration
	local duration = distance/speed

	-- cancel if interrupted
	if interrupt then return end

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_volt_tackle", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects

end

--------------------------------------------------------------------------------
-- Sub-ability
function volt_tackle_release:OnSpellStart()
	self.main:OnChargeFinish( false )
end


modifier_volt_tackle_charge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_volt_tackle_charge:IsHidden()
	return false
end

function modifier_volt_tackle_charge:IsDebuff()
	return false
end

function modifier_volt_tackle_charge:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_volt_tackle_charge:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )

	if not IsServer() then return end

	self.origin = self.parent:GetOrigin()
	self.charge_finish = false

	-- turning data
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- Start interval
	self:StartIntervalThink( FrameTime() )

	-- order filter using library
	

	-- play effect
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_volt_tackle_charge:OnRefresh( kv )
end

function modifier_volt_tackle_charge:OnRemoved()
	if not IsServer() then return end

	-- stop effects
	local sound_cast = "pikachu.3_1"
	EmitSoundOn( sound_cast, self.parent )

	if not self.charge_finish then
		self.ability:OnChargeFinish( false )
	end

	-- remove filter

end

function modifier_volt_tackle_charge:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_volt_tackle_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_volt_tackle_charge:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self.ability:OnChargeFinish( false )
	end	
end

function modifier_volt_tackle_charge:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_volt_tackle_charge:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_volt_tackle_charge:CheckState()
if self:GetParent():HasTalent("special_bonus_pikachu_20_alt") then
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,}
	return state
else
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	

	return state
end
end

--------------------------------------------------------------------------------
-- Filter
-- NOTE: Filter is required because right-clicking faces the unit to target position, RESPECTING the terrain, so the target point may be different
function modifier_volt_tackle_charge:OrderFilter( data )
	-- only filter right-clicks
	if data.order_type~=DOTA_UNIT_ORDER_MOVE_TO_POSITION and
		data.order_type~=DOTA_UNIT_ORDER_MOVE_TO_TARGET and
		data.order_type~=DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		return true
	end

	-- filter orders given to parent
	local found = false
	for _,entindex in pairs(data.units) do
		local entunit = EntIndexToHScript( entindex )
		if entunit==self.parent then
			found = true
		end
	end
	if not found then return true end

	-- set order to move to direction
	data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION

	-- if there is target, set position to its origin
	if data.entindex_target~=0 then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end

	return true
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_volt_tackle_charge:OnIntervalThink()
	-- cancel logic
	if self.parent:IsRooted() or self.parent:IsStunned() or self.parent:IsSilenced() or
		self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsCurrentlyVerticalMotionControlled()
	then
		self.ability:OnChargeFinish( true )
	end

	-- turning logic
	self:TurnLogic( FrameTime() )

	-- set particles
	self:SetEffects()
end

function modifier_volt_tackle_charge:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_volt_tackle_charge:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_range_finder.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self.effect_cast = effect_cast
	self:SetEffects()
end

function modifier_volt_tackle_charge:SetEffects()
	local target_pos = self.origin + self.parent:GetForwardVector() * self.speed * self:GetElapsedTime()
	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_volt_tackle_charge:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf"
	local sound_cast = "Hero_PrimalBeast.Onslaught.Channel"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
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

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end



modifier_volt_tackle = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_volt_tackle:IsHidden()
	return false
end

function modifier_volt_tackle:IsDebuff()
	return false
end

function modifier_volt_tackle:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_volt_tackle:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )

	self.radius = self:GetAbility():GetSpecialValueFor( "knockback_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.stun = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	local damage = self:GetAbility():GetSpecialValueFor( "knockback_damage" )

	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3 -- kv above is a lie

	if not IsServer() then return end

	-- ability properties
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	-- turning data
	self.target_angle = self.parent:GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	-- knockback data
	self.knockback_units = {}
	self.knockback_units[self.parent] = true

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
		return
	end

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self.parent,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self.ability, --Optional.
	}
end

function modifier_volt_tackle:OnRefresh( kv )
end

function modifier_volt_tackle:OnRemoved()
end

function modifier_volt_tackle:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveHorizontalMotionController(self)
	FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_volt_tackle:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_volt_tackle:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- point right click
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		ExecuteOrderFromTable({
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION,
			Position = params.new_pos,
		})
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		-- set facing
		self:SetDirection( params.new_pos )

	-- targetted right click
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		-- set facing
		self:SetDirection( params.target:GetOrigin() )
	
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_volt_tackle:GetModifierDisableTurning()
	return 1
end

function modifier_volt_tackle:SetDirection( location )
	local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_volt_tackle:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_volt_tackle:GetActivityTranslationModifiers()
	return "onslaught_movement"
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_volt_tackle:OnIntervalThink()
end

function modifier_volt_tackle:TurnLogic( dt )
	-- only rotate when target changed
	if self.face_target then return end

	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		-- end rotating
		self.current_angle = self.target_angle
		self.face_target = true
	else
		-- rotate current angle
		self.current_angle = self.current_angle + sign*turn_speed
	end

	-- turn the unit
	local angles = self.parent:GetAnglesAsVector()
	self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_volt_tackle:HitLogic()
	-- destroy trees
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.tree_radius, false )

	local units = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,unit in pairs(units) do
		-- only knockback once
		if not self.knockback_units[unit] then
			self.knockback_units[unit] = true

			local is_enemy = unit:GetTeamNumber()~=self.parent:GetTeamNumber()

			-- damage and stun
			if is_enemy then
				local enemy = unit

				-- damage
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)

				-- stun
				enemy:AddNewModifier(
					self.parent, -- player source
					self.ability, -- ability source
					"modifier_generic_stunned_lua", -- modifier name
					{ duration = self.stun } -- kv
				)
			end

			-- knockback, for both enemies and allies
			if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
				-- knockback data
				local direction = unit:GetOrigin()-self.parent:GetOrigin()
				direction.z = 0
				direction = direction:Normalized()

				-- create arc
				unit:AddNewModifier(
					self.parent, -- player source
					self.ability, -- ability source
					"modifier_generic_arc_lua", -- modifier name
					{
						dir_x = direction.x,
						dir_y = direction.y,
						duration = self.duration,
						distance = self.distance,
						height = self.height,
						activity = ACT_DOTA_FLAIL,
					} -- kv
				)
			end

			-- play effects
			self:PlayEffects( unit, self.radius )
		end
	end
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_volt_tackle:UpdateHorizontalMotion( me, dt )
	-- cancel if rooted
	if self.parent:IsRooted() then
		self:Destroy()
		return
	end

	self:HitLogic()

	self:TurnLogic( dt )

	local nextpos = me:GetOrigin() + me:GetForwardVector() * self.speed * dt
	me:SetOrigin(nextpos)
end

function modifier_volt_tackle:OnHorizontalMotionInterrupted()
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_volt_tackle:GetEffectName()
	return "particles/pikachu_volt_tackle.vpcf"
end

function modifier_volt_tackle:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_volt_tackle:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning.vpcf"
	local sound_cast = "pikachu.3_hit"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end













electro_ball = class({})
LinkLuaModifier( "modifier_generic_root", "modifiers/modifier_generic_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_electro_ball_damage", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE )
function electro_ball:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("dejavu_pikachu")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	
end
--------------------------------------------------------------------------------
-- Ability Start
function electro_ball:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/pikachu_electro_ball.vpcf"
	local projectile_speed = self:GetSpecialValueFor("arrow_speed")
	local projectile_distance = self:GetSpecialValueFor("arrow_range")
	local projectile_start_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_end_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_vision = self:GetSpecialValueFor("arrow_vision")

	local min_damage = self:GetAbilityDamage()
	local bonus_damage = self:GetSpecialValueFor( "arrow_bonus_damage" )
	local min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
	local max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
	local max_distance = self:GetSpecialValueFor( "arrow_max_stunrange" )

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),

		ExtraData = {
			originX = origin.x,
			originY = origin.y,
			originZ = origin.z,

			max_distance = max_distance,
			min_stun = min_stun,
			max_stun = max_stun,

			min_damage = min_damage,
			bonus_damage = bonus_damage,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Effects
	local sound_cast = "pikachu.4"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
function electro_ball:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end
	local caster = self:GetCaster()

	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)

	local damageTable = {
		attacker = self:GetCaster(),
		damage = extraData.min_damage + extraData.bonus_damage*bonus_pct,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}



	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_electro_ball_damage", -- modifier name
		{ duration = 0.01 } -- kv
	)

	-- effects
	local sound_cast = "pikachu.4_impact"
	EmitSoundOn( sound_cast, hTarget )

	return true
end


modifier_electro_ball_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_electro_ball_damage:IsHidden()
	return false
end

function modifier_electro_ball_damage:IsDebuff()
	return true
end

function modifier_electro_ball_damage:IsStunDebuff()
	return true
end

function modifier_electro_ball_damage:IsPurgable()
	return true
end

function modifier_electro_ball_damage:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_electro_ball_damage:OnCreated( kv )
	-- references
local intellect = self:GetCaster():GetIntellect()
	local int = self:GetAbility():GetSpecialValueFor( "int_scale" ) * intellect
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) + int
	self.radius = 300
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects

	
end


function modifier_electro_ball_damage:OnRefresh( kv )
	-- references
	local intellect = self:GetCaster():GetIntellect()
	local int = self:GetAbility():GetSpecialValueFor( "int_scale" ) * intellect
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) + int
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_electro_ball_damage:OnRemoved()
end

function modifier_electro_ball_damage:OnDestroy()
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
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
enemy:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_root", -- modifier name
		{ duration = 1.5 } -- kv
	)
		-- play overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			self:GetParent(),
			self.damageTable.damage,
			nil
		)
	end
end








LinkLuaModifier("modifier_pikachu_swap", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pikachu_exe_awakening", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE)
pikachu_swap = class({})

function pikachu_swap:IsStealable() return true end
function pikachu_swap:IsHiddenWhenStolen() return false end

function pikachu_swap:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("inversion_sword")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function pikachu_swap:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	

	if caster:HasModifier("modifier_cursed_spirit_unlock") then
	    caster:AddNewModifier(caster, self, "modifier_pikachu_exe_awakening", {})
	self:PlayEffects2()
	else

    caster:AddNewModifier(caster, self, "modifier_pikachu_swap", {})
	self:PlayEffects()
	end

    
end
function pikachu_swap:PlayEffects( )

	local particle_cast = "particles/billy_cum.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )


end
function pikachu_swap:PlayEffects2( )

	local particle_cast = "particles/pika_exe_awake.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )


end
modifier_pikachu_swap_invul = class({})
function modifier_pikachu_swap_invul:IsHidden() return true end
function modifier_pikachu_swap_invul:IsDebuff() return true end
function modifier_pikachu_swap_invul:IsPurgable() return false end
function modifier_pikachu_swap_invul:IsPurgeException() return false end
function modifier_pikachu_swap_invul:RemoveOnDeath() return true end
function modifier_pikachu_swap_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_pikachu_swap_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_pikachu_swap_invul:GetOverrideAnimation()
	return ACT_DOTA_DIE
end


---------------------------------------------------------------------------------------------------------------------
modifier_pikachu_swap = class({})
function modifier_pikachu_swap:IsHidden() return true end
function modifier_pikachu_swap:IsDebuff() return true end
function modifier_pikachu_swap:IsPurgable() return false end
function modifier_pikachu_swap:IsPurgeException() return false end
function modifier_pikachu_swap:RemoveOnDeath() return false end
function modifier_pikachu_swap:AllowIllusionDuplicate() return true end

function modifier_pikachu_swap:DeclareFunctions()
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


function modifier_pikachu_swap:GetModifierModelChange()

    return "models/pikapika/gachichu.vmdl"

end
function modifier_pikachu_swap:GetModifierModelScale()
	return 1
end






function modifier_pikachu_swap:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
    self.skills_table = {
                            ["presence_of_evil"] = "pikachu_nit",
							["aura_of_exe"] = "pikachu_cry",
							["pika_fear"] = "saske_vernis_v_konohu",
							["scary_scary_tale"] = "dejavu_pikachu",
							["throw_booga"] = "gayrang",
							["hunting"] = "pukachu_pukachu",
                            
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
     

      
        EmitSoundOn("gachichu.5", self.parent)
		

        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_pikachu_swap:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_pikachu_swap:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("pikachu_swap_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end

modifier_pikachu_exe_awakening = class({})
function modifier_pikachu_exe_awakening:IsHidden() return false end
function modifier_pikachu_exe_awakening:IsDebuff() return true end
function modifier_pikachu_exe_awakening:IsPurgable() return false end
function modifier_pikachu_exe_awakening:IsPurgeException() return false end
function modifier_pikachu_exe_awakening:RemoveOnDeath() return false end
function modifier_pikachu_exe_awakening:AllowIllusionDuplicate() return true end

function modifier_pikachu_exe_awakening:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
self:SetStackCount(0)
    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
    self.skills_table = {
                            
								
							["pikachu_swap"] = "hunting",
							
                            
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
     

      
        EmitSoundOn("pika_exe.9", self.parent)
		

        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_pikachu_exe_awakening:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_pikachu_exe_awakening:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("pikachu_swap_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
