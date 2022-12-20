LinkLuaModifier("modifier_ryougi_shikiR", "heroes/ryougi_shiki/modifier_ryougi_shikiR", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ryougi_shikiR_debuff", "heroes/ryougi_shiki/modifier_ryougi_shikiR_debuff",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)

ryougi_shikiR = class({})

function ryougi_shikiR:OnAbilityPhaseStart()
    StartAnimation(self:GetCaster(), {
        duration = 1.6,
        activity = ACT_DOTA_CAST_ABILITY_6,
        rate = 1.0
    })

    local ParticleExp5 = "particles/ryougi_eff/ryougi_q/ryougi_q_3_exp.vpcf"
    local GinFx5 = ParticleManager:CreateParticle(ParticleExp5, PATTACH_POINT, self:GetCaster())
    ParticleManager:SetParticleControl(GinFx5, 3, self:GetCaster():GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx5)

    EmitSoundOn("Ryougi.R1", self:GetCaster())

    return true
end

function ryougi_shikiR:OnAbilityPhaseInterrupted()
    StopSoundOn("Ryougi.R1", self:GetCaster())
    EndAnimation(self:GetCaster())
end

function ryougi_shikiR:OnSpellStart()
    local caster = self:GetCaster()
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local point = casterPt
    local damage = self:GetSpecialValueFor("damage")
    local agility = self:GetSpecialValueFor("agility")
    local distance = self:GetSpecialValueFor("distance")
    local duration = self:GetSpecialValueFor("duration")
    local duration_stun = self:GetSpecialValueFor("duration_stun")
    local radius = self:GetSpecialValueFor("radius")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()
    local targetTeam = self:GetAbilityTargetTeam()

    EmitSoundOn("Ryougi.R2", self:GetCaster())
    EmitSoundOn("Ryougi.R3", self:GetCaster())
    EmitSoundOn("truenogolpe1", self:GetCaster())

    local shikiR = Timers:CreateTimer(function()
        point = caster:GetAbsOrigin()
        local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, targetTeam,
            DOTA_UNIT_TARGET_HERO or DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for key, unit in pairs(units) do
            if unit:HasModifier("modifier_ryougi_shikiR_debuff") == false then
                local info = {
                    victim = unit,
                    attacker = caster,
                    damage = damage + caster:GetAgility() * agility,
                    damage_type = damageType,
                    damage_flags = damageFlags
                }

                unit:AddNewModifier(caster, self, "modifier_eff_stun", {
                    duration = duration_stun
                })

                ApplyDamage(info)

                unit:AddNewModifier(caster, self, "modifier_ryougi_shikiR_debuff", {duration = 1.0})
            end
        end

        return 0
    end)

    Timers:CreateTimer(0.2,function ()
        Timers:RemoveTimer(shikiR)
    end)

    local direction = cursorPt - casterPt
    direction = direction:Normalized()

    caster:AddNewModifier(caster, self, "modifier_ryougi_shikiR", {
        duration = duration,
        distance = distance,
        direction_x = direction[1],
        direction_y = direction[2]
    })
end
