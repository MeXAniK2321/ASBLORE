LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_kb", "heroes/modifiers/modifier_generic_kb", LUA_MODIFIER_MOTION_BOTH)

modifier_ryougi_shikiQ = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ryougi_shikiQ:IsHidden()
    return false
end

function modifier_ryougi_shikiQ:IsPurgable()
    return false
end

function modifier_ryougi_shikiQ:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ryougi_shikiQ:OnCreated(kv)
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
        if kv.distance_kb then
            self.distance_kb = kv.distance_kb
        end
        self.duration = kv.duration
        self.targetTeam = kv.targetTeam
        self.radius = kv.radius
        self.damageType = kv.damageType
        self.damageFlags = kv.damageFlags
        self.duration_stun = kv.duration_stun
        self.agility_start = kv.agility_start

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

function modifier_ryougi_shikiQ:OnRefresh(kv)
    if not IsServer() then
        return
    end
end

function modifier_ryougi_shikiQ:OnDestroy(kv)
    if not IsServer() then
        return
    end

    if not self.interrupted then
        -- destroy trees
        if self.tree > 0 then
            GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), self.tree, true)
        end
    end

    local casterPt = self:GetParent():GetAbsOrigin()
    local point = casterPt + self:GetParent():GetForwardVector() * 100
    local direction = self:GetParent():GetForwardVector()

    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), point, nil, self.radius, self.targetTeam,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for key, unit in pairs(units) do
        local info = {
            victim = unit,
            attacker = self:GetParent(),
            damage = self:GetParent():GetAgility() * self.agility_start,
            damage_type = self.damageType,
            damage_flags = self.damageFlags
        }

        local particleImpact2 = "particles/ryougi_eff/ryougi_w/ryougi_blood_2.vpcf"
        local exp2 = ParticleManager:CreateParticle(particleImpact2, PATTACH_POINT_FOLLOW, unit)
        ParticleManager:SetParticleControl(exp2, 0, unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(exp2)

        unit:AddNewModifier(self:GetParent(), self, "modifier_eff_stun", {
            duration = self.duration_stun
        })

        if self.distance_kb then
            self.distance = self.distance_kb
        end

        unit:AddNewModifier(caster, self, "modifier_generic_kb", {
            duration = self.duration,
            distance = self.distance,
            height = 1,
            direction_x = direction[1],
            direction_y = direction[2]
        })

        ApplyDamage(info)

        EmitSoundOn("Ryougi.QCut", unit)
    end

    if self.EndCallback then
        self.EndCallback(self.interrupted)
    end

    self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 1)
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ryougi_shikiQ:SetEndCallback(func)
    self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ryougi_shikiQ:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ryougi_shikiQ:UpdateHorizontalMotion(me, dt)
    local parent = self:GetParent()

    -- set position
    local target = self.direction * self.distance * (dt / self.duration)

    -- change position
    parent:SetOrigin(parent:GetOrigin() + target)

    GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(), self.tree, true)
end

function modifier_ryougi_shikiQ:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end
