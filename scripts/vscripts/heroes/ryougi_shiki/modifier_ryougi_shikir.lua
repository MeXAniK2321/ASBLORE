modifier_ryougi_shikiR = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ryougi_shikiR:IsHidden()
    return false
end

function modifier_ryougi_shikiR:IsPurgable()
    return false
end

function modifier_ryougi_shikiR:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ryougi_shikiR:OnCreated(kv)
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

        --
        --
        --[[ EFECTO DE DESPEGUE ]]
        --
        --

        -- references
        self.distance = kv.distance
        self.duration = kv.duration

        if kv.direction_x and kv.direction_y then
            self.direction = Vector(kv.direction_x, kv.direction_y, 0):Normalized()
        else
            if self.gintoki then
                self.direction = self:GetParent():GetForwardVector()
            else
                self.direction = -(self:GetParent():GetForwardVector())
            end
        end
        self.tree = 500

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

function modifier_ryougi_shikiR:OnRefresh(kv)
    if not IsServer() then
        return
    end
end

function modifier_ryougi_shikiR:OnDestroy(kv)
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

    self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 1)
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ryougi_shikiR:SetEndCallback(func)
    self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ryougi_shikiR:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end

--------------------------------------------------------------------------------
--								DESPLAZAMIENTO 

function modifier_ryougi_shikiR:UpdateHorizontalMotion(me, dt)
    local parent = self:GetParent()

    -- set position
    local target = self.direction * self.distance * (dt / self.duration)

    -- change position
    parent:SetOrigin(parent:GetOrigin() + target)

    local ParticleExp = "particles/ryougi_eff/ryougi_r/ryougi_r_slash.vpcf"
    local GinFx = ParticleManager:CreateParticle(ParticleExp, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(GinFx, 2, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx)

    local ParticleExp2 = "particles/ryougi_eff/ryougi_r/ryougi_r_slash.vpcf"
    local GinFx2 = ParticleManager:CreateParticle(ParticleExp2, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(GinFx2, 2, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx2)

    local ParticleExp3 = "particles/ryougi_eff/ryougi_r/ryougi_r_slash.vpcf"
    local GinFx3 = ParticleManager:CreateParticle(ParticleExp3, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(GinFx3, 2, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx3)

    local ParticleExp4 = "particles/ryougi_eff/ryougi_r/ryougi_r_slash.vpcf"
    local GinFx4 = ParticleManager:CreateParticle(ParticleExp4, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(GinFx4, 2, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx4)

    local ParticleExp5 = "particles/ryougi_eff/ryougi_r/ryougi_r_light.vpcf"
    local GinFx5 = ParticleManager:CreateParticle(ParticleExp5, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(GinFx5, 1, self:GetParent():GetOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx5)
end

function modifier_ryougi_shikiR:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end
