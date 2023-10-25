AICore = {}

-- if creep take more than time specified here (in seconds) he will be teleported to spawn position
local RETREAT_TO_HOME_FORCED_TP_DELAY = 15
-- how long creep chase his target after receiving damage from it (in seconds)
local TEMPORARY_AGGRO_DURATION = 5
-- radius that used in allies search for assist request once creep enter combat state
local SEARCH_RANGE_FOR_BOYS_FOR_HELP = 500
local DISTANCE_TO_SPAWN_POSITION_TO_BE_CONSIDERED_REACHED_SQR = 625 -- 25
local DISTANCE_TO_CURRENT_GOAL_TO_BE_CONSIDERED_REACHED_SQR = 250000 -- 500

-- don't touch unless you know what are you doing
local THINK_INTERVAL_BOUNDS = {0.8, 1.2}
local THINK_INTERVAL_STEP = 0.01
-- Max hp % outside combat healing per second, if ai binded to zone
local MAX_HP_PCT_TO_HEALING_EVERY_025_SECOND = 0.1 -- 10

local AI_ACTION_CASTED_AT_LEAST_ONE_ABILITY = 1
local AI_ACTION_CASTED_NOTHING = -1

local AI_THINK_END = -1

local AI_UNIT_FILTER_INVALID = 0
local AI_UNIT_FILTER_VALID = 1

local AI_GOAL_STATE_NOT_ADJUSTED = 0
local AI_GOAL_STATE_ADJUSTED = 1

-- Use this to define ai properties
GenericAIBehavior = class({
	IsCanRetreatToSpawnPosition = function()
		return true
	end,
	IsCanRespondToHelpCall = function()
		return true
	end,
	IsCanTargetNeutralCreeps = function()
		return true
	end,
	IsBindedToZone = function()
		return false
	end,
	IsCanAdjustPathToGoal = function()
		return false
	end,
	IsCompletelyForgetAboutInvisibleEnemies = function()
		return false
	end,
	EnemyUnitFilterCustom = function(thisEntity, target)
		return true
	end,
	AllyUnitsFilterCustom = function(thisEntity, target)
		return true
	end,
	OnInit = function(thisEntity) end,
	OnDestroy = function(thisEntity) end,
})

-- internal code to make all shit works
function AICore:Init(thisEntity, behavior)
	-- Fix for gaben joke
	thisEntity:SetContextThink(
		"AICoreThink", 
		function()
			if(GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME or AIBehaviors:IsInitialized() == false) then
				return 0.1
			end
			if(not thisEntity.ai) then
				local thinkIntervalForThisEntity = AICore:GetUniqueThinkIntervalForEntity(thisEntity)
				thisEntity.ai = {
					behavior = behavior,
					isInCombat = false,
					isRetreating = false,
					currentGoals = {},
					spawnPosition = thisEntity:GetAbsOrigin(),
					aggroRange = thisEntity:GetAcquisitionRange(),
					thinkInterval = thinkIntervalForThisEntity,
					bindedZones = AIBehaviors:GetZonesForEntity(thisEntity),
					isCanRetreat = behavior:IsCanRetreatToSpawnPosition(),
					isCanRespondToHelpCall = behavior:IsCanRespondToHelpCall(),
					isCanTargetNeutralCreeps = behavior:IsCanTargetNeutralCreeps(),
					isCanAdjustPathToGoal = behavior:IsCanAdjustPathToGoal(),
					isBindedToZone = behavior:IsBindedToZone(),
					isCompletelyForgetAboutInvisibleEnemies = behavior:IsCompletelyForgetAboutInvisibleEnemies(),
					isNextGoalAdjusted = AI_GOAL_STATE_ADJUSTED,
					forcedTPToSpawnPositionTimer = RETREAT_TO_HOME_FORCED_TP_DELAY,
					temporaryAggroList = {},
					allyUnitFilterCustom = behavior.AllyUnitsFilterCustom,
					enemyUnitFilterCustom = behavior.EnemyUnitFilterCustom,
					healingTimerValue = 0
				}
				thisEntity:SetAcquisitionRange(0)
				AICore:InitAbilitiesList(thisEntity)
				thisEntity.ai.behavior:OnInit(thisEntity)
				return 0.1
			end
			local thinkResult = AICore:Think(thisEntity)
			return thinkResult
		end,
		0.1
	)
end

function AICore:OnDestroy(thisEntity)
	if(not IsServer()) then
		return
	end
	thisEntity.ai.behavior:OnDestroy(thisEntity)
	thisEntity.ai = nil
end

function AICore:GetUniqueThinkIntervalForEntity(thisEntity)
	-- This shit move so fucking fast that it bugs waypoint code...
	if(thisEntity:GetUnitName() == "npc_dota_plague_wagon") then
		return 0.05
	end
	local currentIndex = (_G._AICoreCurrentEntityIndex or 0)
	_G._AICoreCurrentEntityIndex = currentIndex + 1
	local newThinkInterval = (_G._AICoreCurrentEntityIndex * THINK_INTERVAL_STEP) + THINK_INTERVAL_BOUNDS[1]
	if(newThinkInterval > THINK_INTERVAL_BOUNDS[2]) then
		newThinkInterval = THINK_INTERVAL_BOUNDS[1]
		_G._AICoreCurrentEntityIndex = 0
	end
	return newThinkInterval	
end

function AICore:OnTakeDamage(thisEntity, attacker)
	if(not thisEntity or not thisEntity.ai) then
		return
	end
    if(AICore:IsRetreating(thisEntity) == true) then
        return
    end
    AICore:AddToTemporaryAggroList(thisEntity, attacker)
    local allies = AICore:FindAlliesAround(thisEntity, thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), SEARCH_RANGE_FOR_BOYS_FOR_HELP)
    AICore:CallAllBoysAroundToHelp(thisEntity, allies, attacker)
end

function AICore:InitAbilitiesList(thisEntity)
	thisEntity.ai.abilitiesWithAllyTarget = {}
	thisEntity.ai.abilitiesWithEnemyTarget = {}
	for i = 0, thisEntity:GetAbilityCount() - 1 do
		local offensiveAbility = AICore:FindAbility(thisEntity, i, ABILITY_AI_TYPE_OFFENSIVE)
		local supportAbility = AICore:FindAbility(thisEntity, i, ABILITY_AI_TYPE_SUPPORTING)
		if(supportAbility ~= nil) then
			table.insert(thisEntity.ai.abilitiesWithAllyTarget, supportAbility)
		end
		if(offensiveAbility ~= nil) then
			table.insert(thisEntity.ai.abilitiesWithEnemyTarget, offensiveAbility)
		end
	end
end

function AICore:RebuildAbilitiesList(thisEntity)
	if(thisEntity.ai) then
		AICore:InitAbilitiesList(thisEntity)
	end
end

function AICore:FindAbility(unit, index, type)
    local ability = unit:GetAbilityByIndex(index)
    if (not ability) or ability:GetName() == "twin_gate_portal_warp" then
		return nil
	end
	local abilityTargetTeam = ability:GetAbilityTargetTeam()
	local isAllyTargetAbility = (bit.band(abilityTargetTeam, DOTA_UNIT_TARGET_TEAM_FRIENDLY) == DOTA_UNIT_TARGET_TEAM_FRIENDLY)
	local isEnemyTargetAbility = (bit.band(abilityTargetTeam, DOTA_UNIT_TARGET_TEAM_ENEMY) == DOTA_UNIT_TARGET_TEAM_ENEMY)
	local isBothTeamTargetAbility = (bit.band(abilityTargetTeam, DOTA_UNIT_TARGET_TEAM_BOTH) == DOTA_UNIT_TARGET_TEAM_BOTH)
	if ((isAllyTargetAbility == true and isEnemyTargetAbility == true) or isBothTeamTargetAbility == true) then
		Debug_PrintError("[AICore] ".. tostring(unit:GetUnitName()) .. " has ability named " .. tostring(ability:GetAbilityName()) .. " that can be used on both allies and enemies. No idea what to do with it. Ignoring.")
		return nil
	end
	local abilityBehavior = ability:GetBehaviorInt()
	if (bit.band(abilityBehavior, DOTA_ABILITY_BEHAVIOR_PASSIVE) == DOTA_ABILITY_BEHAVIOR_PASSIVE or bit.band(abilityBehavior, DOTA_ABILITY_BEHAVIOR_AURA) == DOTA_ABILITY_BEHAVIOR_AURA) then
		ability.behavior = DOTA_ABILITY_BEHAVIOR_PASSIVE 
	elseif bit.band(abilityBehavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		ability.behavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET      
	elseif bit.band(abilityBehavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		ability.behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET   
	elseif bit.band(abilityBehavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
		ability.behavior = DOTA_ABILITY_BEHAVIOR_POINT
	end
	if bit.band(abilityBehavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE then
		ability.behavior = DOTA_ABILITY_BEHAVIOR_TOGGLE    
	end
	if(not ability.behavior) then
		Debug_PrintError("[AICore] ".. tostring(unit:GetUnitName()) .. " has ability named " .. tostring(ability:GetAbilityName()) .. " with unsupported behavior. No idea what to do with it. Ignoring.")
		return nil
	end
	local abilityTargetFlags = ability:GetAbilityTargetFlags()
	local isAbilityPierceBKB = (bit.band(abilityTargetFlags, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES) == DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	if(isAbilityPierceBKB == true) then
		ability.pierceBKB = isAbilityPierceBKB
	end
	if (isAllyTargetAbility == true) then
		if(type == ABILITY_AI_TYPE_SUPPORTING) then
			ability.type = ABILITY_AI_TYPE_SUPPORTING
			return ability
		else
			return nil
		end
	else
		if(type == ABILITY_AI_TYPE_OFFENSIVE) then
			ability.type = ABILITY_AI_TYPE_OFFENSIVE
			return ability
		else
			return nil
		end
	end
	return nil
end

function AICore:GetThinkInterval(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.thinkInterval
	end
	return -1
end

function AICore:GetSpawnPosition(thisEntity)
	return thisEntity.ai.spawnPosition
end

function AICore:IsInCombat(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isInCombat
	end
	return true
end

function AICore:SetInCombat(thisEntity, state)
	if(thisEntity.ai) then
		if(state ~= true and state ~= false) then
			Debug_PrintError("[AICore] Attempt to set combat state to invalid value = "..tostring(state)..". Using default value = false.")
			state = false
		end
		thisEntity.ai.isInCombat = state
	end
end

function AICore:CheckEnemiesInTemporaryAggroList(thisEntity)
	if(thisEntity.ai and thisEntity.ai.temporaryAggroList) then
		local indexesToRemove = {}
		for enemy, duration in pairs(thisEntity.ai.temporaryAggroList) do
			if(enemy:IsNull() == true or enemy:IsAlive() == false) then
				indexesToRemove[enemy] = true
			else
				thisEntity.ai.temporaryAggroList[enemy] = thisEntity.ai.temporaryAggroList[enemy] - AICore:GetThinkInterval(thisEntity)
				if(thisEntity.ai.temporaryAggroList[enemy] < 0.01) then
					indexesToRemove[enemy] = true
				end
			end
		end
		for enemy, _ in pairs(indexesToRemove) do
			thisEntity.ai.temporaryAggroList[enemy] = nil
		end
	end
end

function AICore:AddToTemporaryAggroList(thisEntity, enemy)
	if(thisEntity.ai and thisEntity.ai.temporaryAggroList) then
		if(AICore:EnemyUnitFilter(thisEntity, enemy) == AI_UNIT_FILTER_VALID) then
			thisEntity.ai.temporaryAggroList[enemy] = TEMPORARY_AGGRO_DURATION
		end
	end
end

function AICore:GetTemporaryAggroList(thisEntity)
	if(thisEntity.ai and thisEntity.ai.temporaryAggroList) then
		return thisEntity.ai.temporaryAggroList
	end
	return {}
end

function AICore:ClearTemporaryAggroList(thisEntity)
	if(thisEntity.ai and thisEntity.ai.temporaryAggroList) then
		thisEntity.ai.temporaryAggroList = {}
	end
end

function AICore:GetCurrentGoalEntity(thisEntity)
	if(thisEntity.ai and thisEntity.ai.currentGoals) then
		return thisEntity.ai.currentGoals[1]
	end
	return nil
end

function AICore:GetAllGoalEntities(thisEntity)
	if(thisEntity.ai and thisEntity.ai.currentGoals) then
		return thisEntity.ai.currentGoals
	end
	return {}
end

function AICore:GetGoalEntitiesCount(thisEntity)
	if(thisEntity.ai and thisEntity.ai.currentGoals) then
		return #thisEntity.ai.currentGoals
	end
	return 0
end

function AICore:AddGoalEntity(thisEntity, goalEntity)
	if(thisEntity.ai) then
		table.insert(thisEntity.ai.currentGoals, goalEntity)
	end
end

function AICore:RemoveGoalEntity(thisEntity, goalEntity)
	if(thisEntity.ai) then
		ArrayRemove(AICore:GetAllGoalEntities(thisEntity), function(t, i, j)
			local goal = t[i]
			return goal ~= goalEntity
		end)
	end
end

function AICore:RemoveAllGoalEntities(thisEntity)
	if(thisEntity.ai) then
		ArrayRemove(AICore:GetAllGoalEntities(thisEntity), function(t, i, j)
			return false
		end)
	end
end

function AICore:SetInitialGoalEntity(thisEntity, goalEntity)
	if(thisEntity.ai and goalEntity) then
		AICore:AddGoalEntity(thisEntity, goalEntity)
		if (goalEntity.hNext and goalEntity.hNext ~= goalEntity) then
			AICore:SetInitialGoalEntity(thisEntity, goalEntity.hNext)
		end
	end
end

function AICore:IsCanAdjustPathToGoal(thisEntity)
	if(thisEntity.ai and thisEntity.ai.isCanAdjustPathToGoal ~= nil) then
		return thisEntity.ai.isCanAdjustPathToGoal
	end
	return false
end

function AICore:SetIsNextGoalAdjusted(thisEntity, value)
	if(thisEntity.ai and thisEntity.ai.isNextGoalAdjusted ~= nil) then
		thisEntity.ai.isNextGoalAdjusted = value
	end
end

function AICore:IsNextGoalAdjusted(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isNextGoalAdjusted or true
	end
	return true
end

function AICore:AdjustNextGoal(thisEntity)
	if(not thisEntity.ai) then
		return
	end
	if(AICore:IsCanAdjustPathToGoal(thisEntity) == false) then
		return
	end
	if(AICore:IsNextGoalAdjusted(thisEntity) == AI_GOAL_STATE_ADJUSTED) then
		return
	end
	-- last point almost or already reached or there are no waypoints
	if(AICore:GetGoalEntitiesCount(thisEntity) < 2) then
		return
	end
	-- search for closest waypoint from current position
	local goalEntities = AICore:GetAllGoalEntities(thisEntity)
	local currentGoal = AICore:GetCurrentGoalEntity(thisEntity)
	local currentEntityPosition = thisEntity:GetAbsOrigin()
	local distancetoLatestKnownGoal = CalculateDistanceSqr(currentGoal:GetAbsOrigin(), currentEntityPosition)
	local distanceToCurrentCheckingGoal = 0
	for i = #goalEntities, 1, -1 do
		distanceToCurrentCheckingGoal = CalculateDistanceSqr(goalEntities[i]:GetAbsOrigin(), currentEntityPosition)
		if(distanceToCurrentCheckingGoal < distancetoLatestKnownGoal) then
			currentGoal = goalEntities[i]
			distancetoLatestKnownGoal = distanceToCurrentCheckingGoal
		end
	end
	AICore:RemoveAllGoalEntities(thisEntity)
	AICore:SetInitialGoalEntity(thisEntity, currentGoal)
	AICore:SetIsNextGoalAdjusted(thisEntity, AI_GOAL_STATE_ADJUSTED)
end

function AICore:SetIsRetreating(thisEntity, state)
	if(thisEntity.ai) then
		if(state ~= true and state ~= false) then
			Debug_PrintError("[AICore] Attempt to set retreating state to invalid value = "..tostring(state)..". Using default value = false.")
			state = false
		end
		thisEntity.ai.isRetreating = state
	end
end

function AICore:IsRetreating(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isRetreating
	end
	return false
end

function AICore:AdjustForcedTPTimer(thisEntity, value)
	if(thisEntity.ai) then
		thisEntity.ai.forcedTPToSpawnPositionTimer = thisEntity.ai.forcedTPToSpawnPositionTimer - value
		if(thisEntity.ai.forcedTPToSpawnPositionTimer <= 0) then
			AICore:ResetForcedTPTimer(thisEntity)
			AICore:SetIsRetreating(thisEntity, false)
			FindClearSpaceForUnit(thisEntity, AICore:GetSpawnPosition(thisEntity), true)
			thisEntity:Stop()
		end
	end
end

function AICore:ResetForcedTPTimer(thisEntity)
	if(thisEntity.ai) then
		thisEntity.ai.forcedTPToSpawnPositionTimer = RETREAT_TO_HOME_FORCED_TP_DELAY
	end
end

function AICore:IsCanRetreat(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isCanRetreat
	end
	return false
end

function AICore:GetAggroRange(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.aggroRange
	end
	return 0
end

function AICore:Think(thisEntity)
    if (thisEntity:IsNull() == true or thisEntity:IsAlive() == false or thisEntity:IsControllableByAnyPlayer() == true) then
		AICore:OnDestroy(thisEntity)
        return AI_THINK_END
    end
    if (GameRules:IsGamePaused() == true) then
        return AICore:GetThinkInterval(thisEntity)
    end
	AICore:CheckEnemiesInTemporaryAggroList(thisEntity)
    if (thisEntity:IsChanneling() == true) then
        return AICore:GetThinkInterval(thisEntity)
    end
	if(thisEntity:IsCommandRestricted() == true) then
        return AICore:GetThinkInterval(thisEntity)
	end
	if(AICore:IsInCombat(thisEntity) == false and AICore:IsBindedToZone(thisEntity) == true) then
		AICore:CheckHealingTimer(thisEntity, AICore:GetThinkInterval(thisEntity))
	end
	local currentEntityPosition = thisEntity:GetAbsOrigin()
	local searchRadius = AICore:GetAggroRange(thisEntity)
	if(AICore:IsRetreating(thisEntity) == true) then
		AICore:RetreatToHome(thisEntity)
		AICore:AdjustForcedTPTimer(thisEntity, AICore:GetThinkInterval(thisEntity))
		local distanceToSpawnPosition = CalculateDistanceSqr(currentEntityPosition, AICore:GetSpawnPosition(thisEntity))
		if(distanceToSpawnPosition <= DISTANCE_TO_SPAWN_POSITION_TO_BE_CONSIDERED_REACHED_SQR) then
			AICore:SetIsRetreating(thisEntity, false)
			thisEntity:Stop()
		end
		return AICore:GetThinkInterval(thisEntity)
	end
	if(AICore:IsCanRetreat(thisEntity) == true) then
		if(AICore:IsBindedToZone(thisEntity) == true) then
			if(AICore:IsInBindedZone(thisEntity) == false) then
				AICore:RetreatToHome(thisEntity)				
				return AICore:GetThinkInterval(thisEntity)
			end
		else
			local distanceToSpawnPosition = CalculateDistanceSqr(currentEntityPosition, AICore:GetSpawnPosition(thisEntity))
			local searchRadiusSqr = searchRadius * searchRadius
			if (distanceToSpawnPosition > searchRadiusSqr) then
				AICore:RetreatToHome(thisEntity)
				return AICore:GetThinkInterval(thisEntity)
			end
		end
	end
	if(AICore:IsInCombat(thisEntity) == true) then
		searchRadius = searchRadius * 1.5
	end
	local currentEntityTeam = thisEntity:GetTeamNumber()
    local enemies = AICore:FindEnemiesAround(thisEntity, currentEntityTeam, currentEntityPosition, searchRadius)
	-- Add enemies from temporary aggro list
	for enemy, _ in pairs(AICore:GetTemporaryAggroList(thisEntity)) do
		table.insert(enemies, enemy)
	end
	-- Remove invalid units from target list
	ArrayRemove(enemies, function(t, i, j)
        local enemy = t[i]
		return AICore:EnemyUnitFilter(thisEntity, enemy) == AI_UNIT_FILTER_VALID
    end)
	-- fix for case when there are enemies in aggro range, but damage source in opposite map side (too far)
	local enemiesInAggroRange = {}
	for index, enemy in pairs(enemies) do
		enemiesInAggroRange[index] = enemy
	end
	local searchRadiusSqr = searchRadius * searchRadius
	ArrayRemove(enemiesInAggroRange, function(t, i, j)
        local enemy = t[i]
		return CalculateDistanceSqr(currentEntityPosition, enemy:GetAbsOrigin()) <= searchRadiusSqr
    end)
	if(#enemiesInAggroRange > 0) then
		enemies = enemiesInAggroRange
	end
	-- sort by low priority modifier property and range
	table.sort(enemies, function(a, b)
		local firstEnemyAttackPriority = a:GetAttackPriority()
		local secondEnemyAttackPriority = b:GetAttackPriority()
		if(firstEnemyAttackPriority ~= secondEnemyAttackPriority) then
		     return firstEnemyAttackPriority > secondEnemyAttackPriority   
		end
		local distanceToFirstEnemy = CalculateDistanceSqr(currentEntityPosition, a:GetAbsOrigin())
		local distanceToSecondEnemy = CalculateDistanceSqr(currentEntityPosition, b:GetAbsOrigin())
		return distanceToFirstEnemy < distanceToSecondEnemy
	end)
	if(#enemies > 0) then
		AICore:SetInCombat(thisEntity, true)
		AICore:SetIsNextGoalAdjusted(thisEntity, AI_GOAL_STATE_NOT_ADJUSTED)
		local actionResult = AICore:TryAttackEnemies(thisEntity, enemies)
		if(actionResult ~= AI_ACTION_CASTED_NOTHING) then
			return AICore:GetThinkInterval(thisEntity)
		end
	else
		AICore:AdjustNextGoal(thisEntity)
		AICore:SetInCombat(thisEntity, false)
	end
	if(AICore:IsInCombat(thisEntity) == true) then
		local allies = AICore:FindAlliesAround(thisEntity, currentEntityTeam, currentEntityPosition, searchRadius)
		ArrayRemove(allies, function(t, i, j)
			local ally = t[i]
			return AICore:AllyUnitsFilter(thisEntity, ally) == AI_UNIT_FILTER_VALID
		end)
		if(#allies > 0) then
			local actionResult = AICore:TryHelpAllies(thisEntity, allies)
			if(actionResult ~= AI_ACTION_CASTED_NOTHING) then
				return AICore:GetThinkInterval(thisEntity)
			end
		end
	else
		if(AICore:IsCanRetreat(thisEntity) == true) then
			local distanceToSpawnPosition = CalculateDistanceSqr(currentEntityPosition, AICore:GetSpawnPosition(thisEntity))
			if (distanceToSpawnPosition > DISTANCE_TO_SPAWN_POSITION_TO_BE_CONSIDERED_REACHED_SQR) then
				AICore:RetreatToHome(thisEntity)
			end
		else
			AICore:MoveToNextGoal(thisEntity)
		end
	end
	return AICore:GetThinkInterval(thisEntity)
end

function AICore:FindAlliesAround(thisEntity, thisEntityTeam, thisEntityPosition, searchRadius)
    local allies = FindUnitsInRadius(
        thisEntityTeam,
		thisEntityPosition, 
		nil, 
		searchRadius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_CLOSEST,
		false
	)
	return allies
end

function AICore:FindEnemiesAround(thisEntity, thisEntityTeam, thisEntityPosition, searchRadius)
    local enemies = FindUnitsInRadius(
        thisEntityTeam,
		thisEntityPosition, 
		nil, 
		searchRadius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_ANY_ORDER,
		false
	)
	return enemies
end

function AICore:AllyUnitsFilter(thisEntity, target)
	if(thisEntity.ai.allyUnitFilterCustom and thisEntity.ai.allyUnitFilterCustom(AICore, thisEntity, target) == false) then
		return AI_UNIT_FILTER_INVALID
	end
	if(not target or target:IsNull() == true or target:IsAlive() == false) then
		return AI_UNIT_FILTER_INVALID
	end
	if(thisEntity:GetTeamNumber() ~= target:GetTeamNumber()) then
		return AI_UNIT_FILTER_INVALID
	end
	if(target:IsOutpost()) then
		return AI_UNIT_FILTER_INVALID
	end
	return AI_UNIT_FILTER_VALID
end

function AICore:EnemyUnitFilter(thisEntity, target)
	if(not target or target:IsNull() == true or target:IsAlive() == false) then
		return AI_UNIT_FILTER_INVALID
	end
	if(thisEntity.ai.enemyUnitFilterCustom and thisEntity.ai.enemyUnitFilterCustom(AICore, thisEntity, target) == false) then
		return AI_UNIT_FILTER_INVALID
	end
	if(AICore:IsCompletelyForgetAboutInvisibleEnemies(thisEntity) == true and thisEntity:CanEntityBeSeenByMyTeam(target) == false) then
		return AI_UNIT_FILTER_INVALID
	end
	if(target:IsOutpost()) then
		return AI_UNIT_FILTER_INVALID
	end
	if(target:IsPhantom() == true or target:IsPhantomBlocker() == true) then
		return AI_UNIT_FILTER_INVALID
	end
	if(target:IsControllableByAnyPlayer() == true) then
		return AI_UNIT_FILTER_VALID
	end
	if(AICore:IsCanTargetNeutralCreeps(thisEntity) == false) then
		if(target:IsNeutralCreep() == true) then
			return AI_UNIT_FILTER_INVALID
		end
	end
	return AI_UNIT_FILTER_VALID
end

function AICore:IsCanTargetNeutralCreeps(thisEntity)
	if(not thisEntity.ai) then
		return false
	end
	return thisEntity.ai.isCanTargetNeutralCreeps
end

function AICore:MoveToNextGoal(thisEntity)
	if(not thisEntity.ai) then
		return
	end
	local currentGoal = AICore:GetCurrentGoalEntity(thisEntity)
	if(not currentGoal) then
		return
	end
	local goalPosition = currentGoal:GetAbsOrigin()
	AICore:MoveToPosition(thisEntity, goalPosition)
	local distanceToGoal = 	CalculateDistanceSqr(goalPosition, thisEntity:GetAbsOrigin())
	if(distanceToGoal <= DISTANCE_TO_CURRENT_GOAL_TO_BE_CONSIDERED_REACHED_SQR) then
		if(AICore:GetGoalEntitiesCount(thisEntity) > 1) then
			AICore:RemoveGoalEntity(thisEntity, currentGoal)
			AICore:MoveToNextGoal(thisEntity)
		end
	end
end

function AICore:CallAllBoysAroundToHelp(thisEntity, boys, target)
	for _, boy in pairs(boys) do
		if(boy.ai and boy ~= thisEntity and AICore:IsInCombat(boy) == false and AICore:IsCanRespondToHelpCall(boy) == true) then
			if(AICore:EnemyUnitFilter(boy, target) == AI_UNIT_FILTER_VALID) then
				AICore:AddToTemporaryAggroList(boy, target)
				AICore:SetInCombat(boy, true)
			end
		end
	end
end

function AICore:IsCanRespondToHelpCall(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isCanRespondToHelpCall
	end
	return false
end

function AICore:IsInBindedZone(thisEntity)
	if(thisEntity.ai and thisEntity.ai.isBindedToZone and thisEntity.ai.bindedZones) then
		local isInAtLeastOneZone = false
		-- some errors in kv probably, ignore zone binding behavior
		if(#thisEntity.ai.bindedZones == 0) then
			return true
		end
		for _, v in pairs(thisEntity.ai.bindedZones) do
			if(v:IsTouching(thisEntity) == true) then
				isInAtLeastOneZone = true
				break
			end
		end
		return isInAtLeastOneZone
	end
	return true
end

function AICore:IsBindedToZone(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isBindedToZone
	end
	return false
end

function AICore:IsCompletelyForgetAboutInvisibleEnemies(thisEntity)
	if(thisEntity.ai) then
		return thisEntity.ai.isCompletelyForgetAboutInvisibleEnemies
	end
	return false
end

function AICore:SetHealingTimerValue(thisEntity, value)
	if(thisEntity.ai and thisEntity.ai.healingTimerValue) then
		thisEntity.ai.healingTimerValue = tonumber(value) or 0
	end
end

function AICore:GetHealingTimerValue(thisEntity)
	if(thisEntity.ai and thisEntity.ai.healingTimerValue) then
		return thisEntity.ai.healingTimerValue
	end
	return 0
end

function AICore:CheckHealingTimer(thisEntity, thinkInterval)
	local timer = AICore:GetHealingTimerValue(thisEntity) + thinkInterval
	if(timer > 0.25) then
		thisEntity:Heal(thisEntity:GetMaxHealth() * MAX_HP_PCT_TO_HEALING_EVERY_025_SECOND, thisEntity, DOTA_HEAL_TYPE_HEALING)
		timer = 0
	end
	AICore:SetHealingTimerValue(thisEntity, timer)
end

function AICore:TryAttackEnemies(thisEntity, enemies)
	for _, ability in ipairs(thisEntity.ai.abilitiesWithEnemyTarget) do
		local actionResult = AICore:TryCastAbility(ability, thisEntity, enemies)
		if(actionResult ~= AI_ACTION_CASTED_NOTHING) then
			return actionResult
		end
	end
	AICore:SetInCombat(thisEntity, true)
	AICore:AttackTarget(thisEntity, enemies[1])
	return AI_ACTION_CASTED_NOTHING
end

function AICore:TryHelpAllies(thisEntity, allies)
	for _, ability in ipairs(thisEntity.ai.abilitiesWithAllyTarget) do
		local actionResult = AICore:TryCastAbility(ability, thisEntity, allies)
		if(actionResult ~= AI_ACTION_CASTED_NOTHING) then
			AICore:SetInCombat(thisEntity, true)
			return actionResult
		end
	end
	return AI_ACTION_CASTED_NOTHING
end

function AICore:TryCastAbility(ability, caster, allTargets)
    if (ability:IsFullyCastable() == false or ability.behavior == DOTA_ABILITY_BEHAVIOR_PASSIVE) then
        return AI_ACTION_CASTED_NOTHING
    end
	if(ability:GetMaxAbilityCharges(ability:GetLevel()) > 0 and ability:GetCurrentAbilityCharges() == 0) then
		return AI_ACTION_CASTED_NOTHING
    end
	if(ability:IsCooldownReady() == false) then
		return AI_ACTION_CASTED_NOTHING
    end
	local target = AIBehaviors:GetTargetForAbility(ability, caster, allTargets)
	if(target) then
		if(caster:CanEntityBeSeenByMyTeam(target) == false) then
			AICore:MoveToPosition(caster, target:GetAbsOrigin())
			return
		end
		local orderType = AICore:GetOrderTypeFromAbilityBehaviour(ability)
		ExecuteOrderFromTable({
			UnitIndex = caster:entindex(),
			OrderType = orderType, 
			AbilityIndex = ability:entindex(), 
			TargetIndex = target:entindex(),
			Position = target:GetAbsOrigin(),
			Queue = false,
		})
		return AI_ACTION_CASTED_AT_LEAST_ONE_ABILITY
	end
	return AI_ACTION_CASTED_NOTHING
end

function AICore:GetOrderTypeFromAbilityBehaviour(ability)
    if ability.behavior == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        return DOTA_UNIT_ORDER_CAST_TARGET
    elseif ability.behavior == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
        return DOTA_UNIT_ORDER_CAST_NO_TARGET
    elseif ability.behavior == DOTA_ABILITY_BEHAVIOR_POINT then
        return DOTA_UNIT_ORDER_CAST_POSITION   
    elseif ability.behavior == DOTA_ABILITY_BEHAVIOR_TOGGLE then
        return DOTA_UNIT_ORDER_CAST_TOGGLE
    elseif ability.behavior == DOTA_ABILITY_BEHAVIOR_PASSIVE then
        return -1
    end
	return -1
end

function AICore:MoveToPosition(thisEntity, position)
	if (position == nil or thisEntity:HasMovementCapability() == false) then
        return
    end
	ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = position,
		Queue = false
    })
end

function AICore:AttackTarget(thisEntity, enemy)
	if (enemy == nil or thisEntity:HasMovementCapability() == false) then
        return
    end
	if(AICore:EnemyUnitFilter(thisEntity, enemy) == AI_UNIT_FILTER_INVALID) then
		return
	end
	AICore:SetInCombat(thisEntity, true)
	if(thisEntity:CanEntityBeSeenByMyTeam(enemy) == false) then
		AICore:MoveToPosition(thisEntity, enemy:GetAbsOrigin())
		return
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = enemy:entindex(),
		Queue = false
	})
end

function AICore:RetreatToHome(thisEntity)
	AICore:SetInCombat(thisEntity, false)
    if (thisEntity:HasMovementCapability() == false) then
        return
    end
	AICore:SetIsRetreating(thisEntity, true)
	AICore:ClearTemporaryAggroList(thisEntity)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = AICore:GetSpawnPosition(thisEntity),
		Queue = false
    })
end

function AICore:ForceThink(thisEntity, searchForNewTargets)
    if (not thisEntity or thisEntity.ai == nil) then
        return
    end
	if(searchForNewTargets == true) then
		AICore:ClearTemporaryAggroList(thisEntity)
	end
	AICore:Think(thisEntity)
	AICore:ForceAdjustPath(thisEntity)
end

function AICore:ForceAdjustPath(thisEntity)
	AICore:SetIsNextGoalAdjusted(thisEntity, AI_GOAL_STATE_NOT_ADJUSTED)
	AICore:AdjustNextGoal(thisEntity)
end

_G.AICore = _G.AICore or AICore