modifier_bloodseeker_blood_rite_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bloodseeker_blood_rite_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_bloodseeker_blood_rite_lua_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.duration = self:GetAbility():GetSpecialValueFor("silence_duration")
		local vision = 200

		-- Start interval
		self:StartIntervalThink( 0.1 )

		-- Create fow viewer
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), vision, 3, true)

		if self:GetCaster():HasModifier("modifier_yoshino_state_inversion") then
		self:PlayEffects5()
		else
		self:PlayEffects1()
		end
	end
end

function modifier_bloodseeker_blood_rite_lua_thinker:OnDestroy( kv )
	if IsServer() then
		UTIL_Remove(self:GetParent())
		self:PlayEffects2()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_bloodseeker_blood_rite_lua_thinker:OnIntervalThink()
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
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = self.duration } -- kv
		)
		

		-- effects
		self:PlayEffects3( enemy )
		self:PlayEffects2()
		self:Destroy()
	end

	
	
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/bloodseeker_bloodritual_ring1.vpcf"
	local sound_cast = "yoshino.zayac_attack"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	assert(loadfile("modifiers/rubick_spell_steal_lua_color"))(self,self.effect_cast)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end
function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects5()
	-- Get Resources
	local particle_cast = "particles/yoshino_inversion_trap.vpcf"
	local sound_cast = "yoshino.inversion_blizzard_start"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	assert(loadfile("modifiers/rubick_spell_steal_lua_color"))(self,self.effect_cast)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects2()
	-- Get Resources
	-- local sound_cast = 

	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Sound
	-- EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects3( target )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "yoshino.spikes"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	assert(loadfile("modifiers/rubick_spell_steal_lua_color"))(self,effect_cast)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end