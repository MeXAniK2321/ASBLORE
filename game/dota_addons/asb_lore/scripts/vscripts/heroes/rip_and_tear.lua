rip_and_tear = class({})
LinkLuaModifier( "modifier_rip_and_tear", "modifiers/modifier_rip_and_tear", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rip_and_tear_blood", "modifiers/modifier_rip_and_tear_blood", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
function rip_and_tear:GetIntrinsicModifierName()
	return "modifier_rip_and_tear"
end

--------------------------------------------------------------------------------
-- Ability Start
function rip_and_tear:OnSpellStart()
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
function rip_and_tear:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetCaster():GetAttackDamage() * 5
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = self:GetCaster():GetAttackDamage() * 5,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun

	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_slow", -- modifier name
		{ duration = duration } -- kv
	)
	
caster:PerformAttack(target, true,
				true,
				true,
				true,
				true,
				false,
				true)
	-- Play effects
	self:PlayEffects( target, dragonform )
	local sound_cast = "chara_5"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function rip_and_tear:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function rip_and_tear:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/chara_blood2.vpcf"

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

