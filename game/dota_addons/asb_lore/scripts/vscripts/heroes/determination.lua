determination = class({})
LinkLuaModifier( "modifier_determination", "modifiers/modifier_determination", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_genocide", "modifiers/modifier_genocide", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_genocide_complited", "modifiers/modifier_genocide", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_storyshift", "modifiers/modifier_storyshift", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function determination:GetIntrinsicModifierName()
	return "modifier_determination"
end