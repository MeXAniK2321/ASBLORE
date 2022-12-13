kanade_blade = class({})
LinkLuaModifier( "modifier_kanade_blade", "modifiers/modifier_kanade_blade", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function kanade_blade:GetIntrinsicModifierName()
	return "modifier_kanade_blade"
end
