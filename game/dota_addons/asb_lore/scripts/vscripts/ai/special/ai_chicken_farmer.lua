require('libraries/interaction')


local SQUARE_DIST = 128
local RIGHT_VECTOR = Vector(0, 1, 0)
local DOWN_VECTOR = Vector(-1, 0, 0)

local info_target_preffix = "chicken_farmer_spawn_"

local ITEMS = 
{
    "item_bfury_1"
}

local ITEM = "item_chicken_coin"
local CHIKEN_STAFF = "item_chicken_king_staff"

local CREEP_NAME = "npc_dota_chicken"

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	thisEntity.m_hBehavior = ChickenFarmerBehavior(thisEntity, 0.2)
	thisEntity:SetInteractionData({range = 250, is_enabled = true, __callback = function(pid, unit) end})
end

ChickenFarmerBehavior = class(Interaction)

ChickenFarmerBehavior.m_iCount = 4
ChickenFarmerBehavior.m_bWasFinished = true
ChickenFarmerBehavior.m_bIsCurrentlyUsing = false
ChickenFarmerBehavior.m_flCooldown = 0.25
ChickenFarmerBehavior.m_iCurrentPid = -1
ChickenFarmerBehavior.m_iCurrentBet = -1
ChickenFarmerBehavior.m_hInteractableUnit = nil

ChickenFarmerBehavior.m_hChickens = {}
ChickenFarmerBehavior.m_hCorrectCombination = nil
ChickenFarmerBehavior.m_iCurrentChicken = -1
ChickenFarmerBehavior.m_hCorrectFlow = {}

ChickenFarmerBehavior.m_bAlreayGrantedItems = false

function ChickenFarmerBehavior:OnCreated()
	
end

function ChickenFarmerBehavior:StartCooldown(cd)
    self.m_flCooldown = cd
end

function ChickenFarmerBehavior:GetSpawnPoint()
    return Vector(self:GetParent():Attribute_GetFloatValue("p1_x", 0), self:GetParent():Attribute_GetFloatValue("p1_y", 0), self:GetParent():Attribute_GetFloatValue("p1_z", 0))
end

function ChickenFarmerBehavior:Think()
    if self.m_flCooldown >= 0 then
		self.m_flCooldown = self.m_flCooldown - self:GetIntervalThink()
	end
end

--[[
{
   target                          	= 505 (number)
   unit                            	= 330 (number)
   pid                             	= 0 (number)
}]]

function ChickenFarmerBehavior:OnInteraction(params)
	local target = EntIndexToHScript(params.target)
	local hero = EntIndexToHScript(params.unit)

    self.m_iCount = self:GetParent():Attribute_GetIntValue("count", 4)
    self.m_iCost = self:GetParent():Attribute_GetIntValue("cost", 500)
    self.m_bUsingInfoTargets = self:GetParent():Attribute_GetIntValue("use_info_targets", 0)

    if hero and self:GetParent() == target and IsValidEntity(hero) == true and self:IsCooldownReady() == true and self:IsCurrentlyUsing() == false then
		self.m_iCurrentPid = params.pid
		self.m_bIsCurrentlyUsing = true
		self.m_hInteractableUnit = hero

        Dialogues:CreateDialogueWindow(params.pid, 
        {
            font_size = 16,
            msg = "",
            msg_variant = {
                text = "chicken_farmer_text",
                options = {
                    cost = self.m_iCost
                }
            },
            input = "chicken_farmer_input", 
            variant1 = "chicken_farmer_variant1", 
            variant2 = "chicken_farmer_variant2", 
            allow_chars = false
        }, 
        function(positive, pid)
            if positive and self.m_iCost <= hero:GetGold() then
				hero:SpendGold(self.m_iCost, DOTA_ModifyGold_Unspecified)

                EmitSoundOn("ChickenKing.SpendGold", self.m_hInteractableUnit)
                EmitSoundOn("Hero_LoneDruid.TrueForm.Recast", self:GetParent())

                self.mflValue = self.m_iCost

                local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/frostivus/frostivus_tree_cast_ability.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
			    ParticleManager:ReleaseParticleIndex( nFXIndex )

				self:RollBet()
            else 
				self:Reset()
            end
        end)
	end
end

function ChickenFarmerBehavior:OnGameRulesStateChange()
	
end

--[[
    {
   entindex_inflictor              	= 175 (number)
   damagebits                      	= 8192 (number)
   game_event_listener             	= 503316494 (number)
   game_event_name                 	= "entity_killed" (string)
   entindex_killed                 	= 176 (number)
   entindex_attacker               	= 174 (number)
   splitscreenplayer               	= -1 (number)
}
]]
function ChickenFarmerBehavior:OnEntityKilled(params)
    if params.entindex_attacker and params.entindex_killed then
        local target = EntIndexToHScript(params.entindex_killed)
        local attacker = EntIndexToHScript(params.entindex_attacker)
        
        if self:IsCurrentlyUsing() and target.m_bChecken and attacker:entindex() == self.m_hInteractableUnit:entindex() and target.m_iIndex == self:GetParent():entindex() then
            if self.m_hCorrectCombination[self.m_iCurrentChicken] == target.m_iNumber then
                self.m_iCurrentChicken = self.m_iCurrentChicken + 1

                self.m_hCorrectFlow[target.m_iNumber] = true

                if self.m_iCurrentChicken > #self.m_hCorrectCombination then
                    self:SetGameResult()
                end
            else 
				EmitSoundOn("ChickenKing.ChickenTaunt", target)
                self:Reset()
            end
        end
    end
end

function ChickenFarmerBehavior:SetGameResult()
    EmitSoundOn("Hero_LegionCommander.Duel.Victory", self.m_hInteractableUnit)

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.m_hInteractableUnit )
    ParticleManager:ReleaseParticleIndex( nFXIndex )

    self:SpawnItems()
    self:Reset()

    self.m_hCorrectFlow = {}
    self.m_bWasFinished = true
    self.m_iCurrentChicken = 1
    self.m_hCorrectCombination = nil
end

function ChickenFarmerBehavior:IsCooldownReady()
	return self.m_flCooldown <= 0
end

function ChickenFarmerBehavior:RollBet()
	local nFXIndex = ParticleManager:CreateParticle( self.m_sParticle1, PATTACH_OVERHEAD_FOLLOW, self.m_hInteractableUnit )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	GameRules:SetActionDelay(2, function()
		self:SpawnCreeps()
	end)
end

function ChickenFarmerBehavior:IsCurrentlyUsing()
	return self.m_bIsCurrentlyUsing == true
end

function ChickenFarmerBehavior:IsUsingInfoTargets()
	return self.m_bUsingInfoTargets == 1
end

function ChickenFarmerBehavior:Reset()
	self.m_bIsCurrentlyUsing = false
	self.m_iCurrentPid = -1
	self.m_hInteractableUnit = nil
    self.m_iCurrentBet = -1
    self.mflValue = -1

    if self.m_hChickens then
        for i = 1, self.m_iCount do
            for j = 1, self.m_iCount do
                if self.m_hChickens[i] ~= nil and self.m_hChickens[i][j] ~= nil then
                    local chicken = EntIndexToHScript(self.m_hChickens[i][j])

                    if IsValidEntity(chicken) then
                        UTIL_Remove(chicken)
                    end
                end
            end
        end
    end

    self.m_hChickens = {}

	self:StartCooldown(0.25)
end

--[[
	{1, 2, 3, 4, 5, 6, 7, 8, 9} =>

	{
		{1, 2, 3}
		{4, 5, 6}
		{7, 8, 9}
	}
]]

function ChickenFarmerBehavior:UTIL_ToMatrix(array, dimensions, depth)
	local result = {}

	for i = 1, dimensions do
		local row = {}
	
		table.insert(result, row)

		for j = 1, depth do
			table.insert(row, array[(i - 1) * dimensions + j])
		end
	end
	return result
end

function ChickenFarmerBehavior:SpawnCreeps()
    local point = self:GetSpawnPoint()

    if self.m_bWasFinished then 
        self.m_bWasFinished = false 

        self.m_iCurrentChicken = 1
    end

    local function shuffle(t)
        local tbl = {}

        for i = 1, #t do
            tbl[i] = t[i]
        end
        
        for i = #tbl, 2, -1 do
            local j = math.random(i)

            tbl[i], tbl[j] = tbl[j], tbl[i]
        end

        return tbl
        -- body
    end

    local tbl = {}

    local index = 1

    if self:IsUsingInfoTargets() then
        local targets = {}

        for i = 1, self.m_iCount * self.m_iCount do
            table.insert(targets, Entities:FindByName(nil, info_target_preffix .. self:GetParent():GetName() .. "_" .. tostring(i)):GetAbsOrigin())
        end

        local points = self:UTIL_ToMatrix(targets, self.m_iCount, self.m_iCount)

        for i = 1, self.m_iCount do
            self.m_hChickens[i] = {}
    
            for j = 1, self.m_iCount do
                local jitter_point = points[i][j]
    
                index = index + 1
    
                if self.m_hCorrectFlow and self.m_hCorrectFlow[index] == true then
                    self.m_hChickens[i][j] = nil
                else 
                    local unit =
                    CreateUnitByName(
                        CREEP_NAME,
                        jitter_point,
                        false,
                        nil,
                        nil,
                        DOTA_TEAM_CUSTOM_1
                    )
    
                    unit.m_bChecken = true
                    unit.m_iNumber = index
                    unit.m_iIndex = self:GetParent():entindex()
                    unit.m_iAttackerEntiIndex = self.m_hInteractableUnit:entindex()
    
                    unit:AddNewModifier(self:GetParent(), nil, "modifier_chicken_protection", {caster = self.m_hInteractableUnit:entindex()})
                    unit:AddNewModifier(self:GetParent(), nil, "modifier_phased", {duration = 1})
                    self.m_hChickens[i][j] = unit:entindex() 
    
                    table.insert(tbl, unit.m_iNumber)
                end
            end
        end
    else 
        for i = 1, self.m_iCount do
            local iter_point = point + RIGHT_VECTOR * SQUARE_DIST * i
    
            self.m_hChickens[i] = {}
    
            for j = 1, self.m_iCount do
                local jitter_point = iter_point + DOWN_VECTOR * SQUARE_DIST * j
    
                index = index + 1
    
                if self.m_hCorrectFlow and self.m_hCorrectFlow[index] == true then
                    self.m_hChickens[i][j] = nil
                else 
                    local unit =
                    CreateUnitByName(
                        CREEP_NAME,
                        jitter_point,
                        false,
                        nil,
                        nil,
                        DOTA_TEAM_CUSTOM_1
                    )
    
                    unit.m_bChecken = true
                    unit.m_iNumber = index
                    unit.m_iIndex = self:GetParent():entindex()
                    unit.m_iAttackerEntiIndex = self.m_hInteractableUnit:entindex()
    
                    unit:AddNewModifier(self:GetParent(), nil, "modifier_chicken_protection", {caster = self.m_hInteractableUnit:entindex()})
    
                    self.m_hChickens[i][j] = unit:entindex() 
    
                    table.insert(tbl, unit.m_iNumber)
                end
            end
        end
    end
    
    if self.m_hCorrectCombination == nil then
        self.m_hCorrectCombination = {}
        
        for i = 1, #tbl do
            table.insert(self.m_hCorrectCombination, tbl[i])
        end
        
        self.m_hCorrectCombination = shuffle(self.m_hCorrectCombination)
    end
    
    tbl = nil
    if(IsInToolsMode() == true) then
        DeepPrintTable(self.m_hCorrectCombination)
    end

    AddFOWViewer(DOTA_TEAM_GOODGUYS, point, SQUARE_DIST * 4, 10, true)
end

function ChickenFarmerBehavior:Respawn()
    for i = 1, self.m_iCount do
        for j = 1, self.m_iCount do
            local chicken = EntIndexToHScript(self.m_hChickens[i][j])

            if IsValidEntity(chicken) then
                UTIL_Remove(chicken)
            end
        end
    end

    self:SpawnCreeps()
end

function ChickenFarmerBehavior:SpawnItems()
    local point = self:GetSpawnPoint()

    for i = 1, self.m_iCount do
        local iter_point = point + RIGHT_VECTOR * SQUARE_DIST * i

        for j = 1, self.m_iCount do
            local jitter_point = iter_point + DOWN_VECTOR * SQUARE_DIST * j

            CreateItemOnPositionSync(jitter_point, CreateItem(ITEM, nil, nil))
        end
    end
    
    ---- Если игра 4 на 4 и больше
    if self.m_iCount >= 4 then
        CreateItemOnPositionSync(point, CreateItem(CHIKEN_STAFF, nil, nil))
    end
    --[[
    if (not self.m_bAlreayGrantedItems) then
        local item_low = ITEMS[RandomInt(1, #ITEMS)]

        local center = point + Vector(-0.5, 0, 0) * (SQUARE_DIST * self.m_iCount / 2)
        CreateItemOnPositionSync(center, CreateItem(item_low, nil, nil))

        self.m_bAlreayGrantedItems = true
    end --]]
end


modifier_chicken_protection = class({
	IsHidden				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_chicken_protection:CanParentBeAutoAttacked()
    return false
end

function modifier_chicken_protection:OnCreated(params)
    if IsServer() then
        self.caster = EntIndexToHScript(params.caster)
    end
end

function modifier_chicken_protection:CheckState()
	local state = {}

	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
    state[MODIFIER_STATE_NO_HEALTH_BAR] = true
    state[MODIFIER_STATE_NO_UNIT_COLLISION] = true

	return state
end

function modifier_chicken_protection:GetAbsoluteNoDamagePhysical(params)
    if IsServer() then
        if params.target and params.attacker and params.target == self:GetParent() and params.target == params.attacker:GetAttackTarget() and params.attacker == self.caster then ---attacker	table: 0x0362d4f0
            return 0
        end
    end 
	
    return 1
end

function modifier_chicken_protection:GetAbsoluteNoDamageMagical(params)
    return 1
end

function modifier_chicken_protection:GetAbsoluteNoDamagePure(params)
    return 1
end


LinkLuaModifier(" modifier_chicken_protection", "ai/special/ai_chicken_farmer", LUA_MODIFIER_MOTION_NONE ,  modifier_chicken_protection)
