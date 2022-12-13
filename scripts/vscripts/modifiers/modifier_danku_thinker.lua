modifier_danku_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_danku_thinker:IsHidden()
	return false
end

function modifier_danku_thinker:IsDebuff()
	return false
end

function modifier_danku_thinker:IsStunDebuff()
	return false
end

function modifier_danku_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_danku_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.team = self.caster:GetTeamNumber()

	-- references
	self.outgoing = self:GetAbility():GetSpecialValueFor( "replica_damage_outgoing" )
	self.incoming = self:GetAbility():GetSpecialValueFor( "replica_damage_incoming" )
	self.duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )

	local length = self:GetAbility():GetSpecialValueFor( "width" ) + self:GetCaster():FindTalentValue("special_bonus_aizen_20")
	

	if not IsServer() then return end

	-- get data
	local direction = Vector( kv.x, kv.y, 0 ):Normalized()
	self.origin = self:GetParent():GetOrigin() + direction*length/2
	self.target = self:GetParent():GetOrigin() - direction*length/2

	-- init
	self.width = 50
	self.bounty = 5
	local tick = 0.2
	self.illusions = {}

	-- Start interval
	self:StartIntervalThink( tick )
	self:OnIntervalThink()

	-- Play effects
	self:PlayEffects()
end

function modifier_danku_thinker:OnRefresh( kv )
	
end

function modifier_danku_thinker:OnRemoved()
end

function modifier_danku_thinker:OnDestroy()
	if not IsServer() then return end

	-- stop effects
	local sound_loop = ""
	StopSoundOn( sound_loop, self:GetParent() )

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_danku_thinker:OnIntervalThink()
	-- find line
	local enemies = FindUnitsInLine(
		self.team,	-- int, your team number
		self.origin,	-- point, center point
		self.target,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.width,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- slow
		if (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
			enemy:AddNewModifier(
				self.caster, -- player source
				self.ability, -- ability source
				"modifier_danku_debuff", -- modifier name
				{ duration = self.duration } -- kv
			)
			
		end

		-- illusion
		local id = enemy:GetPlayerOwnerID()
		
		
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_danku_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/danku.vpcf"
	local sound_cast = "aizen.2"
	local sound_loop = ""

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

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
	EmitSoundOn( sound_loop, self:GetParent() )
end