good_loser = class({})
LinkLuaModifier( "modifier_good_loser", "modifiers/modifier_good_loser", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_throw_screw", "modifiers/modifier_throw_screw", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function good_loser:GetIntrinsicModifierName()
	return "modifier_good_loser"
end