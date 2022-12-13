modifier_judgment_cut_end = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_cut_end:IsHidden()
	return false
end

function modifier_judgment_cut_end:IsDebuff()
	return true
end

function modifier_judgment_cut_end:IsStunDebuff()
	return false
end

function modifier_judgment_cut_end:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_judgment_cut_end:OnCreated()

	if not IsServer() then return end
	if not self.thinker then return end
	self.radius = 600
	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
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
		enemy:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_judgment_end",
			{ duration = 1.5 }
		)
		
	end
	



	

	
	self:PlayEffects()
end

function modifier_judgment_cut_end:OnRefresh( kv )
	
end

function modifier_judgment_cut_end:OnRemoved()
end

function modifier_judgment_cut_end:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
	ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_judgment_cut_end:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		
		
	}

	return state
end




function modifier_judgment_cut_end:IsAura()
	return self.thinker
end

function modifier_judgment_cut_end:GetModifierAura()
	return "modifier_judgment_cut_end"
end

function modifier_judgment_cut_end:GetAuraRadius()
	return self.radius
end

function modifier_judgment_cut_end:GetAuraDuration()
	return 0.5
end

function modifier_judgment_cut_end:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_judgment_cut_end:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_judgment_cut_end:GetAuraSearchFlags()
	return 0
end



function modifier_judgment_cut_end:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/judgment_cut_end.vpcf"
	

	-- Create Particle
	self.particle_time = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.particle_time, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.particle_time, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		self.particle_time,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)


end