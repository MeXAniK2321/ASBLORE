
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
local GridNavPathIsTraversable = function(self, vPos, iPointsNotTraversable)
    if IsNotNull(self) 
        and IsNotNull(self.parent) then
        local hParent         = self.parent
        local vPosition       = vPos or hParent:GetOrigin()
        iPointsNotTraversable = iPointsNotTraversable or 10
        self.iPointsTraverse  = self.iPointsTraverse or 0
    
        -- Assuming that you are moving at a speed of 900 units every second at a 0.03s interval and iPointsNotTraversable = 33, you would check if a distance of 900 is traversable.
        -- Ideally should check if a distance of 250-300 is traversable for optimal behavior i think ?
        if not GridNav:IsTraversable(vPosition) or GridNav:IsBlocked(vPosition) then
            -- Prevent checking the same position if standing in place
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
        
        --print("Grid Nav Path Test: " .. self.iPointsTraverse)
        
        return true
    end
end
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
function modifier_gojo_projectile_thinker:CheckState()
    local func = {
                   [MODIFIER_STATE_INVULNERABLE] = true,
                   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                 }
    if self.bIsBlueOrb == false and self.bIsRedOrb == false then
        func[MODIFIER_STATE_PROVIDES_VISION] = true
    end
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
        
            -- Handle Red Orb Logic
            -- TEST HMMMMMM.....
            if self.bIsRedOrb then
                for iKey, hTarget in pairs(__hGojoProjectiles) do
                    if IsNotNull(hTarget)
                        and IsNotNull(self.parent)
                        and hTarget ~= self.parent
                        and not hTarget:IsRealHero()
                        and hTarget:HasModifier("modifier_gojo_projectile_thinker") 
                        and GetDistance(hTarget, self.parent) <= tMoveValues.fRadiusCopy then
                        local hModifier = hTarget:FindModifierByName("modifier_gojo_projectile_thinker")
                        
                        hModifier.iBlueCurrentState = STATE_IS_EXPLODING
                        hModifier.bIsExploding = true
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
                    self:ApplyMotionModifier(hTarget, tMoveValues)
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
            local vCenter = self.parent:GetOrigin()  -- Center of rotation
            local iRadius = 300  -- Radius of rotation
            local iSpeed = 45  -- Speed of angular incrementation
            local iDeltaAngle = 1  -- Delta Angle for smoother rotation
         
            -- Calculate new position in polar coordinates
            self.angle = self.angle + iDeltaAngle * iSpeed * FrameTime()
                    
            -- Check if a full revolution has occurred
            if self.angle >= 360 then
                self.iBlueCurrentState = STATE_IS_IDLING
                self.angle = 0
                print("Blue Orb Full Revolution")
            end
                    
            local vRadians = math.rad(self.angle % 360)
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
function modifier_gojo_projectile_thinker:ApplyMotionModifier(hTarget, tMoveValues)
    if not self.bIsExploding and (self.bIsBlueOrb or self.bIsRedOrb) then
        if hTarget:HasModifier("modifier_gojo_projectile_thinker_aura") then
            return
        end
            
        local hModifier = hTarget:AddNewModifier(self.caster, self.Ability, "modifier_gojo_projectile_thinker_aura", { duration = 20.0 })
        
        if not IsNotNull(hModifier) then
            return
        end
        
        hTarget:SetOrigin(tMoveValues.vCurPos) -- Initiate first pull
        hModifier.caster = self.parent
        hModifier.parent = hTarget
        hModifier.fRadius = tMoveValues.fRadiusCopy
        hModifier.UpdateHorizontalMotion = function(hModifier, me, dt)
            if hModifier.caster and not hModifier.caster:IsNull() and GetDistance(hModifier.parent, hModifier.caster) <= hModifier.fRadius then
                local vCurPos = GetGroundPosition(hModifier.caster:GetOrigin(), hModifier.caster)
                hModifier.parent:SetOrigin(vCurPos) 
                --print("TEST HMMMMM")
            else
                hModifier:Destroy()
            end                                   
        end
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
        local iExplosion = ParticleManager:CreateParticle("particles/darkness_parade_explosion.vpcf", PATTACH_WORLDORIGIN, self.caster)
        ParticleManager:SetParticleControl(iExplosion, 0, self.parent:GetOrigin()) 
        self:AddParticle(iExplosion, false, false, -1, false, false)
                
        if self.fExplosionTimer < 1.5 then
            EmitSoundOn("Gojo.purple_snap", self.parent)
        end  
    end
end
function modifier_gojo_projectile_thinker:OnDestroy()
    if IsServer() then
        if self.bIsBlueOrb
            and not self:BlueIsExploding() then
            EmitSoundOn("Gojo.blue_expire", self.parent)
        end
        if self.parent 
            and IsNotNull(self.parent) 
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
	return 0.1
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
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
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

function goju_red_orb:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function goju_red_orb:OnSpellStart()
    local hCaster = self:GetCaster()
    
    self:CreateRedOrb()
end
function goju_red_orb:CreateRedOrb()
    local hCaster      = self:GetCaster()
    local f__Radius    = self:GetSpecialValueFor("radius")
    local i__Speed     = self:GetSpecialValueFor("movespeed")
    local f__Distance  = self:GetSpecialValueFor("distance") + hCaster:FindTalentValue("special_bonus_gojo_20_alt")
    local f__ProjDmg   = self:GetSpecialValueFor("projectile_damage")
    
    self.vForward = hCaster:GetForwardVector()
    
    local hExplosion =  {   
                          duration     = self:GetSpecialValueFor("duration"),
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
                          fProjDamage  = f__ProjDmg,
                          bDestroy     = true,
                          bIsBlueOrb   = false,
                          fRadius      = f__Radius,
                          bIsRedOrb    = true
                     	}
                        
    local hProjectile = Goju_Create_Projectile(self, hCaster, hExplosion)
    EmitSoundOn("Gojo.redball" .. RandomInt(1, 2), hCaster)
    
    return hProjectile
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
	if self.hModifier and not self.hModifier:IsNull() then
		local hTarget  = self:GetCursorPosition()
        local hParent  = self.hModifier.parent
        local vDirection = (hTarget - hParent:GetOrigin()):Normalized()
        
        hParent:SetForwardVector(vDirection)
        self.hModifier.iBlueCurrentState = STATE_IS_MOVING
        self.hModifier.Target            = hParent:GetOrigin() + hParent:GetForwardVector() * 1300
        self.hModifier.bIsRedirected     = true
	end
    
	    
    Goju_Swap_Blue(self:GetCaster(), self.hMainAbility, self)
end

---------------------------------------------------------------------------------------------------------------
-- Goju Infinite Void (E)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_infinite_void","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

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
            and "gojo_infinity2"
            or self.BaseClass.GetAbilityTextureName(self)
end
function goju_infinite_void:OnSpellStart()
    local hCaster = self:GetCaster()
    local hPoint  = self:GetCursorPosition()
    local hTarget = self:GetCursorTarget()
    
    if not hCaster:HasModifier("modifier_goju_infinite_void") then
        local fDuration = self:GetSpecialValueFor("duration")
        hCaster:AddNewModifier(hCaster, self, "modifier_goju_infinite_void", { duration = fDuration })
    else
        self:Blink(hCaster, hPoint, hTarget)
    end
end
function goju_infinite_void:Blink(hCaster, hPoint, hTarget)
    local fBlinkDistance = self:GetSpecialValueFor("blink_distance") + hCaster:FindTalentValue("special_bonus_gojo_20")
    local vDirection     = GetDirection(hPoint, hCaster)
    fBlinkDistance       = math.min(GetDistance(hPoint, hCaster), fBlinkDistance)
    vDirection           = hCaster:GetOrigin() + vDirection * fBlinkDistance
        
    local iParticle = ParticleManager:CreateParticle("particles/decompiled_particles/items_fx/blink_dagger_start.vpcf", PATTACH_WORLDORIGIN, nil)
                      ParticleManager:SetParticleControl(iParticle, 0, hCaster:GetAbsOrigin())
    
    if IsNotNull(hTarget) and GetDistance(hTarget, hCaster) <= fBlinkDistance then  
        self:Hit(hCaster, hTarget)
    else
        FindClearSpaceForUnit( hCaster, vDirection, true )
    end
    ProjectileManager:ProjectileDodge(hCaster)
    ParticleManager:CreateParticle("particles/decompiled_particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, hCaster)
    
    EmitSoundOn("Gojo.blink", hCaster)
    --self:Hit(hCaster, self:GetCursorTarget())
end
function goju_infinite_void:Hit(hCaster, hTarget)
    if IsNotNull(hCaster) and IsNotNull(hTarget) and hCaster:IsAlive() and hTarget:IsAlive() then
        local vDirection = GetDirection(hTarget, hCaster)
        local vTargetLoc = hTarget:GetOrigin()
        vTargetLoc       = vTargetLoc - vDirection * 50
        
        hCaster:SetOrigin(vTargetLoc)
        FindClearSpaceForUnit( hCaster, vTargetLoc, true )
        
        if GetDistance(hTarget, hCaster) <= 100 then
            hCaster:FaceTowards(hTarget:GetOrigin())
            hCaster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ALACRITY, 1.5)
            hTarget:RemoveModifierByName("modifier_goju_domain_motion")
            hTarget:AddNewModifier(hCaster, self, "modifier_goju_domain_motion", { duration = 2.0 })
            
            for i = 1, 3 do
                hCaster:PerformAttack(hTarget, true, true, true, true, false, false, true)
            end
            
            self:HitEffect(hCaster, hTarget)
        end
    end
end
function goju_infinite_void:HitEffect(hCaster, hTarget)
    local sParticle = "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf"

    local iParticle = ParticleManager:CreateParticle( sParticle, PATTACH_ABSORIGIN_FOLLOW, hCaster )
                      ParticleManager:SetParticleControlEnt(iParticle, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
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
                   [MODIFIER_STATE_DEBUFF_IMMUNE] = true,
                 }
    return self.caster == self.parent and func
end
function modifier_goju_infinite_void:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_PROPERTY_DODGE_PROJECTILE,
                        --MODIFIER_EVENT_ON_ORDER,
                        MODIFIER_PROPERTY_AVOID_DAMAGE_AFTER_REDUCTIONS,
                    }
    return self.caster == self.parent and tFunc
end
function modifier_goju_infinite_void:GetModifierDodgeProjectile()
    return self.caster == self.parent and 1
end
function modifier_goju_infinite_void:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    self.fRadius = self.ability:GetSpecialValueFor("radius")
    
    if IsServer() then
        self.vOriginP = self.parent:GetOrigin()
    
        if self.caster ~= self.parent then
            self:StartIntervalThink(0.01)
        else
            self.iDmgTreshold = self.ability:GetSpecialValueFor("damage_treshold")
            self.ability:EndCooldown()
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
        
        if self:CanMove() then return end
    
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
    local fSpeed     = 500 * 0.01
    local vNextPos   = vCurPos - self.vDirection * fSpeed
    
    if self.fDistance <= 100 then
        vCurPos.z = vGroundPos.z
        self.parent:SetOrigin(vNextPos)
        self.vOriginP = vNextPos
    else
        self.parent:SetOrigin(self.vOriginP)
    end     
end
function modifier_goju_infinite_void:GetModifierAvoidDamageAfterReductions(keys)
	if IsServer() then
        if IsNotNull(keys.attacker) and IsNotNull(keys.target) and keys.target == self.parent and self.caster == self.parent then
            if keys.damage < self.iDmgTreshold then
		        return 1
            end
        end
	end
end
--[[function modifier_goju_infinite_void:OnOrder(keys)
    if self.caster == self.parent then return end

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
        if self.caster ~= self.parent then
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
    return self.caster == self.parent and "particles/heroes/anime_hero_gojo/infinite_void/gojo_infinite_void_refract.vpcf"
end
function modifier_goju_infinite_void:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_goju_infinite_void:IsAura()
	return self.caster == self.parent
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
LinkLuaModifier("modifier_goju_red_explosion_active","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_red_explosion = goju_red_explosion or class({})

function goju_red_explosion:Spawn()
    self.bUpgraded = self.bUpgraded or true
    if IsServer() then
        self:SetLevel(1)
    end
end
function goju_red_explosion:GetBehavior()
     return self.bUpgraded == true 
            and self.BaseClass.GetBehavior(self)
            or DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end
function goju_red_explosion:GetCastRange()
     return self.bUpgraded == true
            and 400 -- Hardcoded ranges for optimal behavior
            or 4000
end
function goju_red_explosion:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
    local fDuration = self:GetSpecialValueFor("duration")
    
    if type(self.bUpgraded) == "boolean" then
        hCaster:AddNewModifier(hCaster, self, "modifier_goju_red_explosion_active", { duration = fDuration })
        hTarget:AddNewModifier(hCaster, self, "modifier_goju_red_explosion_stun", { duration = fDuration + 0.2 })
    else
        self.Effect = Goju_Create_Explosion_Channeled(self, hCaster, true)
        EmitSoundOn("Gojo.red_channeled", hCaster)
        hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        hCaster:AddNewModifier(hCaster, self, "modifier_goju_vision", { duration = (self:GetChannelTime() or 3.0) + 0.4 })
    end
end
function goju_red_explosion:OnChannelFinish(bInterrupted)
    if self.bUpgraded == true then return end
    
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
        
        local bUpgraded = type(hTable.bUpgraded) == "number"
                          and true
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
function goju_red_explosion:CreateRed(fChannelStartTime)
    local hCaster      = self:GetCaster()
    
    local f__Distance  = self:GetSpecialValueFor("distance") + hCaster:FindTalentValue("special_bonus_gojo_15") or 2500
    local f__Radius    = self:GetSpecialValueFor("radius") or 500
    local i__Speed     = self:GetSpecialValueFor("speeed") or 2500
    
    fChannelStartTime = fChannelStartTime or 1.0
        
    local hExplosion =  {   
                            Ability             = self,
                            EffectName          = "particles/heroes/anime_hero_gojo/red/red_projectile_main.vpcf",
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
                            vVelocity           = hCaster:GetForwardVector() * i__Speed,
                            bProvidesVision     = true,
                            iVisionRadius     	= f__Radius,
                            iVisionTeamNumber 	= hCaster:GetTeamNumber(),
                            ExtraData 			= {bUpgraded = self.bUpgraded, fChannelStartTime = fChannelStartTime}
                        }

    local iProjectile = ProjectileManager:CreateLinearProjectile(hExplosion)
    EmitSoundOn("Gojo.red_launched", hCaster)

    return iProjectile 
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
                        [MODIFIER_STATE_PROVIDES_VISION] = true,
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
        self.ability:EndCooldown()
        EmitGlobalSound("Gojo.red")
    end
end
function modifier_goju_red_explosion_active:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_goju_red_explosion_active:OnDestroy()
    if IsServer() then
        if not self.parent:IsAlive() then
            Destroy__Particle(self.GojoRedEffect)
            StopGlobalSound("Gojo.red")
        else
            StopGlobalSound("Gojo.red")
            self.ability:CreateRed()
        end
        self.ability.bUpgraded = "Not"
        self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    else
        self.ability.bUpgraded = "Not"
    end
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Expansion (F)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_domain_expansion","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goju_domain_expansion_debuff","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

goju_domain_expansion = goju_domain_expansion or class({})

function goju_domain_expansion:Spawn()
    if IsServer() then
        if self:GetLevel() <= 0 then
            self:SetLevel(1)
            local hCaster = self:GetCaster()
            Timers:CreateTimer(1.0, function()
                for _, sAbility in pairs(hTABLE_ABILITIES2) do
                    local hAbility = hCaster:FindAbilityByName(sAbility)
                    if IsNotNull(hAbility) then
                        hAbility:SetLevel(1)
                        --print("WADAPUCK")                    
                    end
                    --print("WATAFAK")
                end
            end)
            -- GABEN Stop Trolliiiiiiiiiing......
            --local iAbilityPoints = hCaster:GetAbilityPoints()
            --hCaster:SetAbilityPoints(iAbilityPoints + 1)
            --hCaster:UpgradeAbility(self)
            --self:UpgradeAbility(true)
        end
        if not self:GetCaster():HasModifier("modifier_item_six_eyes_active") then
            self:SetActivated(false)
        end
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
function goju_domain_expansion:OnSpellStart()
    local hCaster = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("duration")
    
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_expansion", { duration = fDuration })
    hCaster:AddNewModifier(hCaster, self, "modifier_goju_vision", { duration = fDuration })
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_domain_expansion = modifier_goju_domain_expansion or class({})

function modifier_goju_domain_expansion:IsHidden() return false end
function modifier_goju_domain_expansion:IsPurgeable() return false end
function modifier_goju_domain_expansion:IsPurgeException() return true end
function modifier_goju_domain_expansion:RemoveOnDeath() return true end
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
    
    for i = 1, 2 do
        local iEyeEffect = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
                           ParticleManager:SetParticleControlEnt(iEyeEffect, 0, self.parent, PATTACH_POINT_FOLLOW, "ATTACH_EYEOFLIE" .. i, self.parent:GetAbsOrigin(), true)
        self:AddParticle(iEyeEffect, false, true, -1, false, false)
    end
    
    if self.bSwapped then
        self.iEffect = ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/dimension/six_eyes_buff_hands.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        self:AddParticle(self.iEffect, false, true, -1, false, false)
    end
    
    if IsServer() and not self.bSwapped then
        self.parent:SetAngles(self.parent:GetAngles().x, 270, self.parent:GetAngles().z)
        self.parent:SetAbsAngles(self.parent:GetAngles().x, 270, self.parent:GetAngles().z)
        self.parent:SetLocalAngles(self.parent:GetAngles().x, 270, self.parent:GetAngles().z)
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
        EmitGlobalSound("Gojo.domain_partial")
        Timers:CreateTimer(0.125, function()
            self.iEffect = ParticleManager:CreateParticle("particles/test.test.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
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
    elseif IsServer() and self.bSwapped then
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
    
    -- Reapply modifier for duration
    if IsNotNull(self.parent)
        and self.parent:IsAlive()
        and not self.bIsActive
        and self.bSwapped then
        -- Maybe should use OnIntervalThink but do this instead because PEPEGA?????
        local hModifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_goju_domain_expansion", { duration = 50.0, bIsActive = 1, bSwapped = 1 })
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_star_tier2", {duration = 50.0, bSecondTheme = 1})
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
-- Goju Hollow Purple (R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_hollow_purple_active","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

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
    if self.hHollowPurple 
        and IsNotNull(self.hHollowPurple) then
        self.hHollowPurple:RemoveModifierByName("modifier_gojo_projectile_thinker")
    end
end

---------------------------------------------------------------------------------------------------------------
modifier_goju_hollow_purple_active = modifier_goju_hollow_purple_active or class({})

function modifier_goju_hollow_purple_active:IsHidden() return false end
function modifier_goju_hollow_purple_active:IsPurgeable() return false end
function modifier_goju_hollow_purple_active:IsPurgeException() return true end
function modifier_goju_hollow_purple_active:RemoveOnDeath() return true end
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
    else
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
        self.bIsLinear        = hAbility:GetSpecialValueFor("islinear") > 0
        self.bIsTracking      = hAbility:GetSpecialValueFor("istracking") > 0
        self.fEnemyDuration   = hAbility:GetLevelSpecialValueFor("all_duration", 1)
        --===============================================================================--
        self.bDelayFirstAtt   = hAbility:GetLevelSpecialValueFor("hit_settings", 0) > 0
        self.fFirstAttDelay   = hAbility:GetLevelSpecialValueFor("hit_settings", 1)
        self.bDelayLastAtt    = hAbility:GetLevelSpecialValueFor("hit_settings", 2) > 0
        self.fLastAttDelay    = hAbility:GetLevelSpecialValueFor("hit_settings", 3)
        self.bHitOncePerAtt   = hAbility:GetLevelSpecialValueFor("hit_settings", 4) > 0
        self.bAscendorDescend = hAbility:GetLevelSpecialValueFor("hit_settings", 5) > 0
        --===============================================================================--
        self.fDistance        = hAbility:GetLevelSpecialValueFor("motion_params", 0)
        self.fSpeed           = hAbility:GetLevelSpecialValueFor("motion_params", 1)
        self.iAttackCount     = hAbility:GetLevelSpecialValueFor("motion_params", 2)
        self.fAttackDelay     = hAbility:GetLevelSpecialValueFor("motion_params", 3)
        self.fHitBoxDur       = hAbility:GetLevelSpecialValueFor("motion_params", 4)
        self.iAutoAttacksDone = hAbility:GetLevelSpecialValueFor("motion_params", 5)
        --===============================================================================--
        self.iStagesCount     = hAbility:GetLevelSpecialValueFor("stage_params", 0)
        self.fStageDelay      = hAbility:GetLevelSpecialValueFor("stage_params", 1)
        --===============================================================================--
        self.bHasTrackingAnim = hAbility:GetLevelSpecialValueFor("animations", 0) > 0
        self.bHasHitAnim      = hAbility:GetLevelSpecialValueFor("animations", 1) > 0
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
            self.fHitBoxDur        = 99.999
            self.iAutoAttacksDone  = 1
            self.bDelayFirstAtt    = false
            self.bDelayLastAtt     = false
            iGetTeam               = hCaster:GetTeam()
            hInflictor             = hCaster
            vDirection             = -self.vDirection2
            
            local bValue = self.ability:GetLevelSpecialValueFor("hit_settings", 5) > 0
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
            if self.fDistance >= 0 then
                -- Get all necessary values for Linear Motion
                local vOrigin = hParent:GetAbsOrigin()
                local fExtra  = self.bAscendorDescend == false and 1.5 or 0
                local fSpeed  = (self.fSpeed + self.fSpeed * fExtra) * dt
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
                                local hit_particle = ParticleManager:CreateParticle("particles/nanaya_work_22.vpcf", PATTACH_ABSORIGIN, hEnemy)
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
            else
                if hParent == hCaster then
                    self:Destroy()
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
                    local iImpactEffect =  ParticleManager:CreateParticle("particles/gogeta_punch_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
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
                        local iImpactEffect =  ParticleManager:CreateParticle("particles/gojo_shockwave.vpcf", PATTACH_WORLDORIGIN, nil)
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
                            for i = 1, self.iAutoAttacksDone + 2 do
                                hParent:PerformAttack(self.hTarget, true, true, true, true, false, false, true)
                            end
                            self.hModifierEnemy.fDistance = 1000
                            local iImpactEffect =  ParticleManager:CreateParticle("particles/gojo_shockwave2.vpcf", PATTACH_WORLDORIGIN, nil)
                                                   ParticleManager:SetParticleControl(iImpactEffect, 0, self.parent:GetAbsOrigin())
                            self.hModifierEnemy.bAscendorDescend = false
                            self.bFinalAttack = true
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
                local fExtra     = 1.5
                local vCurHeight = bAscend
                                   and vCurPos.z + self.fHeightOffset
                                   or vCurPos.z - self.fHeightOffset * fExtra
                
                if vCurPos.z <= vGroundPos.z and not bAscend then
                    vCurHeight = vGroundPos.z
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
GojoStartMotion(nil)



LinkLuaModifier("modifier_goju_domain_motion","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_BOTH)

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
    local fDuration = self:GetLevelSpecialValueFor("all_duration", 0)
    
    local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_goju_domain_motion", { duration = fDuration }) 
    
    --GojoStartMotion(hModifier)
end

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (W)
---------------------------------------------------------------------------------------------------------------
goju_kick2 = goju_kick2 or class (goju_kick1)

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (D)
---------------------------------------------------------------------------------------------------------------
goju_kick3 = goju_kick3 or class (goju_kick1)

---------------------------------------------------------------------------------------------------------------
-- Goju Domain Kick (R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_domain_vertical","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_VERTICAL)

goju_kick4 = goju_kick4 or class ({})

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
        self.vPosCheck   = self.parent:GetOrigin()
        
        self.hDamageTable =  {  
                                 victim       = nil,
                                 attacker     = self.parent,
                                 damage       = 500,
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
        if IsNotNull(self.parent) and self.vPosCheck.z > 0 then
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
                                   400,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                   self.ability:GetAbilityTargetTeam(),  -- int, team filter
                                   self.ability:GetAbilityTargetType(),  -- int, type filter
                                   self.ability:GetAbilityTargetFlags(),  -- int, flag filter
                                   FIND_ANY_ORDER,  -- int, order filter
                                   false  -- bool, can grow cache
                                )
                                
    self.iStompEffect =  ParticleManager:CreateParticle("particles/heroes/anime_hero_gojo/kick/gojo_land_punch_stomp.vpcf", PATTACH_WORLDORIGIN, nil)
                        ParticleManager:SetParticleControl(self.iStompEffect, 0, self.parent:GetAbsOrigin())     
    self:AddParticle(self.iStompEffect, false, false, -1, false, false)
                                
    self.hKnockBackTable.center_x = self.bDealDmg.x
    self.hKnockBackTable.center_y = self.bDealDmg.y
    self.hKnockBackTable.center_z = self.bDealDmg.z
    
    for _, hEnemy in pairs(enemies) do
        if IsNotNull(hEnemy) then
            hEnemy:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, hEnemy:IsOpposingTeam(self.parent:GetTeamNumber()))
            self.hDamageTable.victim = hEnemy
            for i = 1, 5 do
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
            RemoveAllAndOrStartGesture(self.parent, ACT_DOTA_CAST_ICE_WALL, 1.5)
            self:DealAOEDmg()
        end
    end
end





---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_goju_red_explosion_stun","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

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
LinkLuaModifier("modifier_goju_vision","heroes/gojo/gojo.lua", LUA_MODIFIER_MOTION_NONE)

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

