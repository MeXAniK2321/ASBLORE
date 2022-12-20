omniknight_degen_aura_lua = class({})
LinkLuaModifier( "modifier_omniknight_degen_aura_lua", "modifiers/modifier_omniknight_degen_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_degen_aura_lua_effect", "modifiers/modifier_omniknight_degen_aura_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function omniknight_degen_aura_lua:GetIntrinsicModifierName()
	return "modifier_omniknight_degen_aura_lua"
end