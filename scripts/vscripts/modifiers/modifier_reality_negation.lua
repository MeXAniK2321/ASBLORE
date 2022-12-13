modifier_reality_negation = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_reality_negation:IsHidden()
	return false
end

function modifier_reality_negation:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_reality_negation:IsStunDebuff()
	return true
end

function modifier_reality_negation:IsPurgable()
	return true
end

function modifier_reality_negation:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_reality_negation:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
end


function modifier_reality_negation:OnRefresh( kv )
	-- references
	
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_reality_negation:OnRemoved()
end

function modifier_reality_negation:OnDestroy()
	if not IsServer() then return end
	
	
	self.poison_chance = self:GetAbility():GetSpecialValueFor("poison_chance")
	self.frost_chance = self:GetAbility():GetSpecialValueFor("frost_chance")
	self.hell_chance = self:GetAbility():GetSpecialValueFor("hell_chance")

	
		if RollPercentage(self.poison_chance) then
    	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_poison_chance", -- modifier name
		{ duration = 5 } -- kv
	)
   	
	
	elseif RollPercentage(self.frost_chance) then
    	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ice_chance", -- modifier name
		{ duration = 5 } -- kv
	)
   	

   	else 
    	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_hell_chance", -- modifier name
		{ duration = 3 } -- kv
	)
    
  
	end
	-- play effects
	self:GetParent():RemoveNoDraw()
	
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_reality_negation:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_reality_negation:PlayEffects()
	-- Get Resources
	local particle_cast1 = ""
	local particle_cast2 = ""
	local sound_loop = ""

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end