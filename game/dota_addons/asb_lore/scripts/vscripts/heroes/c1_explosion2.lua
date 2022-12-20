c1_explosion2 = class({})
LinkLuaModifier( "modifier_c1_explosion", "modifiers/modifier_c1_explosion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_explosion", "modifiers/modifier_explosion", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function c1_explosion2:GetIntrinsicModifierName()
	return "modifier_c1_explosion"
end