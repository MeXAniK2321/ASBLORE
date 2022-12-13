frisk_return = class({})
LinkLuaModifier( "modifier_frisk_return_active", "modifiers/modifier_frisk_return_active", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frisk_return_debuff", "modifiers/modifier_frisk_return_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function frisk_return:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_frisk_return_active", {duration = 2.0})
	EmitSoundOn("frisk.8", caster)

end