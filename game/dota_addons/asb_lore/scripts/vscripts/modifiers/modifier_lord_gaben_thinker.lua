modifier_lord_gaben_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lord_gaben_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lord_gaben_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
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

function modifier_lord_gaben_thinker:OnDestroy( kv )
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_lord_gaben_thinker:OnIntervalThink()
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
		

		-- effects
		self:PlayEffects3( enemy )
	end

	self:PlayEffects2()
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_lord_gaben_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/lord_gaben.vpcf"
	local sound_cast = ""

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	assert(loadfile("modifiers/rubick_spell_steal_lua_color"))(self,self.effect_cast)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_lord_gaben_thinker:PlayEffects2()
	-- Get Resources
	-- local sound_cast = 
local sound_cast = "daisuke_5_2"
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
	-- Create Sound
	-- EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_lord_gaben_thinker:PlayEffects3( target )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	assert(loadfile("modifiers/rubick_spell_steal_lua_color"))(self,effect_cast)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end