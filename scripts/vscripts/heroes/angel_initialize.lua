LinkLuaModifier("modifier_uranys_system_initialization", "modifiers/modifier_uranys_system_initialization", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_uranys_system_launched", "modifiers/modifier_uranys_system_launched", LUA_MODIFIER_MOTION_NONE)

angel_initialize = class({})


function angel_initialize:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    caster:EmitSound("ikaros.sfx")

    caster:AddNewModifier(caster, self, "modifier_uranys_system_initialization", {} )
	 self:EndCooldown()
	self:StartCooldown(self:GetCooldown(-1))
end
