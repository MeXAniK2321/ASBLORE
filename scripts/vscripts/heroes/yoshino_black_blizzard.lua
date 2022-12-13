yoshino_black_blizzard = class({})
LinkLuaModifier( "modifier_yoshino_black_blizzard", "heroes/yoshino_black_blizzard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sheer_cold", "modifiers/modifier_sheer_cold", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function yoshino_black_blizzard:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function yoshino_black_blizzard:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 3

	-- load data


	-- create thinker
	 CreateModifierThinker( caster, self, "modifier_yoshino_black_blizzard", { duration = duration }, point, caster:GetTeamNumber(), false )
	
end


modifier_yoshino_black_blizzard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_yoshino_black_blizzard:IsHidden()
	return true
end

function modifier_yoshino_black_blizzard:IsDebuff()
	return false
end

function modifier_yoshino_black_blizzard:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_yoshino_black_blizzard:IsAura()
	return true
end

function modifier_yoshino_black_blizzard:GetModifierAura()
	return "modifier_sheer_cold"
end

function modifier_yoshino_black_blizzard:GetAuraRadius()
	return self.slow_radius
end

function modifier_yoshino_black_blizzard:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_yoshino_black_blizzard:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_yoshino_black_blizzard:GetAuraDuration()
	return self.slow_duration
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_yoshino_black_blizzard:OnCreated( kv )
	-- references
	self.slow_radius = 300
	self.slow_duration = 1
	self.explosion_radius = 300
	self.explosion_interval = 0.2
	self.explosion_min_dist = 100
	self.explosion_max_dist = 200
	local explosion_damage = 250

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()

		-- Play Effects
		self:PlayEffects1()
	end
end

function modifier_yoshino_black_blizzard:OnRefresh( kv )
	-- references
	self.slow_radius = 500
	self.slow_duration = 1
	self.explosion_radius = 300
	self.explosion_interval = 0.3
	self.explosion_min_dist = 100
	self.explosion_max_dist = 300
	local explosion_damage = 250

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()
	end
end

function modifier_yoshino_black_blizzard:OnDestroy( kv )
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_yoshino_black_blizzard:OnIntervalThink()
	-- Set explosion quartal
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end

	-- determine explosion relative position
	local a = RandomInt(0,90) + self.quartal*90
	local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	-- actual position
	point = self:GetParent():GetOrigin() + point

	-- Explode at point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage units
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- Play effects
	self:PlayEffects2( point )
end

--------------------------------------------------------------------------------
-- Effects
function modifier_yoshino_black_blizzard:PlayEffects1()
	local particle_cast = "particles/yoshino_black_blizzard_aura.vpcf"
	self.sound_cast = "yoshino.inversion_blizzard_start"

	-- Create Particle
	-- self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self.effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Play sound
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_yoshino_black_blizzard:PlayEffects2( point )
	-- Play particles
	local particle_cast = "particles/yoshino_black_swords.vpcf"

	-- Create particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )

	-- Play sound
	local sound_cast = "yoshino.black_sword"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetParent() )
end

function modifier_yoshino_black_blizzard:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end