
local GOJO_STAGE_STARTING  = 1
local GOJO_STAGE_ASCENDING = 2
local GOJO_STAGE_PRE_EXPLO = 3
local GOJO_STAGE_EXPLODING = 4

local tGOJO_HOLLOW_NUKE_ANIMS = {
                                    --1
                                    ACT_DOTA_CAST_GHOST_SHIP,
                                    --2
                                    ACT_DOTA_CAST_GHOST_WALK,
                                    --3
                                    ACT_DOTA_CAST_GHOST_WALK_ORB,
                                }
                                
---------------------------------------------------------------------------------------------------------------
-- Gojo Hollow Nuke (Spell)
---------------------------------------------------------------------------------------------------------------
gojo_hollow_nuke = gojo_hollow_nuke or class({})

function gojo_hollow_nuke:GetAOERadius()
    return 10000
end
function gojo_hollow_nuke:OnSpellStart()
    local hCaster = self:GetCaster()
                           
    hCaster:AddNewModifier(hCaster, self, "modifier_gojo_hollow_nuke", { duration = 24.5 })
end


---------------------------------------------------------------------------------------------------------------
-- Gojo Hollow Nuke (Modifier)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_gojo_hollow_nuke", "heroes/gojo/gojo_hollow_nuke.lua", LUA_MODIFIER_MOTION_NONE)

modifier_gojo_hollow_nuke = modifier_gojo_hollow_nuke or class({})

function modifier_gojo_hollow_nuke:IsHidden() return false end
function modifier_gojo_hollow_nuke:IsPurgeable() return false end
function modifier_gojo_hollow_nuke:IsPurgeException() return false end
function modifier_gojo_hollow_nuke:RemoveOnDeath() return true end
function modifier_gojo_hollow_nuke:CheckState()
    local func = {
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_ROOTED] = true,
                    [MODIFIER_STATE_DISARMED] = true,
                    [MODIFIER_STATE_SILENCED] = true,
                    [MODIFIER_STATE_MUTED] = true,
                    [MODIFIER_STATE_INVULNERABLE] = true,
                    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                 }
    if self.bIsFrozen then
        func[MODIFIER_STATE_FROZEN] = true
    end
    return func
end
function modifier_gojo_hollow_nuke:OnCreated(hTable)
    if IsServer() then
       self.caster  = self:GetCaster()
       self.parent  = self:GetParent()
       self.ability = self:GetAbility()
       
       self.fDistance        = 345 --445
       self.fDistanceBlue    = 625 - 155 -- Blue Ball spawns with 155 height
       
       self.fFPS             = 30
       self.fRedBallTime     = 75 / self.fFPS
       self.fTravelDelay     = 8.7
       self.fReachHeightTime = 14.0
       self.fHollowNukeComb  = 16.2 -- Starts combine at 15.1, balls touch at ~16.2, combines at ~16.6
       self.fHollowNukeEXP   = 17.8
       
       self.fTravelTime      = self.fReachHeightTime - self.fTravelDelay
       self.fUnitsPerSec     = self.fDistance / self.fTravelTime
       self.fUnitsPerSecBlue = self.fDistanceBlue / self.fTravelTime
       
       self.fFirstAnimDur    = 122 / self.fFPS - ( 3 * FrameTime() )
       self.fThirdAnimDur    = 50 / self.fFPS
       
       self.bIsFrozen        = self.bIsFrozen or false
       self.nHollowNukeSTAGE = self.nHollowNukeSTAGE or GOJO_STAGE_STARTING
        
        if IsNotNull(self.parent)
            and not self.iHollowNukeEffect then
            
            self.parent:StartGesture(self:GetAnimation(1))
            
            EmitGlobalSound("Gojo.hollow_nuke")

            self.iHollowNukeEffect =  ParticleManager:CreateParticle("particles/test/custom/hollow_purple_nuke_v2.vpcf", PATTACH_WORLDORIGIN, nil)
                                      --ParticleManager:SetParticleControl(self.iHollowNukeEffect, 0, self.parent:GetOrigin()) -- Set Main Point Initial Origin
                                      ParticleManager:SetParticleControlTransform(self.iHollowNukeEffect, 0, self.parent:GetOrigin(), self.parent:GetAngles()) -- Use This Instead (Origin + Angles)
                                      ParticleManager:SetParticleControl(self.iHollowNukeEffect, 2, Vector(2000, 0, 0 )) -- Set Movement Max Velocity
                                      ParticleManager:SetParticleControl(self.iHollowNukeEffect, 60, self.parent:GetOrigin()) -- Set Initial Blue Ball Origin
                                      ParticleManager:SetParticleControl(self.iHollowNukeEffect, 22, Vector(0, self.fRedBallTime - 0.2, 0)) -- Red Ball Spawn Timer
                                      ParticleManager:SetParticleControl(self.iHollowNukeEffect, 23, Vector(0, self.fRedBallTime - 0.3, 0)) -- Red Ball Spawn Timer Glow
        end
        
        self.__fElapsedTime = self.__fElapsedTime or 0
        
        print(self.__fElapsedTime)
        
        self:StartIntervalThink(FrameTime())
    end
end
function modifier_gojo_hollow_nuke:OnIntervalThink()
    local me = self.parent
    local dt = FrameTime()

    if not IsNotNull(me) or not me:IsAlive() or not self.iHollowNukeEffect then
        return self:Destroy()
    end
    
    self.__fElapsedTime = self.__fElapsedTime + dt
    
    --========================--
    self:StagesThinking()
    self:BallsThinking(me, dt)
    --========================--
    
    -- Gojo starts going up after delay
    if self.__fElapsedTime < self.fTravelDelay then
        --self.parent:InterruptMotionControllers(true)
        return
    end
    
    local vCurPos = me:GetOrigin()
    local vGround = GetGroundPosition(vCurPos, me)
    local vNewPos = self.fUnitsPerSec * dt
    local vSetPos = vCurPos.z >= vGround.z + self.fDistance
                    and vCurPos
                    or vCurPos + Vector(0, 0, vNewPos)
                    
    me:SetOrigin(vSetPos)
    --print("HUH")
end
function modifier_gojo_hollow_nuke:StagesThinking()
    -- First Stage of Hollow Nuke
    if self:GetStage() == GOJO_STAGE_STARTING then
        if self.__fElapsedTime >= self.fFirstAnimDur
            and not self.bSetAnim2 then
            self.parent:RemoveGesture(self:GetAnimation(1))
            self.parent:StartGesture(self:GetAnimation(2))
            
            self:SetStage(GOJO_STAGE_ASCENDING)
            
            self.bSetAnim2 = true
        end
    end
    
    -- Second Stage of Hollow Nuke
    if self:GetStage() == GOJO_STAGE_ASCENDING then
        if self.__fElapsedTime >= self.fReachHeightTime 
            and not self.bSetAnim3 then
            Timers:CreateTimer(FrameTime() * 3, function()
                self.parent:RemoveGesture(self:GetAnimation(2))
            end)
            self.parent:StartGesture(self:GetAnimation(3))
            ParticleManager:SetParticleControl(self.iHollowNukeEffect, 2, Vector(800, 0, 0 ))
            self.bSetAnim3 = true
        end
        
        if self.__fElapsedTime >= self.fReachHeightTime + self.fThirdAnimDur then
            self:SetStage(GOJO_STAGE_PRE_EXPLO)
            self:SetFrozen(true)
        end
    end
    
    -- Third Stage of Hollow Nuke
    if self:GetStage() == GOJO_STAGE_PRE_EXPLO then
        if self.__fElapsedTime < self.fHollowNukeComb then
            return
        end
        
        local iHollowNukeEffectBefore = self.iHollowNukeEffect
        
        Timers:CreateTimer(0.4, function()
            ParticleManager:DestroyParticle(iHollowNukeEffectBefore, false)
            ParticleManager:ReleaseParticleIndex(iHollowNukeEffectBefore)
        end)  
        
        -- NOTE: All effects with PATTACH_WORLDORIGIN + No Cull Radius (Base Properties) = visible globally !
        self.iHollowNukeEffect =  ParticleManager:CreateParticle("particles/test/custom/hollow_purple_nuke_combine_main2.vpcf", PATTACH_WORLDORIGIN, nil)
                                  ParticleManager:SetParticleControlTransform(self.iHollowNukeEffect, 0, self.parent:GetOrigin(), self.parent:GetAngles())
        self:SetStage(GOJO_STAGE_EXPLODING)
        --self:SetFrozen(true)
    end
    
    -- Fourth Stage of Hollow Nuke
    if self:GetStage() == GOJO_STAGE_EXPLODING then
        if self.__fElapsedTime >= self.fHollowNukeEXP
            and not self.bExploded then
            self:Explode()
        end
    end
end
function modifier_gojo_hollow_nuke:BallsThinking(me, dt)
    -- Red and Blue effect destroyed, don't set CP and return
    if self.__fElapsedTime > self.fHollowNukeComb then
        return
    end

    local vCurPos = me:GetOrigin()
    local vGround = GetGroundPosition(vCurPos, me)
    
    self.vAbstractBluePos = self.vAbstractBluePos or vCurPos
    
    if self.__fElapsedTime > self.fTravelDelay then
        local vNewPos = self.fUnitsPerSecBlue * dt
        local vSetPos = self.vAbstractBluePos.z >= vGround.z + self.fDistanceBlue
                        and self.vAbstractBluePos
                        or self.vAbstractBluePos + Vector(0, 0, vNewPos)
                        
        self.vAbstractBluePos = vSetPos
    end
    
    -- Move Main Origin
    ParticleManager:SetParticleControlTransform(self.iHollowNukeEffect, 0, vGround, self.parent:GetAngles())
    -- Move Blue Ball Origin
    ParticleManager:SetParticleControl(self.iHollowNukeEffect, 60, self.vAbstractBluePos)
    
    print("HUHHHHHH????")
end
function modifier_gojo_hollow_nuke:SetFrozen(bIsFrozen)
    self.bIsFrozen = bIsFrozen
end
function modifier_gojo_hollow_nuke:SetStage(nGojoStage)
    self.nHollowNukeSTAGE = nGojoStage or ( self:GetStage() + 1 )
end
function modifier_gojo_hollow_nuke:GetStage()
    return self.nHollowNukeSTAGE
end
function modifier_gojo_hollow_nuke:GetAnimation(nAnimation)
    return tGOJO_HOLLOW_NUKE_ANIMS[nAnimation]
end
function modifier_gojo_hollow_nuke:Explode()
    local vCasterPos     = self.parent:GetAbsOrigin()
    local nHollowNukeFX  = ParticleManager:CreateParticle("particles/test/custom/hollow_purple_nuke_explosion_lightning.vpcf", PATTACH_WORLDORIGIN, nil)
                           ParticleManager:SetParticleControl(nHollowNukeFX, 0, vCasterPos)
    local fHollowNukeDur   = 4.0
    local fHollowNukeTimer = GameRules:GetGameTime() + fHollowNukeDur
    local iHollowNukeTicks = 20
    local fHollowNukeInt   = fHollowNukeDur / iHollowNukeTicks
    
    Timers:CreateTimer(0, function()
        if GameRules:GetGameTime() > fHollowNukeTimer or not IsNotNull(self.parent) then
            ParticleManager:DestroyParticle(nHollowNukeFX, false)
            ParticleManager:ReleaseParticleIndex(nHollowNukeFX)
            return nil
        end
    
        local hEnemies = FindUnitsInRadius( self.parent:GetTeamNumber(),  -- int, your team number
                                            vCasterPos,  -- point, center point
                                            nil,  -- handle, cacheUnit. (not known)
                                            FIND_UNITS_EVERYWHERE,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY,  -- int, team filter
                                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  -- int, type filter
                                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  -- int, flag filter
                                            FIND_ANY_ORDER,  -- int, order filter
                                            false  -- bool, can grow cache
                                         )
                                        
        --==============================--
        table.insert(hEnemies, self.parent)
        --==============================--
        
        for _, hEnemy in pairs(hEnemies) do
            if IsNotNull(hEnemy) then
                local fEnemyDMG = (hEnemy:GetMaxHealth() * 0.8) / iHollowNukeTicks
                local iDMGFLAG  = hEnemy == self.parent and (DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + 
                                                             DOTA_DAMAGE_FLAG_NON_LETHAL) or DOTA_DAMAGE_FLAG_NONE
                
                ApplyDamage({
                    victim          = hEnemy,
                    damage          = fEnemyDMG,
                    damage_type     = DAMAGE_TYPE_PURE,
                    damage_flags    = bit.bor(iDMGFLAG, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION),
                    attacker        = self.parent,
                    ability         = self.ability
                })
            end
        end
        
        return fHollowNukeInt
    end)
    
    self.bExploded = true
end
function modifier_gojo_hollow_nuke:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_gojo_hollow_nuke:OnDestroy()
    if IsServer() then
        StopGlobalSound("Gojo.hollow_nuke")
        ParticleManager:DestroyParticle(self.iHollowNukeEffect, true)
        ParticleManager:ReleaseParticleIndex(self.iHollowNukeEffect) 
    end
end
