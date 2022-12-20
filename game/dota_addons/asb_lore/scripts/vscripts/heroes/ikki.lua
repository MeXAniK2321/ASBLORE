LinkLuaModifier("modifier_ikki_shinkiro", "heroes/ikki", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blade_steal2", "modifiers/modifier_blade_steal2", LUA_MODIFIER_MOTION_NONE)
ikki_shinkiro = class({})

function ikki_shinkiro:GetIntrinsicModifierName()
    return "modifier_ikki_shinkiro"
end
function ikki_shinkiro:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("perfect_vision")
    if ability and ability:GetLevel() < self:GetLevel() then
       ability:SetLevel(self:GetLevel())
    end
end
function ikki_shinkiro:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function ikki_shinkiro:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = 350
	local duration = 2
	local damage = self:GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_ikki_20")

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
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_blade_steal2", -- modifier name
			{ duration = duration } -- kv
		)
	end

	self:PlayEffects( radius )
end

function ikki_shinkiro:PlayEffects( radius )
	local particle_cast = "particles/crit_red.vpcf"
	local sound_cast = "ikki.shinkiro"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_ikki_shinkiro = class({})

function modifier_ikki_shinkiro:IsHidden() return true end
function modifier_ikki_shinkiro:IsDebuff() return false end
function modifier_ikki_shinkiro:IsPurgable() return false end
function modifier_ikki_shinkiro:IsPurgeException() return false end
function modifier_ikki_shinkiro:RemoveOnDeath() return false end

function modifier_ikki_shinkiro:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		
    }

    return funcs
end

function modifier_ikki_shinkiro:GetModifierBaseAttackTimeConstant()
	return 1.7
end
function modifier_ikki_shinkiro:OnAttackLanded(params)
self.ability = self:GetAbility()
self.crit_chance = 20
if params.target~=self:GetParent() then return end
if not params.target:IsIllusion() then
if self:GetAbility():IsFullyCastable() then
if not params.target:IsStunned() then
if RandomInt(0, 100)<self.crit_chance then

		-- cancel if immune
		if params.attacker:IsMagicImmune() then return end
local blinkDistance = 50
	local target_loc_forward_vector = params.attacker:GetForwardVector()
	local final_pos = params.attacker:GetAbsOrigin() - target_loc_forward_vector * 150
local duration  = self:GetAbility():GetSpecialValueFor('duration')	
local damage = self:GetAbility():GetSpecialValueFor('damage') + self:GetCaster():FindTalentValue("special_bonus_ikki_20")
	 self.ability:StartCooldown(self.ability:GetCooldown(-1) * self:GetParent():GetCooldownReduction())

	-- Blink
	self:GetParent():SetOrigin( final_pos )
	FindClearSpaceForUnit( self:GetParent(), final_pos, true )
	self:GetParent():SetForwardVector(target_loc_forward_vector)
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_2)
	EmitSoundOn( "ikki.shinkiro", params.attacker )
	local damageTable = {
		victim = params.attacker,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	
	params.attacker:AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = duration } -- kv
	)
	local target = params.attacker
	self:PlayEffects(target)
end
end
end
end
end
function modifier_ikki_shinkiro:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/ikki_shinkiro.vpcf"

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


ikki_blade_steal = class({})
LinkLuaModifier( "modifier_ikki_blade_steal", "heroes/ikki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ikki_blade_steal_count", "heroes/ikki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ikki_blade_steal_buff", "heroes/ikki", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function ikki_blade_steal:GetIntrinsicModifierName()
	return "modifier_ikki_blade_steal"
end



modifier_ikki_blade_steal = class({})

--------------------------------------------------------------------------------

function modifier_ikki_blade_steal:IsHidden()
	return false
end

function modifier_ikki_blade_steal:IsDebuff()
	return false
end

function modifier_ikki_blade_steal:IsPurgable()
	return false
end

function modifier_ikki_blade_steal:RemoveOnDeath()
	return false
end
function modifier_ikki_blade_steal:AllowIllusionDuplicate()
 return false 
 end

function modifier_ikki_blade_steal:DeclareFunctions()
	local funcs = {


		MODIFIER_EVENT_ON_ATTACK_LANDED,

	}

	return funcs
end
function modifier_ikki_blade_steal:OnAttackLanded(params)
self.ability = self:GetAbility()
self.number = self.ability:GetSpecialValueFor("attacks")
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	if self:GetAbility():IsFullyCastable() then
	if params.attacker == self:GetParent() then
		if self:GetParent():IsRealHero() then
	    if not params.attacker:IsIllusion() then
			local target = params.target
			local duration = self.ability:GetSpecialValueFor("duration")
			local target_stack = target:GetModifierStackCount("modifier_ikki_blade_steal_count",self:GetCaster())
			if target_stack == self.number or target:HasModifier("modifier_perfect_vision1") then 
			self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ikki_blade_steal_buff", -- modifier name
		{
			duration = duration,
			buff_duration = duration,
		} 
	)
	target:RemoveModifierByName("modifier_ikki_blade_steal_count")
	EmitSoundOn( "ikki.blade_steal", params.attacker )
	local ability = self:GetParent():FindAbilityByName("ikki_blade_steal")
	 ability:StartCooldown(self.ability:GetCooldown(-1) * self:GetParent():GetCooldownReduction())
  else

			target:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ikki_blade_steal_count", -- modifier name
		{
			duration = 5,
			
		} 
	)
			end
			end
		end
	end
	end
	end
	end

modifier_ikki_blade_steal_count = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ikki_blade_steal_count:IsHidden()
	return false
end

function modifier_ikki_blade_steal_count:IsDebuff()
	return true
end

function modifier_ikki_blade_steal_count:IsStunDebuff()
	return false
end

function modifier_ikki_blade_steal_count:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ikki_blade_steal_count:OnCreated( kv )
	self.duration = kv.buff_duration

	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_ikki_blade_steal_count:OnRefresh( kv )
	
	local max_stack = 10

	if IsServer() then
	if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
		
	end
end

function modifier_ikki_blade_steal_count:OnDestroy( kv )

end

function modifier_ikki_blade_steal_count:GetEffectName()
	return "particles/blade_steal_debuff.vpcf"
end

function modifier_ikki_blade_steal_count:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_ikki_blade_steal_buff = class({})
function modifier_ikki_blade_steal_buff:IsHidden() return false end
function modifier_ikki_blade_steal_buff:IsDebuff() return false end
function modifier_ikki_blade_steal_buff:IsPurgable() return true end
function modifier_ikki_blade_steal_buff:IsPurgeException() return true end
function modifier_ikki_blade_steal_buff:RemoveOnDeath() return true end
function modifier_ikki_blade_steal_buff:OnCreated(table)
	self.parent = self:GetParent()
	
     if not IsServer() then return end
	 
	 self.damage = self:GetCaster():GetAttackDamage()
	 self.damage2 = self.damage * 0.8
	 
   
end
function modifier_ikki_blade_steal_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_ikki_blade_steal_buff:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
					
					}
	return func
end
function modifier_ikki_blade_steal_buff:GetModifierProcAttack_BonusDamage_Physical()
    return self.damage2
end

function modifier_ikki_blade_steal_buff:GetEffectName()
	return "particles/blade_steal_buff.vpcf"
end
function modifier_ikki_blade_steal_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end






ten_i_muho = class({})
LinkLuaModifier( "modifier_ten_i_muho", "heroes/ikki", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_ten_i_muho_debuff", "heroes/ikki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_BOTH )


function ten_i_muho:Spawn()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Ability Start
function ten_i_muho:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- add charge modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_ten_i_muho", -- modifier name
		{ target = target:entindex() } -- kv
	)
end






modifier_ten_i_muho = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ten_i_muho:IsHidden()
	return false
end

function modifier_ten_i_muho:IsDebuff()
	return false
end

function modifier_ten_i_muho:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ten_i_muho:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "movement_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "bash_radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

	if not IsServer() then return end

	self.target = EntIndexToHScript( kv.target )
	self.direction = self:GetParent():GetForwardVector()
	self.targets = {}

	self.search_radius = 1250
	self.tree_radius = 150
	self.min_dist = 150
	self.offset = 20
	self.interrupted = false

	-- check ability
	

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	-- set target
	self:SetTarget( self.target )

	-- set ability as inactive
	self:GetAbility():SetActivated( false )

	-- play effects
	local sound_cast = "ikki.swoosh"
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_ten_i_muho:OnRefresh( kv )
	
end

function modifier_ten_i_muho:OnRemoved()
end

function modifier_ten_i_muho:OnDestroy()
	if not IsServer() then return end

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, true )

	self:GetParent():RemoveHorizontalMotionController( self )

	-- remove debuff
	if self.debuff and (not self.debuff:IsNull()) then
		self.debuff:Destroy()
	end

	-- set ability as inactive
	self:GetAbility():SetActivated( true )

	-- start cooldown
	self:GetAbility():UseResources( false, false, true )


	if self.interrupted then return end
	
	-- bash
	if self.mod and (not self.mod:IsNull()) then
		self.mod:Bash( self.target, false )
	end
local damage  = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_ikki_25")
	-- stun enemy
	self.target:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = self.duration } -- kv
	)
	local damageTable = {
		victim = self.target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	self:PlayEffects()

	-- set attack target
	if self.target:IsAlive() then
		-- command to attack target
		local order = {
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.target:entindex(),
		}
		ExecuteOrderFromTable( order )
		-- self.parent:SetAttacking( self.target )
	end
	local radius = 250

	-- play effects
	local sound_cast = "ikki.ten_i_muho_strike"
	EmitSoundOn( sound_cast, self.target )
end
function modifier_ten_i_muho:PlayEffects( radius )
	local particle_cast = "particles/ikki_ten_i_muho_strike.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ten_i_muho:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
				MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end
function modifier_ten_i_muho:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_6
end


function modifier_ten_i_muho:OnOrder( params )
	if params.unit~=self.parent then return end

	-- TODO: check more orders

	if
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or
		params.order_type==DOTA_UNIT_ORDER_STOP or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION or
		params.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
		params.order_type==DOTA_UNIT_ORDER_CAST_TARGET_TREE or
		params.order_type==DOTA_UNIT_ORDER_CAST_RUNE or
		params.order_type==DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION
	then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_ten_i_muho:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_ten_i_muho:GetModifierIgnoreMovespeedLimit()
	return 1
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_ten_i_muho:UpdateHorizontalMotion( me, dt )
	-- bash logic
	self:BashLogic()

	-- cancel logic
	self:CancelLogic()

	-- get direction
	local direction = self.target:GetOrigin()-me:GetOrigin()
	local dist = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()

	-- check if near
	if dist<self.min_dist then
		self:Destroy()
		return
	end

	-- set target pos
	local pos = me:GetOrigin() + direction * me:GetIdealSpeed() * dt
	pos = GetGroundPosition( pos, me )

	me:SetOrigin( pos )
	self.direction = direction

	-- face towards
	self.parent:FaceTowards( self.target:GetOrigin() )
end

function modifier_ten_i_muho:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_ten_i_muho:BashLogic()
	-- check modifier
	if (not self.mod) or self.mod:IsNull() then return end

	local loc = self.parent:GetOrigin() + self.direction * self.offset

	-- find units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		loc,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		if not self.targets[enemy] then
			self.targets[enemy] = true

			-- apply bash
			self.mod:Bash( enemy, 0, false )
		end
	end
end

function modifier_ten_i_muho:CancelLogic()
	-- check stun
	local check = self.parent:IsHexed() or self.parent:IsStunned() or self.parent:IsRooted()
	if check then
		self.interrupted = true
		self:Destroy()
	end

	-- check if target is dead
	if not self.target:IsAlive() then
		-- find another valid target
		local enemies = FindUnitsInRadius(
			self.parent:GetTeamNumber(),	-- int, your team number
			self.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		if #enemies<1 then
			self.interrupted = true
			self:Destroy()
			return
		else
			self:SetTarget( enemies[1] )
		end
	end
end

function modifier_ten_i_muho:SetTarget( target )
	-- reset previous
	if self.debuff and (not self.debuff:IsNull()) then
		self.debuff:Destroy()
	end

	-- add charge indicator
	self.debuff = target:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_ten_i_muho_debuff", -- modifier name
		{} -- kv
	)

	self.target = target

	-- target gets bashed last
	self.targets[target] = true
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ten_i_muho:GetEffectName()
	return "particles/ikki_ten_i_muho.vpcf"
end

function modifier_ten_i_muho:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_rakudai_kishi = class ({})
function modifier_rakudai_kishi:IsHidden() return true end
function modifier_rakudai_kishi:IsDebuff() return false end
function modifier_rakudai_kishi:IsPurgable() return false end
function modifier_rakudai_kishi:IsPurgeException() return false end
function modifier_rakudai_kishi:RemoveOnDeath() return false end

function modifier_rakudai_kishi:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_rakudai_kishi:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_rakudai_kishi:OnIntervalThink()
    if IsServer() then
        local lerolero = self:GetParent():FindAbilityByName("perfect_vision")
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



ikki_invisible_step = class({})

LinkLuaModifier( "modifier_blade_steal2", "modifiers/modifier_blade_steal2", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start

function ikki_invisible_step:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	  if not IsServer() then return nil end
    local caster = self:GetCaster()
   

	-- load data
	local max_range = self:GetSpecialValueFor("blink_range")

	-- determine target position
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end

	-- teleport
	FindClearSpaceForUnit( caster, origin + direction, true )
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
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
			"modifier_blade_steal2", -- modifier name
			{ duration = duration } -- kv
		)
		end

   caster:StartGesture(ACT_DOTA_ATTACK2)
	self:PlayEffects( origin, direction )
	if self:GetCaster():HasModifier("modifier_ittou_shura_raiko") then
	
	self:EndCooldown()
	self:StartCooldown(4)
	end
end

--------------------------------------------------------------------------------
function ikki_invisible_step:PlayEffects( origin, direction )
	-- Get Resources
	local particle_cast_a = "particles/earthshaker_arcana_blink_end1.vpcf"
	local sound_cast_a = "ikki.blink"

	local particle_cast_b = "particles/crit_red.vpcf"
	

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	local effect_cast_b = ParticleManager:CreateParticle( particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_b )

end






















LinkLuaModifier("modifier_ittou_shura_raiko", "heroes/ikki", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)

ittou_shura_raiko = class({})

function ittou_shura_raiko:IsStealable() return true end
function ittou_shura_raiko:IsHiddenWhenStolen() return false end

function ittou_shura_raiko:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_lua")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
	if self:GetCaster():HasScepter() then
	else
	local HiddenAbilities = 
	{
	
		"ittou_shura_raiko",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetCaster():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        
    end
	end
	end
end

function ittou_shura_raiko:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
caster:RemoveModifierByName("modifier_ittou_shura")
	caster:RemoveModifierByName("modifier_star_tier1")
    caster:AddNewModifier(caster, self, "modifier_ittou_shura_raiko", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	local radius = 800
    self:PlayEffects( radius )
    self:EndCooldown()


end
function ittou_shura_raiko:PlayEffects( radius )

	local particle_cast = "particles/ittou_shura_raiko_activation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function ittou_shura_raiko:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

	

	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_ittou_shura_raiko = class({})
function modifier_ittou_shura_raiko:IsHidden() return false end
function modifier_ittou_shura_raiko:IsDebuff() return true end
function modifier_ittou_shura_raiko:IsPurgable() return false end
function modifier_ittou_shura_raiko:IsPurgeException() return false end
function modifier_ittou_shura_raiko:RemoveOnDeath() return true end
function modifier_ittou_shura_raiko:AllowIllusionDuplicate() return true end
function modifier_ittou_shura_raiko:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("ittou_shura_raiko_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_ittou_shura_raiko:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_DISABLE_HEALING,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					}
    return func
end



function modifier_ittou_shura_raiko:GetModifierAttackSpeedBonus_Constant()
    return 150
end

function modifier_ittou_shura_raiko:GetModifierBonusStats_Strength()
    return 50
end

function modifier_ittou_shura_raiko:GetModifierPreAttack_BonusDamage()
    return self.damage
end

	


function modifier_ittou_shura_raiko:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
	self.hp = self.caster:GetMaxHealth()
		self.damage = self.hp * 0.05

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["ittou_shura_raiko"] = "void_spirit_astral_step_lua",
							["ittou_shura"] = "ikki_invisible_step",
                            
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
             self.particle_time =    ParticleManager:CreateParticle("particles/ittou_shura_raiko_sfx.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        end

        
		
        EmitSoundOn("ikki.ittou_shura_last", self.parent)
        local interval = 1
self:StartIntervalThink( interval )
        self.parent:Purge(false, true, false, true, true)
		self:PlayEffects()
		self:PlayEffects2()
		self:PlayEffects3()
		self:PlayEffects4()
    end
end
end
function modifier_ittou_shura_raiko:PlayEffects( )
	-- Get Resources
	self.particle_cast = "particles/ittou_shura_raiko_screen.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForPlayer( self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
function modifier_ittou_shura_raiko:PlayEffects2( )
	-- Get Resources
	 if not self.particle_time2 then
            self.particle_time2 =    ParticleManager:CreateParticle("particles/test_ittou_shura_blood_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time2, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki1", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time2, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_ittou_shura_raiko:PlayEffects3( )
	-- Get Resources
	 if not self.particle_time3 then
            self.particle_time3 =    ParticleManager:CreateParticle("particles/test_ittou_shura_blood_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time3, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time3, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_ittou_shura_raiko:PlayEffects4( )
	-- Get Resources
	 if not self.particle_time4 then
            self.particle_time4 =    ParticleManager:CreateParticle("particles/test_ittou_shura_blood_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time4, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki3", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time4, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end


function modifier_ittou_shura_raiko:OnIntervalThink()
if not self:GetParent():HasModifier("modifier_intetsu_awake") then
self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	-- update damage
	self.damageTable.damage = 0.08*self:GetParent():GetHealth()

	-- apply damage
	ApplyDamage( self.damageTable )
end
end
function modifier_ittou_shura_raiko:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_ittou_shura_raiko:OnDestroy()
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
		ParticleManager:DestroyParticle(self.particle_time4, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time4)

            StopSoundOn("ittou.shura", self.parent)
			
ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
               if self:GetCaster():HasScepter() then
	else
                     local HiddenAbilities = 
	{
	
		"ittou_shura_raiko",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
                end
            end
        end
    end
	end
