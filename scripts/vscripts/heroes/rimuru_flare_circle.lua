rimuru_flare_circle = class({})
LinkLuaModifier( "modifier_generic_burn", "modifiers/modifier_generic_burn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rimuru_flare_circle_thinker", "modifiers/modifier_rimuru_flare_circle_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function rimuru_flare_circle:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function rimuru_flare_circle:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_predator")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function rimuru_flare_circle:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data

	-- create thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_rimuru_flare_circle_thinker",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = "rimuru.flare_circle"
	EmitSoundOn( sound_cast, caster )
end