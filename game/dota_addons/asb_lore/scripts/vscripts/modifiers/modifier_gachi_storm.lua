modifier_gachi_storm = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_gachi_storm:IsHidden()
	return false
end

function modifier_gachi_storm:IsDebuff()
	return false
end

function modifier_gachi_storm:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_gachi_storm:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) + self:GetCaster():FindTalentValue("special_bonus_bogdan_25")
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value
	self.interval = 0.5
	self.stun_duration = 0.1
 
	if IsServer() then
		-- initialize
		self.active = true
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage * self.interval,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- start effects
		local caster = self:GetParent()
		if IsASBPatreon(caster) then
	self:PlayEffects2( self.radius )
	else
		self:PlayEffects( self.radius )
	end
end
end

function modifier_gachi_storm:OnRefresh( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) + self:GetCaster():FindTalentValue("special_bonus_bogdan_25") -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value

	if IsServer() then
		-- initialize
		self.damageTable.damage = self.damage * self.interval
		self.active = kv.start
		self:SetDuration( kv.duration, true )
	end
end

function modifier_gachi_storm:OnDestroy( kv )
	if IsServer() then
		-- stop effects
		self:StopEffects()
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects


--------------------------------------------------------------------------------
-- Status Effects


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_gachi_storm:OnIntervalThink()

	if self.active==0 then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage enemies
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = 0.15 } )
	end

	-- effects: reposition cloud
	if self.effect_cast then
		--ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_gachi_storm:PlayEffects( radius )
	-- Get Resources
	
	local particle_cast = "particles/gachi_storm.vpcf"
	local sound_cast = "bogdan.kach"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_gachi_storm:PlayEffects2( radius )
	-- Get Resources
	local particle_cast = "particles/hurk_storm.vpcf"
	local sound_cast = "hurk.push_up"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_gachi_storm:StopEffects()
	-- Stop particles
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Stop sound
	local sound_cast = "bogdan.kach"
	local sound_cast2 = "hurk.push_up"
	StopSoundOn( sound_cast, self:GetParent() )
	StopSoundOn( sound_cast2, self:GetParent() )
end