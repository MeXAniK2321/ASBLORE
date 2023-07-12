--PATENTED BY EIEOFLIE (C) SPECIAL FOR ANIME CUSTOM GAME IN DOTA 2--
 
 ae86_clown_horn = ae86_clown_horn or class({})
-------------
local xd = 1
-------------
function ae86_clown_horn:OnSpellStart()
     local hCaster = self:GetCaster()
     
	 -- Seriously wtf
	 if xd then
	   if xd < 10 then
	     xd = xd + 1
	   elseif xd >= 10 then
	     self:StartCooldown(self:GetSpecialValueFor("cooldown"))
		 xd = 1
	   end
	 end
	 
	 -- Emit Sounds
	 EmitSoundOn("skywrath_mage_drag_deny_01", hCaster)
     EmitSoundOn("DOTA_Item.Hand_Of_Midas", hCaster)
	 
	 -- Apply the gold gain effect particle
     local particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
     ParticleManager:ReleaseParticleIndex(particle)
	
	 -- Gain the gold
     hCaster:ModifyGold(self:GetSpecialValueFor("gold"), true, DOTA_ModifyGold_Unspecified)
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
ae86_drift = ae86_drift or class({})

function ae86_drift:GetOnUpgradeAbilities()
    local hTable =  {
                        "ae86_clown_horn"
                    }
    return hTable
end
function ae86_drift:GetChannelTime()
    return IsInToolsMode() 
           and 0.5 
           or self.BaseClass.GetChannelTime(self)
end
function ae86_drift:GetBehavior()
    return self.bRacingMod 
           and self.BaseClass.GetBehavior(self) 
           or DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED 
end
function ae86_drift:GetIntrinsicModifierNames()
    local hModifiers =  {
                            "modifier_ae86_gas",
                            "modifier_ae86_left",
                            "modifier_ae86_right",
                            "modifier_ae86_back",
                            --"modifier_anime_mechanic_movement_buttons_control"
                        }
    return hModifiers
end
function ae86_drift:OnChannelFinish(bInterrupted)
    local hCaster = self:GetCaster()
    if not bInterrupted then
        hCaster:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK) --TEST 26.03.2021 + TEST 26.10.2021

        FireGameEvent("anime_cf_server_client", {
                                                    sFunctionName = "bRacingMod",
                                                    iEntIndex     = self:entindex(),
                                                    bValue        = true,
                                                    fValue        = true,
                                                    iType         = ANIME_SC_TYPE_ENTINDEX
                                                })
        
        self:ToggleAbility()
    end
end
function ae86_drift:OnOwnerSpawned() --NOTE: This uses when we want disable state before respawn after death, work fine with respawn while alive
    if self._AE86_DriftState
        and self._AE86_DriftState ~= self:GetToggleState() then
        self:ToggleAbility()
    end
end
--function ae86_drift:ResetToggleOnRespawn()                            return false end
--function ae86_drift:OnOwnerDied()                                     end
--function ae86_drift:OnOwnerSpawned()                                  end
function ae86_drift:OnToggle()
    local hCaster = self:GetCaster()
    local bAlive  = hCaster:IsAlive()
    local iPID    = hCaster:GetPlayerOwnerID()
    local bToggle = bAlive and self:GetToggleState()

    PlayerResource:SetCameraTarget(iPID, bToggle and hCaster or nil)
    
    if bAlive then
        self._AE86_DriftState = bToggle  --REMADE FOR IDEAL LIKE DEI AND CAMERA UNLOCKS AND LOCKS AGAIN WHEN U REVOVE AFFECT PREV STATE IF U NOT LOCKED THEN WILL NOT LOCK AGAIN
    end
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_gas", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_ae86_gas = modifier_ae86_gas or class({})

function modifier_ae86_gas:IsHidden()                                return not self.ability:GetToggleState() end
function modifier_ae86_gas:IsDebuff()                                return false end
function modifier_ae86_gas:IsPurgable()                              return false end
function modifier_ae86_gas:IsPurgeException()                        return false end
function modifier_ae86_gas:RemoveOnDeath()                           return false end
function modifier_ae86_gas:GetAttributes()                           return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ae86_gas:GetPriority()                             return MODIFIER_PRIORITY_ULTRA end
function modifier_ae86_gas:IsMarbleException()                       return true end
function modifier_ae86_gas:GetTexture()
    return "anime_hero_ae86/ae86_gas"
end
function modifier_ae86_gas:CheckState()
    if IsNotNull(self.ability)
        and self.ability.bRacingMod then
        local hState =  { 
                            [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true, 
                            [MODIFIER_STATE_NO_UNIT_COLLISION]           = true,
                            --[MODIFIER_STATE_CANNOT_TARGET_ENEMIES]       = true
                            --[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true --TEST 26.03.2021
                        }
        return hState
    end
end
function modifier_ae86_gas:DeclareFunctions()
    local hFunc =   {  
                        MODIFIER_PROPERTY_DISABLE_TURNING,
                        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
                        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,

                        MODIFIER_PROPERTY_DISABLE_AUTOATTACK --TEST 26.03.2021
                    }
    return hFunc
end
function modifier_ae86_gas:GetModifierDisableTurning(keys)
    if IsNotNull(self.ability) 
        and self.ability.bRacingMod then
        return 1
    end
end
function modifier_ae86_gas:GetModifierIgnoreCastAngle(keys)
    if IsNotNull(self.ability) 
        and self.ability.bRacingMod then
        return 1
    end
end
function modifier_ae86_gas:GetModifierIgnoreMovespeedLimit(keys)
    if IsNotNull(self.ability) 
        and self.ability.bRacingMod then
        return 1
    end
end
function modifier_ae86_gas:GetModifierMoveSpeed_Limit(keys)
    if IsNotNull(self.ability) 
        and self.ability.bRacingMod then
        return self.fLimitMs
    end
end
function modifier_ae86_gas:GetModifierMoveSpeed_Absolute(keys)
    if IsClient()
        and IsNotNull(self.ability)
        and self.ability.bRacingMod then
        local iMs = math.abs(self:GetStackCount())
        return iMs > 0 
               and iMs 
               or 1
    end
end
function modifier_ae86_gas:GetModifierTotalDamageOutgoing_Percentage(keys)
    if IsNotNull(self.ability)
        and self.ability.bRacingMod then
        return self.fDamageIncrease * math.abs(self:GetStackCount())
    end
end
function modifier_ae86_gas:GetOverrideAnimation(keys)
    if IsNotNull(self.ability)
        and self.ability.bRacingMod then
        return self.parent:IsMoving() 
               and ACT_DOTA_RUN 
               or ACT_DOTA_IDLE
    end
end
function modifier_ae86_gas:GetDisableAutoAttack(keys)
    if IsNotNull(self.ability)
        and self.ability.bRacingMod then
        return 1
    end
end
function modifier_ae86_gas:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    if IsServer() then
        self.ABILITY_TARGET_TEAM  = self.ability:GetAbilityTargetTeam() 
        self.ABILITY_TARGET_TYPE  = self.ability:GetAbilityTargetType() 
        self.ABILITY_TARGET_FLAGS = self.ability:GetAbilityTargetFlags()

        self.fAccelTime      = self.ability:GetSpecialValueFor("accel_time")
        self.fBrakeTime      = self.ability:GetSpecialValueFor("brake_time")
        self.fTurnTime       = self.ability:GetSpecialValueFor("turn_time")
        self.fReverseBoost   = self.ability:GetSpecialValueFor("reverse_boost")
        self.fMaxDegrees     = self.ability:GetSpecialValueFor("max_degrees")

        self.fAutoLength     = self.ability:GetSpecialValueFor("auto_length")
        self.fAutoWidth      = self.ability:GetSpecialValueFor("auto_width")

        self.fLimitMs        = self.ability:GetSpecialValueFor("limit_ms")

        self.fTurnDrift      = self.ability:GetSpecialValueFor("turn_drift")

        self.fDamageIncrease = self.ability:GetSpecialValueFor("damage_increase")

        self.fSaveSpeed      = self.parent:GetIdealSpeed()

        self.hKnockBackTable = {
                                    should_stun        = 0,
                                    knockback_duration = 1,
                                    duration           = 1,
                                    knockback_distance = self.fAutoLength,
                                    knockback_height   = self.fAutoWidth,
                                    center_x           = nil,
                                    center_y           = nil,
                                    center_z           = nil 
                                }

        self.hDriftEnemies   = self.hDriftEnemies or {}
        self.hDriftTable     = self.hDriftTable or {}
        self.bDriftDownCheck = false
        self.bDriftUpCheck   = true

        self.bMoveUp    = false
        self.bMoveLeft  = false
        self.bMoveDown  = false
        self.bMoveRight = false

        self.fFrameTime = FrameTime()

        self:StartIntervalThink(self.fFrameTime)
    end
end
function modifier_ae86_gas:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ae86_gas:OnHorizontalMotionInterrupted()
    if IsServer() then
    end
end
function modifier_ae86_gas:OnIntervalThink()
    if IsServer() 
        and IsNotNull(self.ability)
        and self.ability.bRacingMod then

        local bMoveUp    = self.bMoveUp
        local bMoveLeft  = self.bMoveLeft
        local bMoveDown  = self.bMoveDown
        local bMoveRight = self.bMoveRight

        local iMoveUpStacks    = self.parent:GetModifierStackCount("modifier_ae86_gas", self.parent)
        local iMoveLeftStacks  = self.parent:GetModifierStackCount("modifier_ae86_left", self.parent)
        local iMoveDownStacks  = self.parent:GetModifierStackCount("modifier_ae86_back", self.parent)
        local iMoveRightStacks = self.parent:GetModifierStackCount("modifier_ae86_right", self.parent)
        --print(iMoveUpStacks, iMoveLeftStacks, iMoveDownStacks, iMoveRightStacks)
        local iMaxPossibleMS   = self.parent:IsAlive() 
                                 and self.parent:GetIdealSpeed() 
                                 or 0
        local fTimeFix         = 1
        local iStacksFix       = 0
        --print(iMaxPossibleMS)
        -- MOVEUP WHEN PLAYER PRESS MOVEUP
        --print(iMaxPossibleMS, iMoveUpStacks)
        --[[if ( iMaxPossibleMS ~= self.fSaveSpeed or not self.parent:IsAlive() )
            and math.abs(iMoveUpStacks) > iMaxPossibleMS then
            self.parent:SetModifierStackCount("modifier_ae86_gas", self.parent, iMaxPossibleMS)
        end

        self.fSaveSpeed = iMaxPossibleMS]]
  
        if bMoveUp then
            --and iMoveUpStacks < iMaxPossibleMS then
            fTimeFix   = iMoveUpStacks < 0
                         and self.fAccelTime / self.fReverseBoost 
                         or self.fAccelTime
            iStacksFix = math.ceil( ( iMaxPossibleMS * self.fFrameTime ) / fTimeFix )

            local iSetStacks = iMoveUpStacks + iStacksFix
                  iSetStacks = iSetStacks > iMaxPossibleMS 
                               and iMaxPossibleMS 
                               or iSetStacks

            self.parent:SetModifierStackCount("modifier_ae86_gas", self.parent, iSetStacks)

            if iMoveDownStacks > 0 then
                iSetStacks = iMoveDownStacks - iStacksFix
                iSetStacks = iSetStacks < 0 
                             and 0 
                             or iSetStacks

                self.parent:SetModifierStackCount("modifier_ae86_back", self.parent, iSetStacks)
            end
        end

        -- MOVELEFT WHEN PLAYER PRESS MOVELEFT
        if bMoveLeft 
            and iMoveLeftStacks < self.fMaxDegrees then
            fTimeFix   = iMoveRightStacks > 0 
                         and self.fTurnTime / self.fReverseBoost 
                         or self.fTurnTime
            iStacksFix = math.ceil( ( self.fMaxDegrees * self.fFrameTime ) / fTimeFix )

            if iMoveRightStacks ~= 0 then
                local iSetStacks = iMoveRightStacks - iStacksFix
                      iSetStacks = iSetStacks < 0 
                                   and 0 
                                   or iSetStacks

                self.parent:SetModifierStackCount("modifier_ae86_right", self.parent, iSetStacks)
            end

            if iMoveRightStacks <= 0 then
                local iSetStacks = iMoveLeftStacks + iStacksFix
                      iSetStacks = iSetStacks > self.fMaxDegrees 
                                   and self.fMaxDegrees 
                                   or iSetStacks

                self.parent:SetModifierStackCount("modifier_ae86_left", self.parent, iSetStacks)
            end
        end

        -- MOVEDOWN WHEN PLAYER PRESS MOVEDOWN
        if bMoveDown then
            --and iMoveUpStacks > -iMaxPossibleMS then
            fTimeFix   = iMoveUpStacks > 0 
                         and self.fAccelTime / self.fReverseBoost 
                         or self.fAccelTime
            iStacksFix = math.ceil( ( iMaxPossibleMS * self.fFrameTime ) / fTimeFix )

            local iSetStacks = iMoveUpStacks - iStacksFix
                  iSetStacks = iSetStacks < -iMaxPossibleMS 
                               and -iMaxPossibleMS 
                               or iSetStacks

            self.parent:SetModifierStackCount("modifier_ae86_gas", self.parent, iSetStacks)

            if --iMoveDownStacks < iMaxPossibleMS 
                iMoveUpStacks < 0 then
                iSetStacks = iMoveDownStacks + iStacksFix
                iSetStacks = iSetStacks > iMaxPossibleMS 
                             and iMaxPossibleMS 
                             or iSetStacks

                self.parent:SetModifierStackCount("modifier_ae86_back", self.parent, iSetStacks)
            end
        end

        -- MOVERIGHT WHEN PLAYER PRESS MOVERIGHT
        if bMoveRight 
            and iMoveRightStacks < self.fMaxDegrees then
            fTimeFix   = iMoveLeftStacks > 0 
                         and self.fTurnTime / self.fReverseBoost 
                         or self.fTurnTime
            iStacksFix = math.ceil( ( self.fMaxDegrees * self.fFrameTime ) / fTimeFix )

            if iMoveLeftStacks ~= 0 then
                local iSetStacks = iMoveLeftStacks - iStacksFix
                      iSetStacks = iSetStacks < 0 
                                   and 0 
                                   or iSetStacks

                self.parent:SetModifierStackCount("modifier_ae86_left", self.parent, iSetStacks)
            end

            if iMoveLeftStacks <= 0 then
                local iSetStacks = iMoveRightStacks + iStacksFix
                      iSetStacks = iSetStacks > self.fMaxDegrees 
                                   and self.fMaxDegrees 
                                   or iSetStacks

                self.parent:SetModifierStackCount("modifier_ae86_right", self.parent, iSetStacks)
            end
        end

        if self.parent:IsMoving() 
            and self.parent:IsAlive() then --NEW LINE
            -- NEUTRAL(KA) WHEN PLAYER NOT PRESS BUTTONS MOVEUP OR MOVEDOWN
            if not bMoveUp 
                and not bMoveDown then--iMoveUpStacks ~= 0 then
                fTimeFix   = self.fBrakeTime
                iStacksFix = math.ceil( ( iMaxPossibleMS * self.fFrameTime ) / fTimeFix )

                if iMoveUpStacks > 0 then
                    local iSetStacks = iMoveUpStacks - iStacksFix
                          iSetStacks = iSetStacks < 0 
                                       and 0 
                                       or iSetStacks

                    self.parent:SetModifierStackCount("modifier_ae86_gas", self.parent, iSetStacks)
                end

                if iMoveUpStacks < 0 then
                    local iSetStacks = iMoveUpStacks + iStacksFix
                          iSetStacks = iSetStacks > 0 
                                       and 0 
                                       or iSetStacks

                    self.parent:SetModifierStackCount("modifier_ae86_gas", self.parent, iSetStacks)
                end

                if iMoveDownStacks > 0 then
                    local iSetStacks = iMoveDownStacks - iStacksFix
                          iSetStacks = iSetStacks < 0 
                                       and 0 
                                       or iSetStacks

                    self.parent:SetModifierStackCount("modifier_ae86_back", self.parent, iSetStacks)
                end
            end
            -- AUTOFIX TURNING TO 0 WHEN MOVING BUT NOT PRESS BUTTONS TOO
            if not bMoveLeft 
                and not bMoveRight 
                and math.abs(iMoveLeftStacks - iMoveRightStacks) ~= 0 then
                fTimeFix   = self.fTurnTime
                iStacksFix = math.ceil( ( self.fMaxDegrees * self.fFrameTime ) / fTimeFix )

                if iMoveLeftStacks ~= 0 then
                    local iSetStacks = iMoveLeftStacks - iStacksFix
                          iSetStacks = iSetStacks < 0 
                                       and 0 
                                       or iSetStacks

                    self.parent:SetModifierStackCount("modifier_ae86_left", self.parent, iSetStacks)
                end

                if iMoveRightStacks ~= 0 then
                    local iSetStacks = iMoveRightStacks - iStacksFix
                          iSetStacks = iSetStacks < 0 
                                       and 0 
                                       or iSetStacks

                    self.parent:SetModifierStackCount("modifier_ae86_right", self.parent, iSetStacks)
                end
            end

            --DRIFTING FEATURES
            if not self.bDriftDownCheck and self.bDriftUpCheck and ( bMoveDown ) then
                self.bDriftDownCheck = true
                self.bDriftUpCheck   = false
            end

            if self.bDriftDownCheck and not self.bDriftUpCheck and ( bMoveUp ) then
                self.bDriftDownCheck = false
                self.bDriftUpCheck   = true

                local iVectorFix = iMoveLeftStacks - iMoveRightStacks
                if math.abs(iVectorFix) > self.fTurnDrift then
                    local hDriftTable = {
                                            vDriftVec      = iVectorFix / math.abs(iVectorFix),
                                            fDriftSpeed    = math.abs(iMoveUpStacks) * self.fAccelTime,
                                            fDriftDistance = math.abs(iMoveUpStacks) * self.fAccelTime
                                        }

                    table.insert(self.hDriftTable, hDriftTable)

                    EmitSoundOn("AE86.Car.Cast.1", self.parent)
                end
            end

            if not self.DriftingFX then
                local vColor =   Vector(255, 255, 255)

                self.DriftingFX =   ParticleManager:CreateParticle("particles/heroes/anime_hero_ae86/ae86_drift.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControl(self.DriftingFX, 0, self.parent:GetAbsOrigin())
                                    ParticleManager:SetParticleControl(self.DriftingFX, 10, self.parent:GetForwardVector())
                                    ParticleManager:SetParticleControl(self.DriftingFX, 60, vColor)
                                    ParticleManager:SetParticleControl(self.DriftingFX, 61, vColor)
                                    ParticleManager:SetParticleControl(self.DriftingFX, 62, vColor)
            end
        else
            --TODO: Add ordering just for showing wheels are moving kek...(basicaly done by animation)
            if self.DriftingFX then
                ParticleManager:DestroyParticle(self.DriftingFX, false)
                ParticleManager:ReleaseParticleIndex(self.DriftingFX)

                self.DriftingFX = nil
            end
        end

        for iEntIndex, fSecondsPerAttack in pairs(self.hDriftEnemies) do
            if type(fSecondsPerAttack) == "number" then
                self.hDriftEnemies[iEntIndex] = self.hDriftEnemies[iEntIndex] - self.fFrameTime
                if self.hDriftEnemies[iEntIndex] <= 0 then
                    self.hDriftEnemies[iEntIndex] = nil
                end
            end
        end

        if self.parent:IsAlive()
            and not self.parent:IsCurrentlyHorizontalMotionControlled() 
            and not self.parent:IsCurrentlyVerticalMotionControlled() then
            if self:ApplyHorizontalMotionController() == false then
                --self:Destroy() --COMMENTED CAUSE (MODIFIER_STATE_CAN'T_MOTION_CONTROLLED INTERRUPT TO FALSE)
            end
        end
    end
end
function modifier_ae86_gas:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        if me:IsMoving()
            and me:IsAlive()
            and not IsNotNull(me:GetForceAttackTarget()) then --NEW LINE
                
            local iCurrentMS       = me:GetModifierStackCount("modifier_ae86_gas", me)

            local iTurn_LR_Degrees = me:GetModifierStackCount("modifier_ae86_left", me) - me:GetModifierStackCount("modifier_ae86_right", me)
                  iTurn_LR_Degrees = iCurrentMS < 0 
                                     and -iTurn_LR_Degrees 
                                     or iTurn_LR_Degrees

            local ABS_iCurrentMS       = math.abs(iCurrentMS)
            local ABS_iTurn_LR_Degrees = math.abs(iTurn_LR_Degrees)
            if ABS_iCurrentMS < ABS_iTurn_LR_Degrees then
                  iTurn_LR_Degrees = iTurn_LR_Degrees < 0 
                                     and -ABS_iCurrentMS 
                                     or ABS_iCurrentMS
            end

            local vCurrentLoc    = me:GetOrigin()

            local vCurrentFowVec = me:GetForwardVector()
                  vCurrentFowVec = RotateVector2D(vCurrentFowVec, iTurn_LR_Degrees / math.pi * dt, true)
                  vCurrentLoc    = vCurrentLoc + vCurrentFowVec * iCurrentMS * dt

            --DRIFTING FEATURES
            if TableLength(self.hDriftTable) > 0 then
                for iDriftId, hDriftTable in pairs(self.hDriftTable) do
                    vCurrentLoc = vCurrentLoc + ( me:GetRightVector() * hDriftTable.vDriftVec ) * ( iCurrentMS / TableLength(self.hDriftTable) + 1 ) * dt

                    hDriftTable.fDriftDistance = hDriftTable.fDriftDistance - ( hDriftTable.fDriftSpeed * dt )

                    if hDriftTable.fDriftDistance <= 0 or ( hDriftTable.vDriftVec ~= ( iTurn_LR_Degrees / ABS_iTurn_LR_Degrees ) and ABS_iTurn_LR_Degrees > self.fTurnDrift ) then
                        table.remove(self.hDriftTable, iDriftId)
                    end
                end

                if not self.parent:IsDisarmed()
                    and not self.parent:HasModifier("modifier_anime_special_respawn") then --NEW LINE 23.10.2021 FOR FIX INVUL
                        
                    --local fSecondsPerAttack = self.parent:GetSecondsPerAttack() + self.parent:GetAttackAnimationPoint()
                    local fAttacksPerSecond = math.ceil(self.parent:GetAttacksPerSecond())
                    --print(fAttacksPerSecond)
                    self.hKnockBackTable.center_x = vCurrentLoc.x
                    self.hKnockBackTable.center_y = vCurrentLoc.y
                    self.hKnockBackTable.center_z = vCurrentLoc.z

                    local hEnemies = FindUnitsInLine(
                                                        self.parent:GetTeamNumber(),
                                                        vCurrentLoc + vCurrentFowVec * self.fAutoLength * 0.5,
                                                        vCurrentLoc + vCurrentFowVec * self.fAutoLength * -0.5,
                                                        nil,
                                                        self.fAutoWidth,
                                                        self.ABILITY_TARGET_TEAM, 
                                                        self.ABILITY_TARGET_TYPE,
                                                        self.ABILITY_TARGET_FLAGS)

                    for _, hEnemy in pairs(hEnemies) do
                        if IsNotNull(hEnemy) then
                            local iEntIndex = hEnemy:entindex()
                            if not self.hDriftEnemies[iEntIndex] then
                                self.hDriftEnemies[iEntIndex] = 1

                                hEnemy:AddNewModifier(self.parent, self.ability, "modifier_knockback", self.hKnockBackTable, hEnemy:IsOpposingTeam(self.parent:GetTeamNumber()))

                                for i = 1, fAttacksPerSecond do
                                    self.parent:AnimePerformAttack( hEnemy,                     --hTarget
                                                                    true,                       --bProcessProcs
                                                                    true,                       --bSkipCooldown
                                                                    true,                       --bBreakInvis
                                                                    false,                      --bUseProjectile
                                                                    false,                      --bFakeAttack
                                                                    false,                      --bNeverMiss
                                                                    {
                                                                        __sProjectileName = nil,
                                                                        __sAttackSound    = nil,

                                                                        __fOverrideDamage = nil,
                                                                        __fPostCritDamage = nil,
                                                                        __fCritDamage     = nil,

                                                                        __fPhysicalDamage = nil,
                                                                        __fMagicalDamage  = nil,
                                                                        __fPureDamage     = nil,
                                                                        __fFeedbackDamage = nil,

                                                                        __bSupressCleave  = nil,
                                                                        __bCleaveRange    = nil
                                                                    })
                                end

                                EmitSoundOn("AE86.Drift.Impact.1", hEnemy)
                            end
                        end
                    end
                end
            end
                vCurrentLoc = GetGroundPosition(vCurrentLoc, me)

            local vTraverseLoc = GetGroundPosition(vCurrentLoc + vCurrentFowVec * self.fAutoLength * 0.5, me)

                vCurrentFowVec = GetDirection(vTraverseLoc, vCurrentLoc, true)

            --08.03.2023 Fixes because gabe did longer time for autoreupdate motion modifier.... nice cringe...
            local nDist    = math.abs(GetDistance(vCurrentLoc, vTraverseLoc, true) - GetDistance(vCurrentLoc, vTraverseLoc))
            --GridNav:FindPathLength(vCurrentLoc, vTraverseLoc) > -1 and 
            --print(nDist, GridNav:FindPathLength(vCurrentLoc, vTraverseLoc))
            local bCanPath = ( ( GridNav:IsTraversable(vTraverseLoc) and not GridNav:IsBlocked(vTraverseLoc) and nDist < 35 ) or me:HasFlyMovementCapability() )
            --print(GridNav:FindPathLength(vCurrentLoc, vTraverseLoc), GetDistance(vCurrentLoc, vTraverseLoc), GetDistance(vCurrentLoc, vTraverseLoc, true))
            --TODO: Make High speed fix
            me:SetForwardVector(vCurrentFowVec, true)

            if bCanPath then
                
                GridNav:DestroyTreesAroundPoint( vTraverseLoc, self.fAutoWidth, true )
                GridNav:DestroyTreesAroundPoint( vCurrentLoc, self.fAutoWidth, true )

                --me:SetOrigin(vCurrentLoc)
                --FindClearSpaceForUnit(me, vCurrentLoc, true)
                me:SetAbsOrigin(vCurrentLoc)
            else
            --     me:SetForwardVector(vCurrentFowVec, true)
            --     --me:SetOrigin(vCurrentLoc)
            --     --me:SetAbsOrigin(vCurrentLoc)
                FindClearSpaceForUnit(me, vCurrentLoc, true)
            end
        end
    end
end
function modifier_ae86_gas:OnDestroy()
    if IsServer() 
        and IsNotNull(self.parent) then
        --self.parent:RemoveHorizontalMotionController(self)
        self.parent:InterruptMotionControllers(true)
    end
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_left", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

modifier_ae86_left = modifier_ae86_left or class({})

function modifier_ae86_left:IsHidden()                                return not self.ability:GetToggleState() end
function modifier_ae86_left:IsDebuff()                                return false end
function modifier_ae86_left:IsPurgable()                              return false end
function modifier_ae86_left:IsPurgeException()                        return false end
function modifier_ae86_left:RemoveOnDeath()                           return false end
function modifier_ae86_left:GetAttributes()                           return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ae86_left:GetPriority()                             return MODIFIER_PRIORITY_ULTRA end
function modifier_ae86_left:IsMarbleException()                       return true end
function modifier_ae86_left:GetTexture()
    return "anime_hero_ae86/ae86_left"
end
function modifier_ae86_left:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_ae86_left:OnRefresh(hTable)
    --print("left_refresh")
    self:OnCreated(hTable)
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_right", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

modifier_ae86_right = modifier_ae86_right or class({})

function modifier_ae86_right:IsHidden()                                return not self.ability:GetToggleState() end
function modifier_ae86_right:IsDebuff()                                return false end
function modifier_ae86_right:IsPurgable()                              return false end
function modifier_ae86_right:IsPurgeException()                        return false end
function modifier_ae86_right:RemoveOnDeath()                           return false end
function modifier_ae86_right:GetAttributes()                           return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ae86_right:GetPriority()                             return MODIFIER_PRIORITY_ULTRA end
function modifier_ae86_right:IsMarbleException()                       return true end
function modifier_ae86_right:GetTexture()
    return "anime_hero_ae86/ae86_right"
end
function modifier_ae86_right:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_ae86_right:OnRefresh(hTable)
    self:OnCreated(hTable)
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_back", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

modifier_ae86_back = modifier_ae86_back or class({})

function modifier_ae86_back:IsHidden()                                return not self.ability:GetToggleState() end
function modifier_ae86_back:IsDebuff()                                return false end
function modifier_ae86_back:IsPurgable()                              return false end
function modifier_ae86_back:IsPurgeException()                        return false end
function modifier_ae86_back:RemoveOnDeath()                           return false end
function modifier_ae86_back:GetAttributes()                           return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ae86_back:GetPriority()                             return MODIFIER_PRIORITY_ULTRA end
function modifier_ae86_back:IsMarbleException()                       return true end
function modifier_ae86_back:GetTexture()
    return "anime_hero_ae86/ae86_stop"
end
function modifier_ae86_back:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_ae86_back:OnRefresh(hTable)
    self:OnCreated(hTable)
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
ae86_repair = ae86_repair or class({})

function ae86_repair:IsStealable()              return true end
function ae86_repair:IsHiddenWhenStolen()       return false end
function ae86_repair:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("duration") + hCaster:FindTalentValue("special_bonus_anime_ae86_10R")

    hCaster:Purge(false, true, false, true, true)
    hCaster:InterruptMotionControllers(true)
    hCaster:AddNewModifier(hCaster, self, "modifier_ae86_repair", {duration = fDuration})
 
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_repair", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

modifier_ae86_repair = modifier_ae86_repair or class({})

function modifier_ae86_repair:IsHidden()                            return false end
function modifier_ae86_repair:IsDebuff()                            return false end
function modifier_ae86_repair:IsPurgable()                          return false end
function modifier_ae86_repair:IsPurgeException()                    return false end
function modifier_ae86_repair:RemoveOnDeath()                       return true end
function modifier_ae86_repair:CheckState()
    local state =   {
                        [MODIFIER_STATE_STUNNED]           = true,
                        [MODIFIER_STATE_FROZEN]            = true,
                        [MODIFIER_STATE_MAGIC_IMMUNE]      = true
                    }
    return state
end
function modifier_ae86_repair:DeclareFunctions()
    local func =    {  
                    
                    }
    return func
end
function modifier_ae86_repair:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.vParentLoc = self.parent:GetAbsOrigin()

    self.fInterval  = 0.25

    self.fHealHp    = self.ability:GetSpecialValueFor("heal_hp")
    self.fHealHpPct = self.ability:GetSpecialValueFor("heal_hp_pct")
    self.fHealMp    = self.ability:GetSpecialValueFor("heal_mp")
    self.fHealMpPct = self.ability:GetSpecialValueFor("heal_mp_pct")

    if IsServer() then
        if not self.RepairFX then
            self.RepairFX = ParticleManager:CreateParticle("particles/items5_fx/repair_kit_ancient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                            ParticleManager:SetParticleControl(self.RepairFX, 0, self.vParentLoc)
                            ParticleManager:SetParticleControl(self.RepairFX, 1, self.vParentLoc)

            self:AddParticle(self.RepairFX, false, false, -1, false, false)
        end

        self.ability.anime_overhead_effect_heal = OVERHEAD_ALERT_HEAL

        self:OnIntervalThink()
        self:StartIntervalThink(self.fInterval)

        EmitSoundOn("AE86.Limit.Cast.1", self.parent)
    end
end
function modifier_ae86_repair:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ae86_repair:OnIntervalThink()
    if IsServer() then
        local fParentHP   = self.parent:GetMaxHealth()
        local fHealHpCalc = ( self.fHealHp + ( fParentHP * self.fHealHpPct * 0.01 ) ) * self.fInterval

        local fParentMP   = self.parent:GetMaxMana()
        local fHealMpCalc = ( self.fHealMp + ( fParentHP * self.fHealMpPct * 0.01 ) ) * self.fInterval

        self.parent:Heal(fHealHpCalc, self.ability)
        self.parent:GiveMana(fHealMpCalc)

        SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.parent, fHealMpCalc, nil)
    end
end
function modifier_ae86_repair:OnDestroy()
    if IsServer() then
        self.ability.anime_overhead_effect_heal = nil

        StopSoundOn("AE86.Limit.Cast.1", self.parent)
    end
end

--
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
--LinkLuaModifier("modifier_ae86_charge_ability_charges", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

--modifier_ae86_charge_ability_charges = modifier_ae86_charge_ability_charges --or class(modifier_anime_mechanic_ability_charges_new)

ae86_charge = ae86_charge or class({})

--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function ae86_charge:GetIntrinsicModifierName()
    return "modifier_ae86_charge_ability_charges"
end
function ae86_charge:HasAnimeCharges()
    return self:GetCaster():HasScepter()
end
function ae86_charge:GetInitialAC()
    return self:GetSpecialValueFor("scepter_charges")
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function ae86_charge:IsStealable()              return true end
function ae86_charge:IsHiddenWhenStolen()       return false end
function ae86_charge:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function ae86_charge:OnSpellStart()
    local hCaster = self:GetCaster()

    hCaster:AddNewModifier(hCaster, self, "modifier_ae86_charge", {})

    EmitSoundOn("AE86.Charge.Cast."..RandomInt(1, 2), hCaster)
end

--]]
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_charge", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_BOTH)

modifier_ae86_charge = modifier_ae86_charge or class({})

function modifier_ae86_charge:IsHidden()                return false end
function modifier_ae86_charge:IsDebuff()                return false end
function modifier_ae86_charge:IsPurgable()              return true end
function modifier_ae86_charge:IsPurgeException()        return true end
function modifier_ae86_charge:RemoveOnDeath()           return true end
function modifier_ae86_charge:CheckState()
    local state =   {
                        --[MODIFIER_STATE_STUNNED]           = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
                    }
    return state
end
function modifier_ae86_charge:DeclareFunctions()
    local func =    {  
                        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
                    }
    return func
end
function modifier_ae86_charge:GetOverrideAnimation()
    return ACT_DOTA_RUN
end
function modifier_ae86_charge:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        if not self.DashFX then
            self.DashFX =   ParticleManager:CreateParticle("particles/econ/items/pangolier/pangolier_immortal_musket/pangolier_immortal_swashbuckler_dash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                            --ParticleManager:SetParticleControl(self.DashFX, 0, self.parent:GetAbsOrigin()) -- point 0: origin, point 2: sparkles, point 5: burned soil
                            --ParticleManager:SetParticleControl(self.DashFX, 2, self.parent:GetAbsOrigin())
                            --ParticleManager:SetParticleControl(self.DashFX, 5, self.parent:GetAbsOrigin())

            self:AddParticle(self.DashFX, false, false, -1, false, false)
        end

        self.speed       = self.parent:GetIdealSpeedNoSlows() * self.ability:GetSpecialValueFor("speed_multiplier")
        self.distance    = self.ability:GetAOERadius()

        self.direction   = self.parent:GetForwardVector()
        self.direction.z = 0
        
        self.point       = self.parent:GetAbsOrigin() + self.direction * self.distance + 1

        self.start_loc   = self.parent:GetAbsOrigin()

        if self:ApplyHorizontalMotionController() == false
            or self:ApplyVerticalMotionController() == false then
            self:Destroy()
        end

        --20R Talent Features
        self.ABILITY_TARGET_TEAM  = self.ability:GetAbilityTargetTeam() 
        self.ABILITY_TARGET_TYPE  = self.ability:GetAbilityTargetType() 
        self.ABILITY_TARGET_FLAGS = self.ability:GetAbilityTargetFlags()

        self.hDriftEnemies = self.hDriftEnemies or {}

        self.fAutoLength   = 480
        self.fAutoWidth    = 125
        --===============================================================--
        self.jump_duration = self.ability:GetSpecialValueFor("fly_time")
        self.jump_height   = 200

        self.hVelocity = self.distance / self.jump_duration

        self.elapsedTime = 0
        self.motionTick = {}
        self.motionTick[0] = 0
        self.motionTick[1] = 0
        self.motionTick[2] = 0

        self.iGravity = -self.jump_height / (self.jump_duration * self.jump_duration * 0.125)
        self.vVelocity = (-0.5) * self.iGravity * self.jump_duration
    else
    end
end
function modifier_ae86_charge:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ae86_charge:SyncTime(iDir, dt)
    if self.motionTick[1] == self.motionTick[2] then
        self.motionTick[0] = self.motionTick[0] + 1
        self.elapsedTime = self.elapsedTime + dt
    end

    self.motionTick[iDir] = self.motionTick[0]
    
    if self.elapsedTime > self.jump_duration and self.motionTick[1] == self.motionTick[2] then
        self:Destroy()
    end
end
function modifier_ae86_charge:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        self:SyncTime(1, dt)

        local target = self.direction * self.hVelocity * self.elapsedTime

        local parent_pos = self.start_loc + target
        me:SetOrigin(parent_pos)
        me:FaceTowards(self.point)

        GridNav:DestroyTreesAroundPoint(parent_pos, self.parent:Script_GetAttackRange(), false)
        
        --[[if self.distance <= 0 then
            self:Destroy()
        end

        local units_per_dt = self.speed * dt
        local parent_pos = self.parent:GetAbsOrigin()

        local next_pos = parent_pos + self.direction * units_per_dt
        local distance_will = self.distance - units_per_dt

        if distance_will < 0 then
            next_pos = self.point
        end

        GridNav:DestroyTreesAroundPoint(next_pos, self.parent:Script_GetAttackRange(), false)

        self.parent:SetOrigin(next_pos)

        self.distance = self.distance - units_per_dt]]

        --20R Talent Features
        if self.parent:HasTalent("special_bonus_anime_ae86_20R") then
            local hEnemies = FindUnitsInLine(   
                                                self.parent:GetTeamNumber(),
                                                parent_pos + self.direction * self.fAutoLength * 0.5,
                                                parent_pos + self.direction * self.fAutoLength * -0.5,
                                                nil,
                                                self.fAutoWidth,
                                                self.ABILITY_TARGET_TEAM, 
                                                self.ABILITY_TARGET_TYPE,
                                                self.ABILITY_TARGET_FLAGS)

            for _, hEnemy in pairs(hEnemies) do
                if IsNotNull(hEnemy) then
                    local iEntIndex = hEnemy:entindex()
                    if not self.hDriftEnemies[iEntIndex] then
                        self.hDriftEnemies[iEntIndex] = true

                        self.parent:AnimePerformAttack( hEnemy,                     --hTarget
                                                        true,                       --bProcessProcs
                                                        true,                       --bSkipCooldown
                                                        true,                       --bBreakInvis
                                                        false,                      --bUseProjectile
                                                        false,                      --bFakeAttack
                                                        false,                      --bNeverMiss
                                                        {
                                                            __sProjectileName = nil,
                                                            __sAttackSound    = nil,

                                                            __fOverrideDamage = nil,
                                                            __fPostCritDamage = nil,
                                                            __fCritDamage     = nil,

                                                            __fPhysicalDamage = nil,
                                                            __fMagicalDamage  = nil,
                                                            __fPureDamage     = nil,
                                                            __fFeedbackDamage = nil,

                                                            __bSupressCleave  = nil,
                                                            __bCleaveRange    = nil
                                                        })

                        EmitSoundOn("AE86.Drift.Impact.1", hEnemy)
                    end
                end
            end
        end
    end
end
function modifier_ae86_charge:UpdateVerticalMotion(me, dt)
    if IsServer() then
        self:SyncTime(2, dt)

        local target = self.vVelocity * self.elapsedTime + 0.5 * self.iGravity * self.elapsedTime * self.elapsedTime

        me:SetOrigin(Vector(me:GetOrigin().x, me:GetOrigin().y, self.start_loc.z + target))
    end
end
function modifier_ae86_charge:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_ae86_charge:OnVerticalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_ae86_charge:OnDestroy()
    if IsServer() then
        --self.parent:RemoveHorizontalMotionController(self)
        self.parent:InterruptMotionControllers(true)
    end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
ae86_limit = ae86_limit or class({})

function ae86_limit:IsStealable()                   return true end
function ae86_limit:IsHiddenWhenStolen()            return false end
function ae86_limit:GetIntrinsicModifierName()
    return "modifier_ae86_limit"
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_limit", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

modifier_ae86_limit = modifier_ae86_limit or class({})

function modifier_ae86_limit:IsHidden()              return true end
function modifier_ae86_limit:IsDebuff()              return false end
function modifier_ae86_limit:IsPurgable()            return false end
function modifier_ae86_limit:IsPurgeException()      return false end
function modifier_ae86_limit:RemoveOnDeath()         return false end
function modifier_ae86_limit:GetAttributes()         return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_ae86_limit:DeclareFunctions()
    local func =   {
                        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
                    }
    return func
end
function modifier_ae86_limit:GetModifierMoveSpeedBonus_Percentage(keys)
    if IsNotNull(self.parent) then
        --and not self.parent:PassivesDisabled() then
        return self.fBonusMs * self.parent:FindTalentValue("special_bonus_anime_ae86_25R", nil, 1)
    end
end
function modifier_ae86_limit:GetModifierPhysicalArmorBonus(keys)
    if IsNotNull(self.parent) then
        --and not self.parent:PassivesDisabled() then
        return self.fBonusArmor * self.parent:FindTalentValue("special_bonus_anime_ae86_25R", nil, 1)
    end
end
function modifier_ae86_limit:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fBonusMs    = self.ability:GetSpecialValueFor("bonus_ms")
    self.fBonusArmor = self.ability:GetSpecialValueFor("bonus_armor")
end
function modifier_ae86_limit:OnRefresh(hTable)
    self:OnCreated(hTable)
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
ae86_theme = ae86_theme or class({})

function ae86_theme:IsStealable()                   return true end
function ae86_theme:IsHiddenWhenStolen()            return false end
function ae86_theme:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("duration")

    hCaster:AddNewModifier(hCaster, self, "modifier_ae86_theme", {duration = fDuration})
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_ae86_theme", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

modifier_ae86_theme = modifier_ae86_theme or class({})

function modifier_ae86_theme:IsHidden()                return false end
function modifier_ae86_theme:IsDebuff()                return false end
function modifier_ae86_theme:IsPurgable()              return not self.parent:HasTalent("special_bonus_anime_ae86_15R") end
function modifier_ae86_theme:IsPurgeException()        return not self.parent:HasTalent("special_bonus_anime_ae86_15R") end
function modifier_ae86_theme:RemoveOnDeath()           return true end
function modifier_ae86_theme:CheckState()
    local state = {}
     
    if self.parent:HasTalent("special_bonus_anime_ae86_15R") then
        state[MODIFIER_STATE_UNSLOWABLE] = true
    end

    return state
end
function modifier_ae86_theme:DeclareFunctions()
    local func =    {  
                        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
                    }
    return func
end
function modifier_ae86_theme:GetModifierMoveSpeedBonus_Constant(keys)
    return self.fBonusMs
end
function modifier_ae86_theme:GetModifierAttackSpeedBonus_Constant(keys)
    return self.fBonusAs
end
function modifier_ae86_theme:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self.fBonusMs = self.ability:GetSpecialValueFor("bonus_ms")
    self.fBonusAs = self.ability:GetSpecialValueFor("bonus_as")

    if IsServer() then
        EmitSoundOn("AE86.Theme.Cast."..RandomInt(1, 3), self.parent)
    else
        if not self.ThemeFX1 then
            local vColor =  Vector(255, 255, 255)

            self.ThemeFX1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
                            ParticleManager:SetParticleControl(self.ThemeFX1, 1, Vector(200, 0, 0))
                            ParticleManager:SetParticleControl(self.ThemeFX1, 2, Vector(50, 0, 0))
                            ParticleManager:SetParticleControl(self.ThemeFX1, 60, vColor)
                            ParticleManager:SetParticleControl(self.ThemeFX1, 61, vColor)

            self:AddParticle(self.ThemeFX1, false, false, -1, false, false)
        end

        --[[if not self.ThemeFX2 then
            self.ThemeFX2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_stampede_haste.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )

            self:AddParticle(self.ThemeFX2, false, false, -1, false, false)
        end]]
    end
end
function modifier_ae86_theme:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ae86_theme:OnDestroy()
    if IsServer() then
        for i = 1, 3 do
            StopSoundOn("AE86.Theme.Cast."..i, self.parent)
        end
    end
end
--!!!!!!!!!!!!!ALL LOCAL VALVE_THINGS RELOAD SELF CHANGED VERSIONS AFTER script_reload IDK CAN BE IT IN REAL GAME OR NOT, NEED FIX IT SOMEDAY!!!!!!!!!!!--

--!!CUSTOM BONUS GLOBAL INT VALUES!!--
--print(_G["DOTA_DAMAGE_FLAG_NONE"], "PEEPEPP")
ANIME_DAMAGE_FLAG_RED_STONE = (2^20) --LAST 2^17 FOR VALVE--262144 --65536 BUSY BY NEW FORCE AMO DOTA_DAMAGE_FLAG_FORCE_SPELL_AMPLIFICATION = 65536, AND NEXT TOO BUSY WITH MAGIC AUTOATTACK FLAG XD GABEN, NICE KOKS

ANIME_SC_TYPE_ENTINDEX = 1
ANIME_SC_TYPE_PID      = 2
--!!CUSTOM BONUS GLOBAL INT VALUES!!--
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!-----ARCANA NEW CODE SERVER-CLIENT------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------

--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
IsNotNull = function(hScript) --ATTENTION!!!!!!!! TODO: IF U USE IsNotNull(false) it'll return TRUE, need change or not i not decided, need check all lua code for rightability using (First Appear problem in vergil trigger gauge)
    local sType = type(hScript)
    if sType ~= "nil" then
        if sType == "table" 
            and type(hScript.IsNull) == "function" then
            return not hScript:IsNull()
        end
        return true
    end
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
TableLength = function(hTable)
    local i = 0
    if type(hTable) == "table" then
        for _, hV in pairs(hTable) do
            i = i + 1
        end
    end
    return i
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
TableCopy = function(hTable, siIndex, bIntIndex)
    local hTable2 = {}
    if type(hTable) == "table" then
        local i = 1
        for siKey, hValue in pairs(hTable) do
            siKey = bIntIndex 
                    and i
                    or ( ( type(siIndex) ~= "nil" and type(hValue) == "table" )
                         and hValue[siIndex]
                         or siKey )
            hTable2[siKey] = hValue
            i = i + 1
        end
    else
        hTable2 = hTable
    end
    return hTable2
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
TablePick = function(hTableReference, hTable, bRemove)
    if type(hTableReference) == "table" 
        and type(hTable) == "table" then
        if TableLength(hTable) <= 0 then
            for k, v in pairs(hTableReference) do
                hTable[k] = v
            end
        end
        local iRandIndex = RandomInt( 1, TableLength(hTable) )
        local hReturn    = hTable[iRandIndex]
        if bRemove then
            table.remove( hTable, iRandIndex )
        end
        return hReturn
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
TableShuffle = function(hTable, bCopy)
    if type(hTable) == "table" then
        local hTableReturn = bCopy and {} or hTable
        local hTableInt = TableCopy(hTable, nil, true)
        for k, v in pairs(hTable) do
            hTableReturn[k] = TablePick(hTableInt, hTableInt, true)
        end
        return hTableReturn
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
TableEqual = function(hTable1, hTable2, bIgnoreMetatable)
    if hTable1 == hTable2 then
        return true
    end

    local sType1 = type(hTable1)
    local sType2 = type(hTable2)

    if sType1 ~= "table"
        or sType1 ~= sType2 then
        return false
    end

    if not bIgnoreMetatable then
        local hMeta1 = getmetatable(hTable1)
        if hMeta1 and hMeta1.__eq then --compare using built in method
            return hTable1 == hTable2
        end
    end

    local hKeysSet = {}
    
    for iKey1, hValue1 in pairs(hTable1) do
        local hValue2 = hTable2[iKey1]
        if hValue2 == nil 
            or not TableEqual(hValue1, hValue2, bIgnoreMetatable) then
            return false
        end
        hKeysSet[iKey1] = true
    end

    for iKey2, hValue2 in pairs(hTable2) do
        if not hKeysSet[iKey2] then
            return false
        end
    end

    return true
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
GetDistance = function(hEnt1, hEnt2, b3D)
    hEnt1 = hEnt1.GetAbsOrigin and hEnt1:GetAbsOrigin() or hEnt1
    hEnt2 = hEnt2.GetAbsOrigin and hEnt2:GetAbsOrigin() or hEnt2
    return b3D and (hEnt1 - hEnt2):Length() or (hEnt1 - hEnt2):Length2D()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
GetDirection = function(hEnt1, hEnt2, b3D)
    hEnt1 = hEnt1.GetAbsOrigin and hEnt1:GetAbsOrigin() or hEnt1
    hEnt2 = hEnt2.GetAbsOrigin and hEnt2:GetAbsOrigin() or hEnt2

    local iEnt1 = hEnt1.z
    local iEnt2 = hEnt2.z
    
    hEnt1.z = b3D and iEnt1 or 0
    hEnt2.z = b3D and iEnt2 or 0

    local vReturn = (hEnt1 - hEnt2):Normalized()

    hEnt1.z = iEnt1
    hEnt2.z = iEnt2

    return vReturn
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
GetLerped = function(hValue1, hValue2, fTime)
    return hValue1 + ( hValue2 - hValue1 ) * fTime
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!IMPORTANT: NEED FOR HANDLE SOME FUNCTION ON CLIENT SIDE!!!------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
_G.RegistredGameEventsListeners = RegistredGameEventsListeners or {}
for _, lID in pairs(RegistredGameEventsListeners) do
    StopListeningToGameEvent(lID)
    RegistredGameEventsListeners[_] = nil
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterGameEventListener = function(sEventName, hCallback, hOptional)
    table.insert(RegistredGameEventsListeners, ListenToGameEvent(sEventName, hCallback, hOptional))
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
Anime_CF_Server_Client = function(keys)
    --_G.INDEX_SERVER_CLIENT = (INDEX_SERVER_CLIENT or 0) + 1
    --print(INDEX_SERVER_CLIENT, Time(), "INDEX_SERVER_CLIENT")
    local sFunctionName = keys.sFunctionName
    local iEntIndex     = keys.iEntIndex
    local bValue        = keys.bValue
    local fValue        = keys.fValue
    local iType         = keys.iType

    if type(sFunctionName) == "string" and type(iEntIndex) == "number" and type(bValue) == "number" and type(fValue) == "number" and type(iType) == "number" then
        if iType == ANIME_SC_TYPE_ENTINDEX then
            iEntIndex = EntIndexToHScript(iEntIndex)
        elseif iType == ANIME_SC_TYPE_PID then
            --iEntIndex = AnimeArcanas._PLAYERS_TABLE[iEntIndex]
        end
        if bValue > 0 then fValue = fValue > 0 end
        if IsNotNull(iEntIndex) then
            iEntIndex[sFunctionName] = fValue--print(iEntIndex:GetName(), bValue, fValue, sFunctionName, IsServer())
        end
    end
end
RegisterGameEventListener("anime_cf_server_client", Anime_CF_Server_Client)
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function string.starts(sString, sStarts)
    return string.sub(sString, 1, string.len(sStarts)) == sStarts
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function string.ends(sString, sEnds)
    return sEnds == "" or string.sub(sString, -string.len(sEnds)) == sEnds
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function string.split(sString, sSplitter)
    local t = {}
    for str in string.gmatch(sString, "([^" .. (sSplitter or "%s") .. "]+)") do
        table.insert(t, str)
    end
    return t
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function string.splitQuoted(sString)
    local t = {}
    local spat, epat, buf, quoted = [=[^(['"])]=], [=[(['"])$]=]
    for str in sString:gmatch("%S+") do
        local squoted = str:match(spat)
        local equoted = str:match(epat)
        local escaped = str:match([=[(\*)['"]$]=])
        if squoted and not quoted and not equoted then
            buf, quoted = str, squoted
        elseif buf and equoted == quoted and #escaped % 2 == 0 then
            str, buf, quoted = buf .. ' ' .. str, nil, nil
        elseif buf then
            buf = buf .. ' ' .. str
        end
        if not buf then
            local newString = str:gsub(spat,""):gsub(epat,"")
            table.insert(t, newString)
        end
    end
    if buf then
        error("Missing matching quote for "..buf)
    end
    return t
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function string.NumDigits(sNumber, iMaxDigits) --FINISHED: DID 17.12.2021 FOR GIORNO BASICALY (COUNTER)
    local hTable  = {}
    local iLength = string.len(sNumber)

    if iLength > iMaxDigits then
        sNumber = ""
        for i = 1, iMaxDigits do
            sNumber = sNumber .. "9"
        end
    end

    sNumber = string.format("%0" .. iMaxDigits .. "d", sNumber)
    for i = 1, string.len(sNumber) do
        --print(string.sub(sNumber, i, i))
        table.insert(hTable, string.sub(sNumber, i, i))
    end

    return hTable
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function math.round(fNumber) --SPECIAL FOR ROUNDING NUMBERS, 20.03.2022, can return wrong for -0.49999999999999994 (-1) and 0.49999999999999994 (1)
    fNumber = fNumber >= 0 
              and math.floor(fNumber + 0.5)
              or math.ceil(fNumber - 0.5)
    return fNumber
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!IMPORTANT: NEED FOR HANDLE SOME FUNCTION ON CLIENT SIDE!!!------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_UTIL_Remove = UTIL_Remove
UTIL_Remove = function(hEntity, bImmediate, bDebug)
    local hRemoveReturn = bImmediate 
                          and UTIL_RemoveImmediate 
                          or VALVE_UTIL_Remove
    if IsServer()
        and IsValidEntity(hEntity)
        and type(hEntity.RemoveAllModifiers) == "function" then
        hEntity:RemoveAllModifiers(0, true, true, true)
    end
    return hRemoveReturn(hEntity)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--BASICALY NEEDS ONLY FOR UNIQUE MODIFIERS + ABILITIES + UNITS
GetOrSetUniqueEntValue = function(hEntity, sUniqueValue, bSet, biUniqueValue)
    if IsNotNull(hEntity)
        and IsValidEntity(hEntity)
        and type(sUniqueValue) == "string" then
        sUniqueValue = "___"..sUniqueValue.."___"
        if type(bSet) == "boolean"
            and bSet then
            local bIsBool = type(biUniqueValue) == "boolean"
            if bIsBool
                or type(biUniqueValue) == "number"
                or type(biUniqueValue) == "nil" then
                hEntity[sUniqueValue] = biUniqueValue
                if IsServer() then
                    FireGameEvent("anime_cf_server_client", {
                                                                sFunctionName = sUniqueValue,
                                                                iEntIndex     = hEntity:entindex(),
                                                                bValue        = bIsBool,
                                                                fValue        = biUniqueValue,
                                                                iType         = ANIME_SC_TYPE_ENTINDEX
                                                            })
                end
            end
        else
            return hEntity[sUniqueValue]
        end
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
SendAnimeRequest = function(sLink, hTable, fOnSuccess, fOnError, sCheckDedikey, iReloads, fTimeOut) --NOTE: Work with Timers, so don't forget requrie them???

    local iTries   = type(iReloads) == "number"
                    and iReloads
                    or 0

    --print(iTries, Time())

    local hRequest = CreateHTTPRequestScriptVM('POST', sLink) or CreateHTTPRequest('POST', sLink)
    if sCheckDedikey then
        hRequest:SetHTTPRequestHeaderValue('Anime-Dedicate-Key', sCheckDedikey)
    end
    if fTimeOut then
        hRequest:SetHTTPRequestNetworkActivityTimeout(fTimeOut)
    end
    if IsNotNull(hTable) then
        for sParameter, hData in pairs(hTable) do
            hRequest:SetHTTPRequestGetOrPostParameter(sParameter, json.encode(hData))
        end
    end
    hRequest:Send(function(hResponse)
        if hResponse.StatusCode == 200 then
            local hData = json.decode(hResponse.Body)
            if IsNotNull(hData) then
                if fOnSuccess then
                    fOnSuccess(hData, hResponse.StatusCode)
                end
            else
                if fOnError then
                    fOnError(hResponse.Body or "Unknown error (" .. tostring(hResponse.StatusCode) .. ")", hResponse.StatusCode)
                end
            end
        else
            if iTries > 0 then
                iTries = iTries - 1
                SendAnimeRequest(sLink, hTable, fOnSuccess, fOnError, sCheckDedikey, iReloads, fTimeOut)
            else
                if fOnError then
                    fOnError(hResponse.Body or "Unknown error (" .. tostring(hResponse.StatusCode) .. ")", hResponse.StatusCode)
                end
            end
        end
    end)
end
--[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]
if IsServer() then
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    _G.RegistredCustomEventsListeners = RegistredCustomEventsListeners or {}
    for _, lID in pairs(RegistredCustomEventsListeners) do
        CustomGameEventManager:UnregisterListener(lID)
        RegistredCustomEventsListeners[_] = nil
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    RegisterCustomEventListener = function(sEventName, fCallBack)
        table.insert(RegistredCustomEventsListeners, CustomGameEventManager:RegisterListener(sEventName, function(_, args) fCallBack(args) end))
    end
    --!!FUNCTIONS WITH TEAMS\PLAYERS IN, FOR ANIME CODE!!-- TODO: Continue Develop and finish it, replace parts of code which using old code or "roflo" solutions
    --!!ATP - Is [Anime Teams Players]
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ATP_IsActivePlayer = function(iPlayerID)
        if PlayerResource:IsValidPlayerID(iPlayerID) then
            local hMainPickedHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
            local bMainPickedHero = IsNotNull(hMainPickedHero)
            local iConnectedState = PlayerResource:GetConnectionState(iPlayerID)
            local bConnectedState = iConnectedState == DOTA_CONNECTION_STATE_CONNECTED or iConnectedState == DOTA_CONNECTION_STATE_NOT_YET_CONNECTED
            local bHasDCModifier  = bMainPickedHero and hMainPickedHero:HasModifier("modifier_anime_mechanic_player_disconnected")
            return ( ( not bMainPickedHero and bConnectedState ) or not bHasDCModifier )
        end
        return false
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ATP_GetValidTeams = function()
        local hValidTeams = {}
        for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
            if GameRules:GetCustomGameTeamMaxPlayers(iTeamNumber) > 0 then
                table.insert(hValidTeams, iTeamNumber)
            end
        end
        return hValidTeams
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ATP_GetPlayersInTeam = function(iTeamNumber, bActive, bInActive)
        local hPlayersInTeam = {}
        for iPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, iPlayerID)
            if PlayerResource:IsValidPlayerID(iPlayerID) then
                local bIsActivePlayer = ATP_IsActivePlayer(iPlayerID)
                local bInsertToTable  = false
                if bIsActivePlayer then
                    bInsertToTable = bActive
                else
                    bInsertToTable = bInActive
                end
                if bInsertToTable then
                    table.insert(hPlayersInTeam, iPlayerID)
                end
            end
        end
        return hPlayersInTeam
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ATP_GetTeamsWithPlayers = function(bActive, bInActive)
        local hTeamsWithPlayers = {}
        local hValidTeamsTable  = ATP_GetValidTeams()
        for _, iTeamNumber in pairs(hValidTeamsTable) do
            if TableLength(ATP_GetPlayersInTeam(iTeamNumber, bActive, bInActive)) > 0 then
                table.insert(hTeamsWithPlayers, iTeamNumber)
            end
        end
        return hTeamsWithPlayers
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ATP_GetAllPlayers = function(bActive, bInActive) --NOTE: Work only with valid teams inited at game start, if player in not sancted team he will not be handled... maybe it's good or bad who knows. It's count bots too so be care.
        local hAllPlayers      = {}
        local hValidTeamsTable = ATP_GetValidTeams()
        for _, iTeamNumber in pairs(hValidTeamsTable) do
            local hPlayersInTeam = ATP_GetPlayersInTeam(iTeamNumber, bActive, bInActive)
            for __, iPlayerID in pairs(hPlayersInTeam) do
                table.insert(hAllPlayers, iPlayerID)
            end
        end
        return hAllPlayers
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    FindUnitsInRing = function(iTeamNumber, vPosition, hCacheUnit, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache, fRingWidth)
        local hUnits1 = FindUnitsInRadius(iTeamNumber, vPosition, hCacheUnit, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache)
        local hUnits2 = {}
        for _, hUnit in pairs(hUnits1) do
            if IsNotNull(hUnit) 
                and GetDistance(hUnit, vPosition) >= ( fRadius - fRingWidth ) then
                table.insert(hUnits2, hUnit)
            end
        end
        return hUnits2
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    FindUnitsInCone = function(iTeamNumber, vPosition, hCacheUnit, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache, vDirection, fStartRadius, fEndRadius, fLength)
        if type(vDirection) ~= "userdata" or type(fStartRadius) ~= "number" or type(fEndRadius) ~= "number" or type(fLength) ~= "number" then
            error("Error return {} table, in FindUnitsInCone")
            return {}
        end
        --NOTE: Has fixed UnitsInLine, withous boxing.... NOT FIXED BECAUSE IT'S FUCKING CRINGE, BETTER USE CUSTOM FUNCTION, IT'S MORE IDEAL
        --if fStartRadius == fEndRadius then
            --if IsInToolsMode() then
                --print("FINDING IN LINE, EXCEPT CONE")
            --end
            --return FindUnitsInLine(iTeamNumber, vPosition + vDirection * 200, vPosition + vDirection * 201, hCacheUnit, 400, iTeamFilter, iTypeFilter, iFlagFilter)
        --end
        local vDirectionCone = Vector(vDirection.y, -vDirection.x, 0.0)
        local hUnits1 = FindUnitsInRadius(iTeamNumber, vPosition, hCacheUnit, fEndRadius + fLength, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache)
        local hUnits2 = {}
        for _, hUnit in pairs(hUnits1) do
            if IsNotNull(hUnit) then
                local vPotential    = hUnit:GetAbsOrigin() - vPosition
                local fSideAmmount  = math.abs( ( vPotential.x * vDirectionCone.x ) + ( vPotential.y * vDirectionCone.y ) + ( vPotential.z * vDirectionCone.z ) )
                local fDistance     = ( ( vPotential.x * vDirection.x ) + ( vPotential.y * vDirection.y ) + ( vPotential.z * vDirection.z ) )
                local fRadiusIncMax = fEndRadius - fStartRadius
                local fDistancePCT  = fDistance / fLength
                local fRadiusInc    = fRadiusIncMax * fDistancePCT

                if fSideAmmount < ( fStartRadius + fRadiusInc ) and fDistance > 0 and fDistance < fLength then
                    table.insert(hUnits2, hUnit)
                end
            end
        end
        return hUnits2
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    GetClearPositionForClassnameInSphere = function(sClassName, vPosition, fItemRadius, bRandom) --IDK WHY BUT VALUE <= 30 NOT FOUNDING WTFFFF
        local hRandomTable  = {}
        local vCurrentPoint = vPosition
        local hEntities = Entities:FindAllByClassnameWithin(sClassName, vPosition, fItemRadius)
        if TableLength(hEntities) > 0 then
            local iCurrentValueX = 1
            while vCurrentPoint == vPosition do
                local iCurrentRadius = iCurrentValueX * ( fItemRadius * 2 )
                local iPossibleItems = iCurrentRadius > 0
                                       and math.floor( math.pi / math.asin( fItemRadius / iCurrentRadius ) )
                                       or 1
                local vStartPoint = vPosition + Vector(1, 1, 0) * iCurrentRadius
                local fAngles     = 360 / iPossibleItems
                for i = 1, iPossibleItems do
                    local hItemsAround = Entities:FindAllByClassnameWithin(sClassName, vStartPoint, fItemRadius)
                    if TableLength(hItemsAround) < 1 then
                        vCurrentPoint = vStartPoint
                        table.insert(hRandomTable, vStartPoint)
                    end
                    vStartPoint = RotatePosition(vPosition, QAngle(0, fAngles, 0), vStartPoint)
                end
                iCurrentValueX = iCurrentValueX + 1
            end
        end
        if bRandom
            and TableLength(hRandomTable) > 0 then
            return TablePick(hRandomTable, hRandomTable, true)
        end
        return vCurrentPoint
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    RotateVector2D = function(vVector, fAngle, bIsDegreeNotRad)
        fAngle = bIsDegreeNotRad and math.rad(fAngle) or fAngle
        local sinA = math.sin(fAngle)
        local cosA = math.cos(fAngle)
        local vXP = ( vVector.x * cosA ) - ( vVector.y * sinA )
        local vYP = ( vVector.x * sinA ) + ( vVector.y * cosA )
        return Vector(vXP, vYP, vVector.z):Normalized()
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    RollPseudoRandom = function(fChance, hEntity) --CAN'T BE USED FOR GLOBAL GetGameEntity??? YES, NOT WORK
        if type(fChance) == "number" 
            and IsNotNull(hEntity) then
            local sEntityName = hEntity:GetName()

            hEntity = type(hEntity.GetCaster) == "function"
                      and hEntity:GetCaster()
                      or hEntity

            hEntity.RollPseudoRandomTableIDS              = hEntity.RollPseudoRandomTableIDS or {}
            hEntity.RollPseudoRandomTableIDS[sEntityName] = hEntity.RollPseudoRandomTableIDS[sEntityName] or ( TableLength(hEntity.RollPseudoRandomTableIDS) + 1 )
            
            return RollPseudoRandomPercentage( fChance, hEntity.RollPseudoRandomTableIDS[sEntityName], hEntity )
            --return RollPseudoRandomPercentage( fChance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, hEntity )
        end
        return false
    end

end
--[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!DOTA2 CUSTOM FUNCTIONS!!----------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CreateTalentsModifiers = function(sShortHeroName) --NOT NEED CAUSE REWORKED A LONG TIME AGO TO INSTANT FIND ABILITY IN CLIENT
    --[[for i = 10, 25, 5 do
        local sModifierName_r = "modifier_special_bonus_anime_"..sShortHeroName.."_"..i.."r"
        local sModifierName_l = "modifier_special_bonus_anime_"..sShortHeroName.."_"..i.."l"

        LinkLuaModifier(sModifierName_r, "anime_requires/anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)
        LinkLuaModifier(sModifierName_l, "anime_requires/anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE) 

        local sTypeModifier = [[ = class({   
                                            IsHidden = function(self)               return true end,
                                            IsDebuff = function(self)               return false end,
                                            IsPurgable = function(self)             return false end,
                                            IsPurgeException = function(self)       return false end,
                                            RemoveOnDeath = function(self)          return false end,
                                            GetAttributes = function(self)          return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end,
                                            GetPriority = function(self)            return MODIFIER_PRIORITY_ULTRA end,
                                            AllowIllusionDuplicate = function(self) return true end,
                                            IsMarbleException = function(self)      return true end
                                        })]]
        
    --[[    sModifierName_r = sModifierName_r..sTypeModifier
        sModifierName_l = sModifierName_l..sTypeModifier

        load(sModifierName_r)()
        load(sModifierName_l)()
    end]]
end




--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC
----------------------------------------------------------------------------------------------------------------------------------------

--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_BaseNPC.HasTalent = function(self, sTalentName)
    sTalentName = string.lower(sTalentName)
    if IsNotNull(self) then
        local hTalent = self:FindAbilityByName(sTalentName) --NEW THING 25.03.2021 BY GABEN 
        return IsNotNull(hTalent)
               and hTalent:GetLevel() > 0
    end
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_BaseNPC.FindTalentValue = function(self, sTalentName, sKey, fDefaultValue)
    sTalentName = string.lower(sTalentName)
    if self:HasTalent(sTalentName) then
        local sKey = sKey or "value"
        return self:FindAbilityByName(sTalentName):GetSpecialValueFor(sKey)
    end
    return fDefaultValue or 0
end



--============================----============================----============================----============================--
--============================----==========================SUICIDE!==========================----============================--
--============================----============================----============================----============================--


LinkLuaModifier("modifier_ae86_suicide", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_toilet_model", "heroes/anime_hero_ae86_new", LUA_MODIFIER_MOTION_NONE)

ae86_suicide = ae86_suicide or class({})
 
  
function ae86_suicide:OnChannelFinish(bInterrupted)
    local hCaster = self:GetCaster()
    StopSoundOn(self.sound, hCaster)
    if self.ChannelTime  > self:GetSpecialValueFor("minimum_channel_time") then
        local base_dmg = self:GetSpecialValueFor("base_dmg")
        local charge_dmg = base_dmg + (self:GetSpecialValueFor("damage_max_channel") - base_dmg)* (self.ChannelTime/self:GetChannelTime())
        hCaster:AddNewModifier(hCaster, self, "modifier_ae86_suicide", {damage = base_dmg + charge_dmg,
																	speed = self:GetSpecialValueFor("speed")})

                                                                    
    else
        self:EndCooldown()
        self:StartCooldown(self:GetSpecialValueFor("not_casted_cd"))
        if( self.wastoggled == true) then
            self.drift.bRacingMod = true
        end
        if(self.isToilet )then
            hCaster:RemoveModifierByName("modifier_toilet_model")
        end
    end
end

function ae86_suicide:OnSpellStart()
    local hCaster = self:GetCaster()
	self.ChannelTime = 0
    self.isToilet = hCaster:HasScepter()
    self.target = self:GetCursorPosition()
    self.drift = hCaster:FindAbilityByName("ae86_drift")
    self.wastoggled = false
    if(self.drift.bRacingMod == true) then
        self.drift.bRacingMod = false
        self.wastoggled = true
    end
    self.sound = nil  
    if(self.isToilet )then
        self.sound = "charge_sound_ae86_toilet"
        hCaster:AddNewModifier(hCaster, self, "modifier_toilet_model", {duration = 15})
    else
        self.sound = "charge_sound_ae86"
    end

    EmitSoundOn(self.sound, hCaster)
	--self.particle_kappa = ParticleManager:CreateParticle("particles/custom/mordred/max_excalibur/charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
end


function ae86_suicide:OnChannelThink(fInterval)
    self.ChannelTime = self.ChannelTime + fInterval
    self:GetCaster():FaceTowards(self.target)
end





modifier_ae86_suicide = class({})

function modifier_ae86_suicide:OnCreated(args)
	self.parent = self:GetParent()
    
	self.ability = self:GetAbility()
    self.target = self.ability.target
    self.sound = nil  
    if(self.ability.isToilet )then
        self.sound = "explosion_ae86_toilet"
    else
        self.sound = "run_sound_ae86"
    end

    EmitSoundOn(self.sound, self.parent)
    if IsServer() then
    if not self.DriftingFX then
        if(self.ability.isToilet )then
             self.DriftingFX =           ParticleManager:CreateParticle("particles/ae86_toilet_run.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
             ParticleManager:SetParticleControl(self.DriftingFX, 0, self.parent:GetAbsOrigin())
             ParticleManager:SetParticleControl(self.DriftingFX, 1, self.parent:GetForwardVector() * 3500)
             ParticleManager:SetParticleControl(self.DriftingFX, 2, self.parent:GetAbsOrigin())
             ParticleManager:SetParticleControl(self.DriftingFX, 3, self.parent:GetAbsOrigin())

        else
             local vColor =   Vector(220, 10, 10)
             self.DriftingFX =           ParticleManager:CreateParticle("particles/heroes/anime_hero_ae86/ae86_drift.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
             ParticleManager:SetParticleControl(self.DriftingFX, 0, self.parent:GetAbsOrigin())
             ParticleManager:SetParticleControl(self.DriftingFX, 10, self.parent:GetForwardVector())
             ParticleManager:SetParticleControl(self.DriftingFX, 60, vColor)
             ParticleManager:SetParticleControl(self.DriftingFX, 61, vColor)
             ParticleManager:SetParticleControl(self.DriftingFX, 62, vColor)
        end

    else
                ParticleManager:DestroyParticle(self.DriftingFX, false)
                ParticleManager:ReleaseParticleIndex(self.DriftingFX)

                self.DriftingFX = nil
    end
	
		self.damage = args.damage
		self.speed = args.speed
		self:StartIntervalThink(FrameTime())
		if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
        end
	end
end

function modifier_ae86_suicide:IsHidden() return true end
function modifier_ae86_suicide:IsDebuff() return false end
function modifier_ae86_suicide:RemoveOnDeath() return true end
function modifier_ae86_suicide:GetPriority() return MODIFIER_PRIORITY_HIGH end

function modifier_ae86_suicide:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_STUNNED] = true,
                    --[MODIFIER_STATE_FLYING] = true 
                }
    return state
end
function modifier_ae86_suicide:OnRefresh(args)
    self:OnCreated(args)
end
function modifier_ae86_suicide:OnDestroy()
    StopSoundOn(self.sound, self.parent )
    if  self.DriftingFX then
                ParticleManager:DestroyParticle(self.DriftingFX, false)
                ParticleManager:ReleaseParticleIndex(self.DriftingFX)
                self.DriftingFX = nil
    end
    if( self.ability.wastoggled == true) then
        self.ability.drift.bRacingMod = true
    end
    if IsServer() then
        self.parent:InterruptMotionControllers(true)
        if self.ability.particle_kappa then
            ParticleManager:DestroyParticle(self.ability.particle_kappa, false)
            ParticleManager:ReleaseParticleIndex(self.ability.particle_kappa)
        end
    end
end
function modifier_ae86_suicide:UpdateHorizontalMotion(me, dt)
    if (self.target - self.parent:GetOrigin()):Length2D() < 100 then
        self:BOOM()
        self:Destroy()
        return nil
    end
    self:Rush(me, dt)
end

function modifier_ae86_suicide:BOOM()
    if(self.ability.isToilet )then
        --EmitGlobalSound("explosion_ae86_toilet")
        EmitGlobalSound("explosion_ae86_toilet_2")
        local blow_fx =     ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship_impact.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
        ParticleManager:SetParticleControl(blow_fx, 0, self.target)
        ParticleManager:SetParticleControl(blow_fx, 3, self.target)
    else
        EmitSoundOn("explosion_ae86", self.parent )
        local blow_fx =     ParticleManager:CreateParticle("particles/ae86_explosion.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
        ParticleManager:SetParticleControl(blow_fx, 0, self.target)
        ParticleManager:SetParticleControl(blow_fx, 1,Vector(self.ability:GetSpecialValueFor("explosion_radius"),0,0))
        ParticleManager:ReleaseParticleIndex(blow_fx)
    end
   

    local enemies = FindUnitsInRadius(  self.parent:GetTeamNumber(),
                                        self.target,
                                        nil,
                                        self.ability:GetSpecialValueFor("explosion_radius"),
                                        self.ability:GetAbilityTargetTeam(),
                                        self.ability:GetAbilityTargetType(),
                                        self.ability:GetAbilityTargetFlags(),
                                        FIND_ANY_ORDER,
                                        false)



	    for _, enemy in pairs(enemies) do
	        if enemy and not enemy:IsNull() and IsValidEntity(enemy)  then
                ApplyDamage({
                    victim = enemy,
                    attacker = self.parent,
                    damage = self.damage,
                    damage_type = self.ability:GetAbilityDamageType(),
                    damage_flags = 0,
                    ability = self.ability
                })
	        end
	    end
    self.parent:Kill(self.ability,self.parent)    


    --EmitSoundOnLocationWithCaster(position, "Archer.HruntHit", self.parent)
end
function modifier_ae86_suicide:Rush(me, dt)
    local pos = self.parent:GetOrigin()
    local direction = self.target - pos
    direction.z = 0     
    local target = pos + direction:Normalized() * (self.speed * dt)
    self.parent:SetOrigin(target)
    self.parent:FaceTowards(self.target)

end
function modifier_ae86_suicide:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end


modifier_toilet_model = class({})

function modifier_toilet_model:OnCreated()
	self.parent = self:GetParent()
end
function modifier_toilet_model:OnRespawn(args)
	if(args.unit == self.parent) then
        self:Destroy()
    end
end


function modifier_toilet_model:DeclareFunctions()
	local funcs = {
				MODIFIER_PROPERTY_MODEL_CHANGE,
                MODIFIER_EVENT_ON_RESPAWN
	}

	return funcs
end

function modifier_toilet_model:GetModifierModelChange()
	self.model_fx = "models/toilet/toilet.vmdl"
	return self.model_fx
end

 
function modifier_toilet_model:IsHidden()
	return true
end

function modifier_toilet_model:IsDebuff()
	return false
end

function modifier_toilet_model:RemoveOnDeath()
	return false
end

function modifier_toilet_model:GetAttributes()
  	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end