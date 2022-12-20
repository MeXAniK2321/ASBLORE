c4_explosion = class({})
LinkLuaModifier( "modifier_c4_explosion", "modifiers/modifier_c4_explosion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_c4_explosion2", "modifiers/modifier_c4_explosion2", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function c4_explosion:GetIntrinsicModifierName()
	return "modifier_c4_explosion"
end