modifier_c1_explosion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_c1_explosion:IsHidden()
	return false
end

function modifier_c1_explosion:IsDebuff()
	return false
end

function modifier_c1_explosion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_c1_explosion:OnCreated( kv )
	-- references
	
end

function modifier_c1_explosion:OnRefresh( kv )
	-- references
	
end

function modifier_c1_explosion:OnRemoved()
end

function modifier_c1_explosion:OnDestroy()

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_c1_explosion:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_c1_explosion:OnDeath(params)

    self.radius = 300
	local hp = self:GetParent():GetMaxHealth()
	local damage = hp
	
		
		local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	 local damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}	

	for _,enemy in pairs(enemies) do
	
	damageTable.victim = enemy
		ApplyDamage(damageTable)
		self:GetParent():RemoveModifierByName("modifier_c1_explosion")
		
	
end
local target = self:GetParent()
		self:PlayEffects1( target )
end
end
function modifier_c1_explosion:PlayEffects1( target )
	-- Load effects
	local particle_cast = "particles/homura_grenade_explosion.vpcf"
	EmitSoundOn("deidara.c1_explode", self:GetParent())

	-- if target:IsMechanical() then
	-- 	particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
	-- 	sound_cast = "Hero_PhantomAssassin.CoupDeGrace.Mech"
	-- end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	
end


--------------------------------------------------------------------------------
-- Modifier Effects






