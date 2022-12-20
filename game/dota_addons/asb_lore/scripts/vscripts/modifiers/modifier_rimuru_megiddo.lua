modifier_rimuru_megiddo = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_rimuru_megiddo:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if IsServer() then
	self:StartIntervalThink( 0.8 )
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
		
	end
end

function modifier_rimuru_megiddo:OnIntervalThink()
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

function modifier_rimuru_megiddo:OnRefresh( kv )
	
end


function modifier_rimuru_megiddo:PlayEffects2( target )
	local sound_cast = "rimuru.6_5"
	local particle_cast = "particles/rimuru_megiddo_hit.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn("rimuru.6_5_1", self:GetParent())
end


