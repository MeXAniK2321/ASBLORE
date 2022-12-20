memory_erase = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Cast Filter
function memory_erase:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
		0,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function memory_erase:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

--------------------------------------------------------------------------------
-- Ability Start
function memory_erase:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local origin = caster:GetOrigin()
	local damage = self:GetSpecialValueFor("damage")

	-- Stop if blocked by linken
	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb( self ) then
			return
		end
	end

	-- Get data
	local buff_duration = self:GetDuration()

	-- Generate data

	-- Add modifier
	if target:GetTeamNumber()~=caster:GetTeamNumber() then
		target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_silenced_lua", -- modifier name
			{ duration = buff_duration } -- kv
		)
		local damage_table = {	victim = target,
							attacker = self:GetCaster(),
							damage = damage,
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
		caster:MoveToTargetToAttack(target)
	end

	self:PlayEffects( origin )
end

--------------------------------------------------------------------------------
function memory_erase:PlayEffects( origin )
	-- Get Resources
	local particle_cast_start = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start.vpcf"
	local sound_cast_start = "Pandora.1"
	local particle_cast_end = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_v2_end.vpcf"
	local sound_cast_end = "Pandora.6"

	-- Create Particle
	local effect_cast_start = ParticleManager:CreateParticle( particle_cast_start, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_start, 0, origin )
	ParticleManager:ReleaseParticleIndex( effect_cast_start )

	local effect_cast_end = ParticleManager:CreateParticle( particle_cast_end, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_end, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast_end )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_cast_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast_end, self:GetCaster() )
end