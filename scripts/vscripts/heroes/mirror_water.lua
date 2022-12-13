LinkLuaModifier("modifier_mirror_water",  "modifiers/modifier_mirror_water", LUA_MODIFIER_MOTION_NONE)

mirror_water = class({})

function mirror_water:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function mirror_water:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("jellal.2")
    caster:AddNewModifier(caster, self, "modifier_mirror_water", { duration = duration } )
end

function mirror_water:OnChannelFinish( bInterrupted )
	self:GetCaster():RemoveModifierByName("modifier_mirror_water")
end