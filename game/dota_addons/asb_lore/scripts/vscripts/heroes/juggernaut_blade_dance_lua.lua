juggernaut_blade_dance_lua = class({})
LinkLuaModifier( "modifier_juggernaut_blade_dance_lua", "modifiers/modifier_juggernaut_blade_dance_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_juggernaut_blade_dance_lua_2", "modifiers/modifier_juggernaut_blade_dance_lua_2", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Passive Modifier
function juggernaut_blade_dance_lua:GetIntrinsicModifierName()
	return "modifier_juggernaut_blade_dance_lua" 
end


