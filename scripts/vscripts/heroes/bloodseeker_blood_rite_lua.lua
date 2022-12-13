bloodseeker_blood_rite_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodseeker_blood_rite_lua_thinker", "modifiers/modifier_bloodseeker_blood_rite_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function bloodseeker_blood_rite_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function bloodseeker_blood_rite_lua:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_yoshino_state_inversion") then
		return "yoshino/black_circle"
	end
	return "yoshino1"
end
--------------------------------------------------------------------------------
-- Ability Start
function bloodseeker_blood_rite_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data

	-- create thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_bloodseeker_blood_rite_lua_thinker",
		{duration = 45},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, caster )
end