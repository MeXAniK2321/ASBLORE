reality_negation = class({})
LinkLuaModifier( "modifier_reality_negation", "modifiers/modifier_reality_negation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hell_chance", "modifiers/modifier_hell_chance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_poison_chance", "modifiers/modifier_poison_chance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ice_chance", "modifiers/modifier_ice_chance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_war_chance", "modifiers/modifier_war_chance", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function reality_negation:OnSpellStart()
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
function reality_negation:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data

	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	

	-- stun
	if target:HasModifier( "modifier_fountain_aura_effect_lua" ) then
	else
	local damage = self:GetSpecialValueFor( "damage" ) 
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_reality_negation", -- modifier name
		{ duration = duration } -- kv
	)
	end

	-- Play effects
		local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5
	self:PlayEffects( point, radius, debuffDuration )
	local sound_cast = "Pandora.5_1"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile
function reality_negation:OnProjectileHit( target, location )
	if not target then return end

	self:Hit( target, true )
end

--------------------------------------------------------------------------------
function reality_negation:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/reality_negation.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
