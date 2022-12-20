modifier_freya = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_freya:IsHidden()
	return true
end

function modifier_freya:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_freya:OnCreated( kv )
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

function modifier_freya:OnRefresh( kv )
	
end

function modifier_freya:OnRemoved()
end

function modifier_freya:OnDestroy()
	if not IsServer() then return end

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
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_root", -- modifier name
			{ duration = self.duration } -- kv
		)

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
function modifier_freya:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/freya_true.vpcf"
	local sound_cast = "lelouch.freya2"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end


modifier_freya_slow = class({})

--------------------------------------------------------------------------------

function modifier_freya_slow:IsDebuff()
	return true
end

function modifier_freya_slow:IsStunDebuff()
	return false
end
function modifier_freya_slow:IsHidden()
	return false
end
function modifier_freya_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_freya_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_freya_slow:GetModifierMoveSpeedBonus_Percentage()
	return -30
end

--------------------------------------------------------------------------------

function modifier_freya_slow:GetEffectName()
	return "particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow_caster_ember.vpcf"
end

function modifier_freya_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end