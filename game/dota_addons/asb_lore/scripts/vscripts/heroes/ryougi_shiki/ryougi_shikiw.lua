LinkLuaModifier("modifier_ryougi_shikiW", "heroes/ryougi_shiki/modifier_ryougi_shikiW", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_ryougi_shikiW_stun", "heroes/ryougi_shiki/modifier_ryougi_shikiW_stun",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_no_healthbar", "heroes/ryougi_shiki/ryougi_shikiw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_model_change", "heroes/modifiers/modifier_generic_model_change",
    LUA_MODIFIER_MOTION_NONE)

ryougi_shikiW = class({})

function ryougi_shikiW:OnAbilityPhaseStart()
    StartAnimation(self:GetCaster(), {
        duration = 0.5,
        activity = ACT_DOTA_CAST_ABILITY_2,
        rate = 1.0
    })

    local randomSound = math.random(1, 2)

    if randomSound == 1 then
        EmitSoundOn("Ryougi.W1", self:GetCaster())
    else
        EmitSoundOn("Ryougi.W7", self:GetCaster())
    end

    local dummy = CreateUnitByName("ryougi_dagger", self:GetCaster():GetAbsOrigin() +
        self:GetCaster():GetForwardVector() * 100 + Vector(0, 0, 150), true, self:GetCaster(), self:GetCaster(),
        self:GetCaster():GetTeamNumber())

    self.dummy = dummy
    self.dummy:AddNewModifier(caster, self, "modifier_no_healthbar", {
        duration = 2.0,
       })
    local ParticleR2 = "particles/ryougi_eff/ryougi_q/ryougi_q_onda.vpcf"
    local rfx2 = ParticleManager:CreateParticle(ParticleR2, PATTACH_POINT, self:GetCaster())
    ParticleManager:SetParticleControl(rfx2, 0, self:GetCaster():GetOrigin())
    ParticleManager:ReleaseParticleIndex(rfx2)

    return true
end

function ryougi_shikiW:OnAbilityPhaseInterrupted()
    if "Ryougi.W1" then
        StopSoundOn("Ryougi.W1", self:GetCaster())
    end

    if "Ryougi.W7" then
        StopSoundOn("Ryougi.W7", self:GetCaster())
    end

    if self.dummy:IsAlive() then
        self.dummy:ForceKill(true)
        UTIL_Remove(self.dummy)
    end

    EndAnimation(self:GetCaster())
end

function ryougi_shikiW:OnSpellStart()
    local caster = self:GetCaster()
    local cursorPt = self:GetCursorPosition()
    local casterPt = caster:GetAbsOrigin()
    local damage = self:GetSpecialValueFor("damage")
    local agility = self:GetSpecialValueFor("agility")
    local speed = self:GetSpecialValueFor("speed")
    local distance = self:GetSpecialValueFor("distance")
    local duration = self:GetSpecialValueFor("duration")
    local duration_kb = self:GetSpecialValueFor("duration_kb")
    local radius = self:GetSpecialValueFor("radius")
    local distance_ryougi = self:GetSpecialValueFor("distance_ryougi")
    local damageType = self:GetAbilityDamageType()
    local damageFlags = self:GetAbilityTargetFlags()

    caster:AddNewModifier(caster, self, "modifier_ryougi_shikiW_stun", {
        duration = 0.4
    })

    if self.dummy and self.dummy:IsAlive() then
        self.dummy:AddNewModifier(caster, self, "modifier_generic_model_change", {
            duration = 2.0,
            model = "models/items/queenofpain/ripper_dagger.vmdl"
        })
        
    end

    local dummyPos
    local posPart

    local effT1 = Timers:CreateTimer(function()
        local particleImpact2 = "particles/ryougi_eff/ryougi_w/ryougi_w_wind.vpcf"
        local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT, caster)
        ParticleManager:SetParticleControl(exp2, 0, self.dummy:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp2)

        return 0
    end)

    EmitSoundOn("Ryougi.W3", self:GetCaster())

    local direction = cursorPt - casterPt
    direction = direction:Normalized()

    local projectile = {
        EffectName = "", -- EFECTO PROYECTIL
        vSpawnOrigin = casterPt,
        fDistance = distance,
        fStartRadius = radius,
        fEndRadius = radius,
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
        UnitTest = function(self, unit)
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

                local particleImpact2 = "particles/ryougi_eff/ryougi_w/ryougi_blood.vpcf"
                local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT, unit)
                ParticleManager:SetParticleControl(exp2, 0, unit:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(exp2)

                local particleImpact3 = "particles/ryougi_eff/ryougi_w/ryougi_hit.vpcf"
                    local exp3 = ParticleManager:CreateParticle(particleImpact3, PATTACH_POINT, unit)
                    ParticleManager:SetParticleControl(exp3, 0, unit:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp3)

                ApplyDamage({
                    victim = unit,
                    attacker = caster,
                    damage = damage,
                    damage_type = damageType,
                    damage_flags = damageFlags
                })

                local unitPos = unit:GetAbsOrigin()
                casterPt = caster:GetAbsOrigin()

                EmitSoundOn("Ryougi.W2", caster)
                EmitSoundOn("Ryougi.W4", caster)

                StartAnimation(caster, {
                    duration = 1.0,
                    activity = ACT_DOTA_ATTACK2,
                    rate = 1.0
                })

                Timers:CreateTimer(0.3, function()
                    local particleImpact6 = "particles/ryougi_eff/ryougi_w/ryougi_w_flash.vpcf"
                    local exp6 = ParticleManager:CreateParticle(particleImpact6, PATTACH_POINT, caster)
                    ParticleManager:SetParticleControl(exp6, 1, caster:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp6)
                end)

                Timers:CreateTimer(0.4, function()
                    local particleImpact2 = "particles/ryougi_eff/ryougi_w/ryougi_blood.vpcf"
                    local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT, unit)
                    ParticleManager:SetParticleControl(exp2, 0, unit:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp2)

                    particleImpact2 = "particles/ryougi_eff/ryougi_w/ryougi_w_part.vpcf"
                    exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT, unit)
                    ParticleManager:SetParticleControl(exp2, 0, unit:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp2)

                    FindClearSpaceForUnit(caster, unitPos - caster:GetForwardVector() * 50, true)

                    local particleImpact4 = "particles/ryougi_eff/ryougi_w/ryougi_w_flash.vpcf"
                    local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW, caster)
                    ParticleManager:SetParticleControl(exp4, 1, caster:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp4)

                    EmitSoundOn("Ryougi.W5", caster)
                    EmitSoundOn("Ryougi.W6", caster)

                    ApplyDamage({
                        victim = unit,
                        attacker = caster,
                        damage = caster:GetAgility() * agility,
                        damage_type = damageType,
                        damage_flags = damageFlags
                    })

                    local directionR = unitPos - casterPt
                    directionR = directionR:Normalized()

                    caster:AddNewModifier(caster, self, "modifier_ryougi_shikiW", {
                        duration = duration_kb,
                        distance_ryougi = distance_ryougi,
                        direction_x = directionR[1],
                        direction_y = directionR[2]
                    })
                end)

                unit:AddNewModifier(caster, self, "modifier_eff_stun", {
                    duration = duration
                })
            end
        end,
        OnFinish = function(s, pos)
            if dummyPos then
                Timers:RemoveTimer(dummyPos)
            end
            if effT1 then
                Timers:RemoveTimer(effT1)
            end
            if self.dummy:IsAlive() == true then
                self.dummy:RemoveModifierByName("modifier_generic_model_change")
                self.dummy:ForceKill(true)
                UTIL_Remove(self.dummy)
            end
        end
    }

    local castAngle = caster:GetAngles()
    self.dummy:SetAngles(castAngle[1], castAngle[2], castAngle[3])

    dummyPos = Timers:CreateTimer(function()
        posPart = projectile:GetPosition() + Vector(0, 0, 150)
        FindClearSpaceForUnit(self.dummy, posPart, true)
        return 0
    end)

    Projectiles:CreateProjectile(projectile)
end

modifier_no_healthbar = class({})

--------------------------------------------------------------------------------
function modifier_no_healthbar:IsHidden()
	return true
end

function modifier_no_healthbar:IsDebuff()
	return false
end


function modifier_no_healthbar:IsPurgable()
	return false
end

 
--------------------------------------------------------------------------------75

function modifier_no_healthbar:CheckState()
	local state = {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	 
	}

	return state
end
 
