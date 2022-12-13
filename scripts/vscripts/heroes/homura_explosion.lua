homura_explosion = class({})
LinkLuaModifier( "modifier_homura_explosion", "modifiers/modifier_homura_explosion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_explosion2", "modifiers/modifier_explosion2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_homura_bomb_explosion", "modifiers/modifier_homura_bomb_explosion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function homura_explosion:GetIntrinsicModifierName()
	return "modifier_homura_explosion"
end