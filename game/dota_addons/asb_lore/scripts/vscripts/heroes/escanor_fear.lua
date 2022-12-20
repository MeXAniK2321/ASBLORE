LinkLuaModifier("modifier_escanor_fear", "modifiers/modifier_escanor_fear", LUA_MODIFIER_MOTION_NONE)

escanor_fear = class({})
function escanor_fear:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("super_slash")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function escanor_fear:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function escanor_fear:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("chatwheel.19")
    caster:AddNewModifier(caster, self, "modifier_escanor_fear", { duration = duration } )
end