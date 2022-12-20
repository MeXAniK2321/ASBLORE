doppel_hit = class({})
LinkLuaModifier( "modifier_doppel_hit", "modifiers/modifier_doppel_hit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nightmare", "modifiers/modifier_nightmare", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rip_and_tear_blood", "modifiers/modifier_rip_and_tear_blood", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function doppel_hit:GetIntrinsicModifierName()
	return "modifier_doppel_hit"
end