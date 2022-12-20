ichigoW = class({})
LinkLuaModifier("modifier_ichigoW_target_knockback", "heroes/ichigo/modifier_ichigoW_target_knockback",
    LUA_MODIFIER_MOTION_BOTH)

function ichigoW:OnAbilityPhaseStart()
    EmitSoundOn("Ichigo.R2", self:GetCaster())
    StartAnimation(self:GetCaster(), {
        duration = 1.0,
        activity = ACT_DOTA_CAST_ABILITY_6,
        rate = 1.0
    })

    return true
end

function ichigoW:OnAbilityPhaseInterrupted()
    StopSoundOn("Ichigo.R2", self:GetCaster())
end

function ichigoW:OnSpellStart()
    local caster = self:GetCaster()
    local casterPt = caster:GetAbsOrigin()
    local targetPt = caster:GetCursorPosition()
    local damage = self:GetSpecialValueFor("damage")
    local radius = self:GetSpecialValueFor("radius")
    local duration = self:GetSpecialValueFor("duration")
    local distance = self:GetSpecialValueFor("distance")
    local strength = self:GetSpecialValueFor("strength")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()

    EmitSoundOn("Ichigo.W1", self:GetCaster())
    EmitSoundOn("Ichigo.E1", self:GetCaster())

    EndAnimation(caster)

    StartAnimation(caster, {
        duration = 2.0,
        activity = ACT_DOTA_CAST_ABILITY_5,
        rate = 1.0
    })

    local ParticleTravel = "particles/ichigo_eff/ichigo_r/ichigo_r_travel.vpcf"
    local GinFx = ParticleManager:CreateParticle(ParticleTravel, PATTACH_POINT, caster)
    ParticleManager:SetParticleControl(GinFx, 3, casterPt)
    ParticleManager:ReleaseParticleIndex(GinFx)

    local ParticleTravel2 = "particles/ichigo_eff/ichigo_r/ichigo_r_f.vpcf"
    local GinFx2 = ParticleManager:CreateParticle(ParticleTravel2, PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControl(GinFx2, 0, casterPt)

    Timers:CreateTimer(0.8, function()
        ParticleManager:DestroyParticle(GinFx2, true)
        ParticleManager:ReleaseParticleIndex(GinFx2)
    end)

    local EffectT = Timers:CreateTimer(function()
        local ParticleTravel3 = "particles/ichigo_eff/ichigo_r/ichigo_r_travelr.vpcf"
        local GinFx3 = ParticleManager:CreateParticle(ParticleTravel3, PATTACH_POINT, caster)
        ParticleManager:SetParticleControl(GinFx3, 3, casterPt)
        ParticleManager:ReleaseParticleIndex(GinFx3)

        return 0.1
    end)

    Timers:CreateTimer(0.7, function()
        Timers:RemoveTimer(EffectT)
    end)

    local direction = targetPt - casterPt
    direction = direction:Normalized()

    caster:AddNewModifier(caster, self, "modifier_ichigoW_target_knockback", {
        duration = 0.5,
        distance = distance,
        radius = radius,
        damage = damage,
        strength = strength,
        height = 0,
        direction_x = direction[1],
        direction_y = direction[2],
        damageType = damageType,
        damageFlags = damageFlags
    })
end
