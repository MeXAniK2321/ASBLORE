brs_skattershot = class({})
LinkLuaModifier( "modifier_brs_skattershot", "modifiers/modifier_brs_skattershot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_brs_skattershot_exp", "modifiers/modifier_brs_skattershot_exp", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function brs_skattershot:GetIntrinsicModifierName()
	return "modifier_brs_skattershot"
end



