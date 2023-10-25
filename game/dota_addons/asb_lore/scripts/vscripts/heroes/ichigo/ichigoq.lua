ichigoQ = class({})
LinkLuaModifier( "modifier_animation", "libraries/modifiers/modifier_animation.lua", LUA_MODIFIER_MOTION_NONE )

function ichigoQ:OnAbilityPhaseStart()
    StartAnimation(self:GetCaster(), {
        duration = 1,
        activity = ACT_DOTA_CAST_ABILITY_1,
        rate = 1.0
    })

    self.getsugaTimer = Timers:CreateTimer(function()
        local particleTravel = "particles/ichigo_eff/ichigo_q/ichigo_q_charge.vpcf"
        local fxTrav2 = ParticleManager:CreateParticle(particleTravel, PATTACH_POINT, self:GetCaster())
        ParticleManager:SetParticleControl(fxTrav2, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(fxTrav2)
        return 0.2
    end)

    EmitSoundOn("Ichigo.Q1", self:GetCaster())

    return true
end

function ichigoQ:OnAbilityPhaseInterrupted()
    StopSoundOn("Ichigo.Q1", self:GetCaster())
    Timers:RemoveTimer(self.getsugaTimer)
    EndAnimation(self:GetCaster())
end

function ichigoQ:OnSpellStart()
    local caster = self:GetCaster()
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local damage = self:GetSpecialValueFor("damage")
    local strength = self:GetSpecialValueFor("strength")
    local speed = self:GetSpecialValueFor("speed")
    local distance = self:GetSpecialValueFor("distance")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()

    Timers:RemoveTimer(self.getsugaTimer)

    StartAnimation(self:GetCaster(), {
        duration = 0.8,
        activity = ACT_DOTA_CAST_ABILITY_7,
        rate = 1.0
    })

    EmitSoundOn("Ichigo.Q2", self:GetCaster())

    local direction = cursorPt - casterPt
    direction = direction:Normalized()

    local projectile = {
        EffectName = "particles/ichigo_eff/ichigo_q/ichigo_getsuga.vpcf",
        vSpawnOrigin = casterPt,
        fDistance = distance,
        fStartRadius = 250,
        fEndRadius = 500,
        Source = caster,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        vVelocity = direction * speed,
        UnitBehavior = PROJECTILES_BOUNCE,
        bMultipleHits = false,
        bIgnoreSource = true,
        TreeBehavior = PROJECTILES_NOTHING,
        bCutTrees = true,
        bTreeFullCollision = false,
        WallBehavior = PROJECTILES_BOUNCE,
        GroundBehavior = PROJECTILES_NOTHING,
        fGroundOffset = 80,
        nChangeMax = 1,
        bRecreateOnChange = true,
        bZCheck = false,
        bGroundLock = false,
        bProvidesVision = true,
        iVisionRadius = 500,
        iVisionTeamNumber = caster:GetTeam(),
        bFlyingVision = false,
        fVisionTickTime = .1,
        fVisionLingerDuration = 1,
        draw = false,
        UnitTest = function(s, unit)
            return unit:GetUnitName() ~= "dummy_unit" and unit:GetUnitName() ~= "Chomusuke" and unit:GetUnitName() ~=
                       "npc_dota_hero_announcer_killing_spree" and unit:GetUnitName() ~= "npc_dota_hero_announcer" and
                       unit:GetTeamNumber() ~= caster:GetTeamNumber() and unit:HasAbility("dummy_unit_ability") == false and
                       unit:IsMagicImmune() == false
        end,
        OnUnitHit = function(s, unit)
            if unit ~= nil then
                if unit:HasModifier("modifier_jellalW") then
                    return
                end

                ApplyDamage({
                    victim = unit,
                    attacker = caster,
                    damage = damage + caster:GetStrength() * strength,
                    damage_type = damageType,
                    damage_flags = damageFlags
                })
            end
        end,
        OnFinish = function(self, pos)
        end
    }

    Projectiles:CreateProjectile(projectile)
end
