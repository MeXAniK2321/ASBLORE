issei_promotion = class({})
LinkLuaModifier( "modifier_power_up", "modifiers/modifier_power_up", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function issei_promotion:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_power_up", {duration = 5})
	
	EmitSoundOn("issei.3", caster)
end


