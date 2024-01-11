
LinkLuaModifier("modifier_gojo_projectile_thinker", "heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gojo_projectile_thinker_aura", "heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
modifier_gojo_projectile_thinker = modifier_gojo_projectile_thinker or class({})

-- States for Blue Orb Logic
local STATE_IS_IDLING    = 1
local STATE_IS_MOVING    = 2
local STATE_IS_ROTATING  = 3
local STATE_IS_EXPLODING = 4

local __hGojoProjectiles = {}
--=============================--
local hTABLE_ABILITIES1 = {
                              "goju_red_orb",
                              "goju_blue_orb",
                              "goju_infinite_void",
                              "goju_red_explosion",
                              "goju_domain_expansion",
                              "goju_hollow_purple",  
                          }
--=============================--
local hTABLE_ABILITIES2 = {
                              ["1"] = "goju_kick1",
                              ["2"] = "goju_kick2",
                              ["4"] = "goju_kick3",
                              ["6"] = "goju_kick4",
                          }
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Get Ground Position with an Offset
local GetGroundPosWithOffset = function(hCaster, fForwardVectorOffset, fHeightOffset)
    if IsServer()
        and IsNotNull(hCaster) then
        local vSpawnL  = hCaster:GetAbsOrigin()
        fForwardVectorOffset = fForwardVectorOffset or 0
        fHeightOffset  = fHeightOffset or 0
        vSpawnL        = vSpawnL + hCaster:GetForwardVector() * fForwardVectorOffset
        vSpawnL        = GetGroundPosition(vSpawnL, hCaster)
        vSpawnL.z      = vSpawnL.z + fHeightOffset
    
        return vSpawnL 
    end
    return nil    
end
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Function for swapping Goju's Blue Orb and Redirect Ability
local Goju_Swap_Blue = function(hCaster, hMainAbility, hSubAbility)
    if IsServer() and hCaster then
	    if hMainAbility and (not hMainAbility:IsNull()) and (not hSubAbility:IsNull()) then
		    -- Check if main ability is hidden
		    local bIsActive = hMainAbility:IsActivated()
            -- For Domain Expansion check
            hMainAbility.hModifier = nil

		    hCaster:SwapAbilities(
			                       hMainAbility:GetAbilityName(),
			                       hSubAbility:GetAbilityName(),
			                       bIsActive,
			                       false
		                         )
	    end
	    hCaster:RemoveAbilityByHandle( hSubAbility )
    end
end
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
function modifier_gojo_projectile_thinker:CheckState()
    local func = {
                   [MODIFIER_STATE_INVULNERABLE] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                 }
    return func
end
function modifier_gojo_projectile_thinker:OnCreated(hTable)
    if IsServer() then
        -- DATA for Dummy Projectile
        
        -- Get the modifier thinker parent
        self.parent = self:GetParent()
        
        -- Get the caster of this modifier, basically our player
        self.caster = self:GetCaster()
        
        -- Store game time on creation for comparison
        self.fGameTime = GameRules:GetGameTime()
        
        -- Final destination for dummy projectile
        self.Target = nil
        
        -- Movement speed at which projectile is moving
        self.iMoveSpeed = hTable.iMoveSpeed
        
        -- How long until the projectile expires, 0 = does not expire
        --self.flExpireTime = hTable.flExpireTime
        
        -- Distance the projectile will travel
        self.fDistance = hTable.fDistance
        
        -- Effect for the dummy projectile, should simply be Movement Locked to Control Point in partcile manager
        self.EffectName = hTable.EffectName
        
        -- Set ability to make sure we can pull information from it such as GetSpecialValueFor
        self.Ability = self.caster:GetAbilityByIndex(hTable.Ability)
        
        -- Set the player who cast the projectile so we can use it when doing damage for example
        self.Source = EntIndexToHScript(hTable.Source)
        
        -- Should the projectile provide vision ?
        self.bProvidesVis = hTable.bProvidesVis
        
        -- The radius of vision the projectile should provide
        self.iVisionRad = hTable.iVisionRad
        
        -- The team it should provide vision for
        self.iVisionTeam = hTable.iVisionTeam
        
        -- Launch delay before the projectile starts moving or doing damage
        self.fLaunchDelay = hTable.fLaunchDelay
        
        -- Should the projectile hit the target multiple times or just once ?
        self.bHitMultiple = hTable.bHitMultiple > 0
        
        -- Damage our projectile should do
        self.fProjDamage = hTable.fProjDamage
        
        -- Destroy when reached desired location ?
        self.bDestroy = hTable.bDestroy > 0
        
        -- Radius of the projectile
        self.fRadius = hTable.fRadius
        
        -- Store frame time
        self.fFrameTime = FrameTime()
        
        -- Create the Particle Effect
        self.iParticle = ParticleManager:CreateParticle(self.EffectName, PATTACH_ABSORIGIN_FOLLOW, self.parent)
        self:AddParticle(self.iParticle, false, false, -1, false, false)
        
        -- Stuff for Blue Orb logic
        self.bIsBlueOrb = hTable.bIsBlueOrb > 0
        --self.hBlueOrbTargets = self.hBlueOrbTargets or {}
        self.iBlueOrbTargetsCopy = self.iBlueOrbTargetsCopy or 0
        self.iBlueOrbTargets = self.iBlueOrbTargets or 0
        self.iBlueCurrentState = 0
        self.angle = self.angle or 0
        self.bBlueRotateOnce = false
        self.bIsExploding = false
        self.fExplosionTimer = self.fExplosionTimer or 0
        self.hSubAbility = self.hSubAbility or nil
        self.bIsRedirected = false
        
        -- Red Orb Bool
        self.bIsRedOrb = hTable.bIsRedOrb > 0
        
        -- Only Blue Projectiles for distance detection
        if self.bIsBlueOrb
            and self.parent 
            and IsNotNull(self.parent)
            and not self.parent:IsRealHero() then
            table.insert(__hGojoProjectiles, self.parent)    
        end
        
        if self.bIsBlueOrb and self.bIsRedOrb then self:Destroy() print("Dev is noob") return end
        
        self.hKnockBackTable = {
                                    should_stun        = 1,
                                    knockback_duration = 1,
                                    duration           = 1,
                                    knockback_distance = 200,
                                    knockback_height   = 200,
                                    center_x           = nil,
                                    center_y           = nil,
                                    center_z           = nil
                               }
        
        self:StartIntervalThink(0.01) -- Frame Time is too slow and makes the movement laggy
    end
end
function modifier_gojo_projectile_thinker:OnIntervalThink()
    if IsServer() then
        --print("Hollow Purple Damage: " .. self.fProjDamage)
        --print("Hollow Purple Launch Delay: " .. self.fLaunchDelay)
        --print("Blue Orb State: " .. self.iBlueCurrentState)
        --print("Blue Orb Angle: " .. self.angle)
        --print("Team Number: " .. self.parent:GetTeamNumber())
        --print("Class Name: " .. self.parent:GetClassname())
        -- Handle Projectile Launch Delay
        if self.fLaunchDelay > 0 
            and GameRules:GetGameTime() < self.fGameTime + self.fLaunchDelay then
            local vSpawnL  = GetGroundPosWithOffset(self.caster, 300, 120)
            
            self.parent:SetOrigin(vSpawnL)
        else
            -- Handle Pre Explosion Logic
            if self:BlueIsExploding() then
                if self.fExplosionTimer <= 0 then
                    self.fExplosionTimer = self.iBlueOrbTargetsCopy >= 2
                                           and 1.9
                                           or 0.4
                    self.fExplosionTimer2 = GameRules:GetGameTime() + self.fExplosionTimer
                    if self.fExplosionTimer >= 1.5 then 
                        self.iExplosionParticle = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/blue/blue_purple_combined_main.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                        self:AddParticle(self.iExplosionParticle, false, false, -1, false, false)
                        EmitSoundOn("Gojo.purple_full", self.parent) 
                    end
                    return
                else
                    if GameRules:GetGameTime() < self.fExplosionTimer2 then
                        return
                    end
                end
            end
            
            -- Handle Movement and Radius/Damage Logic
            local tMoveValues = self:MoveAndCalculateStats()

            --self.hBlueOrbTargets = {}
            self.iBlueOrbTargetsCopy = self.iBlueOrbTargets
            self.iBlueOrbTargets = 0
        
            -- Handle Red Orb Logic
            -- TEST HMMMMMM.....
            if self.bIsRedOrb then
                for iKey, hTarget in pairs(__hGojoProjectiles) do
                    if IsNotNull(hTarget)
                        and hTarget ~= self.parent
                        and not hTarget:IsRealHero()
                        and hTarget:HasModifier("modifier_gojo_projectile_thinker") 
                        and GetDistance(hTarget, self.parent) <= tMoveValues.fRadiusCopy then
                        local hModifier = hTarget:FindModifierByName("modifier_gojo_projectile_thinker")
                        
                        hModifier.iBlueCurrentState = STATE_IS_EXPLODING
                        hModifier.bIsExploding = true
                        self:StartIntervalThink(-1) 
                        self:Destroy()
                        return
                        --table.insert(enemies, hTarget)
                    end
                end
            end
            
            -- Handle Projectile Damage
            local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(),  -- int, your team number
                                               self.parent:GetOrigin(),  -- point, center point
                                               nil,  -- handle, cacheUnit. (not known)
                                               tMoveValues.fRadiusCopy,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                               DOTA_UNIT_TARGET_TEAM_ENEMY,  -- int, team filter
                                               DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  -- int, type filter
                                               0,  -- int, flag filter
                                               FIND_ANY_ORDER,  -- int, order filter
                                               false  -- bool, can grow cache
                                            )
            
            for _, hTarget in pairs(enemies) do
                if IsNotNull(hTarget) then
                    local damage = {
                                     victim = hTarget,
                                     attacker = self.Source,
                                     damage = tMoveValues.fDamageCopy,
                                     damage_type = self.Ability:GetAbilityDamageType(),
                                     ability = self.Ability
                                   }
    
                    ApplyDamage(damage)
                    
                    
                    if self:BlueIsExploding() then
                        self.hKnockBackTable.center_x = tMoveValues.vCurPos.x
                        self.hKnockBackTable.center_y = tMoveValues.vCurPos.y
                        self.hKnockBackTable.center_z = tMoveValues.vCurPos.z                    
                        hTarget:AddNewModifier(self.parent, self.Ability, "modifier_knockback", self.hKnockBackTable, hTarget:IsOpposingTeam(self.parent:GetTeamNumber()))                        
                    end 
                     
                    --hTarget:AddNewModifier(self.caster, self.Ability, "modifier_stunned", {duration = 0.01})                    
                    
                    --if not hTarget:IsCurrentlyHorizontalMotionControlled()
                    --if not hTarget:IsCurrentlyVerticalMotionControlled() then
                        --hTarget:SetOrigin(self.parent:GetOrigin())
                    --hTarget:AddNewModifier(self.caster, self.Ability, "modifier_phased", { duration = 0.1 })
                    self:ApplyMotionModifier(hTarget, tMoveValues)
                            --hTarget:SetOrigin(GetGroundPosition(vCurPos, self.parent))
                        --FindClearSpaceForUnit(hTarget, vCurPos, true)
                    --end
                    
                    if self.bIsBlueOrb then
                        --table.insert(self.hBlueOrbTargets, hTarget)
                        --self.hBlueOrbTargets[hTarget:entindex()] = 1
                        self.iBlueOrbTargets = self.iBlueOrbTargets + 1
                    end  
                end
            end
            
            -- Handle Explosion Logic Final
            if self:BlueIsExploding() then
                local iExplosion = ParticleManager:CreateParticle("particles/darkness_parade_explosion.vpcf", PATTACH_WORLDORIGIN, self.caster)
                ParticleManager:SetParticleControl(iExplosion, 0, self.parent:GetOrigin()) 
                self:AddParticle(iExplosion, false, false, -1, false, false)
                
                if self.fExplosionTimer < 1.5 then
                    EmitSoundOn("Gojo.purple_snap", self.parent)
                end                
                       
                self:StartIntervalThink(-1) 
                self:Destroy()
                return
            end
            
            -- Handle Blue Orb Logic
            self:OnBlueOrbLogic(tMoveValues.vCurPos, tMoveValues.vNextPos)
                        
        end
    end
end
function modifier_gojo_projectile_thinker:OnBlueOrbLogic(vCurPos, vNextPos)
    -- Handle Blue Orb Logic
    if self.bIsBlueOrb
        and self.iBlueCurrentState ~= STATE_IS_EXPLODING
        or not self.bIsExploding then
        
        -- Blue Orb Rotation Engagement Logic
        if not self.bBlueRotateOnce
            and self.iBlueOrbTargets > 0 then
            self.iBlueCurrentState = STATE_IS_ROTATING
            self.bBlueRotateOnce = true
        elseif self.bBlueRotateOnce
            and self.iBlueCurrentState == STATE_IS_MOVING
            and self.iBlueOrbTargets > self.iBlueOrbTargetsCopy then
            self.iBlueCurrentState = STATE_IS_ROTATING
        end

        -- Blue Orb Idle Logic
        if self.iBlueCurrentState == STATE_IS_IDLING then
            self.Target = vCurPos
            if not self.fIdleExpireTimer then
                self.fIdleExpireTimer = self.iBlueOrbTargets <= 0
                                        and GameRules:GetGameTime() + 3.0
                                        or GameRules:GetGameTime() + 1.0
            end
            if self.fIdleExpireTimer then
                if GameRules:GetGameTime() > self.fIdleExpireTimer then self:Destroy() return end
            end
        else
            self.fIdleExpireTimer = nil
        end
            
        -- Blue Orb Redirection Logic
        if self.iBlueCurrentState == STATE_IS_MOVING then
            if self.angle > 0 then self.angle = 0 end
            if vNextPos == vCurPos then self.iBlueCurrentState = STATE_IS_IDLING end
        end
            
        -- Blue Orb Rotation Logic
        if self.iBlueCurrentState == STATE_IS_ROTATING then
            -- Handle Circular Motion
            local center = self.parent:GetOrigin()  -- Center of rotation
            local radius = 300  -- Adjust the radius as needed
            local speed = 45  -- Adjust the speed of rotation
            local deltaAngle = 1  -- Adjust the increment for a smoother rotation
         
            -- Calculate new position in polar coordinates
            self.angle = self.angle + deltaAngle * speed * FrameTime()
                    
            -- Check if a full revolution has occurred
            if self.angle >= 360 then
                self.iBlueCurrentState = STATE_IS_IDLING
                self.angle = 0
                print("Blue Orb Full Revolution")
            end
                    
            local radians = math.rad(self.angle % 360)
            local x = center.x + radius * math.cos(radians)
            local y = center.y + radius * math.sin(radians)
            --local offset = Vector(radius, 0, 0):Rotated(Vector(0, 0, 1), radians)
            --local rotatedPosition = center + offset
      
            -- Set the new position
            self.Target = Vector(x, y, center.z) --rotatedPosition
        end
    else
        -- Blue Orb Explosion Logic
        self.Target = vCurPos
        self.bIsExploding = true
    end        
end
function modifier_gojo_projectile_thinker:ApplyMotionModifier(hTarget, tMoveValues)
    if not self.bIsExploding and (self.bIsBlueOrb or self.bIsRedOrb) then
        if not hTarget:HasModifier("modifier_gojo_projectile_thinker_aura") then
            local hModifier = hTarget:AddNewModifier(self.caster, self.Ability, "modifier_gojo_projectile_thinker_aura", { duration = 20.0 })
            if hModifier
                and IsNotNull(hModifier) then
                hTarget:SetOrigin(tMoveValues.vCurPos) -- Initiate first pull
                hModifier.caster = self.parent
                hModifier.parent = hTarget
                hModifier.fRadius = tMoveValues.fRadiusCopy
                hModifier.UpdateHorizontalMotion = function(hModifier, dt)
                    if hModifier.caster and not hModifier.caster:IsNull() and GetDistance(hModifier.parent, hModifier.caster) <= hModifier.fRadius then
                        local vCurPos = GetGroundPosition(hModifier.caster:GetOrigin(), hModifier.caster)
                        hModifier.parent:SetOrigin(vCurPos) 
                        print("TEST HMMMMM")
                    else
                        hModifier:Destroy()
                    end                                   
                end
            end
        end
    end
end
function modifier_gojo_projectile_thinker:MoveAndCalculateStats()
    if not self.Target then 
        self.Target = self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * self.fDistance 
    end
            
    local vCurPos     = GetGroundPosWithOffset(self.parent, 0, 120)
    local vDirection  = GetDirection(self.Target, vCurPos)
    local fDistance   = GetDistance(self.Target, vCurPos)
    local fUnitsPerDt = self.iMoveSpeed * 0.01
    local vNextPos    = vCurPos + vDirection * fUnitsPerDt
    vNextPos = fDistance <= 100
               and vCurPos
               or vNextPos
                  
    if vNextPos == vCurPos and self.bDestroy then 
        self:StartIntervalThink(-1) 
        self:Destroy() 
        return 
    elseif vNextPos == vCurPos and not self.bDestroy then
        if self.iBlueCurrentState == 0 then
            self.iBlueCurrentState = STATE_IS_IDLING
        end
    end
                  
    --if self.bDestroy and vNextPos == vCurPos then self:Destroy() end 
    self.parent:SetOrigin(vNextPos)
            
            
    local fRadiusCopy = self:BlueIsExploding()
                        and self.fRadius + 500
                        or self.fRadius
                                
    local fDamageCopy = self:BlueIsExploding()
                        and self.fProjDamage + 2000
                        or self.fProjDamage
                                
    fDamageCopy       = self.fExplosionTimer >= 1.5
                        and fDamageCopy * 2
                        or fDamageCopy
                        
    local tValues = {
                      vCurPos = vCurPos,
                      vNextPos = vNextPos,
                      fRadiusCopy = fRadiusCopy,
                      fDamageCopy = fDamageCopy,
                    }
                                
    return tValues
end
function modifier_gojo_projectile_thinker:BlueIsExploding()
    return self.iBlueCurrentState == STATE_IS_EXPLODING or self.bIsExploding
end
function modifier_gojo_projectile_thinker:OnDestroy()
    if IsServer() then
        if self.parent 
            and IsNotNull(self.parent) 
            and not self.parent:IsRealHero() then
            self:StartIntervalThink(-1)
            UTIL_Remove(self.parent)
        end
        if not self.bIsRedirected 
            and IsNotNull(self.hSubAbility) then
            Goju_Swap_Blue(self.caster, self.Ability, self.hSubAbility)
        end
    end
end
--[[function modifier_gojo_projectile_thinker:IsAura()
	return self.bIsBlueOrb or self.bIsRedOrb
end

function modifier_gojo_projectile_thinker:GetModifierAura()
	return "modifier_gojo_projectile_thinker_aura"
end

function modifier_gojo_projectile_thinker:GetAuraRadius()
	return self.fRadius
end

function modifier_gojo_projectile_thinker:GetAuraDuration()
	return 0.3
end

function modifier_gojo_projectile_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gojo_projectile_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_gojo_projectile_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end]]--
---------------------------------------------------------------------------------------------------------------

-- NOTE: This modifier is registered with a motion controller, so it should correct unit positioning after being removed.
modifier_gojo_projectile_thinker_aura = modifier_gojo_projectile_thinker_aura or class ({})
function modifier_gojo_projectile_thinker_aura:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_gojo_projectile_thinker_aura:CheckState()
    local func = {
                   [MODIFIER_STATE_STUNNED] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                 }
    return func
end
function modifier_gojo_projectile_thinker_aura:OnCreated()
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_gojo_projectile_thinker_aura:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end

---------------------------------------------------------------------------------------------------------------

local Goju_Create_Projectile = function(hSelf, hCaster, hTable)
    if IsServer() 
        and IsNotNull(hSelf) 
        and IsNotNull(hCaster) then
        
        hTable      = hTable or {}
        
        -- Table for storing all the default values
        local tValues = {
            --Target = nil,
            iMoveSpeed = 25,
            --flExpireTime = nil, -- Pointless just give duration to the modifier
            fDistance = 1000,
            EffectName = "",
            Ability = hSelf:GetAbilityIndex(),
            Source = nil,
            bProvidesVis = false,
            iVisionRad = 0,
            iVisionTeam = 0,
            fLaunchDelay = 0,
            bHitMultiple = false,
            fProjDamage = 0,
            bDestroy = false,
            bIsBlueOrb = false,
            fRadius = 25,
            bIsRedOrb = false,
            iAttachment = DOTA_PROJECTILE_ATTACH_ATTACK1,
        }
        
        --=============================================--
        for key, value in pairs(tValues) do
            hTable[key] = hTable[key] or value
        end
        --=============================================--
        
        -- Create a modifier thinker and use it as a dummy for the tracking projectile
        local vSpawnL  = GetGroundPosWithOffset(hCaster, 300, 120)
        local hTarget  = CreateModifierThinker(hCaster, 
                                               hSelf, 
                                               "modifier_gojo_projectile_thinker", 
                                               hTable,
                                               vSpawnL, 
                                               hCaster:GetTeamNumber(), 
                                               false)
        --[[local hProjectile = {
                              --vSourceLoc          = hCaster:GetAbsOrigin(),
                              --Target              = hTarget,
                              iMoveSpeed          = fLaunchDelay > 0 and 1 or 500,
                              flExpireTime        = GameRules:GetGameTime() + fLaunchDelay,
                              bDodgeable          = false,
                              bIsAttack           = false,
                              bReplaceExisting    = false,
                              --bIgnoreObstructions = false,
                              --bSupressTargetCheck = false, -- Idk this, haven't tested
                              iSourceAttachment   = DOTA_PROJECTILE_ATTACH_ATTACK1,
                              bDrawsOnMinimap     = false,
                              bVisibleToEnemies   = true,
                       
                              EffectName          = sEffect,
                              Ability             = bIsModifier and hSelf:GetAbility() or hSelf,
                              Source              = hCaster,
                              bProvidesVision     = true,
                              iVisionRadius       = 500,
                              iVisionTeamNumber   = hCaster:GetTeamNumber(),
                              --ExtraData           = {damage = nil}
                            }

        local iProjectile = ProjectileManager:CreateTrackingProjectile( hProjectile )
        
        --=========================================================================--
        if iProjectile and fLaunchDelay > 0 then
            Timers:CreateTimer(fLaunchDelay,function()
                if iProjectile then
                    local iNewProjectile = ProjectileManager:CreateTrackingProjectile( hProjectile )
                end
            end)            
        end
        --=========================================================================--]]--
        
        return hTarget
    end
end
-- Function for adding Gojo's Red Explosion effects, using all vector control points for maximum efficiency
local Goju_Create_Explosion = function(hSelf, hParent, bIsNotModifier)
    local iRed_Combined =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/red/red_combined.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
                           ParticleManager:SetParticleControl(iRed_Combined, 0, hParent:GetAbsOrigin()) -- Red Spiral positions
                           ----------IDEAL VALUES--------------------------------------(5.4, 5.6, 10.8)
                           ParticleManager:SetParticleControl(iRed_Combined, 22, Vector(5.6, 7.0, 10.6)) -- Start Times: X.Red Big Ball, Y.Ground Smoke + White Trails, Z.White Flash
                           ParticleManager:SetParticleControlEnt(  iRed_Combined,  -- Red Ball + Red Trails positions
                                                                   21,
                                                                   hParent,
                                                                   PATTACH_POINT_FOLLOW,
                                                                   "attach_attack2",
                                                                   Vector(0,0,0),
                                                                   true)
                                                                   
    return not bIsNotModifier and hSelf:AddParticle(iRed_Combined, false, false, -1, false, false) or iRed_Combined
end
-- Function for Gojo's Hollow Purple Activation effects
local Goju_Hollow_Purple_Activate = function(hSelf, hParent, bIsNotModifier)
    local iHollowPurple =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/hollow_purple/hollow_purple_main.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
                           ParticleManager:SetParticleControl(iHollowPurple, 0, hParent:GetAbsOrigin()) -- Main Attachment Point
                           ParticleManager:SetParticleControl(iHollowPurple, 21, Vector(4.0, 7.0, 0)) -- Rings Times
                           ParticleManager:SetParticleControl(iHollowPurple, 22, Vector(4.5, 7.5, 0)) -- Balls Times
                           ParticleManager:SetParticleControl(iHollowPurple, 23, Vector(4.4, 7.4, 0)) -- Glow Times
                           ParticleManager:SetParticleControl(iHollowPurple, 24, Vector(10.0, 12.8, 0)) -- Lightning + Shockwave Times
                           ParticleManager:SetParticleControl(iHollowPurple, 25, Vector(12.0, 0, 0)) -- Stop Balls Times
                                                                   
    return not bIsNotModifier and hSelf:AddParticle(iHollowPurple, false, false, -1, false, false) or iHollowPurple
end
-- Function for scaling the rate of an animation or something else.
-- EXAMPLE: Ability with 3.0 second channel time, if current channel is also 3.0 then 3.0 / 3.0 = 1.0 Animation Rate.
local GetScalingAnimationRate = function(fAnimeIdeal, fAnimeCurrent)
    local fAnimRateIdeal   = fAnimeIdeal
    local fAnimRateCurrent = fAnimeCurrent or fAnimeIdeal
    local fPlayBackRateSet = fAnimRateIdeal / fAnimRateCurrent
    
    return fPlayBackRateSet
end
-- Function for quickly destroying a particle effect after checking if it exists
local Destroy__Particle = function(iParticle)
    if iParticle then
        ParticleManager:DestroyParticle( iParticle, true )
        ParticleManager:ReleaseParticleIndex( iParticle ) 
        return true
    end
    return false
end

---------------------------------------------------------------------------------------------------------------
-- Goju Red Orb (Q)
---------------------------------------------------------------------------------------------------------------

goju_red_orb = goju_red_orb or class({})

function goju_red_orb:OnSpellStart()
    local hCaster = self:GetCaster()
    
    self:CreateRedOrb()
end
function goju_red_orb:CreateRedOrb()
    local hCaster      = self:GetCaster()
    local f__Radius    = 250
    local i__Speed     = 2000
    local f__Distance  = 2000
    
    local hExplosion =  {   
                          duration     = 7.0,
                          --Target       = nil,
                          iMoveSpeed   = i__Speed,
                          --flExpireTime = 0,
                          fDistance    = f__Distance,
                          EffectName   = "particles/heroes/anime_hero_gojo/red/red_orb_projectile_test.vpcf",
                          Ability      = self:GetAbilityIndex(),
                          Source       = hCaster:entindex(),
                          bProvidesVis = nil,
                          iVisionRad   = 0,
                          iVisionTeam  = 0,
                          fLaunchDelay = 0,
                          bHitMultiple = false,
                          fProjDamage  = 1,
                          bDestroy     = true,
                          bIsBlueOrb   = false,
                          fRadius      = 125,
                          bIsRedOrb    = true
                     	}
                        
    local hProjectile = Goju_Create_Projectile(self, hCaster, hExplosion)
    
    return hProjectile
end

---------------------------------------------------------------------------------------------------------------
-- Goju Blue Orb (W)
---------------------------------------------------------------------------------------------------------------

goju_blue_orb = goju_blue_orb or class({})

function goju_blue_orb:OnSpellStart()
    local hCaster = self:GetCaster()
    
    local hProjectile = self:CreateBlueOrb()
    
	local hModifier = hProjectile:FindModifierByName( "modifier_gojo_projectile_thinker" )

	if IsNotNull(hProjectile)
        and IsNotNull(hModifier) then
        -- Add redirect ability and swap
	    local hSubAbility = hCaster:AddAbility( "goju_blue_orb_redirect" )
	    if hSubAbility
            and IsNotNull(hSubAbility) then
            hSubAbility:SetLevel( 1 )
	        hCaster:SwapAbilities(
		                           self:GetAbilityName(),
		                           "goju_blue_orb_redirect",
		                           false,
		                           true
	                             )

	        -- Register Each Other
	        self.hModifier = hModifier
	        self.hSubAbility = hSubAbility
	        hSubAbility.hModifier = hModifier
            hSubAbility.hMainAbility = self
            hModifier.hSubAbility = hSubAbility
        end
    end
end
function goju_blue_orb:CreateBlueOrb()
    local hCaster      = self:GetCaster()
    local f__Radius    = 250
    local i__Speed     = 1000
    local f__Distance  = 2000
    
    local hExplosion =  {   
                          duration     = 11.0,
                          --Target       = nil,
                          iMoveSpeed   = i__Speed,
                          --flExpireTime = 0,
                          fDistance    = f__Distance,
                          EffectName   = "particles/heroes/anime_hero_gojo/blue/blue_projectile_test.vpcf",
                          Ability      = self:GetAbilityIndex(),
                          Source       = hCaster:entindex(),
                          bProvidesVis = nil,
                          iVisionRad   = 0,
                          iVisionTeam  = 0,
                          fLaunchDelay = 0,
                          bHitMultiple = true,
                          fProjDamage  = 1,
                          bDestroy     = false,
                          bIsBlueOrb   = true,
                          fRadius      = 125,
                          bIsRedOrb    = false
                     	}
                        
    local hProjectile = Goju_Create_Projectile(self, hCaster, hExplosion)
    
    return hProjectile
end
function goju_blue_orb:OnUnStolen()
	if self.hModifier and not self.hModifier:IsNull() then

		-- Reset Position
		self:GetCaster():SwapAbilities(
			                            self:GetAbilityName(),
			                            self.hSubAbility:GetAbilityName(),
			                            true,
			                            false
		                              )
	end
end

---------------------------------------------------------------------------------------------------------------
goju_blue_orb_redirect = goju_blue_orb_redirect or class({})

function goju_blue_orb_redirect:OnSpellStart()
	if self.hModifier and not self.hModifier:IsNull() then
		local hTarget  = self:GetCursorPosition()
        local hParent  = self.hModifier.parent
        local vDirection = (hTarget - hParent:GetOrigin()):Normalized()
        
        hParent:SetForwardVector(vDirection)
        self.hModifier.iBlueCurrentState = STATE_IS_MOVING
        self.hModifier.Target            = hParent:GetOrigin() + hParent:GetForwardVector() * 2000
        self.hModifier.bIsRedirected     = true
	end
    
	    
    Goju_Swap_Blue(self:GetCaster(), self.hMainAbility, self)
end

---------------------------------------------------------------------------------------------------------------
-- Goju Infinite Void (E)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_infinite_void","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_infinite_void = goju_infinite_void or class({})

function goju_infinite_void:OnSpellStart()
    local hCaster = self:GetCaster()
    
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_infinite_void", { duration = 5.0 })
end
---------------------------------------------------------------------------------------------------------------

modifier_goju_infinite_void = modifier_goju_infinite_void or class ({})

function modifier_goju_infinite_void:IsHidden() return false end
function modifier_goju_infinite_void:IsPurgeable() return false end
function modifier_goju_infinite_void:RemoveOnDeath() return true end
function modifier_goju_infinite_void:CheckState()
    local func = {
                   [MODIFIER_STATE_DEBUFF_IMMUNE] = true,
                 }
    return func
end
function modifier_goju_infinite_void:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_PROPERTY_DODGE_PROJECTILE,
                        MODIFIER_EVENT_ON_ORDER
                    }
    return tFunc
end
function modifier_goju_infinite_void:GetModifierDodgeProjectile()
    return 1
end
function modifier_goju_infinite_void:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_goju_infinite_void:OnOrder(keys)
    if keys.unit and keys.unit ~= self.parent and keys.unit:IsRealHero() and not keys.unit:IsBuilding() then
        local fDistance  = GetDistance(keys.unit, self.parent)
        local vDirection = GetDirection(keys.unit, self.parent)
        local vFacingDirection = self.parent:GetForwardVector():Normalized()
        
        if (keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE) 
            or (keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION)
            or (keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET )
            or (keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION )
            or (keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET ) 
            or (keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_DIRECTION ) then
            if fDistance <= 250 and vDirection:Dot(vFacingDirection) > 0 then
                keys.unit:Stop()
            end            
        end
    end
end
function modifier_goju_infinite_void:GetEffectName()
    return "particles/heroes/anime_hero_gojo/infinite_void/gojo_infinite_void_refract.vpcf"
end
function modifier_goju_infinite_void:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------------------------------------------------------------------
-- Goju Red Explosion (D)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_red_explosion_active","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_red_explosion = goju_red_explosion or class({})

function goju_red_explosion:OnSpellStart()
    local hCaster = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("duration")
    
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_red_explosion_active", { duration = fDuration })
end
function goju_red_explosion:OnProjectileThink(vLocation)
end
function goju_red_explosion:OnProjectileHit(hTarget, vLocation)
	if IsNotNull(self)
		and IsNotNull(hTarget) then
		local hCaster   = self:GetCaster()
		local fDamage   = self:GetSpecialValueFor("damage") or 500
        local fStrMult  = self:GetSpecialValueFor("str_mult") or 50.0
        local fStrength = hCaster:GetStrength()
        
        fStrMult = fStrength * fStrMult
        fDamage  = fDamage + fStrMult
        print("Gojo Explosion Damage: " .. fDamage)

        local hDamageTable =    {  
                                    victim 		 = hTarget,
                                    attacker 	 = hCaster,
                                    damage 		 = fDamage,
                                    damage_type  = self:GetAbilityDamageType(),
                                    ability 	 = self,
                             		damage_flags = 0
                                }
        
        ApplyDamage(hDamageTable)
    end
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_red_explosion_active = modifier_goju_red_explosion_active or class({})

function modifier_goju_red_explosion_active:IsHidden() return false end
function modifier_goju_red_explosion_active:IsPurgeable() return false end
function modifier_goju_red_explosion_active:RemoveOnDeath() return true end
function modifier_goju_red_explosion_active:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                    }
    return state
end
function modifier_goju_red_explosion_active:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                    }
    return func
end
function modifier_goju_red_explosion_active:GetOverrideAnimation(keys)
    return ACT_DOTA_CAST_ABILITY_1
end
function modifier_goju_red_explosion_active:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsClient() then
        Destroy__Particle(self.GojoRedEffect)
        self.GojoRedEffect = Goju_Create_Explosion(self, self.parent)
    else
        EmitGlobalSound("Gojo.red")
    end
end
function modifier_goju_red_explosion_active:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_red_explosion_active:OnDestroy()
    if not IsServer() then return end
    
    if not self.parent:IsAlive() then
        Destroy__Particle(self.GojoRedEffect)
        StopGlobalSound("Gojo.red")
    else
        local f__Distance  = self.ability:GetSpecialValueFor("distance") or 2500
        local f__Radius    = self.ability:GetSpecialValueFor("radius") or 500
        local i__Speed     = self.ability:GetSpecialValueFor("speeed") or 2500
        
        local hExplosion =  {   
	    					    Ability             = self.ability,
	                      	    EffectName          = "particles/heroes/anime_hero_gojo/red/red_projectile_main.vpcf",
	                     	    vSpawnOrigin        = self.parent:GetAbsOrigin(),
	                      	    fDistance           = f__Distance,
	                            fStartRadius        = f__Radius,
	                            fEndRadius          = f__Radius,
	                            Source              = self.parent,
	                            bHasFrontalCone     = false,
	                            bReplaceExisting    = false,
	                       	    iUnitTargetTeam     = self.ability:GetAbilityTargetTeam(),
	                       	    iUnitTargetFlags    = self.ability:GetAbilityTargetFlags(),
	                     	    iUnitTargetType     = self.ability:GetAbilityTargetType(),
	                   		    --fExpireTime         = GameRules:GetGameTime() + 30,
	                     	    --bDeleteOnHit        = false,
	                       	    vVelocity           = self.parent:GetForwardVector() * i__Speed,
	                      	    bProvidesVision     = true,
	                      	    iVisionRadius     	= f__Radius,
                          	    iVisionTeamNumber 	= self.parent:GetTeamNumber()
                          	    --ExtraData 			= {damage = 1000}
                     	    }

        local iProjectile = ProjectileManager:CreateLinearProjectile(hExplosion)
    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Expansion (F)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_domain_expansion","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_domain_expansion = goju_domain_expansion or class({})

function goju_domain_expansion:OnSpellStart()
    local hCaster = self:GetCaster()
    local fDuration = 8
    
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_expansion", { duration = fDuration })
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_domain_expansion = modifier_goju_domain_expansion or class({})

function modifier_goju_domain_expansion:IsHidden() return false end
function modifier_goju_domain_expansion:IsPurgeable() return false end
function modifier_goju_domain_expansion:RemoveOnDeath() return true end
function modifier_goju_domain_expansion:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                    }
    return not self.bIsActive and state
end
function modifier_goju_domain_expansion:DeclareFunctions()
    local func =    {
                       
                    }
    return func
end
function modifier_goju_domain_expansion:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    ----------------------------------------------------
    self.bIsActive = self.bIsActive or hTable.bIsActive
    self.bSwapped  = self.bSwapped or hTable.bSwapped
    ----------------------------------------------------
    
    if IsServer() and not self.bSwapped then
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        
        -- Check and make sure Blue Redirect ability is not in the way
        local hAbilityBlue = self.caster:FindAbilityByName(hTABLE_ABILITIES1[2])
        if IsNotNull(hAbilityBlue) then
            if hAbilityBlue.hModifier then
                hAbilityBlue.hModifier:Destroy()
            end
        end
        
        -- Replace Base Ability 1,2,4,6 with Ability 1,2,3,4 from second table
        for i, sAbility in ipairs(hTABLE_ABILITIES1) do
            if i ~= 3 and i~= 5 then
                local hAbility = self.parent:FindAbilityByName(sAbility)
                local sNewAbility = hTABLE_ABILITIES2[tostring(i)]
                if hAbility and sNewAbility then
                    self.parent:SwapAbilities(sAbility, sNewAbility, false, true)
                end
            end
        end
        
        self.bSwapped = true
    end
end
function modifier_goju_domain_expansion:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_domain_expansion:OnDestroy()
    if not IsServer() then return end
    
    -- Reapply modifier for duration
    if IsNotNull(self.parent)
        and self.parent:IsAlive()
        and not self.bIsActive
        and self.bSwapped then
        -- Maybe should use OnIntervalThink but do this instead because PEPEGA?????
        local hModifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_goju_domain_expansion", { duration = 50.0, bIsActive = 1, bSwapped = 1 })
        self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
        return
    end
    
    -- If abilities not swapped then just return
    if not self.bSwapped then return end
    
    -- Swap Abilities back to base
    for i, sAbility in ipairs(hTABLE_ABILITIES1) do
        if i ~= 3 and i~= 5 then
            local sKickAbility = hTABLE_ABILITIES2[tostring(i)]
            if sKickAbility then
                self.parent:SwapAbilities(sAbility, sKickAbility, true, false)
            end
        end
    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Hollow Purple (R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_hollow_purple_active","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_hollow_purple = goju_hollow_purple or class({})

function goju_hollow_purple:GetBehavior()
     return self:GetCaster():HasModifier("modifier_goju_hollow_purple_active") 
            and DOTA_ABILITY_BEHAVIOR_POINT
            or DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function goju_hollow_purple:GetCastPoint()
    return self:GetCaster():HasModifier("modifier_goju_hollow_purple_active")
           and 1.8
           or self.BaseClass.GetCastPoint(self)
end
function goju_hollow_purple:OnAbilityPhaseStart()
    if self:GetCaster():HasModifier("modifier_goju_hollow_purple_active") then
        self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
        self.hHollowPurple = self:CreateHollowPurple()                   
    end
    return true
end
function goju_hollow_purple:GetAbilityTextureName()
     return self:GetCaster():HasModifier("modifier_goju_hollow_purple_active") 
            and "gojo_hollow_purple_active"
            or self.BaseClass.GetAbilityTextureName(self)
end
function goju_hollow_purple:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = 15.0
    
    if not hCaster:HasModifier("modifier_goju_hollow_purple_active") then
        if self.hHollowPurple 
            and IsNotNull(self.hHollowPurple) then
            self.hHollowPurple:RemoveModifierByName("modifier_gojo_projectile_thinker")
        end
        hCaster:AddNewModifier(hCaster, self, "modifier_goju_hollow_purple_active", { duration = fDuration })
    else
        -- Do nothing
    end
end
function goju_hollow_purple:CreateHollowPurple()
    local hCaster      = self:GetCaster()
    local f__Radius    = 250
    local i__Speed     = 2500
    local f__Distance  = 5000
    
    local hExplosion =  {   
                          duration     = 20.0,
                          --Target       = nil,
                          iMoveSpeed   = i__Speed,
                          --flExpireTime = 0,
                          fDistance    = f__Distance,
                          EffectName   = "particles/heroes/anime_hero_gojo/hollow_purple/hollow_purple_projectile_main.vpcf",
                          Ability      = self:GetAbilityIndex(),
                          Source       = hCaster:entindex(),
                          bProvidesVis = nil,
                          iVisionRad   = 0,
                          iVisionTeam  = 0,
                          fLaunchDelay = self:GetCastPoint(),
                          bHitMultiple = false,
                          fProjDamage  = 500,
                          bDestroy     = true,
                          bIsBlueOrb   = false,
                          fRadius      = 200,
                          bIsRedOrb    = false
                     	}
                        
    local hProjectile = Goju_Create_Projectile(self, hCaster, hExplosion)
    
    return hProjectile
end
function goju_hollow_purple:OnAbilityPhaseInterrupted()
    self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
    if self.hHollowPurple 
        and IsNotNull(self.hHollowPurple) then
        self.hHollowPurple:RemoveModifierByName("modifier_gojo_projectile_thinker")
    end
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_hollow_purple_active = modifier_goju_hollow_purple_active or class({})

function modifier_goju_hollow_purple_active:IsHidden() return false end
function modifier_goju_hollow_purple_active:IsPurgeable() return false end
function modifier_goju_hollow_purple_active:RemoveOnDeath() return true end
function modifier_goju_hollow_purple_active:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                    }
    return not self.bIsActive and state
end
function modifier_goju_hollow_purple_active:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() and not self.bIsActive then
        Destroy__Particle(self.HollowPurpleEffect)
        self.HollowPurpleEffect = Goju_Hollow_Purple_Activate(self, self.parent)
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
        EmitGlobalSound("Gojo.purple_activate")
        Timers:CreateTimer(8, function()
            if IsNotNull(self.HollowPurpleEffect) then
                ParticleManager:SetParticleControl(self.HollowPurpleEffect, 2, Vector(15, 0, 0))
            end
        end)
        self.ability:EndCooldown()
        self:StartIntervalThink(14.8)
    else
    end
end
function modifier_goju_hollow_purple_active:OnIntervalThink()
    if not IsServer() then return end
    
    self.bIsActive = true
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_goju_hollow_purple_active", { duration = 50.0 })
    self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1_END)
    EmitGlobalSound("Gojo.purple_theme")
    self:StartIntervalThink(-1)
end
function modifier_goju_hollow_purple_active:StatusEffectPriority()
    return 999999
end
function modifier_goju_hollow_purple_active:GetStatusEffectName()
    return "particles/heroes/anime_hero_gojo/hollow_purple/hollow_purple_status_effect.vpcf"
end
function modifier_goju_hollow_purple_active:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_hollow_purple_active:OnDestroy()
end


---------------------------------------------------------------------------------------------------------------
-- Domain Expansion Abilities
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (Q)
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (W)
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (D)
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (R)
---------------------------------------------------------------------------------------------------------------
