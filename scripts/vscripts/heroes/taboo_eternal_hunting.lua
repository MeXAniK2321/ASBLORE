taboo_eternal_hunting = class({})
LinkLuaModifier( "modifier_taboo_eternal_hunting", "modifiers/modifier_taboo_eternal_hunting", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier


--------------------------------------------------------------------------------
-- Ability Start
function taboo_eternal_hunting:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local vrag = self:GetCursorTarget()
	local point = vrag:GetOrigin()
	local origin = caster:GetOrigin()

	-- load data
	local min_dist = self:GetSpecialValueFor( "min_travel_distance" )
	local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
	local radius = self:GetSpecialValueFor( "radius" )
	local delay = self:GetSpecialValueFor( "pop_damage_delay" )
	local duration = self:GetSpecialValueFor( "duration" )

	-- find destination
	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )

	-- teleport
	FindClearSpaceForUnit( caster, target, true )

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_taboo_eternal_hunting", -- modifier name
			{ duration = delay } -- kv
		)
		
		

		-- play effects
		self:PlayEffects2( enemy )
end
vrag:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_dark_willow_terrorize_lua", -- modifier name
			{ duration = duration } -- kv
		)
	-- play effects
	self:PlayEffects1( origin, target )
	if self:GetCaster():HasModifier("modifier_lunatic_nightmare_thinker_in") then
		self:EndCooldown()
	self:StartCooldown(1)
	end
end

--------------------------------------------------------------------------------
function taboo_eternal_hunting:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/taboo_eternal_hunting_exp.vpcf"
	local sound_start = "flandr.3"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )

end

function taboo_eternal_hunting:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/void_spirit_astral_step_impact1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

