LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_kb", "heroes/modifiers/modifier_generic_kb", LUA_MODIFIER_MOTION_BOTH)

modifier_ryougi_shikiQ_last = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ryougi_shikiQ_last:IsHidden()
    return false
end

function modifier_ryougi_shikiQ_last:IsPurgable()
    return false
end

function modifier_ryougi_shikiQ_last:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ryougi_shikiQ_last:OnCreated(kv)
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
        self.targetTeam = kv.targetTeam
        self.radius_end = kv.radius_end
        self.damageType = kv.damageType
        self.damageFlags = kv.damageFlags
        self.duration_stun = kv.duration_stun
        self.agility_end = kv.agility_end

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

function modifier_ryougi_shikiQ_last:OnRefresh(kv)
    if not IsServer() then
        return
    end
end

function modifier_ryougi_shikiQ_last:OnDestroy(kv)
    if not IsServer() then
        return
    end

    EmitSoundOn("Ryougi.QSlam", self:GetParent())

    local ParticleR = "particles/ryougi_eff/ryougi_q/ryougi_q_3.vpcf"
    local rfx = ParticleManager:CreateParticle(ParticleR, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(rfx, 1, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(rfx)
    
    local ParticleR2 = "particles/ryougi_eff/ryougi_q/ryougi_q_3_exp.vpcf"
    local rfx2 = ParticleManager:CreateParticle(ParticleR2, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(rfx2, 0, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(rfx2)

    if not self.interrupted then
        -- destroy trees
        if self.tree > 0 then
            GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), self.tree, true)
        end
    end

    local casterPt = self:GetParent():GetAbsOrigin()
    local point = casterPt + self:GetParent():GetForwardVector() * 100

    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), point, nil, self.radius_end, self.targetTeam,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for key, unit in pairs(units) do
        local info = {
            victim = unit,
            attacker = self:GetParent(),
            damage = self:GetParent():GetAgility() * self.agility_end,
            damage_type = self.damageType,
            damage_flags = self.damageFlags
        }

        unit:AddNewModifier(self:GetParent(), self, "modifier_eff_stun", {
            duration = self.duration_stun
        })

        unit:AddNewModifier(caster, self, "modifier_generic_kb", {
            duration = self.duration,
            distance = 0,
            height = 250,
            direction_x = self.direction[1],
            direction_y = self.direction[2]
        })

        ApplyDamage(info)
    end

    RYOUGIQ = 1

    if self.EndCallback then
        self.EndCallback(self.interrupted)
    end

    self:GetParent():InterruptMotionControllers(true)
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ryougi_shikiQ_last:SetEndCallback(func)
    self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ryougi_shikiQ_last:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ryougi_shikiQ_last:UpdateHorizontalMotion(me, dt)
    local parent = self:GetParent()

    -- set position
    local target = self.direction * self.distance * (dt / self.duration)

    -- change position
    parent:SetOrigin(parent:GetOrigin() + target)

    GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), self.tree, true)
end

function modifier_ryougi_shikiQ_last:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end
