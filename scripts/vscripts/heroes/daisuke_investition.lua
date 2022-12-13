daisuke_investition = class({})
LinkLuaModifier( "modifier_daisuke_investition", "modifiers/modifier_daisuke_investition", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function daisuke_investition:GetIntrinsicModifierName()
	return "modifier_daisuke_investition"
end