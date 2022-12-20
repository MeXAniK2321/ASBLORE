kurohitsugi1 = class({})
LinkLuaModifier( "modifier_kurohitsugi", "modifiers/modifier_kurohitsugi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- AOE Radius
function kurohitsugi1:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function kurohitsugi1:OnSpellStart()
	-- unit identifier
	if self:GetCaster():HasModifier("modifier_hogyoku_evolution") then
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()

	-- load data
	local damage = self:GetSpecialValueFor("nova_damage")

	local radius = self:GetSpecialValueFor("radius") +150
	
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
			"modifier_kurohitsugi", -- modifier name
			{ duration = debuffDuration - 0.1  } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = debuffDuration  } -- kv
		)
		
		
		
		
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )


	self:PlayEffects2( point, radius, debuffDuration )
	
	else
		
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
			"modifier_kurohitsugi", -- modifier name
			{ duration = debuffDuration -0.1 } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = debuffDuration  } -- kv
		)
		end
	

	


	
	self:PlayEffects( point, radius, debuffDuration )
	end
	end



--------------------------------------------------------------------------------
-- Ability Considerations
function kurohitsugi1:AbilityConsiderations()
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
function kurohitsugi1:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/kurohitsugi.vpcf"
	local sound_cast = "aizen.3"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
function kurohitsugi1:PlayEffects2( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/kurohitsugi2.vpcf"
	local sound_cast = "aizen.3_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end