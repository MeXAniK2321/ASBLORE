---------------------------------------------------------------------------------------
-- CUSTOM FUNCTIONS PLACED HERE IDK WHY
---------------------------------------------------------------------------------------

--// Function for checking if an ability is a certain required level to learn
--// Loads Key Values file and takes Ability Name,Number to compare with the key values
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
local kvAbility = LoadKeyValues("scripts/npc/npc_abilities_custom.txt") --LOAD THIS FILE ONLY ONCE
local kvHeroes  = LoadKeyValues("scripts/npc/npc_heroes_custom.txt") --LOAD THIS FILE ONLY ONCE
LoreIsAbilityRequiredLevel = function(hAbility, iLevel)
    if hAbility and iLevel then
        local kvAbilityInfo = kvAbility[hAbility]

        if kvAbilityInfo and kvAbilityInfo["RequiredLevel"] then
            local iReqLevel = tonumber(kvAbilityInfo["RequiredLevel"])
            if iReqLevel == iLevel then print("Ability: " .. hAbility .. " Level Required: " .. 
			                iReqLevel .. " Level Compare: " .. iLevel .. " Result:TRUE ") return true end
        end
    end
    return false
end

--// Overwrite GetIntellect(*bool*) function in cases where first parameter is not set.
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
local VALVE_GetIntellect = CDOTA_BaseNPC_Hero.GetIntellect
CDOTA_BaseNPC_Hero.GetIntellect = function(self, bskipNoConsume)
    bskipNoConsume = bskipNoConsume or false
    
    return VALVE_GetIntellect(self, bskipNoConsume)
end
--// Remove wearables for heroes
---------------------------------------------------------------------------------------
function GLOBAL_RemoveWearables(hUnit)
    if not hUnit or hUnit:IsNull() then
        return
    end
    for _, hChild in ipairs(hUnit:GetChildren()) do
        if hChild:GetClassname() == "dota_item_wearable" then
			hChild:AddEffects(EF_NODRAW)
			UTIL_Remove(hChild)
			--print("REMOVED???")
        end
    end
end