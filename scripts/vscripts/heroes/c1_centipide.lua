c1_centipide = class({})
LinkLuaModifier( "modifier_c1_centipide_root", "modifiers/modifier_c1_centipide_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_c1_centipide", "modifiers/modifier_c1_centipide", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
-- Ability Start
function c1_centipide:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor( "debuff_duration" )

	-- add debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_c1_centipide", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	
end

--------------------------------------------------------------------------------

