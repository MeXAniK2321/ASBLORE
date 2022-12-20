ichigoR = class({})
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ichigo_R", "heroes/ichigo/modifier_ichigo_R", LUA_MODIFIER_MOTION_BOTH)

function ichigoR:OnAbilityPhaseStart()
    EndAnimation(self:GetCaster())
    StartAnimation(self:GetCaster(), {
        duration = 2,
        activity = ACT_DOTA_CAST_ABILITY_4,
        rate = 1.0
    })

    self.RTimer = Timers:CreateTimer(function()
        local particleTravel = "particles/ichigo_eff/ichigo_q/ichigo_q_charge.vpcf"
        local fxTrav2 = ParticleManager:CreateParticle(particleTravel, PATTACH_POINT, self:GetCaster())
        ParticleManager:SetParticleControl(fxTrav2, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(fxTrav2)
        return 0.2
    end)

    EmitSoundOn("precorte1", self:GetCaster())

    return true
end

function ichigoR:OnAbilityPhaseInterrupted()
    StopSoundOn("Ichigo.R2", self:GetCaster())
    Timers:RemoveTimer(self.RTimer)
    EndAnimation(self:GetCaster())
end

function ichigoR:OnSpellStart()
    local caster = self:GetCaster()
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local damage = self:GetSpecialValueFor("damage")
    local strength = self:GetSpecialValueFor("strength")
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local duration_stun = self:GetSpecialValueFor("duration_stun")
    local duration_travel = self:GetSpecialValueFor("duration_travel")
    local distance = self:GetSpecialValueFor("distance")
    local distance_enemy = self:GetSpecialValueFor("distance_enemy")

    Timers:RemoveTimer(self.RTimer)

    EmitSoundOn("Ichigo.R1", self:GetCaster())

    local direction = cursorPt - casterPt

    caster:AddNewModifier(caster, self, "modifier_ichigo_R", {
        duration = duration_travel,
        duration_stun = duration_stun,
        duration_enemy = duration,
        height = 0,
        distance = distance,
        strength = strength,
        distance_enemy = distance_enemy,
        radius = radius,
        damage = damage,
        direction_x = direction[1],
        direction_y = direction[2]
    })
end
