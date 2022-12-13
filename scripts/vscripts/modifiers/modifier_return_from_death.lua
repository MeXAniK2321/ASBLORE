modifier_return_from_death = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_return_from_death:IsHidden()
	return true
end


function modifier_return_from_death:OnCreated( kv )
	-- references
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" ) -- special value
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "slow_radius" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value

	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" ) -- special value
end

function modifier_return_from_death:OnRefresh( kv )
	-- references
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" ) -- special value
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "slow_radius" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value
	
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" ) -- special value
end

function modifier_return_from_death:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_return_from_death:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_REINCARNATION,
		
	}
	return funcs
end

function modifier_return_from_death:ReincarnateTime( params )
	if IsServer() then
		if self:GetAbility():IsFullyCastable() then
			self:Reincarnate()
			return self.reincarnate_time
		end
		return 0
	end
end

--------------------------------------------------------------------------------
-- Helper Function
function modifier_return_from_death:Reincarnate()
	-- spend resources
	self:GetAbility():UseResources(true, false, true)

	-- find affected enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.slow_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_ALL,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- apply slow
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_generic_stunned_lua",
			{ duration = self.slow_duration }
		)
	end
	local delay = 3.33

	Timers:CreateTimer(delay,function()
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_return_from_death_buff", -- modifier name
		{ duration = 35 } -- kv
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_star_tier2", -- modifier name
		{ duration = 35 } -- kv
	)
	end)
	
	
	

	-- play effects
	self:PlayEffects()
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_return_from_death:PlayEffects()
	-- get resources
	local particle_cast = "particles/return_from_death.vpcf"
	local sound_cast = "subaru.5"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.reincarnate_time, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end