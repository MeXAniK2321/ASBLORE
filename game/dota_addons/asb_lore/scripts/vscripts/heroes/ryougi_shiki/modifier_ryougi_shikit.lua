LinkLuaModifier("modifier_ryougi_shikiT_invu", "heroes/ryougi_shiki/modifier_ryougi_shikiT_invu",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ryougi_shikiT_invu_2", "heroes/ryougi_shiki/modifier_ryougi_shikiT_invu_2",
    LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_kb", "heroes/modifiers/modifier_generic_kb", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ryougi_shiki_T_target", "heroes/ryougi_shiki/modifier_ryougi_shiki_T_target",
    LUA_MODIFIER_MOTION_NONE)

modifier_ryougi_shikiT = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ryougi_shikiT:IsHidden()
    return false
end

function modifier_ryougi_shikiT:IsPurgable()
    return false
end

function modifier_ryougi_shikiT:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ryougi_shikiT:OnCreated(kv)
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
        self.distance = kv.distance
        self.duration = kv.duration
        self.radius = kv.radius
        self.targetTeam = kv.targetTeam
        self.duration_mid = kv.duration_mid
        self.distance_mid = kv.distance_mid

        if kv.direction_x and kv.direction_y then
            self.direction = Vector(kv.direction_x, kv.direction_y, 0):Normalized()
        else
            if self.gintoki then
                self.direction = self:GetParent():GetForwardVector()
            else
                self.direction = -(self:GetParent():GetForwardVector())
            end
        end
        self.tree = kv.tree_destroy_radius or self:GetParent():GetHullRadius()

        --[[ if kv.IsStun  then self.stun = kv.IsStun==1 else self.stun = false end
		if kv.IsFlail then self.flail = kv.IsFlail==1 else self.flail = true end ]]

        self.stun = true
        self.flail = true

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

        -- apply motion controllers
        if self.distance > 0 then
            if self:ApplyHorizontalMotionController() == false then
                self:Destroy()
                return
            end
        end

        -- tell client of activity
        if self.stun then
            self:SetStackCount(1)
        elseif self.flail then
            self:SetStackCount(2)
        end
    else
        self.anim = self:GetStackCount()
        self:SetStackCount(0)
    end
end

function modifier_ryougi_shikiT:OnRefresh(kv)
    if not IsServer() then
        return
    end
end

function modifier_ryougi_shikiT:OnDestroy(kv)
    if not IsServer() then
        return
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

    self:GetParent():InterruptMotionControllers(true)
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ryougi_shikiT:SetEndCallback(func)
    self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ryougi_shikiT:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end

--------------------------------------------------------------------------------
--                          DESPLAZAMIENTO
function modifier_ryougi_shikiT:UpdateHorizontalMotion(me, dt)
    local parent = self:GetParent()

    local particleImpact2 = "particles/ryougi_eff/ryougi_t/ryougi_t_init.vpcf"
    local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT, parent)
    ParticleManager:SetParticleControl(exp2, 0, parent:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(exp2)

    local particleImpact3 = "particles/ryougi_eff/ryougi_t/ryougi_t_travel.vpcf"
    local exp3 = ParticleManager:CreateParticle(particleImpact3, PATTACH_POINT, parent)
    ParticleManager:SetParticleControl(exp3, 0, parent:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(exp3)

    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius,
        self.targetTeam, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

    for key, unit in pairs(units) do
        EndAnimation(self:GetParent())

        local direction = self:GetParent():GetForwardVector()

        StartAnimation(self:GetParent(), {
            duration = 0.5,
            activity = ACT_DOTA_CHANNEL_ABILITY_2,
            rate = 2.0
        })

        local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_hit2.vpcf"
        local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, unit)
        ParticleManager:SetParticleControl(exp4, 3, unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp4)

        local particleImpact7 = "particles/ryougi_eff/ryougi_t/ryougi_t_enemy.vpcf"
        local exp7 = ParticleManager:CreateParticle(particleImpact7, PATTACH_POINT, self:GetParent())
        ParticleManager:SetParticleControl(exp7, 1, self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 600)
        ParticleManager:ReleaseParticleIndex(exp7)

        local particleImpact8 = "particles/ryougi_eff/ryougi_t/ryougi_t_channel.vpcf"
        local exp8 = ParticleManager:CreateParticle(particleImpact8, PATTACH_POINT_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(exp8, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp8)

        local particleImpact9 = "particles/ryougi_eff/ryougi_t/ryougi_t_initial.vpcf"
        local exp9 = ParticleManager:CreateParticle(particleImpact9, PATTACH_POINT, self:GetParent())
        ParticleManager:SetParticleControl(exp9, 0, self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 600)
        ParticleManager:ReleaseParticleIndex(exp9)

        --particleImpact9 = "particles/ryougi_eff/ryougi_t/ryougi_t_circle.vpcf"
        --exp9 = ParticleManager:CreateParticle(particleImpact9, PATTACH_POINT, self:GetParent())
        --ParticleManager:SetParticleControl(exp9, 0, self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 600)
        --ParticleManager:ReleaseParticleIndex(exp9)

        unit:AddNewModifier(unit, self, "modifier_generic_kb", {
            duration = self.duration_mid,
            distance = self.distance_mid,
            height = 1,
            direction_x = direction[1],
            direction_y = direction[2]
        })

        local modifier = unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ryougi_shiki_T_target", {})

        local mod = tempTable:AddATValue(modifier)

        unit:AddNewModifier(unit, self, "modifier_ryougi_shikiT_invu_2", {
            duration = 9
        })

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ryougi_shikiT_invu", {
            duration = 8.8,
            target = mod
        })

        --MUSICSTOPPER()

        EmitGlobalSound("Ryougi.T4")
        EmitGlobalSound("Ryougi.T6")

        self:Destroy()
    end

    -- set position
    local target = self.direction * self.distance * (dt / self.duration)

    -- change position
    parent:SetOrigin(parent:GetOrigin() + target)
end

function modifier_ryougi_shikiT:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end
