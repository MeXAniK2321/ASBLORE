modifier_ichigoE_caster = class({})
LinkLuaModifier("modifier_ichigoE_target_knockback",
                "heroes/ichigo/modifier_ichigoE_target_knockback",
                LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun",
                LUA_MODIFIER_MOTION_NONE)

function modifier_ichigoE_caster:IsHidden() return false end

function modifier_ichigoE_caster:IsDebuff() return false end

function modifier_ichigoE_caster:IsStunDebuff() return false end

function modifier_ichigoE_caster:IsPurgable() return false end

function modifier_ichigoE_caster:OnCreated(kv)
    self.duration_stun = kv.duration_stun
    self.damage = kv.damage
    self.speed = kv.speed
    self.distance = kv.distance
    self.target_modifier = tempTable:RetATValue(kv.target)
    self.target = self.target_modifier:GetParent()
    self.tree = 200

    if not IsServer() then return end

    if not self:ApplyHorizontalMotionController() then
        self:Destroy()
        return
    end
end

function modifier_ichigoE_caster:OnDestroy()
    if not IsServer() then return end
    EndAnimation(self:GetParent())
    self.target_modifier:Destroy()
    self:GetParent():RemoveHorizontalMotionController(self)
end

function modifier_ichigoE_caster:UpdateHorizontalMotion(me, dt)
    self.direction = me:GetForwardVector()

    self.position = self.target:GetAbsOrigin()

    if self.target:IsAlive() == false or self.target:IsInvulnerable() or
        self.target:IsInvisible() then self:Destroy() end

    me:FaceTowards(self.position)

    local origin = me:GetAbsOrigin()
    local target = origin + self.direction * self.speed * dt
    me:SetOrigin(target)

    if CalcDistanceBetweenEntityOBB(self:GetParent(), self.target) < 401 then
        local particle_cast_a = "particles/ichigo_eff/ichigo_f/ichigo_f.vpcf"
        local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a,
                                                             PATTACH_POINT, me)
        ParticleManager:SetParticleControl(effect_cast_a, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast_a)
    end

    if CalcDistanceBetweenEntityOBB(self:GetParent(), self.target) < 400 then
        EmitSoundOn("Ichigo.F1", me)

        me:SetOrigin(self.target:GetAbsOrigin() + me:GetForwardVector() * 100)

        EndAnimation(me)

        StartAnimation(self:GetParent(), {
            duration = 1.0,
            activity = ACT_DOTA_CAST_ABILITY_3,
            rate = 1.0
        })

        local particle_cast_a = "particles/ichigo_eff/ichigo_f/ichigo_f.vpcf"
        local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a,
                                                             PATTACH_POINT, me)
        ParticleManager:SetParticleControl(effect_cast_a, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast_a)

        local particle_cast_b =
            "particles/ichigo_eff/ichigo_e/ichigo_e_hit.vpcf"
        local effect_cast_b = ParticleManager:CreateParticle(particle_cast_b,
                                                             PATTACH_POINT_FOLLOW,
                                                             self.target)
        ParticleManager:SetParticleControl(effect_cast_b, 1,
                                           self.target:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast_b)

        local ParticleExp2 = "particles/ichigo_eff/ichigo_e/ichigo_e_hit.vpcf"
        local GinFx2 = ParticleManager:CreateParticle(ParticleExp2,
                                                      PATTACH_POINT, me)
        ParticleManager:SetParticleControl(GinFx2, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx2)

        local ParticleExp3 = "particles/ichigo_eff/ichigo_e/ichigo_e_hit2.vpcf"
        local ichi = ParticleManager:CreateParticle(ParticleExp3,
                                                      PATTACH_POINT, me)
        ParticleManager:SetParticleControl(ichi, 0, me:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(ichi)

        EmitSoundOn("Ichigo.R3", self:GetParent())

        local info = {
            victim = self.target,
            attacker = self:GetParent(),
            damage = me:GetStrength() * self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL
        }

        local tPoint = self.target:GetAbsOrigin()
        local casterPt = self:GetParent():GetAbsOrigin()

        local direction = tPoint - casterPt

        self.target:AddNewModifier(self:GetParent(), self:GetAbility(),
                                   "modifier_ichigoE_target_knockback", {
            duration = self.duration_stun,
            distance = self.distance,
            direction_x = direction[1],
            direction_y = direction[2]
        })

        self.target:AddNewModifier(self:GetParent(), self:GetAbility(),
                                   "modifier_eff_stun",
                                   {duration = self.duration_stun})

        ApplyDamage(info)

        me:FaceTowards(tPoint)

        self.target_modifier:Destroy()
        self:Destroy()
    end

    GridNav:DestroyTreesAroundPoint(origin, self.tree, false)
end

function modifier_ichigoE_caster:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }

    return state
end

function modifier_ichigoE_caster:OnHorizontalMotionInterrupted() self:Destroy() end

--------------------------------------------------------------------------------
function modifier_ichigoE_caster:GetEffectName()
    return "particles/ichigo_eff/ichigo_e/ichigo_e_travel.vpcf"
end

function modifier_ichigoE_caster:GetEffectAttachType()
    return PATTACH_POINT_FOLLOW
end
