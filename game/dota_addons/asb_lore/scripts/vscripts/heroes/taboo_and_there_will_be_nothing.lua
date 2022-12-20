taboo_and_there_will_be_nothing = class({})
LinkLuaModifier( "modifier_taboo_and_there_will_be_nothing", "modifiers/modifier_taboo_and_there_will_be_nothing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_taboo_and_there_will_be_nothing_self", "modifiers/modifier_taboo_and_there_will_be_nothing_self", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function taboo_and_there_will_be_nothing:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")
  caster:AddNewModifier(caster, self, "modifier_taboo_and_there_will_be_nothing_self", {duration = 2})
	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
	if enemy:HasModifier( "modifier_fountain_aura_effect_lua" )  then
	
	else
    
		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_taboo_and_there_will_be_nothing", -- modifier name
			{ duration = duration } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 1.8 } -- kv
		)
	end
	end

	self:PlayEffects( radius )
end

function taboo_and_there_will_be_nothing:PlayEffects( radius )
	local particle_cast = "particles/flandr_murder.vpcf"
	local sound_cast = "flandr.5_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end