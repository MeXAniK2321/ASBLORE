danku = class({})
LinkLuaModifier( "modifier_danku_thinker", "modifiers/modifier_danku_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_danku_debuff", "modifiers/modifier_danku_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "modifiers/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function danku:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_dark_seer_illusion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica_replicate.vpcf", context )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function danku:OnAbilityPhaseInterrupted()
end

function danku:OnAbilityPhaseStart()
	-- Vector targeting
	if not self:CheckVectorTargetPosition() then return false end
	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function danku:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local targets = self:GetVectorTargetPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_danku_thinker", -- modifier name
		{
			duration = duration,
			x = targets.direction.x,
			y = targets.direction.y,
		}, -- kv
		targets.init_pos,
		caster:GetTeamNumber(),
		false
	)
end