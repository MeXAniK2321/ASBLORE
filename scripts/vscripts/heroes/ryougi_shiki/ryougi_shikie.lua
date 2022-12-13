LinkLuaModifier("modifier_ryougi_shikiE", "heroes/ryougi_shiki/modifier_ryougi_shikiE", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_ryougi_shikiE_deb", "heroes/ryougi_shiki/modifier_ryougi_shikiE_deb",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)

ryougi_shikiE = class({})

function ryougi_shikiE:OnAbilityPhaseStart()
    StartAnimation(self:GetCaster(), {
        duration = 0.8,
        activity = ACT_DOTA_CAST_ABILITY_4,
        rate = 1.0
    })

    EmitSoundOn("Ryougi.E1", self:GetCaster())

    return true
end

function ryougi_shikiE:OnAbilityPhaseInterrupted()
    StopSoundOn("Ryougi.R1", self:GetCaster())
    EndAnimation(self:GetCaster())
end

function ryougi_shikiE:OnSpellStart()
    local caster = self:GetCaster()
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local agility = self:GetSpecialValueFor("agility")
    local distance = self:GetSpecialValueFor("distance")
    local duration = self:GetSpecialValueFor("duration")
    local duration_stun = self:GetSpecialValueFor("duration_stun")
    local radius = self:GetSpecialValueFor("radius")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()
    local targetTeam = self:GetAbilityTargetTeam()

    local particleImpact2 = "particles/ryougi_eff/ryougi_e/ryougi_e_cut.vpcf"
    local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT_FOLLOW, caster)
    ParticleManager:SetParticleControl(exp2, 1, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(exp2)

    local effT1 = Timers:CreateTimer(function()
        local particleImpact3 = "particles/ryougi_eff/ryougi_e/ryougi_e_wind.vpcf"
        local exp3 = ParticleManager:CreateParticle(particleImpact3, PATTACH_POINT, caster)
        ParticleManager:SetParticleControl(exp3, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp3)

        local particleImpact3 = "particles/ryougi_eff/ryougi_e/ryougi_e_light.vpcf"
        local exp3 = ParticleManager:CreateParticle(particleImpact3, PATTACH_POINT, caster)
        ParticleManager:SetParticleControl(exp3, 1, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp3)

        return 0.1
    end)

    Timers:CreateTimer(0.5,function ()
        if effT1 then
            Timers:RemoveTimer(effT1)
        end
    end)

    EmitSoundOn("Ryougi.E2", self:GetCaster())
    EmitSoundOn("Ryougi.E3", self:GetCaster())

    local ParticleExp = "particles/ryougi_eff/ryougi_e/ryougi_e.vpcf"
    local GinFx = ParticleManager:CreateParticle(ParticleExp, PATTACH_POINT, caster)
    ParticleManager:SetParticleControl(GinFx, 0, caster:GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx)

    local ryougiECut = Timers:CreateTimer(0.1, function()
        casterPt = caster:GetAbsOrigin()

        local units = FindUnitsInRadius(caster:GetTeamNumber(), casterPt, nil, radius, targetTeam,
            DOTA_UNIT_TARGET_HERO or DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for key, unit in pairs(units) do
            
                local info = {
                    victim = unit,
                    attacker = caster,
                    damage = caster:GetAgility() * agility,
                    damage_type = damageType,
                    damage_flags = damageFlags
                }

                local particleImpact4 = "particles/ryougi_eff/ryougi_w/ryougi_blood_2.vpcf"
                local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW, unit)
                ParticleManager:SetParticleControl(exp4, 0, unit:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(exp4)

                EmitSoundOn("Ryougi.QCut", self:GetCaster())

                unit:AddNewModifier(caster, self, "modifier_eff_stun", {
                    duration = duration_stun
                })

                ApplyDamage(info)
             
        end

        return 0.1
    end)

    Timers:CreateTimer(0.5, function()
        Timers:RemoveTimer(ryougiECut)
    end)

    local direction = cursorPt - casterPt
    direction = direction:Normalized()

    caster:AddNewModifier(caster, self, "modifier_ryougi_shikiE", {
        duration = 0.5,
        distance = distance,
        direction_x = direction[1],
        direction_y = direction[2]
    })
end
