crystal_maiden_freezing_field_lua = class({})
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_lua", "modifiers/modifier_crystal_maiden_freezing_field_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_freezing_field_lua_effect", "modifiers/modifier_crystal_maiden_freezing_field_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function crystal_maiden_freezing_field_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- Add modifier
	self.modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_crystal_maiden_freezing_field_lua", -- modifier name
		{ duration = self:GetChannelTime() } -- kv
	)
	EmitSoundOn("shu.last", caster)
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function crystal_maiden_freezing_field_lua:GetChannelTime()

-- end

function crystal_maiden_freezing_field_lua:OnChannelFinish( bInterrupted )
local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage_bomb")

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
			"modifier_generic_silenced_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end

	self:PlayEffects( radius )
	if self.modifier then
		self.modifier:Destroy()
		self.modifier = nil
	end
end
function crystal_maiden_freezing_field_lua:PlayEffects( radius )
	local particle_cast = "particles/puck_waning_rift2.vpcf"
	local sound_cast = "shu.void"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function crystal_maiden_freezing_field_lua:AbilityConsiderations()
	-- Scepter
	

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