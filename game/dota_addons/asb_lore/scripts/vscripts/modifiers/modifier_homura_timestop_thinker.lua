modifier_homura_timestop_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_homura_timestop_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
	if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
		self:PlayEffects2()
		else
		self:PlayEffects()
		end
	end
end

function modifier_homura_timestop_thinker:OnRefresh( kv )
	
end

function modifier_homura_timestop_thinker:OnRemoved()
end

function modifier_homura_timestop_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_homura_timestop_thinker:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_homura_timestop_thinker:IsAura()
	return true
end

function modifier_homura_timestop_thinker:GetModifierAura()
	return "modifier_homura_timestop_effect"
end

function modifier_homura_timestop_thinker:GetAuraRadius()
	return self.radius
end

function modifier_homura_timestop_thinker:GetAuraDuration()
	return 0.01
end

function modifier_homura_timestop_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_homura_timestop_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_homura_timestop_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_homura_timestop_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/homura_timestop.vpcf"
	local sound_cast = ""

	-- Create Particle
   local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
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
function modifier_homura_timestop_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/homura_timestop2.vpcf"
	local sound_cast = ""

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