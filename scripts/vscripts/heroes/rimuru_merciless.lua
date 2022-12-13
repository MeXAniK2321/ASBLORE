rimuru_merciless = class({})
LinkLuaModifier( "modifier_rimuru_merciless", "modifiers/modifier_rimuru_merciless", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rimuru_harvest_begin", "modifiers/modifier_rimuru_harvest_begin", LUA_MODIFIER_MOTION_NONE )
-- AOE Radius
function rimuru_merciless:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function rimuru_merciless:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetSpecialValueFor("nova_damage")

	local radius = self:GetSpecialValueFor("radius") 
	
	local debuffDuration = self:GetSpecialValueFor("duration")
	
	
	
	

	local vision_radius = 900
	local vision_duration = 6

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Precache damage	
local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}	
	
	for _,enemy in pairs(enemies) do
		-- Apply damage
		local hp = enemy:GetMaxHealth()
		local enemy_hp = hp * 0.2
		local hp_to_kill = enemy_hp + 1200
		if enemy:GetHealth() <= hp_to_kill and enemy:IsHero() and not enemy:IsIllusion()  then
        enemy:Kill(self, caster)
		local target_stack = caster:GetModifierStackCount("modifier_rimuru_merciless",self:GetCaster())
			if target_stack == 5 or self:GetCaster():HasModifier( "modifier_rimuru_harvest_begin" )  then return end
		caster:AddNewModifier(caster, self, "modifier_rimuru_merciless", {} )
		else
		end

		-- Add modifier
			
		
		
		
		
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )


	self:PlayEffects( point, radius, debuffDuration )
	
	
	end



--------------------------------------------------------------------------------
-- Ability Considerations
function rimuru_merciless:AbilityConsiderations()
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
function rimuru_merciless:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/rimuru_merciless.vpcf"
	local sound_cast = "rimuru.6_2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end