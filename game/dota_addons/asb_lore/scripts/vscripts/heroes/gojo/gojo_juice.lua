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

local qUP    = 1
local qLEFT  = 2
local qRIGHT = 3
local qDOWN  = 4

NPAN_INDICATOR = NPAN_INDICATOR or class({}) 

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

jojo_no_panorama = jojo_no_panorama or class({})

function jojo_no_panorama:CastFilterResultLocation(vLocation)
    if IsClient() then
        local hCaster      = self:GetCaster()
        local hController  = Entities:GetLocalPlayer()
        local iClickBehave = hController:GetClickBehaviors()
        
        self.vAbstractLoc = self.vAbstractLoc or vLocation
        self.nMenuUI_FX   = self.nMenuUI_FX or ParticleManager:CreateParticle("particles/test/custom/vector_target_no_panorama/number_menu_shit_test/menu_main.vpcf", PATTACH_WORLDORIGIN, nil)
        
        if self.nMenuUI_FX then
            if iClickBehave == DOTA_CLICK_BEHAVIOR_CAST then
                self.vAbstractLoc = vLocation
                ParticleManager:SetParticleControl(self.nMenuUI_FX, 0, vLocation)
                NPAN_INDICATOR:SetColors(self.nMenuUI_FX)
            elseif iClickBehave == DOTA_CLICK_BEHAVIOR_VECTOR_CAST then
                local qCurrent = NPAN_INDICATOR:CheckQuadrant(self.vAbstractLoc, vLocation)
                NPAN_INDICATOR:SetColors(self.nMenuUI_FX, qCurrent)
            else
                print("KOK?????")
            end
        end
        --print(Entities:GetLocalPlayer():GetClickBehaviors())
        --print(vLocation)
    end
end
function jojo_no_panorama:GetAOERadius()
    return 250
end
function jojo_no_panorama:OnSpellStart()
    local hCaster       = self:GetCaster()
    local vCursorPos    = self:GetCursorPosition()
    local vVectorTarget = self.init_pos
    local targets = self:CheckVectorTargetPosition()
    
    if vCursorPos and targets then
        local qCurrent = NPAN_INDICATOR:CheckQuadrant(vCursorPos, targets.init_pos)
        Say(hCaster, "QUADRANT: " .. qCurrent, false)
    else
        Say(hCaster, "NANI????", false)
    end
    
    print(targets)
    print(vCursorPos)
end

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