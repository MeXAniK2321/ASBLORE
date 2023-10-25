--[[
	"AIBehavior" 
    {
        "TargetType" "ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET" -- type of target to cast this ability
            -- ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET = target most injured valid target (ally or enemy) in cast range (no_target behavior) or aggro range (all others behaviors)
            -- ABILITY_AI_TARGET_TYPE_MOST_HEALTHY_TARGET = target most healthy valid target (ally or enemy) in cast range (no_target behavior) or aggro range (all others behaviors)
            -- ABILITY_AI_TARGET_TYPE_CLOSEST_TARGET = target closest valid target (ally or enemy) in cast range (no_target behavior) or aggro range (all others behaviors)
            -- ABILITY_AI_TARGET_TYPE_PREFER_CLOSEST_HERO = target closest enemy heroes if possible (ally or enemy), if fail then target all other valid targets
            -- ABILITY_AI_TARGET_TYPE_CLOSEST_HERO = target closest enemy heroes only (ally or enemy)
        "Conditions" 
        {
            "CanTargetBosses"   "1" -- can target boss allies?
            "TargetsAround"	"1", -- targets around in cast range (no_target behavior) or aggro range (all others behaviors) required to use that ability (excluding caster)
            "HeroesAround"  "1" -- heroes around in cast range (no_target behavior) or aggro range (all others behaviors) required to use that ability (excluding caster)
            "CasterHasModifiers" 
            { -- list of modifiers that caster must have to use that ability
                "1" "modifier_name_1"
                "2" "modifier_name_2"
            }
            "CasterDontHasModifiers" 
            { -- list of modifiers that caster must not have to use that ability
                "1" "modifier_name_1"
                "2" "modifier_name_2"
            }
            "HasModifiers" 
            { -- list of modifiers that target(s) must have to use that ability
                "1" "modifier_name_1"
                "2" "modifier_name_2"
            }
            "DontHaveModifiers" 
            { -- list of modifiers that target(s) must not have to use that ability
                "1" "modifier_name_1"
                "2" "modifier_name_2"
            }
            "HealthPercentEqualOrBelow" "50" -- target(s) health percent condition
            "HealthPercentEqualOrGreater"	"90" -- target(s) health percent condition
            "CasterHealthPercentEqualOrBelow" "50" -- caster health percent condition
            "CasterHealthPercentEqualOrGreater" "90" -- caster health percent condition
        }
    }
]] 

_G.ABILITY_AI_TYPE_OFFENSIVE = 0
_G.ABILITY_AI_TYPE_SUPPORTING = 1

_G.ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET = 0
_G.ABILITY_AI_TARGET_TYPE_MOST_HEALTHY_TARGET = 1
_G.ABILITY_AI_TARGET_TYPE_CLOSEST_TARGET = 2
_G.ABILITY_AI_TARGET_TYPE_PREFER_CLOSEST_HERO = 3
_G.ABILITY_AI_TARGET_TYPE_CLOSEST_HERO = 4

AIBehaviors = AIBehaviors or {
    Zones = {
        ["AI_FOREST_ZONE"] = {
            "forest_area_1"
        },
        ["AI_FOREST_BOSS_ZONE"] = {
            "forest_boss_area"
        },
        ["AI_CATACOMBS_ZONE"] = {
            "catacombs_area_1",
            "catacombs_area_2"
        },
        ["AI_CATACOMBS_BOSS_ZONE"] = {
            "catacombs_boss_area"
        },
        ["AI_ICE_ZONE"] = {
            "ice_area_1",
            "ice_area_2"
        },
        ["AI_ICE_BOSS_ZONE"] = {
            "ice_boss_area"
        },
        ["AI_WATER_ZONE"] = {
            "water_area_1",
            "water_area_2"
        },
        ["AI_WATER_BOSS_ZONE"] = {
            "water_boss_area"
        },
        ["AI_WATER_BOSS_SECRET_ZONE"] = {
            "forest_secret_boss_area"
        },
        ["AI_ALLIANCE_ZONE"] = {
            "alliance_area_1"
        },
        ["AI_ALLIANCE_BOSS_ZONE"] = {
            "alliance_boss_area",
        },
        ["AI_FIRE_ZONE"] = {
            "fire_area_1"
        },
        ["AI_FIRE_BOSS_ZONE"] = {
            "fire_boss_area",
        },
        ["AI_COLOSSEUM_ZONE"] = {
            "colosseum_ai_area",
        },
        ["AI_ASTRAL_ZONE"] = {
            "enigma_boss_area",
        }
    },
    Waypoints = {},
    Initialized = false
}

--[[
for k, v in pairs(LoadKeyValues("scripts/npc/npc_units_custom.txt")) do
    if(type(v) == "table") then
        if(v["AIScript"] == "ai/ai_neutral") then
            if(v["AIZone"] == nil) then
                print("Creep named ", k, "has missing or unknown zone.")
            else
                local zoneFound = false
                for zoneName, zoneTriggers in pairs(AIBehaviors.Zones) do
                    if(tostring(v["AIZone"]) == tostring(zoneName)) then
                        zoneFound = true
                        break
                    end
                end
                if(zoneFound == false) then
                    print("Creep named ", k, "has missing or unknown zone.")
                end
            end
        end
    end
end
--]]

function AIBehaviors:Init()
    self:ParseAbilityData()
    self:LoadUnitsForAI()
	OpenEvents:RegisterEventHandler(OPEN_EVENT_ON_GAME_RULES_STATE_CHANGE, function(kv)
		AIBehaviors:OnGameRulesStateChange(kv)
	end)
    ListenToModifierEvent(MODIFIER_EVENT_ON_TAKEDAMAGE, function(kv)
		AICore:OnTakeDamage(kv.unit, kv.attacker)
	end)
end

function AIBehaviors:OnGameRulesStateChange()
    local gameState = GameRules:State_Get()
    if(gameState >= DOTA_GAMERULES_STATE_STRATEGY_TIME and not AIBehaviors.Initialized) then
        self:ParseZonesData()
        self:FindWaypointsForBoys()
        AIBehaviors.Initialized = true
        print("[AIBehavior] Initialized.")
    end
end

function AIBehaviors:IsInitialized()
    return AIBehaviors.Initialized or false
end

function AIBehaviors:ParseZonesData()
    local triggers = Entities:FindAllByClassname("trigger_dota")
    local allTriggers = {}
    for _, trigger in pairs(triggers) do
        table.insert(allTriggers, {
            name = trigger:GetName(),
            trigger = trigger
        })
    end
    local isThereAreError = false
    for zoneName, zoneTriggers in pairs(AIBehaviors.Zones) do
        local unknownZonesIndexes = {}
        for zoneTriggerIndex, zoneTriggerName in pairs(zoneTriggers) do
            for _, triggerData in pairs(allTriggers) do
                if (string.find(triggerData["name"], zoneTriggerName)) then
                    zoneTriggers[zoneTriggerIndex] = triggerData["trigger"]
                    break
                end
            end
            if(type(zoneTriggers[zoneTriggerIndex]) == "string") then
                if(IsInToolsMode()) then
                    print("[AIBehavior] Can't find trigger named "..tostring(zoneTriggers[zoneTriggerIndex])..". Fix this please.")
                end
                table.insert(unknownZonesIndexes, zoneTriggerIndex)
                isThereAreError = true
            end
        end
        for _, unknownZoneTriggerIndex in pairs(unknownZonesIndexes) do
            zoneTriggers[unknownZoneTriggerIndex] = nil
        end
    end
    if(isThereAreError == true) then
        Timers:CreateTimer(0, function() 
            if(GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME) then
                if(IsInToolsMode()) then
                    GameRules:SendCustomMessage("[AIBehavior] There are errors during parsing zones. Check console.", 0, 0)
                end
            else
                return 1
            end
        end)
    end
end

function AIBehaviors:ParseAbilityData()
    self.abilities = {}
    local abilitiesKV = LoadKeyValues('scripts/npc/npc_abilities_custom.txt')
    for abilityName, data in pairs(abilitiesKV) do
        if(type(data) == "table" and data["AIBehavior"]) then
            self.abilities[abilityName] = data["AIBehavior"]
        end
    end
    local isThereAreError = false
    for name, data in pairs(self.abilities) do
        if(data["TargetType"]) then
            if(data["TargetType"] == "ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET") then
                data["TargetType"] = ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET
            elseif(data["TargetType"] == "ABILITY_AI_TARGET_TYPE_MOST_HEALTHY_TARGET") then
                data["TargetType"] = ABILITY_AI_TARGET_TYPE_MOST_HEALTHY_TARGET
            elseif(data["TargetType"] == "ABILITY_AI_TARGET_TYPE_CLOSEST_TARGET") then
                data["TargetType"] = ABILITY_AI_TARGET_TYPE_CLOSEST_TARGET
            elseif(data["TargetType"] == "ABILITY_AI_TARGET_TYPE_PREFER_CLOSEST_HERO") then
                data["TargetType"] = ABILITY_AI_TARGET_TYPE_PREFER_CLOSEST_HERO
            elseif(data["TargetType"] == "ABILITY_AI_TARGET_TYPE_CLOSEST_HERO") then
                data["TargetType"] = ABILITY_AI_TARGET_TYPE_CLOSEST_HERO
            else
                print("[AIBehavior] Ability "..tostring(name).." has unknown TargetType in AIBehavior block. Got "..tostring(data["TargetType"])
                ..", expected: ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET, ABILITY_AI_TARGET_TYPE_MOST_HEALTHY_TARGET, ABILITY_AI_TARGET_TYPE_CLOSEST_TARGET, ABILITY_AI_TARGET_TYPE_PREFER_CLOSEST_HERO, ABILITY_AI_TARGET_TYPE_CLOSEST_HERO.")
                data["TargetType"] = nil
                isThereAreError = true
            end
        end
        if(data["Conditions"]) then
            if(data["Conditions"]["TargetsAround"]) then
                local targersAround = tonumber(data["Conditions"]["TargetsAround"])
                if(targersAround) then
                    data["Conditions"]["TargetsAround"] = targersAround
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown TargetsAround in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["TargetsAround"])
                    ..", expected: (number)")
                    data["Conditions"]["TargetsAround"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["HeroesAround"]) then
                local targersAround = tonumber(data["Conditions"]["HeroesAround"])
                if(targersAround) then
                    data["Conditions"]["HeroesAround"] = targersAround
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown HeroesAround in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["HeroesAround"])
                    ..", expected: (number)")
                    data["Conditions"]["HeroesAround"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["HasModifiers"]) then
                if(type(data["Conditions"]["HasModifiers"]) ~= "table") then
                    print("[AIBehavior] Ability "..tostring(name).." has unknown HasModifiers in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["HasModifiers"])
                    ..", expected: (table)")
                    data["Conditions"]["HasModifiers"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["DontHaveModifiers"]) then
                if(type(data["Conditions"]["DontHaveModifiers"]) ~= "table") then
                    print("[AIBehavior] Ability "..tostring(name).." has unknown DontHaveModifiers in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["DontHaveModifiers"])
                    ..", expected: (table)")
                    data["Conditions"]["DontHaveModifiers"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["CasterHasModifiers"]) then
                if(type(data["Conditions"]["CasterHasModifiers"]) ~= "table") then
                    print("[AIBehavior] Ability "..tostring(name).." has unknown CasterHasModifiers in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["CasterHasModifiers"])
                    ..", expected: (table)")
                    data["Conditions"]["CasterHasModifiers"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["CasterDontHasModifiers"]) then
                if(type(data["Conditions"]["CasterDontHasModifiers"]) ~= "table") then
                    print("[AIBehavior] Ability "..tostring(name).." has unknown CasterDontHasModifiers in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["CasterDontHasModifiers"])
                    ..", expected: (table)")
                    data["Conditions"]["CasterDontHasModifiers"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["HealthPercentEqualOrBelow"]) then
                local healthPct = tonumber(data["Conditions"]["HealthPercentEqualOrBelow"])
                if(healthPct) then
                    data["Conditions"]["HealthPercentEqualOrBelow"] = healthPct
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown HealthPercentEqualOrBelow in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["HealthPercentEqualOrBelow"])
                    ..", expected: (number)")
                    data["Conditions"]["HealthPercentEqualOrBelow"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["HealthPercentEqualOrGreater"]) then
                local healthPct = tonumber(data["Conditions"]["HealthPercentEqualOrGreater"])
                if(healthPct) then
                    data["Conditions"]["HealthPercentEqualOrGreater"] = healthPct
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown HealthPercentEqualOrGreater in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["HealthPercentEqualOrGreater"])
                    ..", expected: (number)")
                    data["Conditions"]["HealthPercentEqualOrGreater"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["CasterHealthPercentEqualOrBelow"]) then
                local healthPct = tonumber(data["Conditions"]["CasterHealthPercentEqualOrBelow"])
                if(healthPct) then
                    data["Conditions"]["CasterHealthPercentEqualOrBelow"] = healthPct
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown CasterHealthPercentEqualOrBelow in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["CasterHealthPercentEqualOrBelow"])
                    ..", expected: (number)")
                    data["Conditions"]["CasterHealthPercentEqualOrBelow"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["CasterHealthPercentEqualOrGreater"]) then
                local healthPct = tonumber(data["Conditions"]["CasterHealthPercentEqualOrGreater"])
                if(healthPct) then
                    data["Conditions"]["CasterHealthPercentEqualOrGreater"] = healthPct
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown CasterHealthPercentEqualOrGreater in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["CasterHealthPercentEqualOrGreater"])
                    ..", expected: (number)")
                    data["Conditions"]["CasterHealthPercentEqualOrGreater"] = nil
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["CanTargetBosses"]) then
                local canTargetBosses = tonumber(data["Conditions"]["CanTargetBosses"])
                if(canTargetBosses) then
                    data["Conditions"]["CanTargetBosses"] = (canTargetBosses == 1)
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown CanTargetBosses in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["CanTargetBosses"])..", expected: (number)")
                    data["Conditions"]["CanTargetBosses"] = true
                    isThereAreError = true
                end
            end
            if(data["Conditions"]["CanTargetSelf"]) then
                local canTargetSelf = tonumber(data["Conditions"]["CanTargetSelf"])
                if(canTargetSelf) then
                    data["Conditions"]["CanTargetSelf"] = (canTargetSelf == 1)
                else
                    print("[AIBehavior] Ability "..tostring(name).." has unknown CanTargetSelf in AIBehavior Conditions block. Got "..tostring(data["Conditions"]["CanTargetSelf"])..", expected: (number)")
                    data["Conditions"]["CanTargetSelf"] = true
                    isThereAreError = true
                end
            end
        end
    end
    if(isThereAreError == true) then
        print("[AIBehavior] There are errors during parsing that will replace invalid behaviours of abilities with default ones.")
        Timers:CreateTimer(0, function() 
            if(GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME) then
                if(IsInToolsMode()) then
                    GameRules:SendCustomMessage("[AIBehavior] There are errors during parsing that will replace invalid behaviours of abilities with default ones. Check console.", 0, 0)
                end
            else
                return 1
            end
        end)
    end
end

function AIBehaviors:FindWaypointsForBoys()
    local tNameIndexed = {}
    local tCorners = Entities:FindAllByClassname('path_corner')
    for _, hCorner in pairs( tCorners ) do
        hCorner.tPrevs = {}
        
        local sName = hCorner:GetName()
        tNameIndexed[ sName ] = hCorner
        
        local tSorces = Entities:FindAllByTarget( sName )
        for _, hSource in pairs( tSorces ) do
            if hSource:GetClassname() == 'path_corner' then
                hSource.hNext = hCorner
                hCorner.tPrevs[ hSource ] = true
            end
        end
    end
    self.Waypoints = tCorners
    self.AllianceInitialGoalEntity = Entities:FindByName(nil, "94_a_waypoint1")
    self.LineDireInitialGoalEntity = Entities:FindByName( nil, "d_waypoint11")
    self.LineDireInitialGoalEntityAfterFrozenThroneDeath = Entities:FindByName( nil, "d_waypoint1")
    self.LineRadiantInitialGoalEntity = Entities:FindByName( nil, "n_waypoint1_neutral")
    self.LineRadiantInitialGoalEntityAfterFrozenThroneDeath = Entities:FindByName( nil, "n_waypoint1_neutral_1")
end

function AIBehaviors:GetRadiantLineInitialGoalEntity()
    if(Spawn:IsWraithKingThroneKilled() == true) then
        return self.LineRadiantInitialGoalEntityAfterFrozenThroneDeath
    end
    return self.LineRadiantInitialGoalEntity
end

function AIBehaviors:GetDireLineInitialGoalEntity()
    if(Spawn:IsWraithKingThroneKilled() == true) then
        return self.LineDireInitialGoalEntityAfterFrozenThroneDeath
    end
    return self.LineDireInitialGoalEntity
end

function AIBehaviors:GetDireFinalBossInitialGoalEntity()
    return self.LineDireInitialGoalEntityAfterFrozenThroneDeath
end

function AIBehaviors:GetAllianceInitialGoalEntity()
    return self.AllianceInitialGoalEntity
end

function AIBehaviors:LoadUnitsForAI()
    self.units = {}
    local unitsKV = LoadKeyValues('scripts/npc/npc_units_custom.txt')
    local isThereAreError = false
    for unitName, data in pairs(unitsKV) do
        if(type(data) == "table") then
            self.units[unitName] = {
                AIZone = nil 
            }
            if(data["AIZone"]) then
                self.units[unitName].AIZone = data["AIZone"]
                if(not AIBehaviors.Zones[data["AIZone"]]) then
                    if(IsInToolsMode()) then
                        print("[AIBehavior] Attempt to add unknown AI zone to unit named "..tostring(unitName).." with value "..tostring(self.units[unitName].AIZone)..". Fix typo or define new ai zone in ai_behavious.lua.")
                        isThereAreError = true
                    end
                    self.units[unitName].AIZone = nil
                end
            end
        end
    end
    if(isThereAreError == true) then
        Timers:CreateTimer(0, function() 
            if(GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME) then
                if(IsInToolsMode()) then
                    GameRules:SendCustomMessage("[AIBehavior] Init detected some errors. Check console.", 0, 0)
                end
            else
                return 1
            end
        end)
    end
end

function AIBehaviors:GetZonesForEntity(entity)
    if(not entity) then
        return {}
    end
    local unitName = entity:GetUnitName()
    if(self.units[unitName] and self.units[unitName].AIZone) then
        return AIBehaviors.Zones[self.units[unitName].AIZone] or {}
    end
    return {}
end

function AIBehaviors:GetTargetForAbility(ability, caster, allTargets)
    if(not ability or not allTargets) then
        return nil
    end
    local filteredTargets = {}
    for _, v in ipairs(allTargets) do
        table.insert(filteredTargets, v)
    end
    local abilityData = self.abilities[ability:GetAbilityName()]
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlags = ability:GetAbilityTargetFlags()
    local casterTeam = caster:GetTeamNumber()
    if(targetTeam ~= DOTA_UNIT_TARGET_TEAM_NONE and targetType ~= DOTA_UNIT_TARGET_NONE) then
        ArrayRemove(filteredTargets, function(t, i, j)
            local target = filteredTargets[i]
            local isBossConditionMeet = true
            local isSelfConditionMeet = true
            if(abilityData and abilityData["Conditions"] and abilityData["Conditions"]["CanTargetBosses"] == false) then
                isBossConditionMeet = (target:IsBoss() == false)
            end
            if(abilityData and abilityData["Conditions"] and abilityData["Conditions"]["CanTargetSelf"] == false) then
                isSelfConditionMeet = (target ~= caster)
            end
            return UnitFilter(target, targetTeam, targetType, targetFlags, casterTeam) == UF_SUCCESS and isBossConditionMeet and isSelfConditionMeet
        end)
    end
    if(#filteredTargets == 0) then
        return nil
    end
    if(not abilityData) then
        return filteredTargets[1]
    end
    if(ability.behavior == DOTA_ABILITY_BEHAVIOR_NO_TARGET) then
        local casterPosition = caster:GetAbsOrigin()
        local range = ability:GetCastRange(casterPosition, nil)
        range = range * range
        if(range > 0) then
            ArrayRemove(filteredTargets, function(t, i, j)
                local target = filteredTargets[i]
                return CalculateDistanceSqr(target:GetAbsOrigin(), casterPosition) <= range and target ~= caster
            end)
        end
        local isMatchConditions = self:CheckAbilityConditions(ability, abilityData, filteredTargets)
        if(isMatchConditions == true) then
            return caster
        end
        return nil
    end
    if(ability.behavior == DOTA_ABILITY_BEHAVIOR_TOGGLE and ability:GetToggleState() == false) then
        local caster = ability:GetCaster()
        local isMatchConditions = self:CheckAbilityConditions(ability, abilityData, filteredTargets)
        if(isMatchConditions == true) then
            return caster
        end
        return nil
    end
    if(abilityData["TargetType"] == ABILITY_AI_TARGET_TYPE_MOST_INJURED_TARGET) then
        table.sort(filteredTargets, function(a, b)
            return a:GetHealthPercent() < b:GetHealthPercent()
        end)
        for _, desiredTarget in ipairs(filteredTargets) do
            if(self:CheckAbilityConditions(ability, abilityData, filteredTargets, desiredTarget) == true) then
                return desiredTarget
            end
        end
        return nil
    end
    if(abilityData["TargetType"] == ABILITY_AI_TARGET_TYPE_MOST_HEALTHY_TARGET) then
        table.sort(filteredTargets, function(a, b)
            return a:GetHealthPercent() > b:GetHealthPercent()
        end)
        for _, desiredTarget in ipairs(filteredTargets) do
            if(self:CheckAbilityConditions(ability, abilityData, filteredTargets, desiredTarget) == true) then
                return desiredTarget
            end
        end
        return nil
    end
    if(abilityData["TargetType"] == ABILITY_AI_TARGET_TYPE_CLOSEST_TARGET) then
        for _, desiredTarget in ipairs(filteredTargets) do
            if(self:CheckAbilityConditions(ability, abilityData, filteredTargets, desiredTarget) == true) then
                return desiredTarget
            end
        end
        return nil
    end
    if(abilityData["TargetType"] == ABILITY_AI_TARGET_TYPE_PREFER_CLOSEST_HERO) then
        for _, desiredTarget in ipairs(filteredTargets) do
            if(desiredTarget:IsRealHero() == true and self:CheckAbilityConditions(ability, abilityData, filteredTargets, desiredTarget) == true) then
                return desiredTarget
            end
        end
        -- hero not found, try found any valid target
        for _, desiredTarget in ipairs(filteredTargets) do
            if(self:CheckAbilityConditions(ability, abilityData, filteredTargets, desiredTarget) == true) then
                return desiredTarget
            end
        end
        return nil
    end
    if(abilityData["TargetType"] == ABILITY_AI_TARGET_TYPE_CLOSEST_HERO) then
        for _, desiredTarget in ipairs(filteredTargets) do
            if(desiredTarget:IsRealHero() == true and self:CheckAbilityConditions(ability, abilityData, filteredTargets, desiredTarget) == true) then
                return desiredTarget
            end
        end
        return nil
    end
    return nil
end

function AIBehaviors:CheckAbilityConditions(ability, abilityData, allTargets, desiredTarget)
    local count = #allTargets
    local result = true
    if (desiredTarget and desiredTarget:IsMagicImmune() and not ability.pierceBKB) then
        return false
    end
    if(not abilityData["Conditions"]) then
        return result
    end
    if(abilityData["Conditions"]["TargetsAround"]) then
        result = result and (count >= abilityData["Conditions"]["TargetsAround"])
    end
    if(abilityData["Conditions"]["HeroesAround"]) then
        local heroesAround = 0
        for _, unit in pairs(allTargets) do
            if(unit:IsRealHero() == true) then
                heroesAround = heroesAround + 1
            end
        end
        result = result and (heroesAround >= abilityData["Conditions"]["HeroesAround"])
    end
    if(abilityData["Conditions"]["HasModifiers"]) then
        if(desiredTarget) then
            for _, modifierName in pairs(abilityData["Conditions"]["HasModifiers"]) do
                result = result and (desiredTarget:HasModifier(modifierName) == true)
            end
        else
            for _, target in pairs(allTargets) do
                for _, modifierName in pairs(abilityData["Conditions"]["HasModifiers"]) do
                    result = result and (target:HasModifier(modifierName) == true)
                end
            end
        end
    end
    if(abilityData["Conditions"]["DontHaveModifiers"]) then
        if(desiredTarget) then
            for _, modifierName in pairs(abilityData["Conditions"]["DontHaveModifiers"]) do
                result = result and (desiredTarget:HasModifier(modifierName) == false)
            end
        else
            for _, target in pairs(allTargets) do
                for _, modifierName in pairs(abilityData["Conditions"]["DontHaveModifiers"]) do
                    result = result and (target:HasModifier(modifierName) == false)
                end
            end
        end
    end
    if(abilityData["Conditions"]["HealthPercentEqualOrBelow"]) then
        if(desiredTarget) then
            result = result and (desiredTarget:GetHealthPercent() <= abilityData["Conditions"]["HealthPercentEqualOrBelow"])
        else
            for _, target in pairs(allTargets) do
                result = result and (target:GetHealthPercent() <= abilityData["Conditions"]["HealthPercentEqualOrBelow"])
            end        
        end
    end
    if(abilityData["Conditions"]["HealthPercentEqualOrGreater"]) then
        if(desiredTarget) then
            result = result and (desiredTarget:GetHealthPercent() >= abilityData["Conditions"]["HealthPercentEqualOrGreater"])
        else
            for _, target in pairs(allTargets) do
                result = result and (target:GetHealthPercent() >= abilityData["Conditions"]["HealthPercentEqualOrGreater"])
            end        
        end
    end
    local caster = ability:GetCaster()
    if(abilityData["Conditions"]["CasterHealthPercentEqualOrBelow"]) then
        result = result and (caster:GetHealthPercent() <= abilityData["Conditions"]["CasterHealthPercentEqualOrBelow"])
    end
    if(abilityData["Conditions"]["CasterHealthPercentEqualOrGreater"]) then
        result = result and (caster:GetHealthPercent() >= abilityData["Conditions"]["CasterHealthPercentEqualOrGreater"])
    end
    if(abilityData["Conditions"]["CasterHasModifiers"]) then
        for _, modifierName in pairs(abilityData["Conditions"]["CasterHasModifiers"]) do
            result = result and (caster:HasModifier(modifierName) == true)
        end
    end
    if(abilityData["Conditions"]["CasterDontHasModifiers"]) then
        for _, modifierName in pairs(abilityData["Conditions"]["CasterDontHasModifiers"]) do
            result = result and (caster:HasModifier(modifierName) == false)
        end
    end
    return result
end

if(not _G.AIBehaviorsInit and IsServer()) then
    AIBehaviors:Init()
    _G.AIBehaviorsInit = true
end

_G.AIBehaviors = AIBehaviors