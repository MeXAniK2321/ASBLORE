hand_sonic = class({})
LinkLuaModifier( "modifier_hand_sonic", "modifiers/modifier_hand_sonic", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function hand_sonic:GetIntrinsicModifierName()
	return "modifier_hand_sonic"
end