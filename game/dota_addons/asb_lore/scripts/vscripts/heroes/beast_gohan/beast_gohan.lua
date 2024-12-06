
local tGohanAbilityKICosts = {
                                 beast_gohan_kamehameha = 100,
                             }
                             
local tGohanSaiyanModels =   {
                                 --1
                                 "models/heroes/anime/dragon_ball/adult_gohan.vmdl",
                                 --2
                                 "models/heroes/anime/dragon_ball/adult_gohan_ssj.vmdl",
                                 --3
                                 "models/heroes/anime/dragon_ball/beast_gohan.vmdl",
                             }

-- Get stored KI
GetStoredKI = function(hCaster)
    return hCaster.nStoredKI
end

-- Set KI and see if it has reached Max KI, useful when lerping and checking
SetStoredKI = function(hCaster, nSetKI, nMaxKI)
    if nSetKI then
        if nSetKI < 0 then nSetKI = 0 end
        nMaxKI = nMaxKI or nSetKI
        hCaster.nStoredKI = math.min(nSetKI, nMaxKI)
        return hCaster.nStoredKI == nMaxKI
    end
    return false
end

-- Set KI on the Visual UI Particle Bar
SetBarKI = function(nFX, nKI, nCP)
    if nFX then
        nKI = nKI or 0 -- If you want just set SetBarKI(nFX) to reset bar easily
        if nKI < 0 then nKI = 0 end
        nCP = nCP or 8 -- Default CP is 8
        ParticleManager:SetParticleControl(nFX, nCP, Vector(nKI, 0, 0))
    end
end

-- Check Abilities for KI Costs
SetAndCheckKISpells = function(hCaster, hAbility)
    local keys = {}
    keys.unit, keys.ability = hCaster, hAbility
    return keys
end

-- Set the current Super Saiyan Form and Update Model
GetSuperSaiyanModel = function(nForm)
    if nForm then
        return tGohanSaiyanModels[nForm]
    end
end

-- Get the current Super Saiyan Form
GetSuperSaiyan = function(hCaster)
    return hCaster.SuperSaiyan
end

-- Set the current Super Saiyan Form and Update Model
SetSuperSaiyan = function(hCaster, nForm, nMax)
    if nForm then
        nMax = nMax or 1
        if nForm <= 0 or nForm > nMax then nForm = 1 end
        local sModelName = GetSuperSaiyanModel(nForm)
        
        hCaster:SetModel(sModelName)
        hCaster:SetOriginalModel(sModelName)
        hCaster.SuperSaiyan = nForm
    end
end

-- Destroy a particle and release its index, (bReset) if table value
-- Use Scenario 1: DestroyAndReleaseParticle(nFX, false, true) (Table)
-- Use Scenario 2: nFX = DestroyAndReleaseParticle(nFX, false) (Update)
DestroyAndReleaseParticle = function(nFX, bDestroyImmediately, bReset)
    if nFX then
        bDestroyImmediately = bDestroyImmediately or false
        bReset = bReset or false
        ParticleManager:DestroyParticle( nFX, bDestroyImmediately )
        ParticleManager:ReleaseParticleIndex( nFX )
        if bReset then nFX = nil end
    end
    return nil
end

---------------------------------------------------------------------------------------------------------------
-- Beast Gohan Kamehameha (Q)
---------------------------------------------------------------------------------------------------------------
beast_gohan_kamehameha = beast_gohan_kamehameha or class({})
LinkLuaModifier("beast_gohan_kamehameha_modifier", "heroes/beast_gohan/beast_gohan.lua", LUA_MODIFIER_MOTION_NONE)

function beast_gohan_kamehameha:OnSpellStart()

end
--function beast_gohan_kamehameha:OnChannelThink(0.1)
    --local hCaster = self:GetCaster()
    
    -- Insert targeting indicator here for range
    --print("Gohan Kamehameha Channeling")
--end
function beast_gohan_kamehameha:OnChannelFinish(bInterrupted)
    if IsServer() then
        local hCaster   = self:GetCaster()
    
        self:LaunchKamehameha()
    end
end
function beast_gohan_kamehameha:LaunchKamehameha()
    local hCaster        = self:GetCaster()
    local vForwardVec    = hCaster:GetForwardVector()
    local vCursorPos     = self:GetCursorPosition()
    local vCastLocation  = GetDirection(vCursorPos, hCaster:GetOrigin())
    local vSpawnLocation = ( hCaster:GetOrigin() + vForwardVec * 200 ) + Vector(0, 0, 100)
    local fDistance      = 5000
    local fSpeed         = 2500
    local vVelocity      = (vCastLocation or vForwardVec) * fSpeed
    
    hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    
    local nKamehamehaFX = ParticleManager:CreateParticle("particles/test/custom/gohan_kamehameha_test/gohan_kamehameha_main.vpcf", PATTACH_WORLDORIGIN, nil)
                          ParticleManager:SetParticleControl(nKamehamehaFX, 0, vSpawnLocation)
                          ParticleManager:SetParticleControl(nKamehamehaFX, 6, vVelocity)
                          
    EmitSoundOn("Gogeta.kamehameha", hCaster)
                          
    local hKamehameha = {   
                            Ability             = self,
                            EffectName          = "", --"particles/moonlight_goddess_bow_arrow.vpcf",
                            vSpawnOrigin        = vSpawnLocation,
                            fDistance           = fDistance,
                            fStartRadius        = 200,
                            fEndRadius          = 200,
                            Source              = hCaster,
                            bHasFrontalCone     = false,
                            bReplaceExisting    = false,
                            iUnitTargetTeam     = self:GetAbilityTargetTeam(),
                            iUnitTargetFlags    = self:GetAbilityTargetFlags(),
                            iUnitTargetType     = self:GetAbilityTargetType(),
                            --fExpireTime         = GameRules:GetGameTime() + 30,
                            --bDeleteOnHit        = false,
                            vVelocity           = vVelocity,
                            bProvidesVision     = true,
                            iVisionRadius     	= 300,
                            iVisionTeamNumber 	= hCaster:GetTeamNumber(),
                            ExtraData 			= { nKamehamehaFX = nKamehamehaFX }
                        }

    ProjectileManager:CreateLinearProjectile(hKamehameha)
    
    local hModifier = hCaster:AddNewModifier(hCaster, self, "beast_gohan_kamehameha_modifier", {duration = fDistance / fSpeed, nKamehamehaFX = nKamehamehaFX})
    
    if IsNotNull(hModifier) then
        hModifier.vCastLocation = vCastLocation
    end
end
function beast_gohan_kamehameha:OnProjectileThink_ExtraData(vLocation, hTable)
	if IsNotNull(self) then
        local hCaster       = self:GetCaster()
        local vCasterOrigin = hCaster:GetOrigin()
        local vDirection    = GetDirection(vLocation, hCaster)
        local hTableClosest = {}
        
        GridNav:DestroyTreesAroundPoint(vLocation, 200, false)
        
        local hClosest = FindUnitsInRadius(hCaster:GetTeamNumber(),  -- int, your team number
                                           vLocation,  -- point, center point
                                           nil,  -- handle, cacheUnit. (not known)
                                           200,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                           self:GetAbilityTargetTeam(),  -- int, team filter
                                           self:GetAbilityTargetType(),  -- int, type filter
                                           self:GetAbilityTargetFlags(),  -- int, flag filter
                                           FIND_ANY_ORDER,  -- int, order filter
                                           false  -- bool, can grow cache
                                         )
        
        for _, hEnemy in pairs(hClosest) do
            if IsNotNull(hEnemy) and hEnemy ~= hCaster then
                local vPushTarget = hEnemy:GetAbsOrigin() + vDirection * ( 2500 * FrameTime() )
                local fPushDuration = FrameTime()                        
                
                -- Phase modifier and corrects position
                hEnemy:AddNewModifier(hCaster, self, "modifier_phased", { duration = fPushDuration })
                
                -- Stun enemies
                hEnemy:AddNewModifier(hCaster, self, "modifier_generic_stunned_lua", { duration = fPushDuration })
                
                -- Push Enemies
                hEnemy:SetAbsOrigin(vPushTarget)
                
                -- Store enemies for line check
                hTableClosest[tostring(hEnemy:entindex())] = true
            end
        end
        
        local hEnemies = FindUnitsInLine(hCaster:GetTeamNumber(),
                                         vCasterOrigin,
                                         vLocation,
                                         nil,
                                         200,
                                         self:GetAbilityTargetTeam(),
                                         self:GetAbilityTargetType(),
                                         self:GetAbilityTargetFlags() )
                            
---------------------------------------------------------------------------------------------------        
        for _, hEnemy in pairs(hEnemies) do
            local hDamageTable = {  victim = hEnemy,
                                    attacker = hCaster,
                                    damage = 500 * FrameTime(),
                                    damage_type = self:GetAbilityDamageType(),
                                    ability = self }
                                    
            if not hTableClosest[tostring(hEnemy:entindex())] then
                local vPushTarget = hEnemy:GetAbsOrigin() + vDirection * ( 200 * FrameTime() )
                local fPushDuration = FrameTime()                        
                
                -- Phase modifier and corrects position
                hEnemy:AddNewModifier(hCaster, self, "modifier_phased", { duration = fPushDuration })
                
                -- Stun enemies
                hEnemy:AddNewModifier(hCaster, self, "modifier_generic_stunned_lua", { duration = fPushDuration })
                
                -- Push Enemies
                hEnemy:SetAbsOrigin(vPushTarget)
            end
            
            ApplyDamage(hDamageTable)
        end
        
        hTableClosest = nil
    end
end
function beast_gohan_kamehameha:OnProjectileHit_ExtraData(hTarget, vLocation, hTable)
	if IsNotNull(self) then
		if not IsNotNull(hTarget) then
            DestroyAndReleaseParticle(hTable.nKamehamehaFX, false, true)
            print("KAMEHAMEHA REMOVED?????")
            return
        end
		
        local hCaster   = self:GetCaster()

        local hDamageTable =    {  
                                    victim 		 = hTarget,
                                    attacker 	 = hCaster,
                                    damage 		 = 4000,
                                    damage_type  = self:GetAbilityDamageType(),
                                    ability 	 = self,
                             		damage_flags = 0
                                }
                                
        local hKnockBackTable = {
                                    should_stun        = 1,
                                    knockback_duration = 1,
                                    duration           = 1,
                                    knockback_distance = 200,
                                    knockback_height   = 200,
                                    center_x           = vLocation.x,
                                    center_y           = vLocation.y,
                                    center_z           = vLocation.z
                                }
                                
        hTarget:RemoveModifierByName("modifier_knockback")
        --hTarget:AddNewModifier(hCaster, self, "modifier_knockback", hKnockBackTable, hTarget:IsOpposingTeam(hCaster:GetTeamNumber()))
        
        ApplyDamage(hDamageTable)
    end
    
    print("KAMEHAMEHA HITTING?????")
end

---------------------------------------------------------------------------------------------------------------
beast_gohan_kamehameha_modifier = beast_gohan_kamehameha_modifier or class({})

function beast_gohan_kamehameha_modifier:IsHidden() return false end
function beast_gohan_kamehameha_modifier:IsPurgeable() return false end
function beast_gohan_kamehameha_modifier:IsPurgeException() return false end
function beast_gohan_kamehameha_modifier:RemoveOnDeath() return true end
function beast_gohan_kamehameha_modifier:CheckState()
    local state =   { 
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_ROOTED] = true,
                        [MODIFIER_STATE_DISARMED] = true,
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED] = true,
                    }
    return state
end
function beast_gohan_kamehameha_modifier:OnCreated(hTable)
    if IsServer() then
       self.caster  = self:GetCaster()
       self.parent  = self:GetParent()
       self.ability = self:GetAbility()
       
       self.nKamehamehaFX  = self.nKamehamehaFX or hTable.nKamehamehaFX
       self.vGroundHeight  = Vector(0, 0, 100)
       
       self:StartIntervalThink(0.05)
       self:OnIntervalThink()
    end
end
function beast_gohan_kamehameha_modifier:OnIntervalThink()
    if self.nKamehamehaFX then
        local vSpawnLocation = ( self.parent:GetOrigin() + self.parent:GetForwardVector() * 200 ) + self.vGroundHeight
        ParticleManager:SetParticleControl(self.nKamehamehaFX, 0, vSpawnLocation)
        
        --if self.vCastLocation then
            --self.parent:SetForwardVector(self.vCastLocation, true)
            --self.parent:FaceTowards(self.vCastLocation)
        --end
    end
end
function beast_gohan_kamehameha_modifier:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function beast_gohan_kamehameha_modifier:OnDestroy()
    if IsServer() then
        DestroyAndReleaseParticle(self.nKamehamehaFX, false, true)
        StopSoundOn("Gogeta.kamehameha", self.parent)
    end
end


---------------------------------------------------------------------------------------------------------------
-- Beast Gohan Transform (W)
---------------------------------------------------------------------------------------------------------------
beast_gohan_transform = beast_gohan_transform or class({})

function beast_gohan_transform:OnSpellStart()
    local hCaster     = self:GetCaster()
    local nSaiyanForm = GetSuperSaiyan(hCaster)
    local hModifier   = hCaster:FindModifierByName("db_powerup_test_modifier")
    
    if not nSaiyanForm then
        SetSuperSaiyan(hCaster, 2, 3)
    elseif nSaiyanForm == 3 then
        SetSuperSaiyan(hCaster, 1, 3)
    else
        SetSuperSaiyan(hCaster, nSaiyanForm + 1, 3)
    end

    if IsNotNull(hModifier) then
        hModifier:SendBuffRefreshToClients()
    end        
end


---------------------------------------------------------------------------------------------------------------
-- DB POWERUP TEST
---------------------------------------------------------------------------------------------------------------
db_powerup_test = db_powerup_test or class({})
LinkLuaModifier("db_powerup_test_modifier", "heroes/beast_gohan/beast_gohan.lua", LUA_MODIFIER_MOTION_NONE)

function db_powerup_test:Spawn()
    if not IsServer() then return end

    local hCaster = self:GetCaster()
    
    if not hCaster:HasModifier("db_powerup_test_modifier") then
        hCaster:AddNewModifier(hCaster, self, "db_powerup_test_modifier", {})
    end
end
function db_powerup_test:GetAbilityTextureName()
     local hCaster      = self:GetCaster()
     local nSaiyanForm  = GetSuperSaiyan(hCaster)
     local sTextureName = self.BaseClass.GetAbilityTextureName(self)
     
     if nSaiyanForm then
         if nSaiyanForm == 2 then
             sTextureName = "beast_gohan_ssj"
         elseif nSaiyanForm == 3 then
             sTextureName = "beast_gohan_beast"
         end
     end
     
     return sTextureName
end
function db_powerup_test:OnSpellStart()
    local hCaster = self:GetCaster()
    local hModifier = hCaster:FindModifierByName("db_powerup_test_modifier")
    
    if IsNotNull(hModifier) then
        local nSaiyanForm = GetSuperSaiyan(hCaster)
        if not nSaiyanForm then
            SetSuperSaiyan(hCaster, 1, 3)
            nSaiyanForm = GetSuperSaiyan(hCaster)
        end
        
        GridNav:DestroyTreesAroundPoint(hCaster:GetOrigin(), 500, false)
        
        self.nChargingFX  = ParticleManager:CreateParticle("particles/test/custom/cringe_aura/gohan_auras/saiyan_aura_gohan" .. nSaiyanForm .. ".vpcf", PATTACH_CUSTOMORIGIN, hCaster)
                            ParticleManager:SetParticleControlEnt(self.nChargingFX, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin() + Vector(0, 0, 500), true)
        hCaster:StartGesture(ACT_DOTA_CHANNEL_ABILITY_3)
        hModifier:StartIntervalThink(0.1)
        print("NANI")
    else
        print("HMMMM")
    end

end
function db_powerup_test:OnChannelFinish(bInterrupted)
    local hCaster = self:GetCaster()
    local hModifier = hCaster:FindModifierByName("db_powerup_test_modifier")
    
    if IsNotNull(hModifier) then
        hModifier:StartIntervalThink(-1)
    else
        print("HMMMM")
    end
    
    DestroyAndReleaseParticle(self.nChargingFX, false, true)
    
    hCaster:RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_3)
end

---------------------------------------------------------------------------------------------------------------
db_powerup_test_modifier = db_powerup_test_modifier or class({})

function db_powerup_test_modifier:IsHidden() return false end
function db_powerup_test_modifier:IsPurgeable() return false end
function db_powerup_test_modifier:IsPurgeException() return false end
function db_powerup_test_modifier:RemoveOnDeath() return false end
function db_powerup_test_modifier:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
                        MODIFIER_EVENT_ON_ORDER,
                    }
    return tFunc
end
function db_powerup_test_modifier:AddCustomTransmitterData()
    return
    {
        SuperSaiyan = GetSuperSaiyan(self.parent),
    }
end
function db_powerup_test_modifier:HandleCustomTransmitterData(hTable)
    for sKey, hValue in pairs(hTable) do
        self.parent[sKey] = hValue
    end
    
    print("UPDATED DATA KOK")
end
function db_powerup_test_modifier:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    self:SetHasCustomTransmitterData(true)
    
    if IsServer() then
       self.iTotalCharge = 250
       self.iChargeRate  = 50
       self.fChargeTick  = 0.1
       
       if not GetStoredKI(self.parent) then
           SetStoredKI(self.parent, 0, self.iTotalCharge)
       end
       
        self.hDamageTable =  {  
                                 victim       = nil,
                                 attacker     = self.parent,
                                 damage       = 1000,
                                 damage_type  = DAMAGE_TYPE_PURE,
                                 ability      = self.ability,
                                --damage_flags = 0
                             }
       
       if not self.nPowerupFX then
           --self.nPowerupFX = ParticleManager:CreateParticle( "particles/test/custom/dragon_ball_powerup_bar_test/dragon_ball_powerup_bar_test.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
           self.nPowerupFX = ParticleManager:CreateParticle( "particles/test/custom/dragon_ball_powerup_bar_test/dragon_ball_powerup_bar_test2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
       end

       --self:StartIntervalThink(FrameTime())
       self:OnIntervalThink()
    end
end
function db_powerup_test_modifier:OnIntervalThink()
    if not self.nPowerupFX then
        self:StartIntervalThink(-1)
        return
    end
    
    if SetStoredKI(self.parent, GetStoredKI(self.parent) + ( self.iChargeRate * self.fChargeTick ), self.iTotalCharge) == true then
        -- Check Abilities
        self:CheckAbilities()
    
        SetBarKI(self.nPowerupFX, GetStoredKI(self.parent))
        
        self.parent:InterruptChannel()
        return
    end
    
    -- Check Abilities
    self:CheckAbilities()

    SetBarKI(self.nPowerupFX, GetStoredKI(self.parent))
    
    print("HMMM")
end
function db_powerup_test_modifier:CheckAbilities()
    -- Check Abilities
    for i = 0, self.parent:GetAbilityCount() - 1 do
        local hAbility = self.parent:GetAbilityByIndex(i)
        if IsNotNull(hAbility) then
            local nKICost  = tGohanAbilityKICosts[hAbility:GetName()]
            if nKICost then
                local keys = SetAndCheckKISpells(self.parent, hAbility)
                self:OnAbilityFullyCast(keys, true)
            end
        end
    end
end
function db_powerup_test_modifier:OnAbilityFullyCast(keys, bTest)
    if keys.unit ~= self.parent then return end
    
    local hAbility = keys.ability
    local nKICost  = tGohanAbilityKICosts[hAbility:GetName()]
    
    --print("HMMMMM")
    
    -- Check for KI cost
    if IsNotNull(hAbility) and nKICost then
        if not bTest then
            SetStoredKI(self.parent, GetStoredKI(self.parent) - 100, self.iTotalCharge)
            SetBarKI(self.nPowerupFX, GetStoredKI(self.parent))
        end
        hAbility:SetActivated(GetStoredKI(self.parent) >= nKICost)
        
        --print("HMMMM2")
    end
end
function db_powerup_test_modifier:OnOrder(keys)
    if keys.unit and keys.unit == self.parent and keys.unit:IsRealHero() and not keys.unit:IsBuilding() then
        
        if keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
            if GetStoredKI(self.parent) < 100 then return end
            
            print("TEST ORDER")
            
            local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(),  -- int, your team number
                                           self.parent:GetOrigin(),  -- point, center point
                                           nil,  -- handle, cacheUnit. (not known)
                                           FIND_UNITS_EVERYWHERE,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                           DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY,  -- int, team filter
                                           DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  -- int, type filter
                                           DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  -- int, flag filter
                                           FIND_CLOSEST,  -- int, order filter
                                           false  -- bool, can grow cache
                                        )
            for _, hEnemy in pairs(enemies) do
                if IsNotNull(hEnemy) and hEnemy ~= self.parent then
                    FindClearSpaceForUnit( self.parent, hEnemy:GetOrigin(), true )

                    SetStoredKI(self.parent, GetStoredKI(self.parent) - 100, self.iTotalCharge)
                    SetBarKI(self.nPowerupFX, GetStoredKI(self.parent))
                    
                    self.hDamageTable.victim = hEnemy
                    ApplyDamage(self.hDamageTable)
                    
                    break
                end
            end           
        end
    end
end

