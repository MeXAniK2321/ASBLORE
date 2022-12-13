modifier_mikagura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mikagura:IsHidden()
	return true
end

function modifier_mikagura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mikagura:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_mikagura:OnRefresh( kv )
	
end

function modifier_mikagura:OnRemoved()
end

function modifier_mikagura:OnDestroy()
	if not IsServer() then return end
local caster = self:GetCaster()
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
		if caster:HasModifier("modifier_heavenly_body_magic") then
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)
		else
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_mikagura_slow", -- modifier name
			{ duration = self.duration } -- kv
		)
		end

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_mikagura:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/circle_explosion.vpcf"
	local sound_cast = "magic.explosion"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end


modifier_mikagura_slow = class({})

--------------------------------------------------------------------------------

function modifier_mikagura_slow:IsDebuff()
	return true
end

function modifier_mikagura_slow:IsStunDebuff()
	return false
end
function modifier_mikagura_slow:IsHidden()
	return false
end
function modifier_mikagura_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_mikagura_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_mikagura_slow:GetModifierMoveSpeedBonus_Percentage()
	return -30
end

--------------------------------------------------------------------------------

function modifier_mikagura_slow:GetEffectName()
	return "particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow_caster_ember.vpcf"
end

function modifier_mikagura_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end