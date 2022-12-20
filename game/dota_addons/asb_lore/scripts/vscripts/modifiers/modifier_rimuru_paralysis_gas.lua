modifier_rimuru_paralysis_gas = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rimuru_paralysis_gas:IsHidden()
	return false
end

function modifier_rimuru_paralysis_gas:IsDebuff()
	return true
end

function modifier_rimuru_paralysis_gas:IsStunDebuff()
	return false
end

function modifier_rimuru_paralysis_gas:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rimuru_paralysis_gas:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = -self:GetAbility():GetSpecialValueFor( "root" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	-- precache damage
	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )

	-- precache effects
	self.sound_cast = "rimuru.poison2"

	-- Play effects
	self:PlayEffects()
end

function modifier_rimuru_paralysis_gas:OnRefresh( kv )
	
end

function modifier_rimuru_paralysis_gas:OnRemoved()
end

function modifier_rimuru_paralysis_gas:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end


function modifier_rimuru_paralysis_gas:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_rimuru_paralysis_gas:GetModifierMoveSpeedBonus_Percentage()
	return -70
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rimuru_paralysis_gas:OnIntervalThink()
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
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		EmitSoundOn( self.sound_cast, enemy )
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_rimuru_paralysis_gas:IsAura()
	return self.thinker
end

function modifier_rimuru_paralysis_gas:GetModifierAura()
	return "modifier_rimuru_paralysis_gas"
end

function modifier_rimuru_paralysis_gas:GetAuraRadius()
	return self.radius
end

function modifier_rimuru_paralysis_gas:GetAuraDuration()
	return 0.5
end

function modifier_rimuru_paralysis_gas:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_rimuru_paralysis_gas:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_rimuru_paralysis_gas:GetAuraSearchFlags()
	return 0
end



function modifier_rimuru_paralysis_gas:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rimuru_poison.vpcf"
	local sound_cast = "rimuru.poison"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

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