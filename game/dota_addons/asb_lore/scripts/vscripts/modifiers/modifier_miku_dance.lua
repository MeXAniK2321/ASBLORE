modifier_miku_dance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_miku_dance:IsHidden()
	return false
end

function modifier_miku_dance:IsDebuff()
	return false
end

function modifier_miku_dance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_miku_dance:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value
	self.caster = self:GetParent()
	self.interval = 2

	if IsServer() then
		-- initialize
		self.active = true
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage ,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		--Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- start effects
        if IsASBPatreon(self.caster) then
		    self:PlayEffects2( self.radius )
		else
            self:PlayEffects( self.radius )
        end
	end
end

function modifier_miku_dance:OnRefresh( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "sand_storm_damage" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "sand_storm_radius" ) -- special value

	if IsServer() then
		-- initialize
		self.damageTable.damage = self.damage 
		self.active = kv.start
		self:SetDuration( kv.duration, true )
	end
end

function modifier_miku_dance:OnDestroy( kv )
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
function modifier_miku_dance:OnIntervalThink()
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
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 1.3 } -- kv
		)
		self:GetCaster():PerformAttack(enemy, true,
				true,
				true,
				true,
				true,
				false,
				true)
			
	end

	-- effects: reposition cloud
	if self.effect_cast then
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_miku_dance:PlayEffects( radius )
	-- Get Resources
	local particle_cast = "particles/miku_song_aura.vpcf"
	local sound_cast = "miku.song_"..RandomInt(1,3)

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )
    self:AddParticle(self.effect_cast, false, false, -1, false, false)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_miku_dance:PlayEffects2( radius )
	-- Get Resources
	local particle_cast = "particles/miku_song_aura_kizuna_ai.vpcf"
	local sound_cast = "miku.kizuna_ai.song_1"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )
    self:AddParticle(self.effect_cast, false, false, -1, false, false)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_miku_dance:StopEffects()
	-- Stop particles
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Stop sound
	local sound_cast = ""
	StopSoundOn( "miku.song_1", self:GetParent() )
	StopSoundOn( "miku.song_2", self:GetParent() )
	StopSoundOn( "miku.song_3", self:GetParent() )
	StopSoundOn( "miku.kizuna_ai.song_1", self:GetParent() )

end