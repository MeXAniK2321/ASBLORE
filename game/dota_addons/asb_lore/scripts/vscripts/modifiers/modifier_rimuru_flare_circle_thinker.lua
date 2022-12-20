modifier_rimuru_flare_circle_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rimuru_flare_circle_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rimuru_flare_circle_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")+ self:GetCaster():FindTalentValue("special_bonus_rimuru_25")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.duration = self:GetAbility():GetSpecialValueFor("silence_duration")
		local vision = 400

		-- Start interval
		self:StartIntervalThink( delay )

		-- Create fow viewer
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), vision, 3, true)

		-- effects
		self:PlayEffects1()
	end
end

function modifier_rimuru_flare_circle_thinker:OnDestroy( kv )
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rimuru_flare_circle_thinker:OnIntervalThink()
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

	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_burn", -- modifier name
			{ duration = self.duration } -- kv
		)

	end

	self:PlayEffects2()
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rimuru_flare_circle_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/rimuru_fire_emblem.vpcf"
	local sound_cast = "rimuru.flre_circle2"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )


	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_rimuru_flare_circle_thinker:PlayEffects2()
local particle_cast = "particles/rimuru_fire_storm.vpcf"
	

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )


	-- Create Sound

end

