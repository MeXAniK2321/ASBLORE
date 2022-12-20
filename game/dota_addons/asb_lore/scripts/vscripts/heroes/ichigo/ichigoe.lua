ichigoE = class({})
LinkLuaModifier("modifier_ichigoE_caster", "heroes/ichigo/modifier_ichigoE_caster", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_ichigoE_target", "heroes/ichigo/modifier_ichigoE_target", LUA_MODIFIER_MOTION_HORIZONTAL)

function ichigoE:OnAbilityPhaseStart()
    EndAnimation(self:GetCaster())
    EmitSoundOn("Ichigo.E1", self:GetCaster())
    EmitSoundOn("Ichigo.E2", self:GetCaster())

    return true
end

function ichigoE:OnAbilityPhaseInterrupted()
    StopSoundOn("ichigo.E1", self:GetCaster())
    StopSoundOn("ichigo.E2", self:GetCaster())
end

function ichigoE:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration_stun = self:GetSpecialValueFor("duration")
    local distance = self:GetSpecialValueFor("distance")
    local strength = self:GetSpecialValueFor("strength")
    local speed = self:GetSpecialValueFor("speed")

    StartAnimation(caster, {
        duration = 5.0,
        activity = ACT_DOTA_CAST_ABILITY_5,
        rate = 1.0
    })

    local modifier = target:AddNewModifier(caster, self, "modifier_ichigoE_target", {})

    local mod = tempTable:AddATValue(modifier)

    caster:AddNewModifier(caster, self, "modifier_ichigoE_caster", {
        target = mod,
        duration = 5,
        damage = strength,
        duration_stun = duration_stun,
        distance = distance,
        speed = speed
    })
end
