LinkLuaModifier("modifier_ryougi_shikiT", "heroes/ryougi_shiki/modifier_ryougi_shikiT", LUA_MODIFIER_MOTION_BOTH)

ryougi_shikiT = class({})

function ryougi_shikiT:OnAbilityPhaseStart()
    EmitSoundOn("Ryougi.T3", self:GetCaster())
    StartAnimation(self:GetCaster(), {
        duration = 1.0,
        activity = ACT_DOTA_CAST_ABILITY_7,
        rate = 1.0
    })

    self.initT = Timers:CreateTimer(function()
        local particleImpact2 = "particles/ryougi_eff/ryougi_t/ryougi_t_init.vpcf"
        local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT, self:GetCaster())
        ParticleManager:SetParticleControl(exp2, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp2)
        local particleImpact3 = "particles/ryougi_eff/ryougi_t/ryougi_t_travel.vpcf"
        local exp3 = ParticleManager:CreateParticle(particleImpact3, PATTACH_POINT, self:GetCaster())
        ParticleManager:SetParticleControl(exp3, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp3)

        return 0.3
    end)

    return true
end

function ryougi_shikiT:OnAbilityPhaseInterrupted()
    EndAnimation(self:GetCaster())
    if self.initT then
        Timers:RemoveTimer(self.initT)
    end
end

function ryougi_shikiT:OnSpellStart()
    local caster = self:GetCaster()
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local point = casterPt + caster:GetForwardVector() * 300
    local duration_initial = self:GetSpecialValueFor("duration_initial")
    local duration_mid = self:GetSpecialValueFor("duration_mid")
    local duration_last = self:GetSpecialValueFor("duration_last")
    local distance = self:GetSpecialValueFor("distance")
    local distance_mid = self:GetSpecialValueFor("distance_mid")
    local damage = self:GetSpecialValueFor("damage")
    local agility = self:GetSpecialValueFor("agility")
    local radius = self:GetSpecialValueFor("radius")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()
    local targetTeam = self:GetAbilityTargetTeam()

    if self.initT then
        Timers:RemoveTimer(self.initT)
    end

    EndAnimation(caster)

    StartAnimation(caster, {
        duration = 0.4,
        activity = ACT_DOTA_CHANNEL_ABILITY_1,
        rate = 2.0
    })

    local direction = cursorPt - casterPt
    direction = direction:Normalized()

    caster:AddNewModifier(caster, self, "modifier_ryougi_shikiT", {
        duration = duration_initial,
        duration_mid = duration_mid,
        distance = distance,
        distance_mid = distance_mid,
        radius = radius,
        targetTeam = targetTeam,
        direction_x = direction[1],
        direction_y = direction[2]
    })
end
