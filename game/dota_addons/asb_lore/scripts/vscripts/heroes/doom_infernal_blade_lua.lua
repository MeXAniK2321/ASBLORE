doom_infernal_blade_lua = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "modifiers/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_doom_infernal_blade_lua", "modifiers/modifier_doom_infernal_blade_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function doom_infernal_blade_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

--------------------------------------------------------------------------------
-- Ability Start
function doom_infernal_blade_lua:OnSpellStart()
end

--------------------------------------------------------------------------------
-- Orb Effects
function doom_infernal_blade_lua:OnOrbImpact( params )
	-- get reference
	local duration = self:GetSpecialValueFor( "burn_duration" )
	local bash = self:GetSpecialValueFor( "ministun_duration" )

	-- add debuff
	params.target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_doom_infernal_blade_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- add ministun
	params.target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = bash } -- kv
	)
end