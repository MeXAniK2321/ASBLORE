lord_gaben = class({})
LinkLuaModifier( "modifier_lord_gaben_thinker", "modifiers/modifier_lord_gaben_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function lord_gaben:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function lord_gaben:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_predator")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function lord_gaben:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data

	-- create thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_lord_gaben_thinker",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = "daisuke_5_1"
	EmitSoundOn( sound_cast, caster )
end