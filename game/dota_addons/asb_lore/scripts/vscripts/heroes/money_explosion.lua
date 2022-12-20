money_explosion = class({})
LinkLuaModifier( "modifier_money_explosion", "heroes/money_explosion", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function money_explosion:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function money_explosion:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = 300
	

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_money_explosion", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
end
function money_explosion:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/dollar_mark1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	
end
modifier_money_explosion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_money_explosion:IsHidden()
	return true
end

function modifier_money_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_money_explosion:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local caster = self:GetCaster()
	  local gold = caster:GetGold()

  if gold > 15000 then
  self.damage = 3000
  else
  self.damage = (gold * 0.15) + 600
  end

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_money_explosion:OnRefresh( kv )
	
end

function modifier_money_explosion:OnRemoved()
end

function modifier_money_explosion:OnDestroy()
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
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_money_explosion:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/money_explosion.vpcf"
	local sound_cast = "daisuke_4_2"
	local sound_cast1 = "daisuke_4_1"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast1, self:GetCaster() )
end