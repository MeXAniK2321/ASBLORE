LinkLuaModifier("modifier_homura_regenerate", "heroes/homura_regenerate", LUA_MODIFIER_MOTION_NONE)


homura_regenerate = class({})



function homura_regenerate:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function homura_regenerate:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    local heal = self:GetSpecialValueFor("regen")
    caster:EmitSound("homura.6")
    caster:Heal( heal, caster )
    caster:AddNewModifier(caster, self, "modifier_homura_regenerate", { duration = duration } )
end

modifier_homura_regenerate = class({})

function modifier_homura_regenerate:IsPurgable()
    return true
end

function modifier_homura_regenerate:DeclareFunctions()
    local funcs = {
        
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end



function modifier_homura_regenerate:GetModifierSpellAmplify_Percentage()
    return 30
end

function modifier_homura_regenerate:GetEffectName()
    return "particles/econ/items/huskar/huskar_ti8/huskar_ti8_shoulder_heal.vpcf"
end

function modifier_homura_regenerate:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_homura_regenerate:GetStatusEffectName()
    return "particles/econ/courier/courier_onibi/courier_onibi_pink_ambient_b.vpcf" 
end

function modifier_homura_regenerate:StatusEffectPriority()
    return 5
end
