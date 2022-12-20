modifier_altair_debuff = class({})
function modifier_altair_debuff:IsHidden() return false end
function modifier_altair_debuff:IsDebuff() return true end
function modifier_altair_debuff:IsPurgable() return true end
function modifier_altair_debuff:IsPurgeException() return true end
function modifier_altair_debuff:RemoveOnDeath() return true end
function modifier_altair_debuff:GetPriority() return MODIFIER_PRIORITY_NORMAL end
function modifier_altair_debuff:GetMotionPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_altair_debuff:CheckState()
    local state = { --[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_DISARMED] = true,
[MODIFIER_STATE_STUNNED] = true,					}

    if not self.parent:IsNull() and self.pull_leash then
        state[MODIFIER_STATE_TETHERED] = true
    end

    return state
end
--[[function modifier_altair_debuff:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,}
    return funcs
end
function modifier_altair_debuff:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end]]
function modifier_altair_debuff:OnCreated(kv)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	 self.center = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
    
    self.pull_speed = self.ability:GetSpecialValueFor("pull_speed") * 0.2

    
    if IsServer() then
        self.rotate_speed = 1

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_altair_debuff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_altair_debuff:OnIntervalThink()
  
    if IsServer() then
        self:UpdateHorizontalMotion(self.parent, FrameTime())
    end
end
function modifier_altair_debuff:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        self:Charge(me, dt)
    end
end
function modifier_altair_debuff:Charge(me, dt)
    if IsServer() then
        
        
        -- get vector
        local target = self.parent:GetAbsOrigin() - self.center
        target.z = 0

        -- reduce length by pull speed
        local targetL = target:Length2D() - self.pull_speed*dt
        self.targetLSpec = targetL

        -- rotate by rotate speed
        local targetN = target:Normalized()
        local deg = math.atan2( targetN.y, targetN.x )
        local targetN = Vector( math.cos(deg + self.rotate_speed * dt), math.sin(deg + self.rotate_speed * dt), 0 );

        local move_loc = self.center + targetN * targetL
        local max_distance = target:Length2D()
        local PathLength = GridNav:FindPathLength(self.parent:GetAbsOrigin(), move_loc)
        if not GridNav:IsTraversable(move_loc) or GetGroundHeight(move_loc, self.parent) ~= GetGroundHeight(self.center, self:GetAuraOwner()) or PathLength == -1 or PathLength > max_distance then
            self.targetLSpec = self.targetLSpec - 10
        end

        self.parent:SetOrigin( self.center + targetN * self.targetLSpec )
    end
end
function modifier_altair_debuff:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_altair_debuff:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end
        --self.parent:InterruptMotionControllers(true)
    end
end