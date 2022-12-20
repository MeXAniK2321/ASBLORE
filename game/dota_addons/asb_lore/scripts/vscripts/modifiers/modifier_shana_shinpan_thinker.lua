modifier_shana_shinpan_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shana_shinpan_thinker:IsHidden()
	return false
end

function modifier_shana_shinpan_thinker:IsDebuff()
	return false
end

function modifier_shana_shinpan_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_shana_shinpan_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "ensnare_duration" )
	self.pit_damage = self:GetAbility():GetSpecialValueFor( "pit_damage" ) + self:GetCaster():FindTalentValue("special_bonus_shana_25")

	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- start interval
	self:StartIntervalThink( 0.5 )
	self:OnIntervalThink()

	-- play effects
	
	
	
		

end

function modifier_shana_shinpan_thinker:OnRefresh( kv )
	
end

function modifier_shana_shinpan_thinker:OnRemoved()

end

function modifier_shana_shinpan_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_shana_shinpan_thinker:OnIntervalThink()
	-- Using aura's sticky duration doesn't allow it to be purged, so here we are
   AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), 0.5, false)
	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- check if not cooldown
		local damage_table = {	victim = enemy, 
									attacker = self:GetCaster(), 
									damage = self.pit_damage, 
									damage_type = DAMAGE_TYPE_MAGICAL,
									--damage_flags = self.ability:GetAbilityTargetFlags(),
									ability = self:GetAbility() }

			ApplyDamage(damage_table)
			self:PlayEffects()
		end
	end
function modifier_shana_shinpan_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/shinpan_shockwave.vpcf"
	

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetDuration(), 0, 0 ) )

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
	
end
function modifier_shana_shinpan_thinker:GetEffectName()

	return "particles/test_shinpan.vpcf"
	end