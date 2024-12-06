
LinkLuaModifier("modifier_gojo_projectile_thinker", "heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gojo_projectile_thinker_aura", "heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
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
local GridNavPathIsTraversable = function(self, vPos, iPointsNotTraversable)
    if IsNotNull(self) 
        and IsNotNull(self.parent) then
        local hParent         = self.parent
        local vPosition       = vPos or hParent:GetOrigin()
        iPointsNotTraversable = iPointsNotTraversable or 10
        self.iPointsTraverse  = self.iPointsTraverse or 0
        
        local vLeft  = RotateVector2D(GetDirection(vPosition, hParent), 90, true)
        local vRight = -vLeft
        
        local fOffset = 500
        local vLeftCheck  = vPosition + (vLeft * fOffset)
        local vRightCheck = vPosition + (vRight * fOffset)
        
        local nTeamNumber = hParent:GetTeamNumber()

        -- Function to check a position
        local function IsPositionBlocked(vCheckPos)
            return not GridNav:IsTraversable(vCheckPos) or GridNav:IsBlocked(vCheckPos)
        end

        -- Check all three positions
        local bBlocked = IsPositionBlocked(vPosition) 
                      and IsPositionBlocked(vLeftCheck) 
                      and IsPositionBlocked(vRightCheck)
        
        if bBlocked then
            -- Prevent checking the same position repeatedly
            if self.__vTraversePosition ~= nil and self.__vTraversePosition == vPosition then return true end
            self.__vTraversePosition = vPosition
            self.iPointsTraverse = self.iPointsTraverse + 1
        else
            self.iPointsTraverse = 0
        end
        
        if self.iPointsTraverse >= iPointsNotTraversable then
            self.iPointsTraverse = 0
            return false
        end

        return true
    end
end
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
function modifier_gojo_projectile_thinker:CheckState()
    local func = {
                   [MODIFIER_STATE_INVULNERABLE] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                   [MODIFIER_STATE_PROVIDES_VISION] = self.bProvidesVis
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
        self.tAlreadyHit = self.tAlreadyHit or {}
        
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
                         ParticleManager:SetParticleShouldCheckFoW(self.iParticle, false)
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
            --table.insert(__hGojoProjectiles, self.parent)
            __hGojoProjectiles[tostring(self.parent:entindex())] = self.parent            
        end
        
        if self.bIsBlueOrb and self.bIsRedOrb then self:Destroy() print("Dev is noob") return end
        
        self.parent:SetHullRadius(self.fRadius)
        --self.parent:SetDayTimeVisionRange(700)
        --self.parent:SetNightTimeVisionRange(700)
        
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
                    local iExplosionReduce = self.caster:FindTalentValue("special_bonus_gojo_25_alt")
                    self.fExplosionTimer = self.iBlueOrbTargetsCopy >= self.Ability:GetSpecialValueFor("targets_for_mult") - math.abs(iExplosionReduce)
                                           and 1.9
                                           or 0.4
                    self.fExplosionTimer2 = GameRules:GetGameTime() + self.fExplosionTimer
                    self:ExplosionEffects()
                    return
                else
                    if GameRules:GetGameTime() < self.fExplosionTimer2 then
                        return
                    end
                end
            end
            
            -- Handle Movement and Radius/Damage Logic
            local tMoveValues = self:MoveAndCalculateStats()
            if tMoveValues == nil then return end

            --self.hBlueOrbTargets = {}
            self.iBlueOrbTargetsCopy = self.iBlueOrbTargets
            self.iBlueOrbTargets = 0
            
            -- Check for out of bounds
            if GridNavPathIsTraversable(self, tMoveValues.vCurPos, 100) == false and not self:BlueIsExploding() then
                self:Destroy()
                return
            end
            
            AddFOWViewer(self.caster:GetTeamNumber(), tMoveValues.vCurPos, 700, 0.01, true)
            GridNav:DestroyTreesAroundPoint(tMoveValues.vCurPos, tMoveValues.fRadiusCopy, false)
        
            
            -- Handle Projectile Damage
            local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(),  -- int, your team number
                                               self.parent:GetOrigin(),  -- point, center point
                                               nil,  -- handle, cacheUnit. (not known)
                                               tMoveValues.fRadiusCopy,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                               self.Ability:GetAbilityTargetTeam(),  -- int, team filter
                                               self.Ability:GetAbilityTargetType(),  -- int, type filter
                                               self.Ability:GetAbilityTargetFlags(),  -- int, flag filter
                                               FIND_ANY_ORDER,  -- int, order filter
                                               false  -- bool, can grow cache
                                            )
            
            for _, hTarget in pairs(enemies) do
                if IsNotNull(hTarget) and not self.tAlreadyHit[tostring(hTarget:entindex())] then
                    local damage = {
                                     victim = hTarget,
                                     attacker = self.Source,
                                     damage = tMoveValues.fDamageCopy,
                                     damage_type = self.Ability:GetAbilityDamageType(),
                                     ability = self.Ability
                                   }
    
                    
                    if self:BlueIsExploding() or (not self.bIsBlueOrb and not self.bIsRedOrb) then
                        self.hKnockBackTable.center_x = tMoveValues.vCurPos.x
                        self.hKnockBackTable.center_y = tMoveValues.vCurPos.y
                        self.hKnockBackTable.center_z = tMoveValues.vCurPos.z                    
                        hTarget:AddNewModifier(self.parent, self.Ability, "modifier_knockback", self.hKnockBackTable, hTarget:IsOpposingTeam(self.parent:GetTeamNumber()))                        
                    end 
                     
                    --=============================================--
                    --self:ApplyMotionModifier(hTarget, tMoveValues)
                    --=============================================--
                    if damage.damage > 0 then
                        ApplyDamage(damage)
                    end
                    
                    -- Store enemies if bool enabled
                    if not self.bHitMultiple and not self.tAlreadyHit[tostring(hTarget:entindex())] then
                        self.tAlreadyHit[tostring(hTarget:entindex())] = true
                    end
                    
                    -- Increment Targets counter for Blue Orb
                    if self.bIsBlueOrb then
                        --table.insert(self.hBlueOrbTargets, hTarget)
                        --self.hBlueOrbTargets[hTarget:entindex()] = 1
                        self.iBlueOrbTargets = self.iBlueOrbTargets + 1
                    end  
                end
            end
            
            -- Handle Explosion Logic Final
            if self:BlueIsExploding() then
                self:ExplosionEffects(2)       
                return self:Destroy()
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
            local vCenter = self.parent:GetOrigin()  -- Center of rotation
            local iRadius = 400 -- Radius of rotation
            local fCircum = (2 * math.pi * iRadius) -- Circumference of the Circle
            local fSpeed = 360 * self.iMoveSpeed / fCircum --45  -- Speed of angular incrementation
            local iDeltaAngle = 1  -- Delta Angle for smoother rotation
         
            -- Calculate new position in polar coordinates
            self.angle = self.angle + iDeltaAngle * fSpeed * 0.01
                    
            -- Check if a full revolution has occurred
            if self.angle >= 360 then
                self.iBlueCurrentState = STATE_IS_IDLING
                self.angle = 0
                print("Blue Orb Full Revolution")
            end
                    
            local vRadians = math.rad(self.angle)
            local VecX = vCenter.x + iRadius * math.cos(vRadians)
            local VecY = vCenter.y + iRadius * math.sin(vRadians)
      
            -- Set the new position
            self.Target = Vector(VecX, VecY, vCenter.z) --Rotated Position
        end
    else
        -- Blue Orb Explosion Logic
        self.Target = vCurPos
        self.bIsExploding = true
    end        
end
function modifier_gojo_projectile_thinker:MoveAndCalculateStats()
    -- There should always be a Target Vector
    if not self.Target then
        local vForward = self.Ability.vForward or self.caster:GetForwardVector()
        self.Target = self.caster:GetOrigin() + vForward * self.fDistance 
    end
            
    -- EYE movement logic pog
    local vCurPos     = GetGroundPosWithOffset(self.parent, 0, 120)
    local vDirection  = GetDirection(self.Target, vCurPos)
    local fDistance   = GetDistance(self.Target, vCurPos)
    local fUnitsPerDt = self.iMoveSpeed * 0.01
    local vNextPos    = vCurPos + vDirection * fUnitsPerDt
    vNextPos = fDistance <= 100
               and vCurPos
               or vNextPos
                  
    -- If final destination reached and Destroy Bool true then nothing to do, else start Idling
    if vNextPos == vCurPos and self.bDestroy then 
        self:StartIntervalThink(-1) 
        self:Destroy() 
        return nil
    elseif vNextPos == vCurPos and not self.bDestroy then
        if self.iBlueCurrentState == 0 then
            self.iBlueCurrentState = STATE_IS_IDLING
        end
    end
                  
    -- Move the parent... yes            
    self.parent:SetOrigin(vNextPos)
                   
    --=================================================--
    local fRadiusCopy = self:BlueIsExploding()
                        and self.fRadius + 500
                        or self.fRadius
    --=================================================--                       
    local fDamageCopy = self:BlueIsExploding()
                        and self.Ability:GetSpecialValueFor("explosion_damage")
                        or self.fProjDamage
    --=================================================--                     
    fDamageCopy       = self.fExplosionTimer >= 1.5
                        and fDamageCopy * self.Ability:GetSpecialValueFor("explosion_mult")
                        or fDamageCopy
    --=================================================--              
    local tValues = {
                      vCurPos = vCurPos,
                      vNextPos = vNextPos,
                      fRadiusCopy = fRadiusCopy,
                      fDamageCopy = fDamageCopy,
                    }
    --=================================================--          
    
    return tValues
end
function modifier_gojo_projectile_thinker:BlueIsExploding()
    return self.iBlueCurrentState == STATE_IS_EXPLODING or self.bIsExploding
end
function modifier_gojo_projectile_thinker:ExplosionEffects(iNum)
    iNum = iNum or 1
    if iNum == 1 then
        if self.fExplosionTimer >= 1.5 then 
            self.iExplosionParticle = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/blue/blue_purple_combined_main.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            self:AddParticle(self.iExplosionParticle, false, false, -1, false, false)
            EmitSoundOn("Gojo.purple_full", self.parent) 
        end
    else
        local iExplosion = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/blue/blue_purple_combined_exp.vpcf", PATTACH_WORLDORIGIN, self.caster)
        ParticleManager:SetParticleControl(iExplosion, 0, self.parent:GetOrigin())
        ParticleManager:SetParticleControl(iExplosion, 3, self.parent:GetOrigin())        
        self:AddParticle(iExplosion, false, false, -1, false, false)
                
        if self.fExplosionTimer < 1.5 then
            EmitSoundOn("Gojo.purple_snap", self.parent)
        end  
    end
    ParticleManager:SetParticleControl(self.iParticle, 8, Vector(1, 0, 0))
end
function modifier_gojo_projectile_thinker:DoATickOfDamage(fDamage)
    -- Do a tick of damage from Red Orb to all enemies in Blue Orb
    fDamage = fDamage or 1
    
    local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(),  -- int, your team number
                                       self.parent:GetOrigin(),  -- point, center point
                                       nil,  -- handle, cacheUnit. (not known)
                                       self.fRadius,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                       self.Ability:GetAbilityTargetTeam(),  -- int, team filter
                                       self.Ability:GetAbilityTargetType(),  -- int, type filter
                                       self.Ability:GetAbilityTargetFlags(),  -- int, flag filter
                                       FIND_ANY_ORDER,  -- int, order filter
                                       false  -- bool, can grow cache
                                    )
    
    for _, hTarget in pairs(enemies) do
        if IsNotNull(hTarget) then
            local damage = {
                             victim = hTarget,
                             attacker = self.Source,
                             damage = fDamage,
                             damage_type = self.Ability:GetAbilityDamageType(),
                             ability = self.Ability
                           }
            
            if damage.damage > 0 then
                ApplyDamage(damage)
            end
        end
    end
end
function modifier_gojo_projectile_thinker:OnDestroy()
    if IsServer() then
        if self.bIsBlueOrb
            and not self:BlueIsExploding() then
            EmitSoundOn("Gojo.blue_expire", self.parent)
        end
        if IsNotNull(self.parent) 
            and not self.parent:IsRealHero() then
            self:StartIntervalThink(-1)
            __hGojoProjectiles[tostring(self.parent:entindex())] = nil
            StopSoundOn("Gojo.Looping.blue_fly", self.parent)
            UTIL_Remove(self.parent)
        end
        if not self.bIsRedirected 
            and IsNotNull(self.hSubAbility) then
            Goju_Swap_Blue(self.caster, self.Ability, self.hSubAbility)
        end
    end
end
function modifier_gojo_projectile_thinker:IsAura()
	return true
end

function modifier_gojo_projectile_thinker:GetModifierAura()
	return "modifier_gojo_projectile_thinker_aura"
end

function modifier_gojo_projectile_thinker:GetAuraRadius()
	return self.fRadius + 10
end

function modifier_gojo_projectile_thinker:GetAuraDuration()
	return 0.03
end

function modifier_gojo_projectile_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_gojo_projectile_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_gojo_projectile_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
---------------------------------------------------------------------------------------------------------------

-- NOTE: This modifier is registered with a motion controller, so it should correct unit positioning after being removed.
modifier_gojo_projectile_thinker_aura = modifier_gojo_projectile_thinker_aura or class ({})
function modifier_gojo_projectile_thinker_aura:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_gojo_projectile_thinker_aura:CheckState()
    local func = {
                   [MODIFIER_STATE_STUNNED] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                   [MODIFIER_STATE_PROVIDES_VISION] = true,
                 }
    return func
end
function modifier_gojo_projectile_thinker_aura:OnCreated()
    self.parent  = self:GetParent()
    self.caster  = self:GetAuraOwner()
    self.ability = self:GetAbility()
    if IsServer() then
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
        if self.ability:GetAbilityName() == "goju_blue_orb" then
            self.fInterval = self.ability:GetSpecialValueFor("dmgps_interval")
            self.fDamage    = self.ability:GetSpecialValueFor("damage_per_second")
            
           self.hDamageTable =  {  
                                    victim 		 = self.parent,
                                    attacker 	 = self.caster,
                                    damage 		 = self.fDamage,
                                    damage_type  = self.ability:GetAbilityDamageType(),
                                    ability 	 = self.ability,
                                    --damage_flags = 0
                                }
            
            self:StartIntervalThink(self.fInterval)
        end
    end
end
function modifier_gojo_projectile_thinker_aura:UpdateHorizontalMotion(me, dt)
    if IsNotNull(self.parent) and IsNotNull(self.caster) then
        self:PullRotate(me, dt) 
        --print("TEST HMMMMM")
    else
        self:Destroy()
    end                                   
end
function modifier_gojo_projectile_thinker_aura:PullRotate(me, dt)
    if IsServer() then
        -- EYE FUNCTION, MODIFIED
        local vCenterLoc = self.caster:GetAbsOrigin()
        local vDirection = GetDirection(self.parent, vCenterLoc)
        local fDistance  = GetDistance(self.parent, vCenterLoc)
        
        if fDistance > 255 or fDistance < 100 then
            fDistance = 150
        end

        local fPullSpeed   = (fDistance / 10) * RandomInt(15, 25) * dt
        local fRotateSpeed = RandomInt(10, 20) * dt

        local fDistanceReduce = fDistance - fPullSpeed

        local fDegree     = math.atan2( vDirection.y, vDirection.x )
        
            vDirection    = Vector( math.cos(fDegree + fRotateSpeed), math.sin(fDegree + fRotateSpeed), 0 )

        local vNextLoc    = GetGroundPosition( (vCenterLoc + vDirection * fDistanceReduce ), self.parent )

        self.parent:SetOrigin( vNextLoc )
    end
end
function modifier_gojo_projectile_thinker_aura:OnIntervalThink()
    if IsNotNull(self.parent) and IsNotNull(self.caster) and self.parent:IsAlive() then
        ApplyDamage(self.hDamageTable)
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
                           ParticleManager:SetParticleControl(iRed_Combined, 22, Vector(6.6, 8.0, 10.8)) -- Start Times: X.Red Big Ball, Y.Ground Smoke + White Trails, Z.White Flash
                           ParticleManager:SetParticleControlEnt(  iRed_Combined,  -- Red Ball + Red Trails positions
                                                                   21,
                                                                   hParent,
                                                                   PATTACH_POINT_FOLLOW,
                                                                   "attach_attack2",
                                                                   Vector(0,0,0),
                                                                   true)
    if bIsNotModifier then else hSelf:AddParticle(iRed_Combined, false, false, -1, false, false) end                                                               
    return iRed_Combined
end
-- Function for Gojo's Channeled Red Explosion effects
local Goju_Create_Explosion_Channeled = function(hSelf, hParent, bIsNotModifier)
    local iRed_Combined =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/red/red_combined_channeled.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
                           ParticleManager:SetParticleControl(iRed_Combined, 0, hParent:GetAbsOrigin()) -- Red Spiral positions
                           ParticleManager:SetParticleControlEnt(  iRed_Combined,  -- Red Ball + Red Trails positions
                                                                   21,
                                                                   hParent,
                                                                   PATTACH_POINT_FOLLOW,
                                                                   "attach_attack2",
                                                                   Vector(0,0,0),
                                                                   true)
    if bIsNotModifier then else hSelf:AddParticle(iRed_Combined, false, false, -1, false, false) end                                                             
    return iRed_Combined
end
-- Function for Gojo's Hollow Purple Activation effects
local Goju_Hollow_Purple_Activate = function(hSelf, hParent, bIsNotModifier)
    local iHollowPurple =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/hollow_purple/hollow_purple_main.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
                           ParticleManager:SetParticleControl(iHollowPurple, 0, hParent:GetAbsOrigin()) -- Main Attachment Point
                           ParticleManager:SetParticleControl(iHollowPurple, 21, Vector(5.0, 8.0, 0)) -- Rings Times
                           ParticleManager:SetParticleControl(iHollowPurple, 22, Vector(5.5, 8.5, 0)) -- Balls Times
                           ParticleManager:SetParticleControl(iHollowPurple, 23, Vector(5.4, 8.4, 0)) -- Glow Times
                           ParticleManager:SetParticleControl(iHollowPurple, 24, Vector(10.0, 11.8, 0)) -- Lightning + Shockwave Times
                           ParticleManager:SetParticleControl(iHollowPurple, 25, Vector(11.5, 0, 0)) -- Stop Balls Times
    if bIsNotModifier then else hSelf:AddParticle(iHollowPurple, false, false, -1, false, false) end                                                              
    return iHollowPurple
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
    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Red Orb (Q)
---------------------------------------------------------------------------------------------------------------

goju_red_orb = goju_red_orb or class({})

function goju_red_orb:CastFilterResultLocation(vLocation)
    NPAN_INDICATOR:RegisterAbility(self, NPAN_INDICATOR_TYPE_AIM_SKILLSHOT, "particles/test/custom/range_finder_cone_no_panorama/range_finder_cone.vpcf")
    NPAN_INDICATOR:CreateUIIndicator(self:GetCaster(), self, vLocation)
end
function goju_red_orb:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function goju_red_orb:OnSpellStart()
    local hCaster = self:GetCaster()
                           
    --hCaster:AddNewModifier(hCaster, self, "modifier_gojo_hollow_nuke", { duration = 24.0 })
    
    self:CreateRedOrb()
end
function goju_red_orb:CreateRedOrb()
    local hCaster      = self:GetCaster()
    local vCursorLoc   = self:GetCursorPosition()
    local f__Radius    = self:GetSpecialValueFor("radius")
    local i__Speed     = self:GetSpecialValueFor("movespeed")
    local f__Distance  = self:GetSpecialValueFor("distance") + hCaster:FindTalentValue("special_bonus_gojo_20_alt")
    
    self.iTARGET_TEAM  = self:GetAbilityTargetTeam()
    self.iTARGET_TYPE  = self:GetAbilityTargetType()
    self.iTARGET_FLAGS = self:GetAbilityTargetFlags()
    
    self.f__ProjDmg     = self:GetSpecialValueFor("projectile_damage")
    self.f__ProjTickDmg = self.f__ProjDmg / ( (f__Distance / i__Speed) / FrameTime() )
    self.vForward       = GetDirection(vCursorLoc, hCaster) or hCaster:GetForwardVector()
    
    self.iTicksTest     = 0
    --print("Ticks Test: " .. (f__Distance / i__Speed) / FrameTime())
    
    local hExplosion =  {   
                            Ability             = self,
                            EffectName          = "particles/heroes/anime_hero_gojo/red/red_orb_projectile_test_linear.vpcf",
                            vSpawnOrigin        = hCaster:GetOrigin() + self.vForward * 25,
                            fDistance           = f__Distance,
                            fStartRadius        = f__Radius,
                            fEndRadius          = f__Radius,
                            Source              = hCaster,
                            bHasFrontalCone     = false,
                            bReplaceExisting    = false,
                            iUnitTargetTeam     = self.iTARGET_TEAM,
                            iUnitTargetFlags    = self.iTARGET_FLAGS,
                            iUnitTargetType     = self.iTARGET_TYPE,
                            --fExpireTime         = GameRules:GetGameTime() + 30,
                            --bDeleteOnHit        = false,
                            vVelocity           = self.vForward * i__Speed,
                            bProvidesVision     = true,
                            iVisionRadius     	= f__Radius,
                            iVisionTeamNumber 	= hCaster:GetTeamNumber(),
                            --ExtraData 			= { fProjDmg = f__ProjDmg }
                        }

    EmitSoundOn("Gojo.redball" .. RandomInt(1, 2), hCaster)
    
    return ProjectileManager:CreateLinearProjectile(hExplosion)
end
function goju_red_orb:OnProjectileThinkHandle(iProjectile)
    if IsNotNull(self)
        and ProjectileManager:IsValidProjectile(iProjectile) then
        local hCaster   = self:GetCaster()
        local vLocation = ProjectileManager:GetLinearProjectileLocation(iProjectile)
        local vGround   = GetGroundPosition(vLocation, hCaster)
        local fRadius   = ProjectileManager:GetLinearProjectileRadius(iProjectile)
        
        GridNav:DestroyTreesAroundPoint(vLocation, fRadius, false)
    
        -- Handle Red Orb Logic
        -- TEST HMMMMMM.....
        for iKey, hTarget in pairs(__hGojoProjectiles) do
            if IsNotNull(hTarget)
                and not hTarget:IsRealHero()
                and hTarget:HasModifier("modifier_gojo_projectile_thinker") 
                and GetDistance(hTarget, vLocation) <= 255 then
                local hModifier = hTarget:FindModifierByName("modifier_gojo_projectile_thinker")
                
                hModifier.iBlueCurrentState = STATE_IS_EXPLODING
                hModifier.bIsExploding = true
                hModifier:DoATickOfDamage(self.f__ProjDmg)
                
                return ProjectileManager:DestroyLinearProjectile(iProjectile)
            end
        end
        
        -- Handle Projectile Pull
        local hEnemies = FindUnitsInRadius( hCaster:GetTeamNumber(),  -- int, your team number
                                           vLocation,  -- point, center point
                                           nil,  -- handle, cacheUnit. (not known)
                                           fRadius,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                           self.iTARGET_TEAM,  -- int, team filter
                                           self.iTARGET_TYPE,  -- int, type filter
                                           self.iTARGET_FLAGS,  -- int, flag filter
                                           FIND_ANY_ORDER,  -- int, order filter
                                           false  -- bool, can grow cache
                                        )

        local hDamageTable = {
                               victim = nil,
                               attacker = hCaster,
                               damage = self.f__ProjTickDmg,
                               damage_type = self:GetAbilityDamageType(),
                               ability = self
                             }
        
        for _, hTarget in pairs(hEnemies) do
            if IsNotNull(hTarget) and not hTarget:HasModifier("modifier_gojo_projectile_thinker_aura") then
                hTarget:AddNewModifier(hTarget, self, "modifier_stunned", { duration = 0.03 })
                if GridNav:IsTraversable(vGround) then
                    hTarget:SetOrigin(vGround)
                else
                    FindClearSpaceForUnit(hTarget, vGround, true)
                end
                hDamageTable.victim = hTarget
                self.iTicksTest = self.iTicksTest + 1
                --print("Ticks Amount: " .. self.iTicksTest )
                ApplyDamage(hDamageTable)
            end
        end
    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Blue Orb (W)
---------------------------------------------------------------------------------------------------------------

goju_blue_orb = goju_blue_orb or class({})

function goju_blue_orb:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function goju_blue_orb:OnSpellStart()
    local hCaster = self:GetCaster()
    
    local hProjectile = self:CreateBlueOrb()
    
	local hModifier = hProjectile:FindModifierByName( "modifier_gojo_projectile_thinker" )

	if IsNotNull(hProjectile)
        and IsNotNull(hModifier) then
        -- Add redirect ability and swap
	    local hSubAbility = hCaster:AddAbility( "goju_blue_orb_redirect" )
	    if IsNotNull(hSubAbility) then
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
    local f__Radius    = self:GetSpecialValueFor("radius")
    local i__Speed     = self:GetSpecialValueFor("movespeed")
    local f__Distance  = self:GetSpecialValueFor("distance")
    
    self.vForward = hCaster:GetForwardVector()
    
    local hExplosion =  {   
                          duration     = self:GetSpecialValueFor("duration"),
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
                          fProjDamage  = 0,
                          bDestroy     = false,
                          bIsBlueOrb   = true,
                          fRadius      = f__Radius,
                          bIsRedOrb    = false
                     	}
                        
    local hProjectile = Goju_Create_Projectile(self, hCaster, hExplosion)
    EmitSoundOn("Gojo.bluenormal", hCaster)
    EmitSoundOn("Gojo.Loop.blue_fly", hProjectile)
    
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
	if IsNotNull(self.hModifier) then
        local hCaster  = self:GetCaster()
		local hTarget  = self:GetCursorPosition()
        local hParent  = self.hModifier.parent
        local vDirection  = GetDirection(hTarget, hParent)
        local nTeamNumber = hParent:GetTeamNumber()
        
        hParent:SetForwardVector(vDirection)
        local vLocation   = hParent:GetOrigin() + hParent:GetForwardVector() * 1300
        self.hModifier.iBlueCurrentState = STATE_IS_MOVING
        self.hModifier.Target            = vLocation
        self.hModifier.bIsRedirected     = true
        
        local nArrowIndicatorFX = ParticleManager:CreateParticleForTeam("particles/test/custom/gojo_blue_orb_arrow_indicator/indicator_main.vpcf", PATTACH_WORLDORIGIN, nil, nTeamNumber)
                                  ParticleManager:SetParticleControl(nArrowIndicatorFX, 0, hParent:GetOrigin() + hParent:GetForwardVector() * 1200)
                                  ParticleManager:ReleaseParticleIndex(nArrowIndicatorFX)
                                  
        if hCaster:HasModifier("modifier_item_six_eyes_active") then
            local nWindImpactFX = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/blue/blue_projectile_redirect_main.vpcf", PATTACH_WORLDORIGIN, nil)
                                  ParticleManager:SetParticleControl(nWindImpactFX, 0, hParent:GetOrigin())
                                  ParticleManager:SetParticleControl(nWindImpactFX, 1, vLocation)
                                  ParticleManager:ReleaseParticleIndex(nWindImpactFX)
                                  
            hCaster:EmitSound("Gojo.thatso")
            hCaster:EmitSound("Gojo.blue_redirect")
            
            local nCounter = 1
            Timers:CreateTimer(0, function()
                local hEnemies = FindUnitsInLine( hCaster:GetTeamNumber(), --team 
                                                  hParent:GetOrigin(), --startPos, 
                                                  vLocation, --endPos
                                                  nil, --cacheUnit 
                                                  200, --width 
                                                  DOTA_UNIT_TARGET_TEAM_ENEMY, --teamFilter: DOTA_UNIT_TARGET_TEAM 
                                                  DOTA_UNIT_TARGET_ALL, --typeFilter: DOTA_UNIT_TARGET_TYPE
                                                  0 ) --flagFilter: DOTA_UNIT_TARGET_FLAGS  
                                                  
                for _, hEnemy in pairs(hEnemies) do
                    if IsNotNull(hEnemy) and hEnemy ~= hCaster then
                        local hDamageTable =    {  
                                                    victim 		 = hEnemy,
                                                    attacker 	 = hCaster,
                                                    damage 		 = 400,
                                                    damage_type  = DAMAGE_TYPE_MAGICAL,
                                                    ability 	 = self,
                                                    damage_flags = 0
                                                }
                        
                        ApplyDamage(hDamageTable)
                        
                        hEnemy:AddNewModifier(hCaster, self, "modifier_stunned", {duration = 0.5})
                        
                        hEnemy:EmitSound("nanaya.slash")
                    end                        
                end
                
                nCounter = nCounter + 1
                
                return nCounter == 2 and 0.5 or nil
            end)
        end
	end
    
    Goju_Swap_Blue(self:GetCaster(), self.hMainAbility, self)
end

---------------------------------------------------------------------------------------------------------------
-- Goju Infinite Void (E)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_infinite_void","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_infinite_void = goju_infinite_void or class({})

function goju_infinite_void:GetAOERadius()
    return self:GetCaster():HasModifier("modifier_goju_infinite_void")
           and self:GetSpecialValueFor("blink_distance")
           or 0
end
function goju_infinite_void:GetBehavior()
     return self:GetCaster():HasModifier("modifier_goju_infinite_void") 
            and DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
            or self.BaseClass.GetBehavior(self)
end
function goju_infinite_void:GetAbilityTextureName()
     return self:GetCaster():HasModifier("modifier_goju_infinite_void") 
            and "anime_hero_gojo/gojo_infinity2"
            or self.BaseClass.GetAbilityTextureName(self)
end
function goju_infinite_void:OnSpellStart()
    local hCaster = self:GetCaster()
    local hPoint  = self:GetCursorPosition()
    local hTarget = self:GetCursorTarget()
    
    if not hCaster:HasModifier("modifier_goju_infinite_void") then
        local fDuration = self:GetSpecialValueFor("duration")
        local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_goju_infinite_void", { duration = fDuration })
        
        if hCaster:HasModifier("modifier_item_six_eyes_active") then
            EmitSoundOn("Gojo.hehehe", hCaster)
            EmitSoundOn("Gojo.aura_sound", hCaster)
            Timers:CreateTimer(0.25, function()
                if IsNotNull(hModifier)
                    and IsNotNull(hCaster) then
                    EmitSoundOn("Gojo.aura_sound", hCaster)
                    return 0.25
                end
                StopSoundOn("Gojo.aura_sound", hCaster)
            end)
        end
    else
        self:Blink(hCaster, hPoint, hTarget)
    end
end
function goju_infinite_void:Blink(hCaster, hPoint, hTarget)
    local fBlinkDistance = self:GetSpecialValueFor("blink_distance") + hCaster:FindTalentValue("special_bonus_gojo_20")
    local vDirection     = GetDirection(hPoint, hCaster)
    fBlinkDistance       = math.min(GetDistance(hPoint, hCaster), fBlinkDistance)
    vDirection           = hCaster:GetOrigin() + vDirection * fBlinkDistance
        
    local iParticle = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_WORLDORIGIN, nil)
                      ParticleManager:SetParticleControl(iParticle, 0, hCaster:GetAbsOrigin())
                      ParticleManager:ReleaseParticleIndex(iParticle)
    
    if IsNotNull(hTarget) and GetDistance(hTarget, hCaster) <= fBlinkDistance then  
        self:Hit(hCaster, hTarget)
    else
        FindClearSpaceForUnit( hCaster, vDirection, true )
    end
    ProjectileManager:ProjectileDodge(hCaster)
    local nParticle = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hCaster)
                      ParticleManager:ReleaseParticleIndex(nParticle)
    
    EmitSoundOn("Gojo.blink", hCaster)
    --self:Hit(hCaster, self:GetCursorTarget())
end
function goju_infinite_void:Hit(hCaster, hTarget)
    if IsNotNull(hCaster) and hCaster:IsAlive() and hTarget:IsAlive() then
        local vDirection = GetDirection(hTarget, hCaster)
        local vTargetLoc = hTarget:GetOrigin()
        local fBoundingR = ( hCaster:BoundingRadius2D() + hTarget:BoundingRadius2D() ) --* 2 -- Need this Diameter or FindClearSpaceForUnit will not position properly
        vTargetLoc       = vTargetLoc - vDirection * fBoundingR
        
        --hCaster:SetOrigin(vTargetLoc)
        FindClearSpaceForUnit( hCaster, vTargetLoc, true )
        
        if GetDistance(hTarget, hCaster) <= fBoundingR * 1.1 then -- Add extra distance in cases where FindClearSpaceForUnit does not position close enough
            hCaster:FaceTowards(hTarget:GetOrigin())
            hCaster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ALACRITY, 1.5)
            hTarget:RemoveModifierByName("modifier_goju_domain_motion")
            hTarget:AddNewModifier(hCaster, self, "modifier_goju_domain_motion", { duration = 2.0 })
            
            for i = 1, 2 do
                hCaster:PerformAttack(hTarget, true, true, true, true, false, false, true)
            end
            
            self:HitEffect(hCaster, hTarget)
        end
    end
end
function goju_infinite_void:HitEffect(hCaster, hTarget)
    local sParticle = "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf"

    local iParticle = ParticleManager:CreateParticle( sParticle, PATTACH_ABSORIGIN_FOLLOW, hCaster )
                      ParticleManager:SetParticleControlEnt(iParticle, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetOrigin(), true)
                      ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
                      ParticleManager:ReleaseParticleIndex(iParticle)
    
    hCaster:EmitSound("nanaya.slash")
end
---------------------------------------------------------------------------------------------------------------

modifier_goju_infinite_void = modifier_goju_infinite_void or class ({})

function modifier_goju_infinite_void:IsHidden() return false end
function modifier_goju_infinite_void:IsPurgeable() return true end
function modifier_goju_infinite_void:IsPurgeException() return true end
function modifier_goju_infinite_void:RemoveOnDeath() return true end
function modifier_goju_infinite_void:CheckState()
    local func = {
                   [MODIFIER_STATE_DEBUFF_IMMUNE] = self.bIsOwner,
                 }
    return func
end
function modifier_goju_infinite_void:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_PROPERTY_DODGE_PROJECTILE,
                        --MODIFIER_EVENT_ON_ORDER,
                        MODIFIER_PROPERTY_AVOID_DAMAGE_AFTER_REDUCTIONS,
                        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                    }
    return tFunc
end
function modifier_goju_infinite_void:GetModifierDodgeProjectile()
    return self.bIsOwner and 1
end
function modifier_goju_infinite_void:GetModifierIgnoreMovespeedLimit(keys)
    if self.bIsOwner
        and self.parent:HasModifier("modifier_item_six_eyes_active") then
        return 1
    end
end
function modifier_goju_infinite_void:GetModifierMoveSpeed_Limit(keys)
    if self.bIsOwner
        and self.parent:HasModifier("modifier_item_six_eyes_active") then
        return 1000
    end
end
function modifier_goju_infinite_void:GetModifierMoveSpeedBonus_Percentage(keys)
    if self.bIsOwner
        and self.parent:HasModifier("modifier_item_six_eyes_active") then
        return 1000
    end
end
function modifier_goju_infinite_void:OnCreated(hTable)
    self.caster   = self:GetCaster()
    self.parent   = self:GetParent()
    self.ability  = self:GetAbility()
    
    self.bIsOwner = self.caster == self.parent
    
    self.fRadius = self.ability:GetSpecialValueFor("radius")
    
    if IsServer() then
        self.vOriginP = self.parent:GetOrigin()
    
        if not self.bIsOwner then
            self:StartIntervalThink(0.01)
        else
        
        if self.parent:HasModifier("modifier_item_six_eyes_active") then
            local nGojoAuraFX  = ParticleManager:CreateParticle("particles/test/custom/cringe_aura/gohan_auras/gojo_aura.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
                                 ParticleManager:SetParticleControlEnt(nGojoAuraFX, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin() + Vector(0, 0, 500), true)
            self:AddParticle(nGojoAuraFX, false, false, -1, false, false)
        end
            self.iDmgTreshold = self.ability:GetSpecialValueFor("damage_treshold")
            self.ability:EndCooldown()
            --local nDomainFX = ParticleManager:CreateParticle("particles/test/custom/domain_expansion_test/domain_expansion_main.vpcf", PATTACH_WORLDORIGIN, nil)
                              --ParticleManager:SetParticleControl(nDomainFX, 0, self.parent:GetAbsOrigin())
                              --ParticleManager:SetParticleShouldCheckFoW(nDomainFX, false)
            --self:AddParticle(nDomainFX, false, false, -1, false, false)
        end
    end
end
function modifier_goju_infinite_void:OnIntervalThink()
    -- !! IMPORTANT: !! --
    -- This is not a true Marble Sphere. Enemies can't get close, but Gojo can.
    -- Functionality wise, the closer enemies get, the slower they become.
    if IsServer() then
        if not IsNotNull(self.parent) then return end
        
        self.fDistance  = GetDistance(self.caster, self.parent)
        self.vDirection = GetDirection(self.caster, self.parent)
        
        if self:CanMove() then self.vOriginP = self.parent:GetOrigin() return end
    
        self:BlockOrPushEnemy()
        --self.parent:SetOrigin(self.vOriginP)
        --print("TEST HMMMM")
    end
end
function modifier_goju_infinite_void:CanMove()
    local vFacingDirection = self.parent:GetForwardVector():Normalized()
       
    if self.parent:HasModifier("modifier_goju_domain_motion") then
        return true
    end
    
    if self.caster:HasModifier("modifier_item_six_eyes_active") then
        return false
    end
    
    local hModifier = self.parent:FindModifierByName("modifier_knockback")
    if IsNotNull(hModifier) then
        if hModifier:GetCaster() == self.caster then
            return true
        end
    end
    
    self.parent:InterruptMotionControllers(true)
    
    if self.fDistance <= self.fRadius + 100
        and self.vDirection:Dot(vFacingDirection) <= 0 
        and self.parent:IsMoving() 
        and not self.parent:IsCurrentlyHorizontalMotionControlled() then
        --and not self.parent:IsCurrentlyVerticalMotionControlled() then 
        
        return true
    end     
    
    return false
end
function modifier_goju_infinite_void:BlockOrPushEnemy()
    local vCurPos    = self.parent:GetOrigin()
    local vGroundPos = GetGroundPosition(vCurPos, self.parent)
    local fSpeed     = (self.caster:GetIdealSpeed() + 500) * 0.01
    local vNextPos   = vCurPos - self.vDirection * fSpeed
    
    local bSixEyes   = self.caster:HasModifier("modifier_item_six_eyes_active")
    local fDistance  = bSixEyes
                       and 200
                       or 100
                       
    if bSixEyes then
        local vForward = self.caster:GetForwardVector()
        if self.vDirection:Dot(vForward) <= 0 then
            vNextPos = vCurPos + vForward * fSpeed
        end
    end
    
    if self.fDistance <= fDistance then
        vCurPos.z = vGroundPos.z
        self.parent:SetOrigin(vNextPos)
        self.vOriginP = vNextPos
        
        if bSixEyes and ( not GridNav:IsTraversable(self.vOriginP) or GridNav:IsBlocked(self.vOriginP) ) then
            if not self.__fDmgInterval then self.__fDmgInterval = 0.25 end
            
            self.__fDmgInterval = self.__fDmgInterval + 0.01
            
            if self.__fDmgInterval >= 0.25 then
                local hDamageTable =    {  
                                            victim 		 = self.parent,
                                            attacker 	 = self.caster,
                                            damage 		 = 2000,
                                            damage_type  = DAMAGE_TYPE_PHYSICAL,
                                            ability 	 = self.ability,
                                            damage_flags = 0
                                        }
                
                ApplyDamage(hDamageTable)
            
                EmitSoundOn("Gojo.aura_crush", self.parent)
                
                self.__fDmgInterval = 0
            end
            
            self.parent:SetOrigin(vCurPos)
        end
    else
        self.parent:SetOrigin(self.vOriginP)
    end     
end
function modifier_goju_infinite_void:GetModifierAvoidDamageAfterReductions(keys)
	if IsServer() then
        if IsNotNull(keys.attacker) and IsNotNull(keys.target) and keys.target == self.parent and self.bIsOwner then
            if keys.damage < self.iDmgTreshold then
		        return 1
            end
        end
	end
end
--[[function modifier_goju_infinite_void:OnOrder(keys)
    if self.bIsOwner then return end

    if keys.unit and keys.unit == self.parent and keys.unit:IsRealHero() and not keys.unit:IsBuilding() then
        local fDistance  = GetDistance(keys.unit, self.caster)
        local vDirection = GetDirection(keys.unit, self.caster)
        local vFacingDirection = self.parent:GetForwardVector():Normalized()
        
        if (keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE) 
            or (keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION)
            or (keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET )
            or (keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION )
            or (keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET ) 
            or (keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_DIRECTION ) then
            if fDistance <= 250 and vDirection:Dot(vFacingDirection) <= 0 then
                --keys.unit:Stop()
                keys.unit:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = 1.0})
                print("TEST HMMMMM")
            end            
        end
    end
end]]--
function modifier_goju_infinite_void:OnDestroy()
    if IsServer() then
        local hModifier = self.parent:FindModifierByName("modifier_knockback")
        if not self.bIsOwner then
            if not self.parent:HasModifier("modifier_goju_domain_motion")
                and not IsNotNull(hModifier) then
                FindClearSpaceForUnit( self.parent, self.parent:GetAbsOrigin(), true )
            end
            return
        end
        
        if IsNotNull(self.ability) and self.ability:IsFullyCastable() then
            self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.caster:GetCooldownReduction())
        end
    end
end
function modifier_goju_infinite_void:GetEffectName()
    if self.bIsOwner and not self.parent:HasModifier("modifier_item_six_eyes_active") then
        return "particles/heroes/anime_hero_gojo/infinite_void/gojo_infinite_void_refract.vpcf"
    end
end
function modifier_goju_infinite_void:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_goju_infinite_void:IsAura()
	return self.bIsOwner
end

function modifier_goju_infinite_void:GetModifierAura()
	return "modifier_goju_infinite_void"
end

function modifier_goju_infinite_void:GetAuraRadius()
	return self.fRadius
end

function modifier_goju_infinite_void:GetAuraDuration()
	return 0.01
end

function modifier_goju_infinite_void:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_goju_infinite_void:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_goju_infinite_void:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

---------------------------------------------------------------------------------------------------------------
-- Goju Red Explosion (D)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_red_explosion_active","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_red_explosion = goju_red_explosion or class({})

function goju_red_explosion:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end
function goju_red_explosion:GetBehavior()
    return self:GetCaster():HasModifier("modifier_goju_red_explosion_active") 
           and DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED
           or self.BaseClass.GetBehavior(self)
end
function goju_red_explosion:GetCastRange()
    return self:GetCaster():HasModifier("modifier_goju_red_explosion_active")
           and 4000 -- Hardcoded ranges for optimal behavior
           or 400
end
function goju_red_explosion:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
    local fDuration = self:GetSpecialValueFor("duration")
    
    if not hCaster:HasModifier("modifier_goju_red_explosion_active") then
        hCaster:AddNewModifier(hCaster, self, "modifier_goju_red_explosion_active", { fTimer = fDuration })
        hTarget:AddNewModifier(hCaster, self, "modifier_goju_red_explosion_stun", { duration = fDuration + 0.2 })
    else
        self.Effect = Goju_Create_Explosion_Channeled(self, hCaster, true)
        EmitSoundOn("Gojo.red_channeled", hCaster)
        hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        hCaster:AddNewModifier(hCaster, self, "modifier_goju_vision", { duration = (self:GetChannelTime() or 3.0) + 0.4 })
    end
end
function goju_red_explosion:OnChannelFinish(bInterrupted)
    if not self:GetCaster():HasModifier("modifier_goju_red_explosion_active") then return end
    
    ParticleManager:DestroyParticle( self.Effect, true )
    ParticleManager:ReleaseParticleIndex( self.Effect )
    StopSoundOn("Gojo.red_channeled", self:GetCaster())
    self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    self:GetCaster():RemoveModifierByName("modifier_goju_vision")
    
    local fChannelStartTime = ( GameRules:GetGameTime() - self:GetChannelStartTime() ) / self:GetChannelTime()
    self:CreateRed(fChannelStartTime)
    --print(fChannelStartTime)
end
function goju_red_explosion:OnProjectileThink(vLocation)
    GridNav:DestroyTreesAroundPoint(vLocation, 500, false)
end
function goju_red_explosion:OnProjectileHit_ExtraData(hTarget, vLocation, hTable)
	if IsNotNull(self)
		and IsNotNull(hTarget) then
		local hCaster   = self:GetCaster()
		local fDamage   = self:GetSpecialValueFor("damage") or 500
        local fRealDmg  = self:GetSpecialValueFor("damage") + hCaster:FindTalentValue("special_bonus_gojo_15")
        local iLevelMul = self:GetSpecialValueFor("level_mult") + hCaster:FindTalentValue("special_bonus_gojo_25")
        local fStrMult  = self:GetSpecialValueFor("str_mult") or 50.0
        local fStrength = hCaster:GetStrength()
        
        fStrMult = fStrength * fStrMult
        fDamage  = fDamage + fStrMult
        --print("Gojo Explosion Damage: " .. fDamage)
        
        local bUpgraded = hTable.bUpgraded
                          and (hTable.bUpgraded > 0) 
                          or false
                          
        --print(hTable.bUpgraded)
        --print(bUpgraded)
        --print(hTable.fChannelStartTime)
        --print(GetLerped(0, 3000, hTable.fChannelStartTime))

        local hDamageTable =    {  
                                    victim 		 = hTarget,
                                    attacker 	 = hCaster,
                                    damage 		 = bUpgraded and fDamage or GetLerped(fRealDmg, fRealDmg + (hCaster:GetLevel() * iLevelMul), hTable.fChannelStartTime),
                                    damage_type  = self:GetAbilityDamageType(),
                                    ability 	 = self,
                             		damage_flags = 0
                                }
                                
        local hKnockBackTable = {
                                    should_stun        = 1,
                                    knockback_duration = GetLerped(0.2, 1.4, hTable.fChannelStartTime),
                                    duration           = GetLerped(0.2, 1.4, hTable.fChannelStartTime),
                                    knockback_distance = GetLerped(200, 800, hTable.fChannelStartTime),
                                    knockback_height   = GetLerped(200, 800, hTable.fChannelStartTime),
                                    center_x           = vLocation.x,
                                    center_y           = vLocation.y,
                                    center_z           = vLocation.z
                                }
                                
        hTarget:RemoveModifierByName("modifier_knockback")
        hTarget:AddNewModifier(hCaster, self, "modifier_knockback", hKnockBackTable, hTarget:IsOpposingTeam(hCaster:GetTeamNumber()))
        
        ApplyDamage(hDamageTable)
    end
end
function goju_red_explosion:CreateRed(fChannelStartTime, bUpgraded)
    local hCaster      = self:GetCaster()
    
    local f__Distance  = self:GetSpecialValueFor("distance") + hCaster:FindTalentValue("special_bonus_gojo_15") or 2500
    local f__Radius    = self:GetSpecialValueFor("radius") or 500
    local i__Speed     = self:GetSpecialValueFor("speeed") or 2500
    
    local vForward     = hCaster:GetForwardVector()
    vForward.z         = 0
    
    fChannelStartTime = fChannelStartTime or 1.0
    bUpgraded         = bUpgraded or not hCaster:HasModifier("modifier_goju_red_explosion_active")
        
    local hExplosion =  {   
                            Ability             = self,
                            EffectName          = "particles/heroes/anime_hero_gojo/red/red_projectile_main2.vpcf", --"particles/heroes/anime_hero_gojo/red/red_projectile_main.vpcf",
                            vSpawnOrigin        = hCaster:GetAbsOrigin(),
                            fDistance           = GetLerped(400, f__Distance, fChannelStartTime),
                            fStartRadius        = f__Radius,
                            fEndRadius          = f__Radius,
                            Source              = hCaster,
                            bHasFrontalCone     = false,
                            bReplaceExisting    = false,
                            iUnitTargetTeam     = self:GetAbilityTargetTeam(),
                            iUnitTargetFlags    = self:GetAbilityTargetFlags(),
                            iUnitTargetType     = self:GetAbilityTargetType(),
                            --fExpireTime         = GameRules:GetGameTime() + 30,
                            --bDeleteOnHit        = false,
                            vVelocity           = vForward * i__Speed,
                            bProvidesVision     = true,
                            iVisionRadius     	= f__Radius,
                            iVisionTeamNumber 	= hCaster:GetTeamNumber(),
                            ExtraData 			= {bUpgraded = bUpgraded, fChannelStartTime = fChannelStartTime}
                        }

    local iProjectile = ProjectileManager:CreateLinearProjectile(hExplosion)
    EmitSoundOn("Gojo.red_launched", hCaster)

    return iProjectile 
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_red_explosion_active = modifier_goju_red_explosion_active or class({})

function modifier_goju_red_explosion_active:IsHidden() return false end
function modifier_goju_red_explosion_active:IsPurgeable() return false end
function modifier_goju_red_explosion_active:IsPurgeException() return false end
function modifier_goju_red_explosion_active:RemoveOnDeath() return false end
function modifier_goju_red_explosion_active:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                        [MODIFIER_STATE_PROVIDES_VISION] = true,
                    }
    return not self.bReady and state
end
function modifier_goju_red_explosion_active:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                    }
    return func
end
--function modifier_goju_red_explosion_active:GetOverrideAnimation(keys)
    --return ACT_DOTA_CAST_ABILITY_1
--end
function modifier_goju_red_explosion_active:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsClient() then
    else
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        
        Destroy__Particle(self.GojoRedEffect)
        self.GojoRedEffect = nil
        self.GojoRedEffect = Goju_Create_Explosion(self, self.parent)
        
        self.ability:EndCooldown()
        EmitGlobalSound("Gojo.red")
        
        self.bReady = false
        self.fTimer = hTable.fTimer or 8.0
        self:StartIntervalThink(self.fTimer)
    end
end
function modifier_goju_red_explosion_active:OnIntervalThink()
    self.bReady = true
    
    if not self.parent:IsAlive() then
        Destroy__Particle(self.GojoRedEffect)
        StopGlobalSound("Gojo.red")
    else
        Destroy__Particle(self.GojoRedEffect)
        StopGlobalSound("Gojo.red")
        self.ability:CreateRed(nil, true)
    end
    self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    self:StartIntervalThink(-1)
end
function modifier_goju_red_explosion_active:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_red_explosion_active:OnDestroy()
    if IsServer() then

    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Expansion (F)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_domain_expansion","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goju_domain_expansion_debuff","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_domain_expansion = goju_domain_expansion or class({})

function goju_domain_expansion:Spawn()
    if IsServer() then
        if self:GetLevel() <= 0 then
            Timers:CreateTimer(0.04, function()
                self:SetLevel(1)
            end)
        end
        if not self:GetCaster():HasScepter() then
            self:SetActivated(false)
        end
    end
end
function goju_domain_expansion:OnOwnerSpawned()
    if IsServer() then
        self:GetCaster():RemoveModifierByName("modifier_goju_domain_expansion")
        self:GetCaster():RemoveModifierByName("modifier_goju_hollow_purple_active")
    end
end
function goju_domain_expansion:GetOnUpgradeAbilities()
    return hTABLE_ABILITIES2
end
function goju_domain_expansion:CastFilterResult()
    if IsServer() then
	    local hCaster = self:GetCaster()

        return ( hCaster:HasModifier("modifier_goju_hollow_purple_active") )
               and UF_FAIL_CUSTOM
               or UF_SUCCESS
    end
end
function goju_domain_expansion:GetCustomCastError()
	return "#goju_domain_expansion_cast_error"
end
function goju_domain_expansion:GetAbilityTextureName()
    local hCaster = self:GetCaster()
    if not hCaster:HasModifier("modifier_item_six_eyes_active") then
        return "anime_hero_gojo/gojo_six_eyes"
    end
    if hCaster:HasModifier("modifier_goju_infinite_void")
        or hCaster:HasModifier("modifier_domain_expansion_full_charge") 
        or self.nFullDomain == 1 then
        return "anime_hero_gojo/gojo_domain_expansion_full" 
    end
    return self.BaseClass.GetAbilityTextureName(self)
end
function goju_domain_expansion:OnSpellStart()
    local hCaster = self:GetCaster()
    
    if not hCaster:HasModifier("modifier_item_six_eyes_active") then
        return hCaster:AddNewModifier(hCaster, self, "modifier_item_six_eyes_active", {})
    end
    
    if hCaster:HasModifier("modifier_goju_infinite_void") then
        return self:CastFullDomain()
    end
    
    self:CastPartialDomain()
end
function goju_domain_expansion:CastPartialDomain()
    local hCaster = self:GetCaster()
    local fDuration = 8.0 -- Hardcoded, changing will break ability
    
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_expansion", { duration = fDuration })
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_vision", { duration = fDuration })
end
function goju_domain_expansion:CastFullDomain()
    local hCaster = self:GetCaster()
    
    self.nFullDomain = 1
    goju_domain_expansion_full:OnSpellStart(self)
    --hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_expansion", { duration = 0.01 })
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_domain_expansion = modifier_goju_domain_expansion or class({})

function modifier_goju_domain_expansion:IsHidden() return false end
function modifier_goju_domain_expansion:IsPurgeable() return false end
function modifier_goju_domain_expansion:IsPurgeException() return false end
function modifier_goju_domain_expansion:RemoveOnDeath() return true end
function modifier_goju_domain_expansion:IsAura() return true end
function modifier_goju_domain_expansion:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                    }
    return not self.bIsActive and state
end
function modifier_goju_domain_expansion:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
                        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
                    }
    return func
end
function modifier_goju_domain_expansion:GetModifierIgnoreMovespeedLimit(keys)
    return 1
end
function modifier_goju_domain_expansion:GetModifierMoveSpeed_Limit(keys)
    return self.iMoveSpeedLimit
end
function modifier_goju_domain_expansion:GetModifierMoveSpeedBonus_Percentage(keys)
    return self.iMoveSpeedPercent
end
function modifier_goju_domain_expansion:GetModifierAttackRangeBonus()
    return self.iMeleeRange
end
function modifier_goju_domain_expansion:GetModifierBaseAttack_BonusDamage()
    return self.fBaseDmgBonus
end
function modifier_goju_domain_expansion:GetModifierProcAttack_BonusDamage_Magical()
    return self.fMagicDmgBonus
end
function modifier_goju_domain_expansion:GetActivityTranslationModifiers()
    return "gojo_domain"
end
function modifier_goju_domain_expansion:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    ----------------------------------------------------
    self.bIsActive = self.bIsActive or hTable.bIsActive
    self.bSwapped  = self.bSwapped or hTable.bSwapped
    ----------------------------------------------------
    
    self.iMeleeRange       = 150 - self.parent:Script_GetAttackRange()
    self.iMoveSpeedLimit   = self.ability:GetSpecialValueFor("movespeed_limit")
    self.iMoveSpeedPercent = self.ability:GetSpecialValueFor("movespeed_bonus_perc")
    self.fBaseDmgBonus     = self.ability:GetSpecialValueFor("base_damage_bonus")
    self.fMagicDmgBonus    = self.ability:GetSpecialValueFor("magic_damage_bonus")
    self.fDurationBuff     = self.ability:GetSpecialValueFor("duration_buff")
    
    if not IsServer() then return end
    
    --for i = 1, 2 do
        --local iEyeEffect = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
                           --ParticleManager:SetParticleControlEnt(iEyeEffect, 0, self.parent, PATTACH_POINT_FOLLOW, "ATTACH_EYEOFLIE" .. i, self.parent:GetAbsOrigin(), true)
        --self:AddParticle(iEyeEffect, false, true, -1, false, false)
    --end
    
    if not self.bSwapped then
        self.parent:SetAngles(self.parent:GetAngles().x, 270, self.parent:GetAngles().z)
        self.parent:SetAbsAngles(self.parent:GetAngles().x, 270, self.parent:GetAngles().z)
        self.parent:SetLocalAngles(self.parent:GetAngles().x, 270, self.parent:GetAngles().z)
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        EmitGlobalSound("Gojo.domain_partial")
        Timers:CreateTimer(0.125, function()
            self.iEffect = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/domain_expansion_partial/test.test.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                           ParticleManager:SetParticleShouldCheckFoW(self.iEffect, false)
            self:AddParticle(self.iEffect, false, true, -1, false, false)
        end)
        
        local fDamage = self.ability:GetSpecialValueFor("damage")
        self.hDamageTable =  {  
                                 victim       = nil,
                                 attacker     = self.parent,
                                 damage       = fDamage,
                                 damage_type  = self.ability:GetAbilityDamageType(),
                                 ability      = self.ability,
                                --damage_flags = 0
                             }
        
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
        
        self:StartIntervalThink(6.0)
        self.bSwapped = true
    else
        self.iEffect = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/dimension/six_eyes_buff_hands.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        self:AddParticle(self.iEffect, false, true, -1, false, false)
        
        self.parent:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    end
end
function modifier_goju_domain_expansion:OnIntervalThink()
    local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(),  -- int, your team number
                                   self.parent:GetOrigin(),  -- point, center point
                                   nil,  -- handle, cacheUnit. (not known)
                                   FIND_UNITS_EVERYWHERE,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                   self.ability:GetAbilityTargetTeam(),  -- int, team filter
                                   self.ability:GetAbilityTargetType(),  -- int, type filter
                                   self.ability:GetAbilityTargetFlags(),  -- int, flag filter
                                   FIND_ANY_ORDER,  -- int, order filter
                                   false  -- bool, can grow cache
                                )
    for _, hEnemy in pairs(enemies) do
        if IsNotNull(hEnemy) and hEnemy ~= self.parent then
            hEnemy:RemoveModifierByName("nanaya_combo_attack")
            hEnemy:AddNewModifier(self.parent, self.ability, "modifier_goju_domain_expansion_debuff", { duration = 4.0 })
            self.hDamageTable.victim = hEnemy
            ApplyDamage(self.hDamageTable)
        end
    end
    
    self:StartIntervalThink(-1)
end
function modifier_goju_domain_expansion:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_domain_expansion:OnDestroy()
    if not IsServer() then return end
    
    self.parent:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
    StopGlobalSound("Gojo.domain_partial")
    
    -- Reapply modifier for duration
    if IsNotNull(self.parent)
        and self.parent:IsAlive()
        and not self.bIsActive
        and self.bSwapped then
        -- Maybe should use OnIntervalThink but do this instead because PEPEGA?????
        local hModifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_goju_domain_expansion", { duration = self.fDurationBuff, bIsActive = 1, bSwapped = 1 })
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_star_tier2", {duration = self.fDurationBuff, bSecondTheme = 1})
        self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
        Destroy__Particle(self.iEffect)
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
modifier_goju_domain_expansion_debuff = modifier_goju_domain_expansion_debuff or class({})

function modifier_goju_domain_expansion_debuff:IsHidden() return false end
function modifier_goju_domain_expansion_debuff:IsPurgeable() return false end
function modifier_goju_domain_expansion_debuff:RemoveOnDeath() return true end
function modifier_goju_domain_expansion_debuff:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_FROZEN]   = true,
                    }
    return state
end
function modifier_goju_domain_expansion_debuff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_goju_domain_expansion_debuff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_domain_expansion_debuff:OnDestroy()
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Expansion Full (F)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_domain_expansion_full_charge", "heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gojo_domain_full_thinker", "heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gojo_domain_full_thinker_out", "heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gojo_domain_full_thinker_in", "heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_domain_expansion_full = goju_domain_expansion_full or class({})

function goju_domain_expansion_full:OnSpellStart(self)
    local caster = self:GetCaster()
    local duration = 8.0
    local blast_radius = 2000
    local blast_speed = 350
    local blast_duration = blast_radius / blast_speed

    local blast_pfx =   ParticleManager:CreateParticle("particles/test/custom/domain_expansion_test/domain_expansion_cast.vpcf", PATTACH_ABSORIGIN, caster)
                        ParticleManager:SetParticleControl(blast_pfx, 0, caster:GetAbsOrigin())
                        ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
    
    local targets_hit = {}
    local current_radius = 0
    local tick_interval = 0.1
    local elapsed_time = 0 
    
    caster:StartGesture(ACT_DOTA_MEDUSA_STONE_GAZE)
    caster:RemoveModifierByName("modifier_goju_infinite_void")

    Timers:CreateTimer(tick_interval, function()

        AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), current_radius, 0.1, false)

        current_radius = current_radius + blast_speed * tick_interval
        elapsed_time = elapsed_time + tick_interval

        local nearby_units = FindUnitsInRadius( caster:GetTeamNumber(), 
                                                caster:GetAbsOrigin(), 
                                                nil, 
                                                current_radius, 
                                                DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                                FIND_ANY_ORDER, 
                                                false)

        for _, unit in pairs(nearby_units) do
            if not caster or not caster:IsAlive() then
                unit:RemoveModifierByName("modifier_domain_expansion_full_charge")
            end
        
            if not targets_hit[unit:entindex()] then
                local hit_pfx = ParticleManager:CreateParticle("particles/econ/events/newbloom_2015/shivas_guard_impact_nian2015.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
                                ParticleManager:SetParticleControl(hit_pfx, 0, unit:GetAbsOrigin())
                                ParticleManager:SetParticleControl(hit_pfx, 1, unit:GetAbsOrigin())
                                ParticleManager:ReleaseParticleIndex(hit_pfx)

                unit:AddNewModifier(caster, self, "modifier_domain_expansion_full_charge", {duration = blast_duration - elapsed_time})

                targets_hit[unit:entindex()] = true
            end
        end
        
        if not caster or not caster:IsAlive() then
            if blast_pfx then
                ParticleManager:DestroyParticle(blast_pfx, true) 
                ParticleManager:ReleaseParticleIndex(blast_pfx)
            end
            self.nFullDomain = 0
            return nil
        end

        if current_radius < blast_radius then
            return tick_interval
        end
       
    end)

    Timers:CreateTimer(blast_duration - 0.6, function()
        CreateModifierThinker(caster, self, "modifier_gojo_domain_full_thinker", {duration = duration}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
        if blast_pfx then
            ParticleManager:DestroyParticle(blast_pfx, true) 
            ParticleManager:ReleaseParticleIndex(blast_pfx)
        end
    end)

    EmitGlobalSound("Gojo.domain_full")
end
---------------------------------------------------------------------------------------------------------------------
modifier_gojo_domain_full_thinker = modifier_gojo_domain_full_thinker or class({})

function modifier_gojo_domain_full_thinker:IsHidden()             return true end
function modifier_gojo_domain_full_thinker:IsDebuff()             return false end
function modifier_gojo_domain_full_thinker:IsPurgable()           return false end
function modifier_gojo_domain_full_thinker:IsPurgeException()     return false end
function modifier_gojo_domain_full_thinker:RemoveOnDeath()        return true end
function modifier_gojo_domain_full_thinker:IsMarble()             return true end
function modifier_gojo_domain_full_thinker:IsMarbleException()    return true end
function modifier_gojo_domain_full_thinker:OnCreated()
    self:GetAbility().nFullDomain = 1
    if IsServer() then
        self.radius = 2000

        self.frametime = 0
        self.dmg_interval = 0.1
        self.damage = 50
        
        self:GetAbility():SetActivated(false)
        self:GetAbility():EndCooldown()
        self:GetCaster():RemoveGesture(ACT_DOTA_MEDUSA_STONE_GAZE)
        self:GetCaster():Stop()
        
        self.domain_expansion = ParticleManager:CreateParticle("particles/test/custom/domain_expansion_test/domain_expansion_main.vpcf", PATTACH_WORLDORIGIN, nil)
                                ParticleManager:SetParticleControl(self.domain_expansion, 0, self:GetParent():GetOrigin())
                                ParticleManager:SetParticleControl(self.domain_expansion, 1, Vector(self.radius, self.radius, 0))
                                ParticleManager:SetParticleShouldCheckFoW( self.domain_expansion, false )
                                
        EmitGlobalSound("Gojo.domain_full_finished")
        
        self:StartIntervalThink(0.01)
    end
end
function modifier_gojo_domain_full_thinker:OnIntervalThink()
    if IsServer() then
        if not self:GetCaster() or not self:GetCaster():IsAlive() or GetDistance(self:GetParent(), self:GetCaster()) > self.radius then
            return self:Destroy()
        end

        self.frametime = self.frametime + 0.01

        if self.frametime >= self.dmg_interval then
            self.frametime = 0

            local units = FindUnitsInRadius(self:GetParent():GetTeam(),
                                            self:GetParent():GetOrigin(), 
                                            nil, 
                                            self.radius, 
                                            DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                            DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, 
                                            0, 
                                            false)

            for _,unit in pairs(units) do
                if IsNotNull(unit) and unit ~= self:GetCaster() then
                    local damage_table = {  victim      = unit, 
                                            attacker    = self:GetCaster(),
                                            damage      = self.damage, 
                                            damage_type = self:GetAbility():GetAbilityDamageType(), 
                                            ability     = self:GetAbility()}

                    ApplyDamage(damage_table)
                end
            end
        end

        local units_resolve = FindUnitsInRadius(self:GetParent():GetTeam(),
                                                self:GetParent():GetAbsOrigin(), 
                                                nil, 
                                                99999, 
                                                DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                                                DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, 
                                                0, 
                                                false) 

        for _,unit in pairs(units_resolve) do
            if not unit or unit == self:GetCaster() then
                return nil
            end
            local distance = (self:GetParent():GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
            local special_duration = self:GetDuration() - self:GetElapsedTime()
            if distance > self.radius then
                if not unit:FindModifierByNameAndCaster("modifier_gojo_domain_full_thinker_out", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_gojo_domain_full_thinker_in", self:GetParent()) then
                    unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_gojo_domain_full_thinker_out", {duration = special_duration, radius = self.radius})
                end
            else
                if not unit:FindModifierByNameAndCaster("modifier_gojo_domain_full_thinker_in", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_gojo_domain_full_thinker_out", self:GetParent()) then
                    unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_gojo_domain_full_thinker_in", {duration = special_duration, radius = self.radius})
                end
            end
        end
    end
end
function modifier_gojo_domain_full_thinker:OnDestroy()
    self:GetAbility().nFullDomain = 0
    if IsServer() then
        if self.domain_expansion then
            ParticleManager:DestroyParticle(self.domain_expansion, false) 
            ParticleManager:ReleaseParticleIndex(self.domain_expansion)
        end
        if self:GetCaster():HasScepter() then
            self:GetAbility():SetActivated(true)
        end
        self:GetCaster():RemoveGesture(ACT_DOTA_MEDUSA_STONE_GAZE)
        self:GetAbility():StartCooldown(300 * self:GetParent():GetCooldownReduction())
        UTIL_Remove(self:GetParent())
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_gojo_domain_full_thinker_in = modifier_gojo_domain_full_thinker_in or class({})

function modifier_gojo_domain_full_thinker_in:IsHidden()                  return true end
function modifier_gojo_domain_full_thinker_in:IsDebuff()                  return true end
function modifier_gojo_domain_full_thinker_in:IsPurgable()                return false end
function modifier_gojo_domain_full_thinker_in:IsPurgeException()          return false end
function modifier_gojo_domain_full_thinker_in:RemoveOnDeath()             return true end
function modifier_gojo_domain_full_thinker_in:GetAttributes()             return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_gojo_domain_full_thinker_in:IsMarbleException()         return true end
function modifier_gojo_domain_full_thinker_in:CheckState()
    local hState =  {
                        [MODIFIER_STATE_ROOTED]   = true,
                        [MODIFIER_STATE_FROZEN]   = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_STUNNED]  = true,
                    }
    return not self.bIsLocked and hState
end
function modifier_gojo_domain_full_thinker_in:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    self.bIsLocked = self.parent:FindAbilityByName("goju_domain_expansion")

    if IsServer() then
        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius - 50
        self.old_pos = self:GetParent():GetAbsOrigin()

        self:StartIntervalThink(0.01)
    end
end
function modifier_gojo_domain_full_thinker_in:OnIntervalThink()
    if IsServer() then
        if not self:GetCaster() then
            self:Destroy()
        end
        if self:GetParent():IsInvulnerable() or self:GetParent():IsMagicImmune() then
            self:Destroy()
        end

        local distance  = (self:GetParent():GetAbsOrigin() - self.center):Length2D()
        --local distance2 = GetDistance(self.caster, self.parent)
        
        --self.bCanMove = (self.caster == self.parent)
                        --or (distance2 <= 200 
                            --and self.parent:GetTeamNumber() == self.caster:GetTeamNumber())

        if distance > self.radius then
            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            --FindClearSpaceForUnit(self:GetParent(), self.old_pos, false)
        end
    end
end
function modifier_gojo_domain_full_thinker_in:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_gojo_domain_full_thinker_out = modifier_gojo_domain_full_thinker_out or class({})

function modifier_gojo_domain_full_thinker_out:IsHidden()                 return true end
function modifier_gojo_domain_full_thinker_out:IsDebuff()                 return true end
function modifier_gojo_domain_full_thinker_out:IsPurgable()               return false end
function modifier_gojo_domain_full_thinker_out:IsPurgeException()         return false end
function modifier_gojo_domain_full_thinker_out:RemoveOnDeath()            return true end
function modifier_gojo_domain_full_thinker_out:GetAttributes()            return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_gojo_domain_full_thinker_out:IsMarbleException()        return true end
function modifier_gojo_domain_full_thinker_out:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 75
        self.old_pos = self:GetParent():GetAbsOrigin()

        self:StartIntervalThink(0.01)
    end
end
function modifier_gojo_domain_full_thinker_out:OnIntervalThink()
    if IsServer() then
        if not self:GetCaster() then
            self:Destroy()
        end
        if self:GetParent():IsInvulnerable() or self:GetParent():IsMagicImmune() then
            self:Destroy()
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance < self.radius then
            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            --FindClearSpaceForUnit(self:GetParent(), self.old_pos, false)
        end
    end
end
function modifier_gojo_domain_full_thinker_out:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_domain_expansion_full_charge = modifier_domain_expansion_full_charge or class({})

function modifier_domain_expansion_full_charge:IsHidden() return true end
function modifier_domain_expansion_full_charge:IsDebuff() return false end
function modifier_domain_expansion_full_charge:IsPurgable() return false end
function modifier_domain_expansion_full_charge:IsPurgeException() return false end
function modifier_domain_expansion_full_charge:RemoveOnDeath() return true end
function modifier_domain_expansion_full_charge:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,
                    [MODIFIER_STATE_UNSELECTABLE] = true,
                    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                    [MODIFIER_STATE_ROOTED] = true,}
    return state
end

---------------------------------------------------------------------------------------------------------------
-- Goju Hollow Purple (R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_hollow_purple_active","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_hollow_purple = goju_hollow_purple or class({})

function goju_hollow_purple:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function goju_hollow_purple:GetBehavior()
     return self:GetCaster():HasModifier("modifier_goju_hollow_purple_active") 
            and DOTA_ABILITY_BEHAVIOR_POINT
            or DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function goju_hollow_purple:GetCastPoint()
    return self:GetCaster():HasModifier("modifier_goju_hollow_purple_active")
           and 1.45
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
        StopGlobalSound("Gojo.hollow_purple_launch2")
        EmitGlobalSound("Gojo.hollow_purple_launched")
    end
end
function goju_hollow_purple:CreateHollowPurple()
    local hCaster      = self:GetCaster()
    local f__Radius    = self:GetSpecialValueFor("radius") or 325
    local i__Speed     = self:GetSpecialValueFor("movespeed") or 2500
    local f__Distance  = self:GetSpecialValueFor("distance") or 8000
    local f__ProjDmg   = self:GetSpecialValueFor("projectile_damage") or 4000
    
    local hExplosion =  {   
                          duration     = self:GetSpecialValueFor("duration"),
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
                          fProjDamage  = 4000,
                          bDestroy     = true,
                          bIsBlueOrb   = false,
                          fRadius      = f__Radius,
                          bIsRedOrb    = false
                     	}
                        
    local hProjectile = Goju_Create_Projectile(self, hCaster, hExplosion)
    EmitGlobalSound("Gojo.hollow_purple_launch2")
    
    return hProjectile
end
function goju_hollow_purple:OnAbilityPhaseInterrupted()
    self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
    StopSoundOn("Gojo.hollow_purple_launch", self:GetCaster())
    if IsNotNull(self.hHollowPurple) then
        self.hHollowPurple:RemoveModifierByName("modifier_gojo_projectile_thinker")
    end
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_hollow_purple_active = modifier_goju_hollow_purple_active or class({})

function modifier_goju_hollow_purple_active:IsHidden() return false end
function modifier_goju_hollow_purple_active:IsPurgeable() return false end
function modifier_goju_hollow_purple_active:IsPurgeException() return false end
function modifier_goju_hollow_purple_active:RemoveOnDeath() return true end
function modifier_goju_hollow_purple_active:IsAura() return true end
function modifier_goju_hollow_purple_active:CheckState()
    local state =   { 
                        [MODIFIER_STATE_STUNNED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                    }
    return not self.bIsActive and state
end
function modifier_goju_hollow_purple_active:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_HEALTH_BONUS,
                      MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                  }

    return funcs
end
function modifier_goju_hollow_purple_active:GetModifierHealthBonus()
    return self.iBonusHealth
end
function modifier_goju_hollow_purple_active:GetModifierSpellAmplify_Percentage()
    return self.iBonusSpellAmp
end
function modifier_goju_hollow_purple_active:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    self.iBonusHealth   = self.ability:GetSpecialValueFor("bonus_health")
    self.iBonusSpellAmp = self.ability:GetSpecialValueFor("bonus_spell_amp")
    
    if IsServer() and not self.bIsActive then
        Destroy__Particle(self.HollowPurpleEffect)
        self.HollowPurpleEffect = Goju_Hollow_Purple_Activate(self, self.parent)
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
        EmitGlobalSound("Gojo.purple_activate")
        Timers:CreateTimer(9, function()
            if IsNotNull(self.HollowPurpleEffect) then
                ParticleManager:SetParticleControl(self.HollowPurpleEffect, 2, Vector(25, 0, 0))
            end
        end)
        self.ability:EndCooldown()
        self:StartIntervalThink(14.0)
    end
end
function modifier_goju_hollow_purple_active:OnIntervalThink()
    if not IsServer() then return end
    
    self.bIsActive = true
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_goju_hollow_purple_active", { duration = 50.0 })
    self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1_END)
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_star_tier2", {duration = 50.0})
    --EmitGlobalSound("Gojo.purple_theme")
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
    if IsServer() then
        if IsNotNull(self.ability) and self.ability:IsFullyCastable() then
            self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
        end
    end
end


---------------------------------------------------------------------------------------------------------------
-- Domain Expansion Abilities
---------------------------------------------------------------------------------------------------------------
local tGestures = {
                      ACT_DOTA_POOF_END,
                      ACT_DOTA_CAST_ABILITY_ROT,
                      ACT_DOTA_CAST_ABILITY_7,
                      ACT_DOTA_ATTACK,
                      ACT_DOTA_ATTACK2,
                      ACT_DOTA_CAST_ALACRITY_ORB,
                  }
                  
--[[local TableContains = function(hTable, Value, sType)
    if type(hTable) == "table" 
        and Value and sType then
        for _, val in pairs(hTable) do
            if type(Value) == sType
                and type(val) == sType 
                and Value == val then
                return true
            end
        end
    end
    return false
end]]--

local RemoveAllAndOrStartGesture = function(hCaster, iGesture, fAnimRate)
    if IsNotNull(hCaster) then
        local bIsInTable = false
        for _, i__Gesture in pairs(tGestures) do
            if bIsInTable == false
                and type(iGesture) == "number"
                and i__Gesture == iGesture then
                bIsInTable = true               
            end
            hCaster:RemoveGesture(i__Gesture)
        end
        --=======================================================--
        -- PEPE PEPE PEPE PEPE PEPE PEPE PEPE PEPE PEPE PEPE PEPE P
        --=======================================================--
        if type(iGesture) == "number" then
            if bIsInTable == false then
                table.insert(tGestures, iGesture)
            end
            if type(fAnimRate) == "number" then
                hCaster:StartGestureWithPlaybackRate( iGesture, 
                                             math.abs(fAnimRate) )
            else
                hCaster:StartGesture(iGesture)
            end
        end
    end
end

local DirectionChangeToCenter = function(vPosition)
    local vDirection = GetDirection(Vector(0, 0, 0), vPosition)
    return vDirection
end

function GojoStartMotion(self)
    if IsNotNull(self)
        and IsNotNull(self.parent)
        and IsNotNull(self.caster)
        and IsNotNull(self.ability)
        and self.parent:IsAlive() then
        
        --===============================================================================--
        local hCaster         = self.caster
        local hParent         = self.parent
        local hAbility        = self.ability
        local vDirection      = self.vDirection
        local vDirection2     = self.vDirection2
        if hParent ~= hCaster then
            --print(hAbility:GetAbilityName())
            hAbility = hCaster:FindAbilityByName(hTABLE_ABILITIES2["1"])
            --print(hAbility:GetAbilityName())
        end
        --===============================================================================--
        if hAbility.Settings then
            hAbility:Settings(self)
        else
            return self:Destroy()
        end
        --===============================================================================--
        self.fAttackDelayCopy = self.fAttackDelay
        self.fHitBoxDurCopy   = 0
        self.fStageDelayCopy  = 0
        self.iAttackCountCopy = self.iAttackCount
        self.fLastAttDelayCopy = 0
        --===============================================================================--
        
        -- Attacks with a Hitbox Duration can hit many times, if Hit Once Per Attack is enabled, then create table to store enemies hit for checking.
        if self.bHitOncePerAtt then 
            for i = 1, self.iAttackCount do
                self["hEnemiesHitTable" .. i] = self["hEnemiesHitTable" .. i] or {}
            end
        end
        
        -- Create certain variables for use in the script, depending on who is Parent and Caster
        local iGetTeam   = hParent:GetTeam()
        local hInflictor = hParent
        -- If the Parent is not the Caster then act as a knockback modifier that hits people
        if hParent ~= hCaster then
            self.iAttackCount      = 1
            self.fAttackDelay      = 0
            self.fSpeed            = 900
            self.fHitBoxDur        = 99.999
            self.iAutoAttacksDone  = 1
            self.bDelayFirstAtt    = false
            self.bDelayLastAtt     = false
            iGetTeam               = hCaster:GetTeam()
            hInflictor             = hCaster
            vDirection             = -self.vDirection2
            
            local bValue = self.ability:GetSpecialValueFor("is_vertical") > 0
            if type(bValue) == "boolean" then
                self.bAscendorDescend = bValue or "Normal"
            end
            --print("TEST HMMMMM")
            --print(self.bIsLinear)
        else
            self.bAscendorDescend = "Normal"
        end
        
        
        -- Create Callback Function for Linear Motion, this is motion that does not track enemies and travels a certain distance.
        local fCallBackLinear = function(me, dt)
            if self.fDistance < 0 then
                if hParent == hCaster then
                    self:Destroy()
                end
                return
            end
            
            -- Get all necessary values for Linear Motion
            local vOrigin = hParent:GetAbsOrigin()
            local fExtra  = self.bAscendorDescend == false and 2.5 or 1
            local fSpeed  = (self.fSpeed * fExtra) * dt
            local vPos    = vOrigin + vDirection * fSpeed
            
            -- Check distance and move the player
            self.fDistance = self.fDistance - fSpeed
            hParent:SetOrigin(vPos)
            
            -- Make sure the path is traversable or move towards the center
            if GridNavPathIsTraversable(self, vPos, 15) == false then
                vDirection = DirectionChangeToCenter(vPos)
                hParent:SetForwardVector(vDirection, true)
                hParent:FaceTowards(vDirection)
            end
            
            -- Get the delay between each attack and reduce it
            self.fAttackDelayCopy = self.fAttackDelayCopy - dt
            
            -- If First Attack should be delayed and Current Attack is first attack then add delay.
            -- Else if First Attack should not be delayed and Current Attack is first attack then remove delay.
            if type(self.bDelayFirstAtt) == "boolean" and self.iAttackCount >= self.iAttackCountCopy then 
                self.fAttackDelayCopy = self.fFirstAttDelay > 0
                                        and self.fFirstAttDelay
                                        or self.fAttackDelay
                if not self.bDelayFirstAtt then self.fAttackDelayCopy = 0 end
                self.bDelayFirstAtt = "done"
            end
            
            -- Do the same thing for last attack delay
            if type(self.bDelayLastAtt) == "boolean" and self.iAttackCount == 1 then 
                self.fAttackDelayCopy = self.fLastAttDelay > 0
                                        and self.fLastAttDelay
                                        or self.fAttackDelay
                if not self.bDelayLastAtt then self.fAttackDelayCopy = 0 end
                self.bDelayLastAtt = "done"
            end
            
            -- If the delay is 0 and there are more than 0 attacks left then do stuff
            if self.fAttackDelayCopy <= 0 and self.iAttackCount > 0 then
                -- Using FindUnitsInLine to detect enemies in front of us
                local hEnemies = FindUnitsInLine( iGetTeam, --team 
                                                  vPos, --startPos, 
                                                  vPos + hParent:GetForwardVector() * 50, --endPos
                                                  nil, --cacheUnit 
                                                  150, --width 
                                                  DOTA_UNIT_TARGET_TEAM_ENEMY, --teamFilter: DOTA_UNIT_TARGET_TEAM 
                                                  DOTA_UNIT_TARGET_ALL, --typeFilter: DOTA_UNIT_TARGET_TYPE
                                                  0 ) --flagFilter: DOTA_UNIT_TARGET_FLAGS  

                -- Particle Effects for Gojo
                if hParent == hCaster then
                    local ParticleExp = "particles/heroes/anime_hero_gojo/kick/kick1_arc.vpcf"
                    local GinFx = ParticleManager:CreateParticle(ParticleExp, PATTACH_ABSORIGIN_FOLLOW, hParent)
                    ParticleManager:ReleaseParticleIndex(GinFx)
                end                
            
                -- For each enemy found do somethhing
                for _, hEnemy in pairs(hEnemies) do
                    -- Enemy should be a valid target
                    if IsNotNull(hEnemy) and hEnemy ~= hParent then
                        -- Check if Enemy is already hit by this attack
                        if not self["hEnemiesHitTable" .. self.iAttackCount][tostring(hEnemy:entindex())] then
                            local fDistance     = GetDistance(hEnemy, hParent)
                            --local fPushDistance = hEnemy:GetAbsOrigin() + vDirection * RemapValClamped(fDistance, 200, 0, 300, 500 ) -- Clamped Value
                            self.hKnockBackTable.center_x           = hEnemy:GetAbsOrigin().x - vDirection.x * 100
                            self.hKnockBackTable.center_y           = hEnemy:GetAbsOrigin().y - vDirection.y * 100
                            self.hKnockBackTable.center_z           = 0
                            self.hKnockBackTable.knockback_distance = RemapValClamped(fDistance, 200, 0, 300, 500 ) -- Clamped Value
                            hEnemy:RemoveModifierByName("modifier_knockback")
                        
                            -- Push the enemy hero back
                            --hEnemy:SetOrigin(fPushDistance)
                            hEnemy:AddNewModifier(hInflictor, hAbility, "modifier_knockback", self.hKnockBackTable, hEnemy:IsOpposingTeam(self.parent:GetTeamNumber()))
                            
                            -- Perform a specified amount of basic attacks on the enemy hero (Can trigger items)
                            for i = 1, self.iAutoAttacksDone do
                                hInflictor:PerformAttack(hEnemy, true, true, true, true, false, false, true)
                            end
                            
                            -- Stun the Enemy Hero
                            hEnemy:AddNewModifier(hInflictor, self.ability, "modifier_stunned", {duration = 1.0})
                            
                            -- If enabled Hit Once Per Attack then store the enemy in the table
                            if self.bHitOncePerAtt then
                                self["hEnemiesHitTable" .. self.iAttackCount][tostring(hEnemy:entindex())] = true
                            end
                            
                            -- Effects
                            local hit_particle = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/nanaya_work_22.vpcf", PATTACH_ABSORIGIN, hEnemy)
                            ParticleManager:ReleaseParticleIndex(hit_particle)
                            
                            hParent:EmitSound("nanaya.slash")
                            --FindClearSpaceForUnit( hEnemy, hEnemy:GetAbsOrigin(), true )
                        end
                    end                        
                end
                
                -- Increase the Hit Box Duration
                self.fHitBoxDurCopy = self.fHitBoxDurCopy + 0.03
                -- If the Hit Box Duration is equal to the set duration then do stuff
                if self.fHitBoxDurCopy >= self.fHitBoxDur then
                    -- Reset the Attack Delay to its original value
                    self.fAttackDelayCopy = self.fAttackDelay 
                    -- Lower the attack counter after the attack has happened                        
                    self.iAttackCount = self.iAttackCount - 1
                    -- Reset the Hitbox Duration
                    self.fHitBoxDurCopy = 0
                end                    
            end                 
        end
        
        
        -- Create Callback Function for Tracking Motion, this is motion that tracks enemies.
        local fCallBackTracking = function(me, dt)
            -- EYE movement logic pog
            local vCurPos     = hParent:GetAbsOrigin()
            local vDirection  = GetDirection(self.hTarget, vCurPos)
            local fDistance   = GetDistance(self.hTarget, vCurPos)
            local fUnitsPerDt = self.fSpeed * dt
            local vNextPos    = vCurPos + vDirection * fUnitsPerDt
            vNextPos = fDistance <= 100
                       and vCurPos
                       or vNextPos
                       
            -- Start a Gesture while moving (Should be a looping Gesture)
            if self.bHasTrackingAnim then
                RemoveAllAndOrStartGesture(hParent, ACT_DOTA_POOF_END)
                self.bHasTrackingAnim = false
            end
            
            -- Check move the player and face the target
            if self.FirstStage then
                hParent:SetForwardVector(vDirection, true)
                hParent:SetOrigin(vNextPos)
            end
            
            hParent:FaceTowards(self.hTarget:GetOrigin())
            
            -- Do things when we get close to the target
            if fDistance <= 100 then
                if self.FirstStage then
                    -- Start a Gesture when hitting the enemy
                    if self.bHasHitAnim then
                        RemoveAllAndOrStartGesture(hParent, ACT_DOTA_TRICKS_END)
                    end
                    
                    -- Add motion modifier to enemy and register it
                    self.hTarget:RemoveModifierByName("modifier_goju_domain_motion")
                    self.hTarget:RemoveModifierByName("modifier_knockback")
                        
                    self.hModifierEnemy = self.hTarget:AddNewModifier(hParent, hAbility, "modifier_goju_domain_motion", { duration = self.fEnemyDuration })
                
                    -- Perform a specified amount of basic attacks on the enemy hero (Can trigger items)
                    for i = 1, self.iAutoAttacksDone do
                        hParent:PerformAttack(self.hTarget, true, true, true, true, false, false, true)
                    end
                    
                    -- Play Particle/Sound Effects
                    local iImpactEffect =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/gogeta_punch_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
                                           ParticleManager:SetParticleControl(iImpactEffect, 1, self.hTarget:GetAbsOrigin())
                    EmitSoundOn("Gojo.hit1", hParent)
                
                    -- Add the knockback modifier to the enemy hero
                    --self.hTarget:AddNewModifier(hParent, self.ability, "modifier_goju_domain_motion", { duration = 2.0 })
                    
                    -- Begin second stage
                    self.FirstStage = false
                    self.SecondStage = true
                    
                    -- Idk
                    --print(self.fAttackDelay)
                    self.fAttackDelayCopy = self.fAttackDelay
                    --print(self.iAttackCount)
                    
                    -- If not 2 stages or more then destroy else refresh duration on self
                    if self.iStagesCount <= 1 then
                        self.bNotRemove = true
                        self:Destroy()
                        return
                    else
                        self:SetDuration(self.fEnemyDuration, true)
                    end
                end
            end
                
            -- Increment time before next stage
            self.fStageDelayCopy = self.fStageDelayCopy + 0.03
                
            -- If second stage and second stage timer is ready then do stuff
            if self.SecondStage and self.fStageDelayCopy >= self.fStageDelay then
                -- Remove modifier faster after final attack        
                if self.fLastAttDelayCopy >= self.fLastAttDelay + 0.2 then
                    self:Destroy()
                    return
                end
                -- If more than 0 attacks then chase the target
                if self.iAttackCount > 0 then
                    hParent:SetOrigin(self.hTarget:GetOrigin() - hParent:GetForwardVector() * 75)
                end
                
                -- If Attacks greater than 0 and delay is 0 then begin attacking
                if self.fAttackDelayCopy <= 0 and self.iAttackCount > 0 then
                    -- Remove current Gestures
                    if self.fLastAttDelayCopy <= 0 and self.iAttackCount == 1 then
                        RemoveAllAndOrStartGesture(hParent)
                    end
                    
                    -- Apply Attacks
                    if self.iAttackCount > 1 then
                        self.parent:StartGestureWithPlaybackRate(tGestures[RandomInt(4, 6)], 1.5)
                        for i = 1, self.iAutoAttacksDone do
                            hParent:PerformAttack(self.hTarget, true, true, true, true, false, false, true)
                        end
                        self.hModifierEnemy.fDistance = 100
                        local iImpactEffect =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/gojo_shockwave.vpcf", PATTACH_WORLDORIGIN, nil)
                                               ParticleManager:SetParticleControl(iImpactEffect, 0, self.parent:GetAbsOrigin()) 
                        EmitSoundOn("Gojo.hit2", hParent)                        

                    -- Apply final attack
                    elseif self.iAttackCount == 1 then
                        if not self.bLastAtt then
                            hParent:StartGestureWithPlaybackRate(tGestures[2], 1)
                            EmitSoundOn("Gojo.hit3", hParent)
                            self.bLastAtt = true
                        end
                        -- Check for delay on the final attack, this is added to sync the animation with the hit
                        if self.fLastAttDelayCopy >= self.fLastAttDelay then
                            for i = 1, self.iAutoAttacksDone + 1 do
                                hParent:PerformAttack(self.hTarget, true, true, true, true, false, false, true)
                            end

                            local iImpactEffect =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/gojo_shockwave2.vpcf", PATTACH_WORLDORIGIN, nil)
                                                   ParticleManager:SetParticleControl(iImpactEffect, 0, self.parent:GetAbsOrigin())
                            local vEnemyPos  = self.hModifierEnemy.parent:GetOrigin()
                            local fEnemyH    = vEnemyPos.z
                            local vFinalLoc  = vEnemyPos - self.hModifierEnemy.vDirection2 * 1000
                            local fFinalG    = GetGroundHeight(vFinalLoc, self.hModifierEnemy.parent)
                            local fHeightDif = fEnemyH - fFinalG -- Get the Height Difference
                             -- Divide the Distance by the Speed to get the Horizontal Time (fDistance = 1000 / fSpeed = 2250 ~ 0.44)
                             -- Then Divide the (Height Difference by the Horizontal Time) and by our Initial Vertical Speed = 400
                             -- This gives us a multipler for Vertical Speed proportional to our Horizontal Speed
                             -- TODO: Adjust if you want for dynamic values, but i think current are perfect so hard coding
                            self.hModifierEnemy.fVerticalTime = math.max( (fHeightDif / 0.44) / 400, 1.5 )
                            self.hModifierEnemy.fDistance = 1000
                            self.hModifierEnemy.bAscendorDescend = false
                            self.bFinalAttack = true
                            print(fHeightDif)
                        end
                       
                        --print(self.fLastAttDelay)
                        --print(self.fLastAttDelayCopy)
                    end

                    -- Reduce attack counter
                    if self.iAttackCount == 1 and self.fLastAttDelayCopy < self.fLastAttDelay + 0.03 then
                    else
                        self.iAttackCount = self.iAttackCount - 1
                    end

                    -- Reset attack delay
                    self.fAttackDelayCopy = self.fAttackDelay 
                end
                
                -- Reduce attack delay
                self.fAttackDelayCopy  = self.fAttackDelayCopy - 0.03
                
                -- Reduce final attack delay
                if self.iAttackCount <= 1 then
                    self.fLastAttDelayCopy = self.fLastAttDelayCopy + 0.03
                end
            end
        end

        
        self.UpdateHorizontalMotion = function(self, me, dt)
            if hCaster == hParent and self.bIsTracking then
                if not IsNotNull(self.hTarget)
                    or not self.hTarget:IsAlive()
                    or ( self.SecondStage 
                         and not self.hTarget:HasModifier("modifier_goju_domain_motion") ) then
                    self:Destroy()
                    return                    
                end
            end
        
            if self.bIsLinear then
                fCallBackLinear(me, dt)
            elseif self.bIsTracking then
                fCallBackTracking(me, dt)
            else
            -- Do Nothing
            end            
        end
        
        
        -- VERTICAL Motion
        ------------------------------------------------------------------------------------------------------
        ------------------------------------------------------------------------------------------------------
        
        local AscendOrDescend = function(bAscend)
            if IsNotNull(hParent) then
                
                bAscend = bAscend or false
                
                if type(bAscend) ~= "boolean" then
                    local vOrigin    = hParent:GetOrigin()
                    local vGroundPos = GetGroundPosition(vOrigin, hParent)
                    hParent:SetOrigin(Vector(vOrigin.x, vOrigin.y, vGroundPos.z))
                    return
                end
                
                local vCurPos    = hParent:GetOrigin()
                local vGroundPos = GetGroundPosition(vCurPos, hParent)
                local fExtra     = self.fVerticalTime 
                local vCurHeight = bAscend
                                   and vCurPos.z + self.fHeightOffset
                                   or vCurPos.z - self.fHeightOffset * fExtra
                
                if vCurPos.z <= vGroundPos.z and not bAscend then
                    vCurHeight = vGroundPos.z
                    if not self.iStompEffect then
                        self.iStompEffect =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/gojo_land_punch_stomp2.vpcf", PATTACH_WORLDORIGIN, nil)
                                             ParticleManager:SetParticleControl(self.iStompEffect, 0, self.parent:GetAbsOrigin())     
                        self:AddParticle(self.iStompEffect, false, false, -1, false, false)
                    end
                end
                
                if bAscend then
                    vCurPos.z = vCurPos.z <= 400
                                and vCurHeight
                                or vCurPos.z
                else
                    vCurPos.z = vCurHeight
                end
            
                hParent:SetOrigin(vCurPos) 
            end
        end
        
        local fCallBackLinearVertical = function(me, dt, bUporDown)
            if hParent == hCaster then
                AscendOrDescend("Test")
            else
                AscendOrDescend(bUporDown)
            end
        end
        
        local fCallBackTrackingVertical = function(me, dt)
            if hParent ~= hCaster then return end
            
            if self.FirstStage then
                local vCurPos    = hParent:GetOrigin()
                local vGroundPos = GetGroundPosition(vCurPos, hParent)
                hParent:SetOrigin(vGroundPos)
            end
            if self.SecondStage and self.fStageDelayCopy >= self.fStageDelay then
                if self.bFinalAttack then
                    hParent:SetOrigin(hParent:GetOrigin())
                else
                    hParent:SetOrigin(self.hTarget:GetOrigin())
                end
            end
        end
        
        self.UpdateVerticalMotion = function(self, me, dt)
            if self.bIsLinear then
                fCallBackLinearVertical(me, dt, self.bAscendorDescend)
            elseif self.bIsTracking then
                fCallBackTrackingVertical(me, dt)
            else
            -- Do Nothing
            end   
        end

    end
end



LinkLuaModifier("modifier_goju_domain_motion","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_BOTH)

modifier_goju_domain_motion = modifier_goju_domain_motion or class ({})

function modifier_goju_domain_motion:IsHidden() return false end
function modifier_goju_domain_motion:IsPurgeable() return false end
function modifier_goju_domain_motion:RemoveOnDeath() return true end
function modifier_goju_domain_motion:CheckState()
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
function modifier_goju_domain_motion:OnCreated(hTable)
    if IsServer() then
        self.caster  = self:GetCaster()
        self.parent  = self:GetParent()
        self.ability = self:GetAbility()
        
        --self.fGameTime    = GameRules:GetGameTime()
        self.vPoint       = self.vPoint or self.ability:GetCursorPosition()
        self.hTarget      = self.hTarget or self.ability:GetCursorTarget()
        self.vDirection   = self.vDirection or (self.vPoint - self.parent:GetAbsOrigin()):Normalized()
        self.vDirection2  = self.vDirection2 or (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
        
        self.FirstStage     = self.FirstStage or true
        self.SecondStage    = self.SecondStage or false
        self.hModifierEnemy = self.hModifierEnemy or nil
        self.fHeightOffset  = 400 * 0.03
        self.fVerticalTime  = 2.27
        self.bFinalAttack   = self.bFinalAttack or nil
        
        self.hKnockBackTable = {
                                    should_stun        = 1,
                                    knockback_duration = 0.2,
                                    duration           = 1,
                                    knockback_distance = 0,
                                    knockback_height   = 0,
                                    center_x           = nil,
                                    center_y           = nil,
                                    center_z           = nil
                               }
        
        GojoStartMotion(self)
        
        if self:ApplyHorizontalMotionController() == false 
            or self:ApplyVerticalMotionController() == false then 
            self:Destroy()
        end
        
    end
end
function modifier_goju_domain_motion:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_goju_domain_motion:OnVerticalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_goju_domain_motion:OnDestroy()
    if IsServer() then
        if self.parent == self.caster and not self.bNotRemove then
            RemoveAllAndOrStartGesture(self.parent)
        end
        if self.SecondStage and self.iStagesCount > 1 and IsNotNull(self.parent) and self.parent:IsAlive() then
            print("TESTING")
            local hAbility = self.parent:FindAbilityByName("goju_infinite_void")
            if IsNotNull(hAbility) and type(hAbility.Blink) == "function" then
                hAbility:Blink(self.parent, self.parent:GetOrigin() + RandomVector(1))
            end
        end
    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (Q)
---------------------------------------------------------------------------------------------------------------
goju_kick1 = goju_kick1 or class ({})

function goju_kick1:OnSpellStart()
    local hCaster = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("duration")
    
    local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_motion", { duration = fDuration }) 
    
    --GojoStartMotion(hModifier)
end
function goju_kick1:Settings(self)
    --===============================================================================--
    self.bIsLinear        = true
    self.bIsTracking      = false
    self.fEnemyDuration   = 0
    --===============================================================================--
    self.bDelayFirstAtt   = true
    self.fFirstAttDelay   = 0.09
    self.bDelayLastAtt    = true
    self.fLastAttDelay    = 0
    self.bHitOncePerAtt   = true
    self.bAscendorDescend = false
    --===============================================================================--
    self.fDistance        = 850
    self.fSpeed           = 1350
    self.iAttackCount     = 2
    self.fAttackDelay     = 0.20
    self.fHitBoxDur       = 0.09
    self.iAutoAttacksDone = 2
    --===============================================================================--
    self.iStagesCount     = 1
    self.fStageDelay      = 0
    --===============================================================================--
    self.bHasTrackingAnim = false
    self.bHasHitAnim      = false
    --===============================================================================--
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (W)
---------------------------------------------------------------------------------------------------------------
goju_kick2 = goju_kick2 or class (goju_kick1)
function goju_kick2:Settings(self)
    --===============================================================================--
    self.bIsLinear        = false
    self.bIsTracking      = true
    self.fEnemyDuration   = 2.0
    --===============================================================================--
    self.bDelayFirstAtt   = false
    self.fFirstAttDelay   = 0
    self.bDelayLastAtt    = false
    self.fLastAttDelay    = 0
    self.bHitOncePerAtt   = false
    self.bAscendorDescend = false
    --===============================================================================--
    self.fDistance        = 0
    self.fSpeed           = 2000
    self.iAttackCount     = 1
    self.fAttackDelay     = 0
    self.fHitBoxDur       = 0
    self.iAutoAttacksDone = 4
    --===============================================================================--
    self.iStagesCount     = 1
    self.fStageDelay      = 0
    --===============================================================================--
    self.bHasTrackingAnim = true
    self.bHasHitAnim      = true
    --===============================================================================--
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (D)
---------------------------------------------------------------------------------------------------------------
goju_kick3 = goju_kick3 or class (goju_kick1)
function goju_kick3:Settings(self)
    --===============================================================================--
    self.bIsLinear        = false
    self.bIsTracking      = true
    self.fEnemyDuration   = 3.5
    --===============================================================================--
    self.bDelayFirstAtt   = false
    self.fFirstAttDelay   = 0
    self.bDelayLastAtt    = true
    self.fLastAttDelay    = 0.8
    self.bHitOncePerAtt   = false
    self.bAscendorDescend = true
    --===============================================================================--
    self.fDistance        = 0
    self.fSpeed           = 4000
    self.iAttackCount     = 3
    self.fAttackDelay     = 0.2
    self.fHitBoxDur       = 0
    self.iAutoAttacksDone = 2
    --===============================================================================--
    self.iStagesCount     = 2
    self.fStageDelay      = 0.8
    --===============================================================================--
    self.bHasTrackingAnim = false
    self.bHasHitAnim      = false
    --===============================================================================--
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_domain_vertical","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_VERTICAL)

goju_kick4 = goju_kick4 or class ({})

function goju_kick4:GetAOERadius()
    return 400
end
function goju_kick4:OnSpellStart()
    local hCaster    = self:GetCaster()
    local vCursorPos = self:GetCursorPosition()
    local fDuration  = 4.0
    
    local hModifier  = hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_vertical", { duration = fDuration }) 
end


---------------------------------------------------------------------------------------------------------------
modifier_goju_domain_vertical = modifier_goju_domain_vertical or class ({})

function modifier_goju_domain_vertical:IsHidden() return false end
function modifier_goju_domain_vertical:IsPurgeable() return false end
function modifier_goju_domain_vertical:RemoveOnDeath() return true end
function modifier_goju_domain_vertical:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                        [MODIFIER_STATE_INVULNERABLE] = true,
                    }
    return state
end
function modifier_goju_domain_vertical:OnCreated(hTable)
    if IsServer() then
        self.caster    = self:GetCaster()
        self.parent    = self:GetParent()
        self.ability   = self:GetAbility()
        
        self.bDealDmg  = false
        
        self.vPosition   = self.ability:GetCursorPosition()
        self.vPosition.z = 2000
        
        self.parent:SetOrigin(self.vPosition)
        self.vPosCheck   = self.parent:GetOrigin().z - GetGroundHeight(self.parent:GetOrigin(), self.parent)
        
        self.hDamageTable =  {  
                                 victim       = nil,
                                 attacker     = self.parent,
                                 damage       = 200,
                                 damage_type  = self.ability:GetAbilityDamageType(),
                                 ability      = self.ability,
                                --damage_flags = 0
                             }
                             
        self.hKnockBackTable = {
                                    should_stun        = 1,
                                    knockback_duration = 1,
                                    duration           = 1,
                                    knockback_distance = 20,
                                    knockback_height   = 200,
                                    center_x           = nil,
                                    center_y           = nil,
                                    center_z           = nil
                               }
                               
        RemoveAllAndOrStartGesture(self.parent, ACT_DOTA_POOF_END)
        
        if self:ApplyVerticalMotionController() == false then 
            self:Destroy()
        end
    end
end
function modifier_goju_domain_vertical:UpdateVerticalMotion(me, dt)
    if IsServer() then
        if IsNotNull(self.parent) and self.vPosCheck > 0 then
            self:Descend(me, dt)
        else
            self:Destroy()
        end
    end
end
function modifier_goju_domain_vertical:Descend(me, dt)
    local vOrigin  = me:GetOrigin()
    local vGroundP = GetGroundPosition(vOrigin, me)
    local fSpeed   = 3000 * dt
    
    local vNextPos = vOrigin.z <= vGroundP.z
                     and vOrigin
                     or vOrigin - Vector( 0, 0, fSpeed )              
    
    me:SetOrigin(vNextPos)
    
    if vNextPos == vOrigin then 
        self.bDealDmg = vOrigin
        self:Destroy()
        return
    end
end
function modifier_goju_domain_vertical:DealAOEDmg()
    local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(),  -- int, your team number
                                   self.parent:GetOrigin(),  -- point, center point
                                   nil,  -- handle, cacheUnit. (not known)
                                   800,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                   self.ability:GetAbilityTargetTeam(),  -- int, team filter
                                   self.ability:GetAbilityTargetType(),  -- int, type filter
                                   self.ability:GetAbilityTargetFlags(),  -- int, flag filter
                                   FIND_ANY_ORDER,  -- int, order filter
                                   false  -- bool, can grow cache
                                )
                                
    self.iStompEffect = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/gojo_land_punch_stomp.vpcf", PATTACH_WORLDORIGIN, nil)
                        ParticleManager:SetParticleControl(self.iStompEffect, 0, self.parent:GetAbsOrigin())     
    self:AddParticle(self.iStompEffect, false, false, -1, false, false)
                                
    self.hKnockBackTable.center_x = self.bDealDmg.x
    self.hKnockBackTable.center_y = self.bDealDmg.y
    self.hKnockBackTable.center_z = self.bDealDmg.z
    
    for _, hEnemy in pairs(enemies) do
        if IsNotNull(hEnemy) then
            hEnemy:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, hEnemy:IsOpposingTeam(self.parent:GetTeamNumber()))
            self.hDamageTable.victim = hEnemy
            for i = 1, 4 do
                self.parent:PerformAttack(hEnemy, true, true, true, true, false, false, true)
            end
            ApplyDamage(self.hDamageTable)
        end
    end
    
    EmitSoundOn("Gojo.land_punch", self.parent)
    EmitSoundOn("Gojo.land_punch_impact", self.parent)
end
function modifier_goju_domain_vertical:OnVerticalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_goju_domain_vertical:OnDestroy()
    if IsServer() then
        if self.bDealDmg then
            self:DealAOEDmg()
        end
        RemoveAllAndOrStartGesture(self.parent, ACT_DOTA_CAST_ICE_WALL, 1.5)
    end
end



---------------------------------------------------------------------------------------------------------------
-- Gojo Six Eyes Active Modifier
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_item_six_eyes_active","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_six_eyes_active = modifier_item_six_eyes_active or class({})

function modifier_item_six_eyes_active:IsHidden() return false end
function modifier_item_six_eyes_active:RemoveOnDeath() return true end
function modifier_item_six_eyes_active:IsDebuff() return false end
function modifier_item_six_eyes_active:IsPurgable() return false end
function modifier_item_six_eyes_active:CheckState()
    local func = {
                     [MODIFIER_STATE_INVULNERABLE] = true,
                     [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                     [MODIFIER_STATE_STUNNED] = true,
                     [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                 }
    return not self.bIsActive and func
end
function modifier_item_six_eyes_active:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        if not IsNotNull(self.parent) then self:Destroy() return end
        
        self.ability:EndCooldown()
        self.parent:StartGesture(ACT_DOTA_TINKER_REARM2)
        EmitGlobalSound("Gojo.six_eyes")
        self.parent:SetBodygroupByName("eye_area", 1)
        
        local particle_cast = "particles/heroes/anime_hero_gojo/dimension/six_eyes_buff.vpcf"

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            1,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "ATTACH_EYEOFLIE1",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            2,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "ATTACH_EYEOFLIE2",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )

        -- buff particle
        self:AddParticle(
            effect_cast,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
        )
        
        self:StartIntervalThink(1.0)
    end
end
function modifier_item_six_eyes_active:OnIntervalThink()
    self.bIsActive = true
    self:StartIntervalThink(-1)
end
function modifier_item_six_eyes_active:OnDestroy()
    self.bIsActive = false
    if IsServer() then
        self.parent:SetBodygroupByName("eye_area", 0)
        self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
    end
end



---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_red_explosion_stun","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

modifier_goju_red_explosion_stun = modifier_goju_red_explosion_stun or class ({})

function modifier_goju_red_explosion_stun:IsHidden() return false end
function modifier_goju_red_explosion_stun:IsPurgeable() return false end
function modifier_goju_red_explosion_stun:RemoveOnDeath() return true end
function modifier_goju_red_explosion_stun:CheckState()
    local state =   { 
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
    return state
end


---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_vision","heroes/anime_hero_gojo.lua", LUA_MODIFIER_MOTION_NONE)

modifier_goju_vision = modifier_goju_vision or class({})

function modifier_goju_vision:IsHidden() return false end
function modifier_goju_vision:IsDebuff() return false end
function modifier_goju_vision:IsStunDebuff() return false end
function modifier_goju_vision:IsPurgable() return false end
function modifier_goju_vision:CheckState()
    local state = {
                      [MODIFIER_STATE_PROVIDES_VISION] = true,
                  }
    return state
end

