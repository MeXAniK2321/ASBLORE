modifier_leg_eating_forest_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_leg_eating_forest_thinker:IsHidden()
	return false
end

function modifier_leg_eating_forest_thinker:IsDebuff()
	return false
end

function modifier_leg_eating_forest_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_leg_eating_forest_thinker:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "ensnare_duration" )
	self.pit_damage = self:GetAbility():GetSpecialValueFor( "pit_damage" ) + self:GetCaster():FindTalentValue("special_bonus_kumagawa_25")

	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- start interval
	self:StartIntervalThink( 0.2 )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects()
	
	
		

end

function modifier_leg_eating_forest_thinker:OnRefresh( kv )
	
end

function modifier_leg_eating_forest_thinker:OnRemoved()

end

function modifier_leg_eating_forest_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_leg_eating_forest_thinker:OnIntervalThink()
	-- Using aura's sticky duration doesn't allow it to be purged, so here we are

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
									damage_type = DAMAGE_TYPE_PHYSICAL,
									--damage_flags = self.ability:GetAbilityTargetFlags(),
									ability = self:GetAbility() }

			ApplyDamage(damage_table)
		end
	end

function modifier_leg_eating_forest_thinker:IsAura()
	return true
end



function modifier_leg_eating_forest_thinker:GetModifierAura()
	return "modifier_leg_eating_forest_aura"
end


function modifier_leg_eating_forest_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end



function modifier_leg_eating_forest_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end


function modifier_leg_eating_forest_thinker:GetAuraRadius()
	return 650
end

function modifier_leg_eating_forest_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/leg_eating_forest.vpcf"
	local sound_cast = "kumagawa.1_1"

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
	EmitSoundOn( sound_cast, parent )
end

modifier_leg_eating_forest_aura = class({})
function modifier_leg_eating_forest_aura:CheckState()
    if self:GetCaster():HasModifier( "modifier_good_loser" ) then
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    
    return state
end
end