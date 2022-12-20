rimuru_black_flame = class({})
LinkLuaModifier( "modifier_generic_burn", "modifiers/modifier_generic_burn", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function rimuru_black_flame:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function rimuru_black_flame:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_black_lightning")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function rimuru_black_flame:OnSpellStart()
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
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	for _,enemy in pairs(enemies) do
		-- Apply damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- Add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_burn", -- modifier name
			{ duration = debuffDuration } -- kv
		)
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )

	self:PlayEffects( point, radius, debuffDuration )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function rimuru_black_flame:AbilityConsiderations()
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
function rimuru_black_flame:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/rimuru_black_flame.vpcf"
	local sound_cast = "rimuru.dark_flame"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end