world_negation = class({})
LinkLuaModifier( "modifier_world_negation", "modifiers/modifier_world_negation", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function world_negation:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function world_negation:OnSpellStart()
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
	
	for _,enemy in pairs(enemies) do
		-- Apply damage
		

		-- Add modifier
		
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_world_negation", -- modifier name
			{ duration = 1.4 } -- kv
		)
		local knockback = { should_stun = 1,
                        knockback_duration = 2.5,
                        duration = 2.5,
                        knockback_distance = 0,
                        knockback_height = 500,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
		
		
		
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )


	self:PlayEffects( point, radius, debuffDuration )
	
	
	end



--------------------------------------------------------------------------------
-- Ability Considerations
function world_negation:AbilityConsiderations()
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
function world_negation:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/world_negation.vpcf"
	local sound_cast = "Pandora.0"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
