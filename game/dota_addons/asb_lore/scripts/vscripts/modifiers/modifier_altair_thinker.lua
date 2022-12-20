modifier_altair_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_altair_thinker:IsHidden()
	return false
end

function modifier_altair_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_altair_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "far_radius" )
	self.interval = 1
	self.ticks = math.floor(self:GetDuration()/self.interval+0.5) -- round
	self.tick = 0
	

	if IsServer() then
		-- precache damage
		local damage = self:GetAbility():GetSpecialValueFor( "near_damage" )
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:PlayEffects()
		self:PlayEffects3()
	end
end

function modifier_altair_thinker:OnRefresh( kv )
	
end

function modifier_altair_thinker:OnRemoved()
	if IsServer() then
		-- ensure last tick damage happens
		if self:GetRemainingTime()<0.01 and self.tick<self.ticks then
			self:OnIntervalThink()
		end

		UTIL_Remove( self:GetParent() )
	end


end

function modifier_altair_thinker:OnDestroy()
	
	self.radius = self:GetAbility():GetSpecialValueFor( "far_radius" )
	local damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = 5500,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}
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
		damageTable.victim = enemy
		ApplyDamage(damageTable )
	end
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_altair_thinker:OnIntervalThink()
	-- aoe damage
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
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- tick
	self.tick = self.tick+1
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_altair_thinker:IsAura()
	return true
end

function modifier_altair_thinker:GetModifierAura()
	return "modifier_altair_debuff"
end

function modifier_altair_thinker:GetAuraRadius()
	return self.radius
end

function modifier_altair_thinker:GetAuraDuration()
	return 0.1
end

function modifier_altair_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_altair_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_altair_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/altair.vpcf"
	local sound_cast = ""

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )

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
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_altair_thinker:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/altair_circle.vpcf"
	local sound_cast = ""

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )

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
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_altair_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/altair_explosion.vpcf"
	local sound_cast = "magic.explosion"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )

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
	EmitSoundOn( sound_cast, self:GetParent() )
end