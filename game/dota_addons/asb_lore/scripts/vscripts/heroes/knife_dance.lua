LinkLuaModifier("modifier_knife_dance", "modifiers/modifier_knife_dance", LUA_MODIFIER_MOTION_NONE)

knife_dance = class({})


function knife_dance:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("duration")

    caster:AddNewModifier(caster, self, "modifier_knife_dance", {duration = fixed_duration})

end