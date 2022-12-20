modifier_len_sing = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_len_sing:IsHidden()
	return false
end

function modifier_len_sing:IsDebuff()
	return false
end

function modifier_len_sing:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_len_sing:OnCreated( kv )
	-- references
	local damage = 1000
	self.radius = 350

	if not IsServer() then return end
	local interval = 1
	self.owner = kv.isProvidedByAura~=1

	if not self.owner then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_kill", -- modifier name
		{ duration = 30 } -- kv
	)

	-- Start interval
	self:StartIntervalThink( 0.8 )

	-- Play effects
	self:PlayEffects1()
end

function modifier_len_sing:OnRefresh( kv )
	-- references
	local damage = 1000
	self.radius = 350

	if not IsServer() then return end
	if not self.owner then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_len_sing:OnRemoved()
end

function modifier_len_sing:OnDestroy()

end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Interval Effects
function modifier_len_sing:OnIntervalThink()
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

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		self:PlayEffects2( enemy )
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_len_sing:IsAura()
	return self.owner
end

function modifier_len_sing:GetModifierAura()
	return "modifier_len_sing"
end

function modifier_len_sing:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_len_sing:GetEffectName()
	return "particles/len_passive.vpcf"
end

function modifier_len_sing:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_len_sing:PlayEffects1()
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )

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

function modifier_len_sing:PlayEffects2( target )
	-- Get Resources
	local particle_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end