modifier_ichigo_R = class({})
LinkLuaModifier("modifier_eff_stun", "heroes/modifiers/modifier_eff_stun",
                LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_kb", "heroes/modifiers/modifier_generic_kb",
                LUA_MODIFIER_MOTION_BOTH)

--------------------------------------------------------------------------------
-- Classifications
function modifier_ichigo_R:IsHidden() return false end

function modifier_ichigo_R:IsPurgable() return false end

function modifier_ichigo_R:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ichigo_R:OnCreated(kv)
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
        self.distance_enemy = kv.distance_enemy or nil
        self.height = kv.height
        self.duration = kv.duration
        self.duration_enemy = kv.duration_enemy
        self.duration_stun = kv.duration_stun
        self.radius = kv.radius or 0
        self.damage = kv.damage or nil
        self.strength = kv.strength

        if kv.direction_x and kv.direction_y then
            self.direction =
                Vector(kv.direction_x, kv.direction_y, 0):Normalized()
        else
            if self.gintoki then
                self.direction = self:GetParent():GetForwardVector()
            else
                self.direction = -(self:GetParent():GetForwardVector())
            end
        end
        self.tree = 300

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

function modifier_ichigo_R:OnRefresh(kv) if not IsServer() then return end end

function modifier_ichigo_R:OnDestroy(kv)
    if not IsServer() then return end

    StopSoundOn("Gintoki.R4", self:GetParent())

    if not self.interrupted then
        -- destroy trees
        if self.tree > 0 then
            GridNav:DestroyTreesAroundPoint(self:GetParent():GetOrigin(),
                                            self.tree, true)
        end
    end

    if self.EndCallback then self.EndCallback(self.interrupted) end

    local TimerBug = Timers:CreateTimer(function()
		if self:GetParent():IsMoving() == false then
			self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin())
		else
			Timers:RemoveTimer(TimerBug)
		end
		return 0
	end)
end

--------------------------------------------------------------------------------
-- Setter
function modifier_ichigo_R:SetEndCallback(func) self.EndCallback = func end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ichigo_R:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true
    }

    return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ichigo_R:UpdateHorizontalMotion(me, dt)
    local parent = self:GetParent()

    -- set position
    local target = self.direction * self.distance * (dt / self.duration)

    -- change position
    parent:SetOrigin(parent:GetOrigin() + target)

    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
                                    self:GetParent():GetAbsOrigin(), nil,
                                    self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
                                    DOTA_UNIT_TARGET_HERO,
                                    DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,
                                    false)

    local ParticleTravel2 =
        "particles/ichigo_eff/ichigo_r/ichigo_r_travel2.vpcf"
    local GinFx2 = ParticleManager:CreateParticle(ParticleTravel2,
                                                  PATTACH_POINT_FOLLOW,
                                                  self:GetParent())
    ParticleManager:SetParticleControl(GinFx2, 0,
                                       self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(GinFx2)

    for key, unit in pairs(units) do
        local ParticleTravel3 =
            "particles/ichigo_eff/ichigo_r/ichigo_r_hit.vpcf"
        local GinFx3 = ParticleManager:CreateParticle(ParticleTravel3,
                                                      PATTACH_POINT_FOLLOW, unit)
        ParticleManager:SetParticleControl(GinFx3, 1, unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx3)

        local T = Timers:CreateTimer(function ()

        local ParticleTravel4 =
            "particles/ichigo_eff/ichigo_r/ichigo_r_hit2.vpcf"
        local GinFx4 = ParticleManager:CreateParticle(ParticleTravel4,
                                                      PATTACH_POINT, unit)
        ParticleManager:SetParticleControl(GinFx4, 0, unit:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(GinFx4)
            return 0.1
        end)

        Timers:CreateTimer(0.5,function ()
            Timers:RemoveTimer(T)
        end)

        local info = {
            victim = unit,
            attacker = self:GetParent(),
            damage = self.damage + self:GetParent():GetStrength() * self.strength,
            damage_type = DAMAGE_TYPE_MAGICAL
        }

        local direction = self:GetParent():GetForwardVector()
        unit:AddNewModifier(self:GetParent(), self:GetAbility(),
                            "modifier_generic_kb", {
            duration = self.duration_enemy,
            distance = self.distance_enemy,
            height = 0,
            direction_x = direction[1],
            direction_y = direction[2]
        })
        unit:AddNewModifier(self:GetParent(), self:GetAbility(),
                            "modifier_eff_stun", {duration = self.duration_stun})

        EmitSoundOn("corte14", unit)

        ApplyDamage(info)

        self:Destroy()
    end
end

function modifier_ichigo_R:OnHorizontalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end

function modifier_ichigo_R:UpdateVerticalMotion(me, dt)
    -- set time
    local time = dt / self.duration

    -- change height
    self.parent:SetOrigin(self.parent:GetOrigin() +
                              Vector(0, 0, self.vVelocity * dt))

    -- calculate vertical velocity
    self.vVelocity = self.vVelocity - self.gravity * dt
end

function modifier_ichigo_R:OnVerticalMotionInterrupted()
    if IsServer() then
        self.interrupted = true
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ichigo_R:GetEffectName()
    if not IsServer() then return end
    if self.stun == true then
        return
            "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_stunned_orbit.vpcf"
    end
end

function modifier_ichigo_R:GetEffectAttachType()
    if not IsServer() then return end
    return PATTACH_OVERHEAD_FOLLOW
end
