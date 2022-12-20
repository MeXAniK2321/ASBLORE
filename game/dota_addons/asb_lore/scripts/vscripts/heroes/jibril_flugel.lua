jibril_flugel = class({})
LinkLuaModifier( "modifier_jibril_flugel", "modifiers/modifier_jibril_flugel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jibril_flugel_damage", "modifiers/modifier_jibril_flugel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function jibril_flugel:GetIntrinsicModifierName()
	return "modifier_jibril_flugel"
end