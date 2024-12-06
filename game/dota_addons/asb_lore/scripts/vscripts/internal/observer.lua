---------------------------------------------------------------------------------------
-- OBSERVERS TEST
---------------------------------------------------------------------------------------

local hTeamAndPlayerColors = {}

hTeamAndPlayerColors[DOTA_TEAM_GOODGUYS] = Vector(61, 210, 150)    --      Teal
hTeamAndPlayerColors[DOTA_TEAM_BADGUYS]  = Vector(243, 201, 9)     --      Yellow
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_1] = Vector(197, 77, 168)    --      Pink
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_2] = Vector(255, 108, 0)     --      Orange
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_3] = Vector(52, 85, 255)     --      Blue
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_4] = Vector(101, 212, 19)    --      Green
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_5] = Vector(129, 83, 54)     --      Brown
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_6] = Vector(27, 192, 216)    --      Cyan
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_7] = Vector(199, 228, 13)    --      Olive
hTeamAndPlayerColors[DOTA_TEAM_CUSTOM_8] = Vector(140, 42, 244)    --      Purple
hTeamAndPlayerColors[DOTA_TEAM_NEUTRALS] = Vector(219, 219, 150)   --      White

observer_custom = observer_custom or class({})

function observer_custom:Start()
    local hEntity = SpawnEntityFromTableSynchronous("info_target", {targetname="timers_observer_thinker"})
    hEntity:SetThink("Think", self, "observer_custom", 1.0)
end
function observer_custom:Think()
    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        print("HMMMMM")
        return 1.0
    end
    local hObservers = Entities:FindAllByClassname("npc_dota_lantern")
    if #hObservers > 0 then
        return self:SetupObservers(hObservers)
    else
        return self:SetupObservers(self:SpawnObservers())
    end
end
function observer_custom:SpawnObservers()
    local hFountains = Entities:FindAllByClassname("info_courier_spawn")
    local hObservers = {}
	for _, hFountain in pairs(hFountains) do
        local vCenter    = Vector(0, 0, 0)
        local vDirection = GetDirection(vCenter, hFountain)
        local fDistance  = GetDistance(vCenter, hFountain)
        local fOffset    = fDistance * (GetMapName() == "desert_quintet" and 0.5 or 0.55)
        local hObserver  = CreateUnitByName("npc_dota_lantern", Vector(0, 0, 0), false, nil, nil, DOTA_TEAM_NOTEAM)
        if IsNotNull(hObserver) then
            local vSpawnPosition = hFountain:GetOrigin() + vDirection * fOffset
            vSpawnPosition = GetClearPositionForClassnameInSphere("npc_dota_lantern", GetGroundPosition(vSpawnPosition, hObserver), 35, true)
            hObserver:SetOrigin(vSpawnPosition)
            --hObserver:StartGesture(ACT_DOTA_IDLE)
            print("TEST")
            table.insert(hObservers, hObserver)
        end
    end
    return hObservers
end
function observer_custom:SetupObservers(hTable)
    for iKey, hValue in pairs(hTable) do
        if IsNotNull(hValue) and not hValue:HasModifier("modifier_custom_observer") then
            hValue:AddNewModifier(hValue, nil, "modifier_custom_observer", {})
        end
    end
    return nil
end

observer_custom:Start()


---------------------------------------------------------------------------------------------------------------
-- Custom Observer Modifier
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_custom_observer", "internal/observer.lua", LUA_MODIFIER_MOTION_NONE)

modifier_custom_observer = modifier_custom_observer or class({})

function modifier_custom_observer:CheckState()
    local hState =  {
                        [MODIFIER_STATE_NO_HEALTH_BAR]        = true,
                        --[MODIFIER_STATE_OUT_OF_GAME]          = true,
                        [MODIFIER_STATE_UNSELECTABLE]         = true,
                        [MODIFIER_STATE_UNTARGETABLE]         = true,
                        [MODIFIER_STATE_INVULNERABLE]         = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION]    = true,
                        --[MODIFIER_STATE_FLYING]               = true,
                        --[MODIFIER_STATE_PROVIDES_VISION]      = true,
                        [MODIFIER_STATE_ROOTED]               = true,
                        [MODIFIER_STATE_FORCED_FLYING_VISION] = true,
                        [MODIFIER_STATE_DISARMED]             = true,
                    }
    return hState
end
function modifier_custom_observer:DeclareFunctions()
    local hFunc =   {
                        --MODIFIER_PROPERTY_MODEL_CHANGE, 
                        --MODIFIER_PROPERTY_MODEL_SCALE,
                        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
                    }
    return hFunc
end
--[[
function modifier_custom_observer:GetModifierModelChange(keys)
    return ""
end]]--
function modifier_custom_observer:GetModifierProvidesFOWVision(keys)
    return 1
end
function modifier_custom_observer:OnCreated(hTable)
    self.caster   = self:GetCaster()
    self.parent   = self:GetParent()
    self.ability  = self:GetAbility()
    
    if IsServer() then
        self.__fLocalThinker    = 0.1
        self.__fCaptureTime     = 1.0
        self.__fCaptureRate     = self.__fCaptureTime * self.__fLocalThinker
        self.__fCaptureProgress = self.__fCaptureProgress or 0
        self.__fCapturedTimer   = 60.0
        self.__fCurrentTimer    = self.__fCurrentTimer or 0
        self.__hMainContester   = self.__hMainContester or nil
        self.__bIsCaptured      = self.__bIsCaptured or false
        self.__nCurrentTeam     = self.__nCurrentTeam or DOTA_TEAM_NEUTRALS
        
        self.__nCaptureDistance = 300
        self.__nGoldGained      = 150
        
        local fUpdateType   = self.__fCurrentTimer > 0 and self.__fCapturedTimer or self.__fCaptureTime
        local fUpdateAmount = self.__fCurrentTimer > 0 and self.__fCurrentTimer or self.__fCaptureProgress
        local fUpdateAlpha  = self.__fCurrentTimer > 0 and 0 or 1
        self:CreateOrUpdateParticle(true, hTeamAndPlayerColors[self.__nCurrentTeam], RemapValClamped(fUpdateAmount, 0, fUpdateType, 0, 1), fUpdateAlpha)
        
        self.parent:SetTeam(self.__nCurrentTeam)
        
        self:StartIntervalThink(self.__fLocalThinker)
    end
end
function modifier_custom_observer:OnIntervalThink()
    --self:InToolsTest()
    
    if not IsNotNull(self.parent) then return end

    if self.__bIsCaptured then
        self.__fCurrentTimer = self.__fCurrentTimer - self.__fLocalThinker
        self:CreateOrUpdateParticle(false, hTeamAndPlayerColors[self.__nCurrentTeam], RemapValClamped(self.__fCurrentTimer, 0, self.__fCapturedTimer, 0, 1), 0)
        if self.__fCurrentTimer <= 0 then
            self:CaptureOrResetObserver()
        end
        return
    end
    
    local hCurrentValidHeroes = self:GetAllValidHeroes()
    if #hCurrentValidHeroes <= 0 or ( #hCurrentValidHeroes == 1 and self.__hMainContester and self.__hMainContester ~= hCurrentValidHeroes[1] ) then
        if self.__fCaptureProgress > 0 then
            self.__fCaptureProgress = self.__fCaptureProgress - self.__fCaptureRate
        end
        if self.__hMainContester and self.__fCaptureProgress <= 0 then
            self.__hMainContester = nil
        end
    elseif #hCurrentValidHeroes == 1 then
        self.__fCaptureProgress = self.__fCaptureProgress + self.__fCaptureRate
        self.__hMainContester = self.__hMainContester or hCurrentValidHeroes[1]
        self:FixVision()
        print("Capturing")
        if self.__fCaptureProgress >= self.__fCaptureTime then
            self:CaptureOrResetObserver(hCurrentValidHeroes[1])
            return
        end
    else
        self.__fCaptureProgress = self.__fCaptureProgress
    end
    
    local vColor = IsNotNull(self.__hMainContester) and hTeamAndPlayerColors[self.__hMainContester:GetTeamNumber()] or nil
    self:CreateOrUpdateParticle(false, vColor, RemapValClamped(self.__fCaptureProgress, 0, self.__fCaptureTime, 0, 1), 1)
end
function modifier_custom_observer:GetAllValidHeroes()
    local hValidHeroes = {}
    for _, hHero in pairs(HeroList:GetAllHeroes()) do 
        if IsNotNull(hHero)
            and not hHero:IsInvulnerable()
            and hHero:IsRealHero()
            and hHero:IsAlive()
            and GetDistance(self.parent, hHero) <= self.__nCaptureDistance then
            table.insert(hValidHeroes, hHero)
        end
    end
    return hValidHeroes
end
function modifier_custom_observer:CaptureOrResetObserver(hHero)
    if not hHero then
        self.parent:SetTeam(DOTA_TEAM_NEUTRALS)
        self.__nCurrentTeam = DOTA_TEAM_NEUTRALS
        self.__bIsCaptured = false
    else
        local nCurrentTeam = hHero:GetTeamNumber()
        self.parent:SetTeam(nCurrentTeam)
        self.__nCurrentTeam = nCurrentTeam
        self.__fCurrentTimer = self.__fCapturedTimer
        self.__fCaptureProgress = 0
        self.__hMainContester = nil
        self.__bIsCaptured = true
        
        self:CaptureEffect()
        
        hHero:ModifyGold(self.__nGoldGained, true, 0)
        SendOverheadEventMessage(hHero, OVERHEAD_ALERT_GOLD, hHero, self.__nGoldGained, nil)
    end
    self:CreateOrUpdateParticle(true, hTeamAndPlayerColors[self.__nCurrentTeam], self.__fCurrentTimer, 0)
end
function modifier_custom_observer:CreateOrUpdateParticle(bRecreate, nColor, fProgress, fAlpha)
    if bRecreate and self.__nCircleFX then
        ParticleManager:DestroyParticle(self.__nCircleFX, true)
        ParticleManager:ReleaseParticleIndex(self.__nCircleFX)
        self.__nCircleFX = nil
    end
    
    nColor    = nColor or Vector(219, 219, 150)
    fProgress = fProgress or 0
    fAlpha    = fAlpha or 0
    
    if self.__nCircleFX then
        ParticleManager:SetParticleControl(self.__nCircleFX, 3, nColor)
        ParticleManager:SetParticleControl(self.__nCircleFX, 8, Vector(fProgress, 0, 0))
        ParticleManager:SetParticleControl(self.__nCircleFX, 11, Vector(fAlpha, 0, 0))
    end
    
    if not self.__nCircleFX then
        self.__nCircleFX = ParticleManager:CreateParticle("particles/test/custom/shrine_capture_ring/shrine_capture_main.vpcf", PATTACH_WORLDORIGIN, nil)
                           ParticleManager:SetParticleControl(self.__nCircleFX, 0, self.parent:GetAbsOrigin())
                           ParticleManager:SetParticleControl(self.__nCircleFX, 3, nColor)
                           ParticleManager:SetParticleControl(self.__nCircleFX, 8, Vector(fProgress, 0, 0))
                           ParticleManager:SetParticleControl(self.__nCircleFX, 10, Vector(self.__nCaptureDistance, 0, 0))
                           ParticleManager:SetParticleControl(self.__nCircleFX, 11, Vector(fAlpha, 0, 0))
    end
end
function modifier_custom_observer:CaptureEffect()
    local nCapturedFX = ParticleManager:CreateParticle("particles/test/custom/shrine_capture_ring/shrine_capture_captured.vpcf", PATTACH_WORLDORIGIN, nil)
                        ParticleManager:SetParticleControl(nCapturedFX, 0, self.parent:GetAbsOrigin())
                        ParticleManager:SetParticleControl(nCapturedFX, 3, hTeamAndPlayerColors[self.__nCurrentTeam] or Vector(219, 219, 150))
                        ParticleManager:SetParticleControl(nCapturedFX, 10, Vector(self.__nCaptureDistance, 0, 0))
                        ParticleManager:ReleaseParticleIndex(nCapturedFX)
end
function modifier_custom_observer:FixVision()
    if self.__fCaptureProgress >= self.__fCaptureTime - self.__fLocalThinker then
        for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
            AddFOWViewer(iTeamNumber, self.parent:GetOrigin(), 50, self.__fLocalThinker + 0.01, false)
        end
    end
end
function modifier_custom_observer:InToolsTest()
    if IsInToolsMode() then
        self.fTest = self.fTest or 70.0
        self.fTest = self.fTest - self.__fLocalThinker
        if self.fTest <= 0 then
            UTIL_Remove(self.parent)
        end
    end
end
function modifier_custom_observer:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_custom_observer:OnDestroy()
    if IsServer() then
        if self.__nCircleFX then
            ParticleManager:DestroyParticle(self.__nCircleFX, true)
            ParticleManager:ReleaseParticleIndex(self.__nCircleFX)
            self.__nCircleFX = nil
        end
    end
end

