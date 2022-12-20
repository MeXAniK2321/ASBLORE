blood_queen = class({})
LinkLuaModifier( "modifier_blood_queen", "modifiers/modifier_blood_queen", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nightmare", "modifiers/modifier_nightmare", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rip_and_tear_blood", "modifiers/modifier_rip_and_tear_blood", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function blood_queen:GetIntrinsicModifierName()
	return "modifier_blood_queen"
end