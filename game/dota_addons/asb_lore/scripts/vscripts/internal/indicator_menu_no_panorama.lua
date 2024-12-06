---------------------------------------------------------------------------------------
-- CUSTOM TEST FOR INDICATOR WITH NO PANORAMA
---------------------------------------------------------------------------------------

-- ALL CLICK BEHAVIORS REFERENCE
--[[
DOTA_CLICK_BEHAVIOR_NONE = 0
DOTA_CLICK_BEHAVIOR_MOVE = 1
DOTA_CLICK_BEHAVIOR_ATTACK = 2
DOTA_CLICK_BEHAVIOR_CAST = 3
DOTA_CLICK_BEHAVIOR_DROP_ITEM = 4
DOTA_CLICK_BEHAVIOR_DROP_SHOP_ITEM = 5
DOTA_CLICK_BEHAVIOR_DRAG = 6
DOTA_CLICK_BEHAVIOR_LEARN_ABILITY = 7
DOTA_CLICK_BEHAVIOR_PATROL = 8
DOTA_CLICK_BEHAVIOR_VECTOR_CAST = 9
DOTA_CLICK_BEHAVIOR_UNUSED = 10
DOTA_CLICK_BEHAVIOR_RADAR = 11
DOTA_CLICK_BEHAVIOR_LAST = 12
]]--

-- EFFECTS FOR INDICATOR TYPES
--[[

 NPAN_INDICATOR_TYPE_AIM_SKILLSHOT
 - particles/test/custom/range_finder_cone_no_panorama/range_finder_cone.vpcf
 - particles/test/custom/range_finder_cone_no_panorama/range_finder_cone_hollow_purple.vpcf
 
 NPAN_INDICATOR_TYPE_VECTOR_MENU
 - particles/test/custom/vector_target_no_panorama/number_menu_shit_test/menu_main2.vpcf
 - particles/test/custom/vector_target_no_panorama/number_menu_shit_test/menu_main22.vpcf
 
 NPAN_INDICATOR_TYPE_VECTOR_RADIUS
 - particles/test/custom/range_finder_aoe_no_panorama/range_finder_aoe_test.vpcf
 
]]--

qUP     = 1
qLEFT   = 2
qRIGHT  = 3
qDOWN   = 4

NPAN_INDICATOR_TYPE_AIM_SKILLSHOT = 1
NPAN_INDICATOR_TYPE_VECTOR_MENU   = 2
NPAN_INDICATOR_TYPE_VECTOR_RADIUS = 3

NPAN_INDICATOR = NPAN_INDICATOR or class({}) 

function NPAN_INDICATOR:RegisterAbility(hAbility, nType, sEffectName)
    if hAbility
        and not hAbility.NPAN_DATA then
        if IsServer() then
            hAbility.NPAN_DATA = true
        else
            hAbility.NPAN_DATA = function()
                return{nType, sEffectName}
            end
        end
    end
end
function NPAN_INDICATOR:CheckAbility(hAbility)
    return hAbility.NPAN_DATA      
end
function NPAN_INDICATOR:GetData(hAbility)
    if IsClient() 
        and self:CheckAbility(hAbility) then
        return hAbility:NPAN_DATA()      
    end
end
function NPAN_INDICATOR:CreateUIIndicator(hCaster, hAbility, vLocation)
    if not hCaster or not hAbility or not vLocation then return end
    
    if IsServer() then
        -- Calls two times on cast, first cast is initial position
        hAbility.nCounter = hAbility.nCounter or 1
        
        -- Avoid having to manage hAbility.vStartPos, fix for different situations (EXAMPLE: Player cancells command)
        -- Because else (hAbility.vStartPos = hAbility.vStartPos or vLocation), now have to set value to nil in ordering for example
        if hAbility.nCounter > 1 then 
            hAbility.nCounter = nil
            return 
        end
        
        hAbility.nCounter = hAbility.nCounter + 1
        
        hAbility.vStartPos = vLocation
        --print("TEST")
    end
    
    if not IsClient() then return end
    
    local tIndicatorData = self:GetData(hAbility)
    if not tIndicatorData then return end
    
    if tIndicatorData[1] == NPAN_INDICATOR_TYPE_AIM_SKILLSHOT then
        local hController       = Entities:GetLocalPlayer()
        if not hAbility.nMenuUI_FX then
            local fRadius       = hAbility:GetSpecialValueFor("radius")
            local fDistance     = hAbility:GetAOERadius()
            hAbility.nMenuUI_FX = ParticleManager:CreateParticle(tIndicatorData[2], PATTACH_CUSTOMORIGIN, hController)
                                  ParticleManager:SetParticleControlEnt(hAbility.nMenuUI_FX, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_origin", hCaster:GetAbsOrigin(), true)
                                  ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 3, Vector(fRadius, fRadius, 0))
                                  ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 10, Vector(fDistance, fDistance, 0))
        end
        
        if hAbility.nMenuUI_FX then
            ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 8, vLocation)
            ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 14, Vector(2, 0, 0))
        end
        
    elseif tIndicatorData[1] == NPAN_INDICATOR_TYPE_VECTOR_MENU then
        local hController       = Entities:GetLocalPlayer()
        local iClickBehave      = hController:GetClickBehaviors()

        if not hAbility.nMenuUI_FX then
            hAbility.nMenuUI_FX = ParticleManager:CreateParticle(tIndicatorData[2], PATTACH_CUSTOMORIGIN, hController)
        end
        
        if hAbility.nMenuUI_FX then
            ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 14, Vector(2, 0, 0))
            
            if iClickBehave == DOTA_CLICK_BEHAVIOR_CAST then
                hAbility.bTest = false
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 0, vLocation)
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 8, vLocation)
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 13, Vector(0, 0, 0))
            elseif iClickBehave == DOTA_CLICK_BEHAVIOR_VECTOR_CAST then
                hAbility.bTest = true
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 8, vLocation)
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 13, Vector(1, 0, 0))
            else
                print("HMMMMM")
            end
        end
        
    elseif tIndicatorData[1] == NPAN_INDICATOR_TYPE_VECTOR_RADIUS then
        local hController       = Entities:GetLocalPlayer()
        local iClickBehave      = hController:GetClickBehaviors()

        if not hAbility.nMenuUI_FX then
            hAbility.fDistanceMin = hAbility.fDistanceMin or hAbility:GetSpecialValueFor("distance")
            hAbility.fDistanceMax = hAbility.fDistanceMax or hAbility:GetSpecialValueFor("distance_max")
            hAbility.nMenuUI_FX   = ParticleManager:CreateParticle(tIndicatorData[2], PATTACH_CUSTOMORIGIN, hController)
                                    ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 9, Vector(hAbility.fDistanceMin, hAbility.fDistanceMax, 0))
        end
        
        if hAbility.nMenuUI_FX then
            ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 14, Vector(2, 0, 0))
            
            if iClickBehave == DOTA_CLICK_BEHAVIOR_CAST then
                hAbility.bTest = false
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 2, vLocation)
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 8, vLocation)
            elseif iClickBehave == DOTA_CLICK_BEHAVIOR_VECTOR_CAST then
                hAbility.bTest = true
                ParticleManager:SetParticleControl(hAbility.nMenuUI_FX, 8, vLocation)
            else
                print("HMMMMM")
            end
        end
    end
    print("KOK")
end
function NPAN_INDICATOR:SetColors(nFX, nCP)
    if not nFX then return end
    
    -- Set colors to use for particle effect
    local vWhiteColor = Vector(1, 1, 1)
    local vGreenColor = Vector(0, 1, 0)
    
    -- Set all colors to white
    for i = 1, 4 do
        ParticleManager:SetParticleControl(nFX, i, vWhiteColor)
    end
    
    -- Ignore if nCP is not within parameter data
    if not nCP or nCP <= 0 or nCP > 4 then
        return
    end
    
    ParticleManager:SetParticleControl(nFX, nCP, vGreenColor)
end
function NPAN_INDICATOR:CheckQuadrant(v1, v2)
    local dirX = v2.x - v1.x
    local dirY = v2.y - v1.y
    
    local angle = math.deg(math.atan2(dirY, dirX))
    
    -- Normalized range
    if angle < 0 then
        angle = angle + 360
    end

    -- Quadrants Selection
    local qReturn = nil
    
    -- UP
    if (angle >= 45 and angle < 135) then
        qReturn = qUP
        
    -- LEFT
    elseif (angle >= 135 and angle < 225) then
        qReturn = qLEFT
        
    -- RIGHT
    elseif (angle >= 315 or angle < 45) then
        qReturn = qRIGHT 
    
    -- DOWN
    else
        qReturn = qDOWN
    end
    
    return qReturn
end


--[[LinkLuaModifier("modifier_nopan_internal", "internal/indicator_menu_no_panorama", LUA_MODIFIER_MOTION_NONE)

modifier_nopan_internal = modifier_nopan_internal or class({})

function modifier_nopan_internal:IsHidden() return false end
function modifier_nopan_internal:IsDebuff() return false end
function modifier_nopan_internal:IsPurgable() return false end
function modifier_nopan_internal:RemoveOnDeath() return false end
function modifier_nopan_internal:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsClient() then
        --self:OnIntervalThink()
        --self:StartIntervalThink(0.15)
        self.parent.hModifierUI = self
    end
end
function modifier_nopan_internal:OnIntervalThink()
    if self.sAbilityName then
        local hAbility = self.parent:FindAbilityByName(self.sAbilityName)
        if IsNotNull(hAbility)
            and hAbility.nMenuUI_FX then

            local __fLastStoredTime = hAbility.__fCurGameTime
            
            if self.__fLastStoredTime ==  __fLastStoredTime then
                self:Reset(hAbility)
            else
                self.__fLastStoredTime = hAbility.__fCurGameTime
            end
        end
    end
    print("KOKOSSSSS")
end
function modifier_nopan_internal:Reset(hAbility, bGetAbility)
    if bGetAbility then
        hAbility = self.parent:FindAbilityByName(self.sAbilityName)
    end
    if hAbility then
        ParticleManager:DestroyParticle(hAbility.nMenuUI_FX, true )
        ParticleManager:ReleaseParticleIndex(hAbility.nMenuUI_FX)
        
        hAbility.nMenuUI_FX = nil
        self.__fLastStoredTime = nil
    end
end
function modifier_nopan_internal:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_nopan_internal:OnDestroy()

end]]--

-- NOT WORKING ONLY CastFilterResultLocation ...
--[[
function indicator_test_spell:CastFilterResult()
    if IsClient() then
        print("ONE: IT SPAMS ???")
    end
end
function indicator_test_spell:CastFilterResultTarget()
    if IsClient() then
        print("THREE: IT SPAMS ???")
    end
end
function indicator_test_spell:CustomCastFilter()
    if IsClient() then
        print("FOUR: IT SPAMS ???")
    end
end
function indicator_test_spell:CastCustomFilter()
    if IsClient() then
        print("FIVE: IT SPAMS ???")
    end
end
]]--



--[[LinkLuaModifier("modifier_indicator_orders", "internal/indicator_menu_no_panorama.lua", LUA_MODIFIER_MOTION_NONE)

modifier_indicator_orders = modifier_indicator_orders or class({})

function modifier_indicator_orders:IsHidden() return false end
function modifier_indicator_orders:IsPurgeable() return false end
function modifier_indicator_orders:IsPurgeException() return false end
function modifier_indicator_orders:RemoveOnDeath() return true end
function modifier_indicator_orders:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_EVENT_ON_ORDER,
                    }
    return tFunc
end
function modifier_indicator_orders:OnCreated(hTable)
    if IsServer() then
        self.caster   = self:GetCaster()
        self.parent   = self:GetParent()
        self.ability  = self:GetAbility()
        
        self.counter = 0
    end
end
function modifier_indicator_orders:OnOrder(keys)
    if keys.unit ~= self.parent then return end
    
    print(keys.order_type)

    if keys.order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
        self.counter = self.counter + 1
        print("IT SPAMS ?????")
        print(self.counter)
        
        self.parent:SetOrigin(Vector(0,0,0))
    end
    
    if keys.order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_CANCELED then
        self.counter = self.counter + 1
        print("IT SPAMS ?????")
        print(self.counter)
        
        self.parent:SetOrigin(Vector(0,0,0))
    end
end
function modifier_indicator_orders:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_indicator_orders:OnDestroy()
    if IsServer() then

    end
end
]]--

