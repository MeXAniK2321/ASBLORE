modifier_deidara_c0 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_deidara_c0:IsHidden()
	return false
end

function modifier_deidara_c0:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_deidara_c0:IsStunDebuff()
	return true
end

function modifier_deidara_c0:IsPurgable()
	return true
end

function modifier_deidara_c0:RemoveOnDeath()
	return true
end
function modifier_deidara_c0:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true
	}

	return state
end
function modifier_deidara_c0:OnDestroy()
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local damage = self.damage
	self.radius = 1300
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	if not IsServer() then return end
	-- find enemies
	local heroes = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,hero in pairs(heroes) do
		-- apply damage
		self.damageTable.victim = hero
		ApplyDamage( self.damageTable )

		-- play overhead event
		
	end
	self:PlayEffects()
	
end
function modifier_deidara_c0:PlayEffects()
	-- stop sound
	local sound_end = ""
	StopSoundOn( sound_end, self:GetParent() )
	
	-- Get Resources
	local particle_cast = "particles/deidara_c0.vpcf"
	local sound_target = "deidara.c0_explode"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
