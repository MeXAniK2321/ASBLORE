deidara_c0 = class({})
LinkLuaModifier( "modifier_deidara_c0", "modifiers/modifier_deidara_c0", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function deidara_c0:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_deidara_c0", {duration = 4})
	caster:AddNewModifier(caster, self, "modifier_muted", {duration = 4})
	EmitSoundOn("deidara.c0", caster)
	
end


