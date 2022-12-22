ichigoT = class({})
LinkLuaModifier("modifier_ichigoT_eff", "heroes/ichigo/modifier_ichigoT_eff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ichigoT_casting", "heroes/ichigo/modifier_ichigoT_casting", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ichigoT_throw", "heroes/ichigo/modifier_ichigoT_throw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jellalT_slow", "heroes/jellal/modifier_jellalT_slow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_combo", "heroes/ichigo/ichigot", LUA_MODIFIER_MOTION_NONE)

function ichigoT:OnAbilityPhaseStart()
    return true
end

function ichigoT:OnAbilityPhaseInterrupted()
end

function ichigoT:OnSpellStart()
    local caster = self:GetCaster()
    local casterPt = caster:GetAbsOrigin()
    local duration_initial = self:GetSpecialValueFor("duration_initial")
    local duration_last = self:GetSpecialValueFor("duration_last")
    local radius = self:GetSpecialValueFor("radius")
    local damage = self:GetSpecialValueFor("damage")
    local vision = self:GetSpecialValueFor("vision")
    local distance = self:GetSpecialValueFor("distance")
    local speed = self:GetSpecialValueFor("speed")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()
    local target = self:GetCursorTarget()
    target:AddNewModifier(caster, caster, "modifier_combo", {Duration = 20})
    caster:AddNewModifier(caster, caster, "modifier_combo", {Duration = 20})
    --[[  if caster:FindAbilityByName("ichigoD"):IsInAbilityPhase() then
        EndAnimation(self:GetCaster())
        Timers:CreateTimer(1.0, function() StopGlobalSound("ichigo.T1") end)
        Timers:RemoveTimer(self.TimerCharge)
        self:GetCaster():RemoveModifierByName("modifier_ichigoT_eff")
        self:GetCaster():RemoveModifierByName("modifier_ichigoT_casting")
        StopGlobalSound("ichigo.T1")
        StopGlobalSound("ichigo.T2")
    end ]]

    -- Casting
    EmitGlobalSound("ichigo.T4")

    Timers:CreateTimer(1.0, function()
        EmitGlobalSound("ichigo.T1")
        StartAnimation(caster, {
            duration = duration_initial,
            activity = ACT_DOTA_CAST_ABILITY_6,
            rate = 1.0
        })
    end)

    Timers:CreateTimer(0.2, function()
        caster:AddNewModifier(caster, self, "modifier_ichigoT_eff", {
            duration = 20.0
        })

        caster:AddNewModifier(caster, self, "modifier_ichigoT_casting", {
            duration = 20.0
        })
    end)

    local T5 = Timers:CreateTimer(6.0, function()
        EmitGlobalSound("ichigo.T5")

        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 9000,
            DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER, false)

        for key, unit in pairs(units) do
            unit:AddNewModifier(caster, self, "modifier_jellalT_slow", {
                duration = 10.0,
                move_slow = 65,
                attack_slow = 65
            })
        end

        caster:SetOriginalModel("models/characters/ichigo/mugetsu/mugetsu.vmdl")
        caster:SetModelScale(0.60)

        StartAnimation(caster, {
            duration = 5.0,
            activity = ACT_DOTA_CAST_ABILITY_1,
            rate = 1.0
        })

        local ParticleCharge4 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1f.vpcf"
        local GinFx4 = ParticleManager:CreateParticle(ParticleCharge4, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx4, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx4)

        local ParticleCharge5 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1k.vpcf"
        local GinFx5 = ParticleManager:CreateParticle(ParticleCharge5, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx5, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx5)

        local ParticleCharge6 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1j.vpcf"
        local GinFx6 = ParticleManager:CreateParticle(ParticleCharge6, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx6, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx6)

        caster:AddNewModifier(caster, self, "modifier_ichigoT_throw", {
            duration = 14.5
        })

        self.TimerCharge2 = Timers:CreateTimer(function()

            local ParticleCharge3 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge4.vpcf"
            local GinFx3 = ParticleManager:CreateParticle(ParticleCharge3, PATTACH_POINT_FOLLOW, caster)
            ParticleManager:SetParticleControl(GinFx3, 2, caster:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(GinFx3)

            return 0.5
        end)
    end)

    self.TimerCharge = Timers:CreateTimer(function()

        local ParticleCharge2 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge2.vpcf"
        local GinFx2 = ParticleManager:CreateParticle(ParticleCharge2, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx2, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx2)

        return 0.5
    end)

    self.ChannelTimer = Timers:CreateTimer(function()
        if caster:IsAlive() == false or caster:FindAbilityByName("ichigoQ"):IsInAbilityPhase() or
            caster:FindAbilityByName("ichigoW"):IsInAbilityPhase() or
            caster:FindAbilityByName("ichigoE"):IsInAbilityPhase() or
            caster:FindAbilityByName("ichigoF"):IsInAbilityPhase() or
            caster:FindAbilityByName("ichigoR"):IsInAbilityPhase() then
            Timers:CreateTimer(1.5, function()
                StopGlobalSound("ichigo.T1")
            end)
            StopGlobalSound("ichigo.T4")
            Timers:RemoveTimer(self.ProTimer)
            Timers:RemoveTimer(self.TimerCharge)
            caster:SetOriginalModel("models/characters/ichigo/ichigo.vmdl")
            caster:SetModelScale(1.20)
            Timers:RemoveTimer(T5)
            if self.TimerCharge2 then
                Timers:RemoveTimer(self.TimerCharge2)
            end
            Timers:RemoveTimer(self.ChannelTimer)
            caster:RemoveModifierByName("modifier_ichigoT_casting")
            caster:RemoveModifierByName("modifier_ichigoT_eff")
            EndAnimation(caster)
        end

        return 0
    end)

    ----------------------------------------------------------------------------------

    self.ProTimer = Timers:CreateTimer(duration_initial, function()

        EmitGlobalSound("ichigo.T2")

        EmitGlobalSound("ichigo.T3")

        Timers:RemoveTimer(self.ChannelTimer)
        local direction = caster:GetForwardVector()
        casterPt = caster:GetAbsOrigin()

        StartAnimation(caster, {
            duration = duration_last,
            activity = ACT_DOTA_CAST_ABILITY_2,
            rate = 1.0
        })

        local kameTimer = Timers:CreateTimer(function()
            local projectile = {
                EffectName = "",
                vSpawnOrigin = casterPt + direction * 300,
                fDistance = distance,
                fStartRadius = radius,
                fEndRadius = radius,
                Source = caster,
                fExpireTime = GameRules:GetGameTime() + 10.0,
                vVelocity = direction * speed,
                UnitBehavior = PROJECTILES_NOTHING,
                bMultipleHits = false,
                bIgnoreSource = true,
                TreeBehavior = PROJECTILES_NOTHING,
                bCutTrees = true,
                bTreeFullCollision = false,
                WallBehavior = PROJECTILES_NOTHING,
                GroundBehavior = PROJECTILES_NOTHING,
                fGroundOffset = 0,
                nChangeMax = 1,
                bRecreateOnChange = true,
                bZCheck = true,
                bGroundLock = false,
                bProvidesVision = true,
                iVisionRadius = vision,
                iVisionTeamNumber = caster:GetTeam(),
                bFlyingVision = false,
                fVisionTickTime = .1,
                fVisionLingerDuration = 1,
                draw = false,
                UnitTest = function(self, unit)
                    return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetUnitName() ~= "Chomusuke" and
                               unit:GetUnitName() ~= "npc_dota_hero_announcer_killing_spree" and unit:GetUnitName() ~=
                               "npc_dota_hero_announcer" and unit:GetTeamNumber() ~= caster:GetTeamNumber()
                end,
                OnUnitHit = function(self, unit)
                    if unit ~= nil and not unit:IsMagicImmune() then
                        ApplyDamage({
                            victim = unit,
                            attacker = caster,
                            damage = damage,
                            damage_type = damageType,
                            damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY,
                        })
                    end
                end,
                OnFinish = function(self, pos)
                end
            }

            Projectiles:CreateProjectile(projectile)
            return 0.4
        end)

        local dummy1 = CreateUnitByName("npc_dummy_unit_vision", casterPt, true, caster, caster, caster:GetTeamNumber())
        local dummy = CreateUnitByName("npc_dummy_unit", casterPt, true, caster, caster, caster:GetTeamNumber())
        visiondummy = caster:GetAbsOrigin() + caster:GetForwardVector() * 300
        dummy1:SetOrigin(visiondummy)
        dummy1:SetDayTimeVisionRange(2000) 
    dummy1:SetNightTimeVisionRange(2000)
        local knockback_push = caster:GetAbsOrigin() - caster:GetForwardVector()*300
    local knockback = { should_stun = false,
    knockback_duration = 8,
    duration = 8,
    knockback_distance = 20000,
    knockback_height = 0,
   
    center_x = knockback_push.x,
    center_y = knockback_push.y,
    center_z = caster:GetAbsOrigin().z }
    dummy1:AddNewModifier(caster, self, "modifier_knockback", knockback)
    --caster:AddNewModifier(caster, self, "modifier_knockback", knockback)
        self:PlayEffects(caster, dummy, casterPt, duration_last)
       
        Timers:CreateTimer(duration_last, function()
            if kameTimer then
                Timers:RemoveTimer(kameTimer)
            end
        end)
    end)
end

function ichigoT:PlayEffects(caster, dummy, casterPt, duration_last)
    local dummyTimer = Timers:CreateTimer(function()
        casterPt = caster:GetAbsOrigin() + caster:GetForwardVector() * 300
        dummy:SetOrigin(casterPt)
        
        return 0
    end)

    local plus300 = 0

    local MugeTimer = Timers:CreateTimer(function()
        plus300 = plus300 + 350
        local ParticleCharge2 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge3.vpcf"
        local GinFx2 = ParticleManager:CreateParticle(ParticleCharge2, PATTACH_POINT, dummy)
        ParticleManager:SetParticleControl(GinFx2, 0, caster:GetAbsOrigin() + caster:GetForwardVector() * plus300)
        ParticleManager:ReleaseParticleIndex(GinFx2)
        return 0.1
    end)

    local chargeTimer = Timers:CreateTimer(function()
        local ParticleCharge4 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1j.vpcf"
        local GinFx4 = ParticleManager:CreateParticle(ParticleCharge4, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx4, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx4)

        return 1.0
    end)

    Timers:CreateTimer(duration_last, function()
        dummy:ForceKill(true)

        local ParticleCharge4 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1f.vpcf"
        local GinFx4 = ParticleManager:CreateParticle(ParticleCharge4, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx4, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx4)

        local ParticleCharge5 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1k.vpcf"
        local GinFx5 = ParticleManager:CreateParticle(ParticleCharge5, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx5, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx5)

        local ParticleCharge6 = "particles/ichigo_eff/ichigo_t/ichigo_t_charge1j.vpcf"
        local GinFx6 = ParticleManager:CreateParticle(ParticleCharge6, PATTACH_POINT_FOLLOW, caster)
        ParticleManager:SetParticleControl(GinFx6, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx6)

        caster:SetOriginalModel("models/characters/ichigo/ichigo.vmdl")
        caster:SetModelScale(1.20)
        caster:ForceKill(true)
       -- Timers:RemoveTimer(dummyTimer)
        Timers:RemoveTimer(chargeTimer)
        Timers:RemoveTimer(self.TimerCharge)
        Timers:RemoveTimer(self.TimerCharge2)
        Timers:RemoveTimer(MugeTimer)
    end)
end

modifier_combo = class({})
function modifier_combo:CheckState()
 local funcs2 = {
    [MODIFIER_STATE_NO_HEALTH_BAR] = true, 
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		--[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
	}
  
  return funcs2
  end