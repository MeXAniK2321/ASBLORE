modifier_ichigoW_target_knockback = class({})
LinkLuaModifier("modifier_ichigoW", "heroes/ichigo/modifier_ichigoW", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ichigoE_target_knockback", "heroes/ichigo/modifier_ichigoE_target_knockback",
    LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_projectile_bug", "heroes/modifiers/modifier_projectile_bug", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Classifications
function modifier_ichigoW_target_knockback:IsHidden()
    return false
end

function modifier_ichigoW_target_knockback:IsPurgable()
    return false
end

function modifier_ichigoW_target_knockback:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ichigoW_target_knockback:OnCreated(kv)
    if IsServer() then
        -- creation data (default)
        -- kv.distance (0)
        -- kv.height (-1)
        -- kv.duration (0)
        -- kv.direction_x, kv.direction_y, kv.direction_z (xy:-forward vector, z:0)
        -- kv.tree_destroy_radius (hull-radius), can be null if -1
        -- kv.IsStun (false)
        -- kv.IsFlail (true)
        -- kv.IsPurgable() // later 
        -- kv.IsMultiple() // later

        -- references
        self.height = kv.height
        self.duration = kv.duration
        self.distance = kv.distance
        self.radius = kv.radius
        self.strength = kv.strength
        self.damage = kv.damage
        self.damageFlags = kv.damageFlags
        self.damageType = kv.damageType
        self.val = false

        if kv.direction_x and kv.direction_y then
            self.direction = Vector(kv.direction_x, kv.direction_y, 0):Normalized()
        else
            self.direction = -(self:GetParent():GetForwardVector())
        end
        self.tree = 300

        if kv.IsStun then
            self.stun = kv.IsStun == 1
        else
            self.stun = false
        end
        if kv.IsFlail then
            self.flail = kv.IsFlail == 1
        else
            self.flail = true
        end

        -- check duration
        if self.duration == 0 then
            self:Destroy()
            return
        end

        -- load data
        self.parent = self:GetParent()
        self.origin = self.parent:GetOrigin()

        -- horizontal init
        self.hVelocity = self.distance / self.duration

        -- vertical init
        local half_duration = self.duration / 2
        self.gravity = 2 * self.height / (half_duration * half_duration)
        self.vVelocity = self.gravity * half_duration

        -- apply motion controllers
        if self.distance > 0 then
            if self:ApplyHorizontalMotionController() == false then
                self:Destroy()
                return
            end
        end
        if self.height >= 0 then
            if self:ApplyVerticalMotionController() == false then
                self:Destroy()
                return
            end
        end
    end
end

function modifier_ichigoW_target_knockback:OnRefresh(kv)
    if not IsServer() then
        return
    end
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ichigoW_target_knockback:SetEndCallback(func)
    self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ichigoW_target_knockback:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ichigoW_target_knockback:UpdateHorizontalMotion(me, dt)
    local parent = self:GetParent()

    -- set position
    local target = self.direction * self.distance * (dt / self.duration)

    -- change position
    parent:SetOrigin(parent:GetOrigin() + target)

    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for key, unit in pairs(units) do
        if unit:HasModifier("modifier_ichigoW") == false and self.val == false then
            self.val = true
            unit:AddNewModifier(me, self:GetAbility(), "modifier_ichigoW", {
                duration = 1.0
            })

            self.unit = unit

            self.unitT = Timers:CreateTimer(function()
                unit:SetOrigin(me:GetAbsOrigin() + me:GetForwardVector() * 250)

                return 0
            end)

            local info = {
                victim = unit,
                attacker = me,
                damage = self.damage,
                damage_type = self.damageType,
                damage_flags = self.damageFlags
            }

            ApplyDamage(info)
        end
    end

    GridNav:DestroyTreesAroundPoint(parent:GetOrigin(), self.tree, false)
end

function modifier_ichigoW_target_knockback:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end

function modifier_ichigoW_target_knockback:UpdateVerticalMotion(me, dt)
    -- set time
    local time = dt / self.duration

    -- change height
    self.parent:SetOrigin(self.parent:GetOrigin() + Vector(0, 0, self.vVelocity * dt))

    -- calculate vertical velocity
    self.vVelocity = self.vVelocity - self.gravity * dt
end

function modifier_ichigoW_target_knockback:OnVerticalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end

function modifier_ichigoW_target_knockback:OnDestroy(kv)
    if not IsServer() then
        return
    end

    EndAnimation(self:GetParent())

    if self.unitT then
        Timers:RemoveTimer(self.unitT)
    end

    if self.unit then
        local direction = self.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()

        local ParticleTravel3 = "particles/ichigo_eff/ichigo_r/ichigo_r_final.vpcf"
        local GinFx3 = ParticleManager:CreateParticle(ParticleTravel3, PATTACH_POINT_FOLLOW, self.unit)
        ParticleManager:SetParticleControl(GinFx3, 0, self.unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx3)

        StartAnimation(self:GetParent(), {
            duration = 1.0,
            activity = ACT_DOTA_CAST_ABILITY_3,
            rate = 1.0
        })

        local T = Timers:CreateTimer(function()

            local ParticleTravel4 = "particles/ichigo_eff/ichigo_r/ichigo_r_hit2.vpcf"
            local GinFx4 = ParticleManager:CreateParticle(ParticleTravel4, PATTACH_POINT, self.unit)
            ParticleManager:SetParticleControl(GinFx4, 0, self.unit:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(GinFx4)
            return 0.1
        end)

        Timers:CreateTimer(0.5, function()
            Timers:RemoveTimer(T)
        end)

        self.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ichigoE_target_knockback", {
            duration = 0.5,
            distance = 500,
            direction_x = direction[1],
            direction_y = direction[2]
        })

        EmitSoundOn("corte3", self:GetParent())

        self.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_eff_stun", {
            duration = 0.5
        })

        local info = {
            victim = self.unit,
            attacker = self:GetParent(),
            damage = self:GetParent():GetStrength() * self.strength,
            damage_type = self.damageType,
            damage_flags = self.damageFlags
        }

        ApplyDamage(info)
    end

    if not self.interrupted then
        -- destroy trees
        if self.tree > 0 then
            GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), self.tree, true)
        end
    end

    if self.EndCallback then
        self.EndCallback(self.interrupted)
    end

    self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 1)

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_projectile_bug", {duration = 0.1})
end
