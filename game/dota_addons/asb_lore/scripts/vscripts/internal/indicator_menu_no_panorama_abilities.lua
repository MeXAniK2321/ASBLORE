---------------------------------------------------------------------------------------
-- CUSTOM ABILITIES TEST FOR INDICATOR WITH NO PANORAMA
---------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- TEST FOR AIM SKILLSHOT TYPE
---------------------------------------------------------------------------------------------------------------

npan_aim_skillshot_test = npan_aim_skillshot_test or class({})

function npan_aim_skillshot_test:CastFilterResultLocation(vLocation)
    NPAN_INDICATOR:RegisterAbility(self, NPAN_INDICATOR_TYPE_AIM_SKILLSHOT, "particles/test/custom/range_finder_cone_no_panorama/range_finder_cone.vpcf")
    NPAN_INDICATOR:CreateUIIndicator(self:GetCaster(), self, vLocation)
end
function npan_aim_skillshot_test:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function npan_aim_skillshot_test:OnSpellStart()
    local hCaster = self:GetCaster()
    
    self:CreateRedOrb()
end
function npan_aim_skillshot_test:CreateRedOrb()
    local hCaster      = self:GetCaster()
    local vCursorLoc   = self:GetCursorPosition()
    local f__Radius    = self:GetSpecialValueFor("radius")
    local i__Speed     = self:GetSpecialValueFor("movespeed")
    local f__Distance  = self:GetSpecialValueFor("distance")
    
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
function npan_aim_skillshot_test:OnProjectileThinkHandle(iProjectile)
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
-- TEST FOR VECTOR MENU TYPE
---------------------------------------------------------------------------------------------------------------

npan_vector_menu_test = npan_vector_menu_test or class({})

function npan_vector_menu_test:CastFilterResultLocation(vLocation)
    NPAN_INDICATOR:RegisterAbility(self, NPAN_INDICATOR_TYPE_VECTOR_MENU, "particles/test/custom/vector_target_no_panorama/number_menu_shit_test/menu_main22.vpcf")
    NPAN_INDICATOR:CreateUIIndicator(self:GetCaster(), self, vLocation)
end
function npan_vector_menu_test:GetAOERadius()
    return 250
end
function npan_vector_menu_test:GetBehavior()
    if IsClient() then
        local hController       = Entities:GetLocalPlayer()
        local iClickBehave      = hController:GetClickBehaviors()
            
        if iClickBehave == DOTA_CLICK_BEHAVIOR_VECTOR_CAST then
            if self.bTest then
                if type(self.bTest) == "boolean" then self.bTest = "TEST" return end
                return DOTA_ABILITY_BEHAVIOR_POINT
            end
        end
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING + DOTA_ABILITY_BEHAVIOR_AOE
end
function npan_vector_menu_test:OnSpellStart()
    local hCaster       = self:GetCaster()
    local vStartingPos  = self.vStartPos or Vector(0, 0, 0)
    local vEndPos       = self:GetCursorPosition()
    local nTeamNumber   = hCaster:GetTeamNumber()
    
    if vStartingPos and vEndPos then
        local qCurrent = NPAN_INDICATOR:CheckQuadrant(vEndPos, vStartingPos)
        self:SpellSelect(qCurrent)
        Say(hCaster, "QUADRANT: " .. qCurrent, false)
    else
        Say(hCaster, "NANI????", false)
    end
end
function npan_vector_menu_test:SpellSelect(nQuadrant)
    if not nQuadrant then return end
    
    local hCaster = self:GetCaster()
    
    if nQuadrant == qUP then
        hCaster:SetOrigin(self:GetCursorPosition())
    elseif nQuadrant == qLEFT then
        local hPlayer        = hCaster:GetPlayerOwner()
        local hMeteorItem    = CreateItem("item_meteor_hammer", hPlayer, self)
        local fDurationTimer = GameRules:GetGameTime() + 4.0
        if IsNotNull(hMeteorItem) then
            local vCurPos = self:GetCursorPosition()
            hCaster:AddItem(hMeteorItem)
            Timers:CreateTimer(0.03, function()
                if not IsNotNull(hMeteorItem) then
                    return nil
                end
                
                hCaster:SetCursorPosition(vCurPos)
                hMeteorItem:OnSpellStart()
                hMeteorItem:OnChannelFinish(false)
                
                if GameRules:GetGameTime() < fDurationTimer then
                    return 0.1
                end
            end)
        end
    end
end

---------------------------------------------------------------------------------------------------------------
-- TEST FOR VECTOR RADIUS TYPE
---------------------------------------------------------------------------------------------------------------

npan_vector_radius_test = npan_vector_radius_test or class({})

function npan_vector_radius_test:CastFilterResultLocation(vLocation)
    NPAN_INDICATOR:RegisterAbility(self, NPAN_INDICATOR_TYPE_VECTOR_RADIUS, "particles/test/custom/range_finder_aoe_no_panorama/range_finder_aoe_test.vpcf")
    NPAN_INDICATOR:CreateUIIndicator(self:GetCaster(), self, vLocation)
end
function npan_vector_radius_test:GetAOERadius()
    return self:GetSpecialValueFor("distance")
end
function npan_vector_radius_test:GetBehavior()
    if IsClient() then
        local hController       = Entities:GetLocalPlayer()
        local iClickBehave      = hController:GetClickBehaviors()
            
        if iClickBehave == DOTA_CLICK_BEHAVIOR_VECTOR_CAST then
            if self.bTest then
                if type(self.bTest) == "boolean" then self.bTest = "TEST" return end
                return DOTA_ABILITY_BEHAVIOR_POINT
            end
        end
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING + DOTA_ABILITY_BEHAVIOR_AOE
end
function npan_vector_radius_test:OnSpellStart()
    local hCaster       = self:GetCaster()
    local vStartingPos  = self.vStartPos
    local vEndPos       = self:GetCursorPosition()
    
    if vStartingPos and vEndPos then
        local fDistanceMin = self:GetSpecialValueFor("distance")
        local fDistanceMax = self:GetSpecialValueFor("distance_max")
        local fDistanceCur = GetDistance(vEndPos, vStartingPos)
        fDistanceCur       = math.min(fDistanceMax, math.max(fDistanceMin, fDistanceMin + fDistanceCur))
        
        local nEffectAOE = ParticleManager:CreateParticle("particles/decompiled_particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_WORLDORIGIN, nil)
                           ParticleManager:SetParticleControl(nEffectAOE, 0, vEndPos)
                           ParticleManager:SetParticleControl(nEffectAOE, 1, Vector(fDistanceCur, fDistanceCur, 0))
                           
        Timers:CreateTimer(4.0, function()
            if nEffectAOE then
                ParticleManager:DestroyParticle(nEffectAOE, false)
                ParticleManager:ReleaseParticleIndex(nEffectAOE)
            end
        end)
        
        --print(fDistanceCur)
    else
        Say(hCaster, "NANI????", false)
    end
end


