LinkLuaModifier("modifier_ryougi_shikiQ", "heroes/ryougi_shiki/modifier_ryougi_shikiQ", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ryougi_shikiQ_last", "heroes/ryougi_shiki/modifier_ryougi_shikiQ_last",
    LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_generic_kb", "heroes/modifiers/modifier_generic_kb", LUA_MODIFIER_MOTION_BOTH)

ryougi_shikiQ = class({})
LinkLuaModifier( "modifier_animation", "libraries/modifiers/modifier_animation.lua", LUA_MODIFIER_MOTION_NONE )

function ryougi_shikiQ:OnAbilityPhaseStart()
    if not RYOUGIQ then 
        RYOUGIQ = 1
    end
    if RYOUGIQ == 1 then
        StartAnimation(self:GetCaster(), {
            duration = 0.5,
            activity = ACT_DOTA_CAST_ABILITY_1,
            rate = 1.0
        })

        EmitSoundOn("Ryougi.Q1", self:GetCaster())

        return true
    end

    if RYOUGIQ == 2 then
          StartAnimation(self:GetCaster(), {
            duration = 0.5,
            activity = ACT_DOTA_CAST_ABILITY_3_END,
            rate = 1.0
        })

        EmitSoundOn("Ryougi.Q2", self:GetCaster())

        return true
    end

    if RYOUGIQ == 3 then
         StartAnimation(self:GetCaster(), {
            duration = 1.0,
            activity = ACT_DOTA_CHANNEL_ABILITY_3,
            rate = 1.0
        })

        EmitSoundOn("Ryougi.Q3", self:GetCaster())

        return true
    end
    print("Q casted without entering if")
    print(RYOUGIQ)
end

function ryougi_shikiQ:OnAbilityPhaseInterrupted()
    StopSoundOn("Ryougi.Q1", self:GetCaster())
    EndAnimation(self:GetCaster())
end

function ryougi_shikiQ:OnSpellStart()
    if RYOUGIQ == 1 then
        local caster = self:GetCaster()
        local cursorPt = self:GetCursorPosition()
        local casterPt = caster:GetAbsOrigin()
        local point = casterPt + caster:GetForwardVector() * 150
        local agility_start = self:GetSpecialValueFor("agility_start")
        local distance = self:GetSpecialValueFor("distance")
        local duration = self:GetSpecialValueFor("duration")
        local duration_stun = self:GetSpecialValueFor("duration_stun")
        local radius = self:GetSpecialValueFor("radius")
        local damageType = self:GetAbilityDamageType()
        local damageFlags = self:GetAbilityTargetFlags()
        local targetTeam = self:GetAbilityTargetTeam()

        RYOUGIQ = 2

        self:EndCooldown()
        caster:FindAbilityByName("ryougi_shikiQ"):SetOverrideCastPoint(0.1)

        local ParticleExp = "particles/ryougi_eff/ryougi_q/ryougi_q2_2.vpcf"
        local GinFx = ParticleManager:CreateParticle(ParticleExp, PATTACH_POINT, caster)
        ParticleManager:SetParticleControl(GinFx, 0, caster:GetOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx)

        local ParticleR = "particles/ryougi_eff/ryougi_q/ryougi_q_dust.vpcf"
        local rfx = ParticleManager:CreateParticle(ParticleR, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(rfx, 0, caster:GetOrigin())
        ParticleManager:ReleaseParticleIndex(rfx)

        self.R1 = Timers:CreateTimer(3.0, function()
            self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
            caster:FindAbilityByName("ryougi_shikiQ"):SetOverrideCastPoint(0.2)
            RYOUGIQ = 1
        end)

        local direction = cursorPt - casterPt
        direction = direction:Normalized()

        caster:AddNewModifier(caster, self, "modifier_ryougi_shikiQ", {
            duration = duration,
            distance = distance,
            direction_x = direction[1],
            direction_y = direction[2],
            radius = radius,
            targetTeam = targetTeam,
            agility_start = agility_start,
            damageType = damageType,
            damageFlags = damageFlags,
            duration_stun = duration_stun
        })

        return
    end

    if RYOUGIQ == 2 then
        local caster = self:GetCaster()
        local cursorPt = self:GetCursorPosition()
        local casterPt = caster:GetAbsOrigin()
        local point = casterPt + caster:GetForwardVector() * 150
        local agility_start = self:GetSpecialValueFor("agility_start")
        local distance = self:GetSpecialValueFor("distance")
        local distance_kb = self:GetSpecialValueFor("distance_kb")
        local duration = self:GetSpecialValueFor("duration")
        local duration_stun = self:GetSpecialValueFor("duration_stun")
        local radius = self:GetSpecialValueFor("radius")
        local damageType = self:GetAbilityDamageType()
        local damageFlags = self:GetAbilityTargetFlags()
        local targetTeam = self:GetAbilityTargetTeam()

        RYOUGIQ = 3

        self:EndCooldown()

        local ParticleExp = "particles/ryougi_eff/ryougi_q/ryougi_q2.vpcf"
        local GinFx = ParticleManager:CreateParticle(ParticleExp, PATTACH_POINT, caster)
        ParticleManager:SetParticleControl(GinFx, 0, caster:GetOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx)

        local ParticleR = "particles/ryougi_eff/ryougi_q/ryougi_q_dust.vpcf"
        local rfx = ParticleManager:CreateParticle(ParticleR, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(rfx, 0, caster:GetOrigin())
        ParticleManager:ReleaseParticleIndex(rfx)

        Timers:RemoveTimer(self.R1)

        self.R2 = Timers:CreateTimer(3.0, function()
            self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
            caster:FindAbilityByName("ryougi_shikiQ"):SetOverrideCastPoint(0.2)
            RYOUGIQ = 1
        end)

        caster:FindAbilityByName("ryougi_shikiQ"):SetOverrideCastPoint(0.1)

        local direction = cursorPt - casterPt
        direction = direction:Normalized()

        caster:AddNewModifier(caster, self, "modifier_ryougi_shikiQ", {
            duration = duration,
            distance = distance,
            distance_kb = distance_kb,
            direction_x = direction[1],
            direction_y = direction[2],
            radius = radius,
            targetTeam = targetTeam,
            agility_start = agility_start,
            damageType = damageType,
            damageFlags = damageFlags,
            duration_stun = duration_stun
        })

        return
    end

    if RYOUGIQ == 3 then
        local caster = self:GetCaster()
        local cursorPt = self:GetCursorPosition()
        local casterPt = caster:GetAbsOrigin()
        local point = casterPt + caster:GetForwardVector() * 150
        local agility_end = self:GetSpecialValueFor("agility_end")
        local distance_last = self:GetSpecialValueFor("distance_last")
        local duration_last = self:GetSpecialValueFor("duration_last")
        local duration_stun = self:GetSpecialValueFor("duration_stun")
        local radius_end = self:GetSpecialValueFor("radius_end")
        local damageType = self:GetAbilityDamageType()
        local damageFlags = self:GetAbilityTargetFlags()
        local targetTeam = self:GetAbilityTargetTeam()

        RYOUGIQ = 1

        self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))

        local ParticleR = "particles/ryougi_eff/ryougi_q/ryougi_q_dust.vpcf"
        local rfx = ParticleManager:CreateParticle(ParticleR, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(rfx, 0, caster:GetOrigin())
        ParticleManager:ReleaseParticleIndex(rfx)

        Timers:RemoveTimer(self.R2)

        caster:FindAbilityByName("ryougi_shikiQ"):SetOverrideCastPoint(0.2)

        local direction = cursorPt - casterPt
        direction = direction:Normalized()

        caster:AddNewModifier(caster, self, "modifier_ryougi_shikiQ_last", {
            duration = duration_last,
            distance = distance_last,
            direction_x = direction[1],
            direction_y = direction[2],
            radius_end = radius_end,
            targetTeam = targetTeam,
            agility_end = agility_end,
            damageType = damageType,
            damageFlags = damageFlags,
            duration_stun = duration_stun
        })

        return
    end
end
