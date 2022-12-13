--------------------------------------------------------------------------------
modifier_jibril_kurianse_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_jibril_kurianse_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	
	self:StartIntervalThink( 0.7)

	if IsServer() then
		self:PlayEffects()
	end
end
function modifier_jibril_kurianse_thinker:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
local radius = 400
	for _,enemy in pairs(enemies) do
		-- apply damage
		local knockback = { should_stun = 0,
                        knockback_duration = 0.3,
                        duration = 0.3,
                        knockback_distance = 400,
                        knockback_height = 0,
                        center_x = self:GetParent():GetAbsOrigin().x,
                        center_y = self:GetParent():GetAbsOrigin().y,
                        center_z = self:GetParent():GetAbsOrigin().z }

    enemy:AddNewModifier(self:GetParent(), self, "modifier_knockback", knockback)

		-- play effects
		self:PlayEffects2( radius )
	end
end
function modifier_jibril_kurianse_thinker:PlayEffects2( radius )
	local particle_cast = "particles/kurianse_shockwave.vpcf"
	 local radius = 400

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end
function modifier_jibril_kurianse_thinker:OnRefresh( kv )
	
end

function modifier_jibril_kurianse_thinker:OnRemoved()
end

function modifier_jibril_kurianse_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_jibril_kurianse_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_jibril_kurianse_thinker:IsAura()
	return true
end

function modifier_jibril_kurianse_thinker:GetModifierAura()
	return "modifier_jibril_kurianse_effect"
end

function modifier_jibril_kurianse_thinker:GetAuraRadius()
	return self.radius
end

function modifier_jibril_kurianse_thinker:GetAuraDuration()
	return 0.01
end

function modifier_jibril_kurianse_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_jibril_kurianse_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_jibril_kurianse_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_jibril_kurianse_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/jibril_kurianse.vpcf"
	local sound_cast = "jibril.6"

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

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