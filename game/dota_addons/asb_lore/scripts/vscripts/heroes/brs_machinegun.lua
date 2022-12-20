brs_machinegun = class({})
LinkLuaModifier( "modifier_brs_machinegun", "modifiers/modifier_brs_machinegun", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function brs_machinegun:OnSpellStart()
	-- get references
	local bonus_duration = self:GetDuration()

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_brs_machinegun",
		{ duration = bonus_duration }
	)

	-- Play effects
	self:PlayEffects()
end

function brs_machinegun:PlayEffects()
	-- get resources
	local sound_cast = "brs.4_1"

	-- play particles

	-- play sounds
	EmitSoundOn(sound_cast, self:GetCaster())
end