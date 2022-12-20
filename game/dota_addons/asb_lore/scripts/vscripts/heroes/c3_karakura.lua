c3_karakura = class({})
LinkLuaModifier( "modifier_c3", "modifiers/modifier_c3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
function c3_karakura:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("deidara_c4")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function c3_karakura:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end


function c3_karakura:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_c3", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	EmitSoundOn("deidara.karakura", caster)
	
end
