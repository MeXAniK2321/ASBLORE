modifier_explosion2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_explosion2:IsHidden()
	return false
end

function modifier_explosion2:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_explosion2:IsStunDebuff()
	return true
end

function modifier_explosion2:IsPurgable()
	return true
end

function modifier_explosion2:RemoveOnDeath()
	return true
end
function modifier_explosion2:OnDestroy()
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local damage = self.damage
	self.radius = 450
	

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
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play overhead event
		
	end
	self:PlayEffects()
	
end
function modifier_explosion2:PlayEffects()
	-- stop sound
	local sound_end = "deidara.c1_explode"
	StopSoundOn( sound_end, self:GetParent() )
	
	-- Get Resources
	local particle_cast = "particles/deidara_c1.vpcf"
	local sound_target = "homura.1_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
