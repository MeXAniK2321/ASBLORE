modifier_c1_centipide_root = class({})

--------------------------------------------------------------------------------

function modifier_c1_centipide_root:IsDebuff()
	return true
end

function modifier_c1_centipide_root:IsStunDebuff()
	return false
end
function modifier_c1_centipide_root:IsPurgable()
	return true
end

function modifier_c1_centipide_root:OnCreated( kv )
	
	local sound_cast = "deidara.centipide"
	EmitSoundOn( sound_cast, self:GetParent() )
end
function modifier_c1_centipide_root:OnDestroy()
self.damage = self:GetAbility():GetSpecialValueFor( "damagex" )+ self:GetCaster():FindTalentValue("special_bonus_deidara_25")
	local damage = self.damage
	self.radius = 300
	

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
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
function modifier_c1_centipide_root:PlayEffects()
	-- stop sound
	local sound_end = "deidara.centipide"
	StopSoundOn( sound_end, self:GetParent() )
	
	-- Get Resources
	local particle_cast = "particles/deidara_c1.vpcf"
	local sound_target = "deidara.c1_explode"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_c1_centipide_root:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_c1_centipide_root:GetEffectName()
	return "particles/deidara_c1_centipide.vpcf"
end
function modifier_c1_centipide_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
