
local KEN_ABILITY_STATE_ONE = 1
local KEN_ABILITY_STATE_TWO = 2

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: Q (Normal)(Hiei Ken + Ganzan Ryozan Ha)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_hiei_ganzan", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_hiei_ganzan = kenshiro_hiei_ganzan or class({})

function kenshiro_hiei_ganzan:GetBehavior()
     return self.nCurState == KEN_ABILITY_STATE_ONE
            and self.BaseClass.GetBehavior(self)
            or DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
function kenshiro_hiei_ganzan:GetAbilityTextureName()
     return self.nCurState == KEN_ABILITY_STATE_ONE
            and self.BaseClass.GetAbilityTextureName(self)
            or "gojo_kick4"
end
function kenshiro_hiei_ganzan:Spawn()
    self.nCurState = KEN_ABILITY_STATE_TWO
end
function kenshiro_hiei_ganzan:OnAbilityPhaseStart()
    if self.nCurState == KEN_ABILITY_STATE_TWO then 
        self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)
        return true 
    end

    local hCaster     = self:GetCaster()
    local fCastPoint  = self:GetCastPoint() - 0.034
    local nAnimFPS    = 30 -- Animation frames per second
    local nAnimFrame  = 25 -- Animation frame to reach

    -- Animation rate calculated to reach frame nAnimFrame within the ability's cast point
    local fPlayBackRateSet = nAnimFrame / (nAnimFPS * fCastPoint)
    
    -- Set the gesture with the precise playback rate
    -- NOTE: Turn rate can mess this up, but will leave as feature
    hCaster:StartGestureWithPlaybackRate(ACT_DOTA_RAZE_1, fPlayBackRateSet)
    
    return true
end
function kenshiro_hiei_ganzan:OnAbilityPhaseInterrupted() 
    self:GetCaster():FadeGesture(ACT_DOTA_RAZE_1)
    self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end
function kenshiro_hiei_ganzan:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    if not self.nCurState then self.nCurState = KEN_ABILITY_STATE_ONE end
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0, self.nCurState })
    
    print (self.nCurState)
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_hiei_ganzan = modifier_kenshiro_hiei_ganzan or class ({})

function modifier_kenshiro_hiei_ganzan:IsHidden() return false end
function modifier_kenshiro_hiei_ganzan:IsPurgeable() return false end
function modifier_kenshiro_hiei_ganzan:IsPurgeException() return false end
function modifier_kenshiro_hiei_ganzan:RemoveOnDeath() return true end
function modifier_kenshiro_hiei_ganzan:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    if not self.hCursorTarget then
        state[MODIFIER_STATE_FROZEN] = true -- Use Frozen to lock the animation
    end
    return state
end
function modifier_kenshiro_hiei_ganzan:DeclareFunctions()
    local funcs = {
                      --MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
--[[
function modifier_kenshiro_hiei_ganzan:GetOverrideAnimation()
    return ACT_DOTA_RAZE_1
end]]--
function modifier_kenshiro_hiei_ganzan:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1500
        self.fTravelTime  = 0.7
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and GetDirection(self.ability:GetCursorPosition(), self.parent:GetOrigin())
                                
        self.hCursorTarget    = self.ability:GetCursorTarget()
        
        self.bFirstStage      = true
        self.bSecondStage     = false
        
        self.nChopTimer       = 1.0
                                
        self.hKnockBackTable  = {
                                    should_stun        = true,
                                    knockback_duration = 0.7,
                                    duration           = 0.7,
                                    knockback_distance = 500,
                                    knockback_height   = 200,
                                    center_x           = nil,
                                    center_y           = nil,
                                    center_z           = nil
                                }
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_hiei_ganzan:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if IsNotNull(self.hCursorTarget) then
            self:Chop(me, dt)
            return
        end
        
        if me:IsStunned() then return end
        
        self:Kick(me, dt)
    end
end
function modifier_kenshiro_hiei_ganzan:Chop(me, dt)
    -- Animations and stuff
    if not self.bAnimHoldSet then
        me:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1_STATUE, 1)
        self.bAnimHoldSet = true    
    end
    -- EYE movement logic pog
    local vCurPos     = me:GetAbsOrigin()
    local vDirection  = GetDirection(self.hCursorTarget, vCurPos)
    local fDistance   = GetDistance(self.hCursorTarget, vCurPos)
    local fUnitsPerDt = self.fUnitsPerSec * dt
    local vNextPos    = vCurPos + vDirection * fUnitsPerDt
               
    if fDistance <= 150 then
        self.bFirstStage = false
        self.bSecondStage = true
    end
    
    if self.bFirstStage then
        me:SetOrigin(vNextPos)
    end
    
    if self.bSecondStage then
        if self.nChopTimer == 1.0 then
            me:RemoveGesture(ACT_DOTA_CAST_ABILITY_1_STATUE)
            me:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1_END, 1)
        end
        self.nChopTimer = self.nChopTimer - dt
        if self.nChopTimer <= 0.65 then
            self:HitEnemies(me)
            self:Destroy()
            return
        end
    end
               
    me:SetForwardVector(vDirection, true)
    me:FaceTowards(self.hCursorTarget:GetOrigin())
end
function modifier_kenshiro_hiei_ganzan:Kick(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = me:GetForwardVector()
    end
    
    if not self.vFacePoint then
        -- Adding more range to the distance or hero will turn back
        -- I guess remove if you want as feature ??
        self.vFacePoint = self.parent:GetOrigin() + self.vChargeDirection * (self.fDistance + 100)
    end
    
    local vOrigin  = me:GetOrigin()
    local fSpeed   = self.fUnitsPerSec * dt
    
    local vNextPos = vOrigin + self.vChargeDirection * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vFacePoint)
    
    self:HitEnemies(me)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_hiei_ganzan:HitEnemies(me)
    local hEnemies = FindUnitsInRadius( me:GetTeamNumber(),
                                        me:GetOrigin(),
                                        nil,
                                        300,
                                        self.ability:GetAbilityTargetTeam(),
                                        self.ability:GetAbilityTargetType(),
                                        self.ability:GetAbilityTargetFlags(),
                                        FIND_CLOSEST,
                                        false)
                                        
    for _, hEnemy in pairs(hEnemies) do
        if IsNotNull(hEnemy) then
            local hKnockbackModifier = hEnemy:FindModifierByName("modifier_knockback")
            if IsNotNull(hKnockbackModifier) and hKnockbackModifier:GetCaster() ~= me then
                hEnemy:RemoveModifierByName("modifier_knockback")
            end
            
            if not IsNotNull(hKnockbackModifier) then
                self.hKnockBackTable.center_x = me:GetAbsOrigin().x
                self.hKnockBackTable.center_y = me:GetAbsOrigin().y
                self.hKnockBackTable.center_z = me:GetAbsOrigin().z
                hEnemy:AddNewModifier(me, self, "modifier_knockback", self.hKnockBackTable, hEnemy:IsOpposingTeam(me:GetTeamNumber()))
            end
        end        
    end
end
function modifier_kenshiro_hiei_ganzan:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_hiei_ganzan:OnDestroy()
    if IsServer() then
        self.parent:FadeGesture(ACT_DOTA_RAZE_1)
        self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1_STATUE)
        --self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1_END)
        if self.bFirstStage then
            self.parent:StartGesture(ACT_DOTA_RAZE_2)
        end
    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: W (Normal)(Shichishi Kihei Zan + Juu Hazan)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_shichishi_juu", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_shichishi_juu = kenshiro_shichishi_juu or class({})

function kenshiro_shichishi_juu:GetAbilityTextureName()
     return ""
end
function kenshiro_shichishi_juu:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_shichishi_juu = modifier_kenshiro_shichishi_juu or class ({})

function modifier_kenshiro_shichishi_juu:IsHidden() return false end
function modifier_kenshiro_shichishi_juu:IsPurgeable() return false end
function modifier_kenshiro_shichishi_juu:IsPurgeException() return false end
function modifier_kenshiro_shichishi_juu:RemoveOnDeath() return true end
function modifier_kenshiro_shichishi_juu:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_shichishi_juu:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_shichishi_juu:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_shichishi_juu:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_shichishi_juu:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_shichishi_juu:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_shichishi_juu:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_shichishi_juu:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: E (Normal)(Zankai Ken)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_zankai", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_zankai = kenshiro_zankai or class({})

function kenshiro_zankai:GetAbilityTextureName()
     return ""
end
function kenshiro_zankai:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_zankai = modifier_kenshiro_zankai or class ({})

function modifier_kenshiro_zankai:IsHidden() return false end
function modifier_kenshiro_zankai:IsPurgeable() return false end
function modifier_kenshiro_zankai:IsPurgeException() return false end
function modifier_kenshiro_zankai:RemoveOnDeath() return true end
function modifier_kenshiro_zankai:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_zankai:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_zankai:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_zankai:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_zankai:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_zankai:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_zankai:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_zankai:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: D (Normal)(TENHA KASSATSU)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_tenha", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_tenha = kenshiro_tenha or class({})

function kenshiro_tenha:GetAbilityTextureName()
     return ""
end
function kenshiro_tenha:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_tenha = modifier_kenshiro_tenha or class ({})

function modifier_kenshiro_tenha:IsHidden() return false end
function modifier_kenshiro_tenha:IsPurgeable() return false end
function modifier_kenshiro_tenha:IsPurgeException() return false end
function modifier_kenshiro_tenha:RemoveOnDeath() return true end
function modifier_kenshiro_tenha:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_tenha:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_tenha:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_tenha:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_tenha:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_tenha:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_tenha:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_tenha:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: F (Normal)(Shichishi Seiten)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_shichishi_seiten", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_shichishi_seiten = kenshiro_shichishi_seiten or class({})

function kenshiro_shichishi_seiten:GetAbilityTextureName()
     return ""
end
function kenshiro_shichishi_seiten:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_shichishi_seiten = modifier_kenshiro_shichishi_seiten or class ({})

function modifier_kenshiro_shichishi_seiten:IsHidden() return false end
function modifier_kenshiro_shichishi_seiten:IsPurgeable() return false end
function modifier_kenshiro_shichishi_seiten:IsPurgeException() return false end
function modifier_kenshiro_shichishi_seiten:RemoveOnDeath() return true end
function modifier_kenshiro_shichishi_seiten:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_shichishi_seiten:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_shichishi_seiten:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_shichishi_seiten:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_shichishi_seiten:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_shichishi_seiten:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_shichishi_seiten:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_shichishi_seiten:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: R (Normal)(Muso Tensei)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_muso_tensei", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_muso_tensei = kenshiro_muso_tensei or class({})

function kenshiro_muso_tensei:GetAbilityTextureName()
     return ""
end
function kenshiro_muso_tensei:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_muso_tensei = modifier_kenshiro_muso_tensei or class ({})

function modifier_kenshiro_muso_tensei:IsHidden() return false end
function modifier_kenshiro_muso_tensei:IsPurgeable() return false end
function modifier_kenshiro_muso_tensei:IsPurgeException() return false end
function modifier_kenshiro_muso_tensei:RemoveOnDeath() return true end
function modifier_kenshiro_muso_tensei:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_muso_tensei:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_muso_tensei:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_muso_tensei:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_muso_tensei:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_muso_tensei:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_muso_tensei:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_muso_tensei:OnDestroy()
    if IsServer() then

    end
end


---------------------------------------------------------------------------------------------------------------
-- Kenshiro Ultimate Abilities
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: Q (Ultimate Form)(Zankai Sekiho Ken)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_zankai_sekiho", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_zankai_sekiho = kenshiro_zankai_sekiho or class({})

function kenshiro_zankai_sekiho:GetAbilityTextureName()
     return ""
end
function kenshiro_zankai_sekiho:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_zankai_sekiho = modifier_kenshiro_zankai_sekiho or class ({})

function modifier_kenshiro_zankai_sekiho:IsHidden() return false end
function modifier_kenshiro_zankai_sekiho:IsPurgeable() return false end
function modifier_kenshiro_zankai_sekiho:IsPurgeException() return false end
function modifier_kenshiro_zankai_sekiho:RemoveOnDeath() return true end
function modifier_kenshiro_zankai_sekiho:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_zankai_sekiho:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_zankai_sekiho:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_zankai_sekiho:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_zankai_sekiho:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_zankai_sekiho:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_zankai_sekiho:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_zankai_sekiho:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: W (Ultimate Form)(Muso Tensei:Styles of Masters)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_muso_tensei_styles", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_muso_tensei_styles = kenshiro_muso_tensei_styles or class({})

function kenshiro_muso_tensei_styles:GetAbilityTextureName()
     return ""
end
function kenshiro_muso_tensei_styles:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_muso_tensei_styles = modifier_kenshiro_muso_tensei_styles or class ({})

function modifier_kenshiro_muso_tensei_styles:IsHidden() return false end
function modifier_kenshiro_muso_tensei_styles:IsPurgeable() return false end
function modifier_kenshiro_muso_tensei_styles:IsPurgeException() return false end
function modifier_kenshiro_muso_tensei_styles:RemoveOnDeath() return true end
function modifier_kenshiro_muso_tensei_styles:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_muso_tensei_styles:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_muso_tensei_styles:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_muso_tensei_styles:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_muso_tensei_styles:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_muso_tensei_styles:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_muso_tensei_styles:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_muso_tensei_styles:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: E (Ultimate Form)(Muso Tensei)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_muso_tensei_ultimate", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_muso_tensei_ultimate = kenshiro_muso_tensei_ultimate or class({})

function kenshiro_muso_tensei_ultimate:GetAbilityTextureName()
     return ""
end
function kenshiro_muso_tensei_ultimate:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_muso_tensei_ultimate = modifier_kenshiro_muso_tensei_ultimate or class ({})

function modifier_kenshiro_muso_tensei_ultimate:IsHidden() return false end
function modifier_kenshiro_muso_tensei_ultimate:IsPurgeable() return false end
function modifier_kenshiro_muso_tensei_ultimate:IsPurgeException() return false end
function modifier_kenshiro_muso_tensei_ultimate:RemoveOnDeath() return true end
function modifier_kenshiro_muso_tensei_ultimate:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_muso_tensei_ultimate:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_muso_tensei_ultimate:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_muso_tensei_ultimate:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_muso_tensei_ultimate:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_muso_tensei_ultimate:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_muso_tensei_ultimate:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_muso_tensei_ultimate:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: F (Ultimate Form)(Shichisei Tenshin)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_shichisei_tenshin", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_shichisei_tenshin = kenshiro_shichisei_tenshin or class({})

function kenshiro_shichisei_tenshin:GetAbilityTextureName()
     return ""
end
function kenshiro_shichisei_tenshin:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_shichisei_tenshin = modifier_kenshiro_shichisei_tenshin or class ({})

function modifier_kenshiro_shichisei_tenshin:IsHidden() return false end
function modifier_kenshiro_shichisei_tenshin:IsPurgeable() return false end
function modifier_kenshiro_shichisei_tenshin:IsPurgeException() return false end
function modifier_kenshiro_shichisei_tenshin:RemoveOnDeath() return true end
function modifier_kenshiro_shichisei_tenshin:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_shichisei_tenshin:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_shichisei_tenshin:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_shichisei_tenshin:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_shichisei_tenshin:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_shichisei_tenshin:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_shichisei_tenshin:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_shichisei_tenshin:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: R (Ultimate Form)(Hyakuretsu Ken)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_hyakuretsu_ken", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_hyakuretsu_ken = kenshiro_hyakuretsu_ken or class({})

function kenshiro_hyakuretsu_ken:GetAbilityTextureName()
     return ""
end
function kenshiro_hyakuretsu_ken:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_hiei_ganzan", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
modifier_kenshiro_hyakuretsu_ken = modifier_kenshiro_hyakuretsu_ken or class ({})

function modifier_kenshiro_hyakuretsu_ken:IsHidden() return false end
function modifier_kenshiro_hyakuretsu_ken:IsPurgeable() return false end
function modifier_kenshiro_hyakuretsu_ken:IsPurgeException() return false end
function modifier_kenshiro_hyakuretsu_ken:RemoveOnDeath() return true end
function modifier_kenshiro_hyakuretsu_ken:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function modifier_kenshiro_hyakuretsu_ken:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                  }

    return funcs
end
function modifier_kenshiro_hyakuretsu_ken:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_kenshiro_hyakuretsu_ken:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.fDistance    = 1000
        self.fTravelTime  = 2.0
        self.fUnitsPerSec = self.fDistance / self.fTravelTime
        
        self.vChargeDirection = IsNotNull(self.ability) 
                                and self.ability:GetCursorPosition()
                                or self.parent:GetForwardVector() * self.fDistance
        
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_kenshiro_hyakuretsu_ken:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if not IsNotNull(me) or self.fDistance <= 0 then
            self:Destroy()
            return
        end
        
        if me:IsStunned() then return end
        
        self:Charge(me, dt)
    end
end
function modifier_kenshiro_hyakuretsu_ken:Charge(me, dt)
    if not self.vChargeDirection then
        self.vChargeDirection = Vector(0, 0, 0)
    end
    
    local vOrigin     = me:GetOrigin()
    local vChargeDir  = GetDirection(self.vChargeDirection, vOrigin)
    local fSpeed      = self.fUnitsPerSec * dt
    
    local vNextPos    = vOrigin + vChargeDir * fSpeed            
    
    me:SetOrigin(vNextPos)
    me:FaceTowards(self.vChargeDirection)
    
    self.fDistance = self.fDistance - fSpeed
end
function modifier_kenshiro_hyakuretsu_ken:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_kenshiro_hyakuretsu_ken:OnDestroy()
    if IsServer() then

    end
end


---------------------------------------------------------------------------------------------------------------
-- Kenshiro Style Change Abilities
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: Q (Style Switch)(Shin - Nanto Koshu Ken)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_shin", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_shin = kenshiro_shin or class({})

function kenshiro_shin:GetAbilityTextureName()
     return ""
end
function kenshiro_shin:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_shin", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: W (Style Switch)(Toki - Ju no Ken:Hokuto Ujo Hagan Ken)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_toki", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_toki = kenshiro_toki or class({})

function kenshiro_toki:GetAbilityTextureName()
     return ""
end
function kenshiro_toki:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_toki", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: E (Style Switch)(Rei - Hisho Hakurei)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_rei", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_rei = kenshiro_rei or class({})

function kenshiro_rei:GetAbilityTextureName()
     return ""
end
function kenshiro_rei:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_rei", { duration = 5.0 })
end

---------------------------------------------------------------------------------------------------------------
-- Kenshiro: R (Style Switch)(Raoh - TENSHO HONRETSU)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_kenshiro_raoh", "heroes/kenshiro/kenshiro.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

kenshiro_raoh = kenshiro_raoh or class({})

function kenshiro_raoh:GetAbilityTextureName()
     return ""
end
function kenshiro_raoh:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 5.0
    
    hCaster:AddNewModifier(hCaster, self, "modifier_kenshiro_raoh", { duration = 5.0 })
end

