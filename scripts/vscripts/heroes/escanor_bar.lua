escanor_bar = class({})
LinkLuaModifier( "modifier_escanor_bar", "modifiers/modifier_escanor_bar", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function escanor_bar:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("escanor_sunshine")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function escanor_bar:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("AbilityDuration")

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_escanor_bar", -- modifier name
		{
			duration = duration,
			start = true,
		} -- kv
	)

	-- effects
	

end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function escanor_bar:GetChannelTime()

-- end

function escanor_bar:OnChannelFinish( bInterrupted )
	self:GetCaster():RemoveModifierByName("modifier_escanor_bar")
end