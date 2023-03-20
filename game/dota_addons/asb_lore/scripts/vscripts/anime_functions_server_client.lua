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
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CreateHeroBotForTeam = function( sHeroClass, vSpawnPosition, bFindClearSpace, iTeamNumber, hOptionalOwner )
        local GetFreeFakeID = function()
            for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
                if PlayerResource:IsValidPlayerID(i) 
                    and PlayerResource:IsFakeClient(i) 
                    and not PlayerResource:HasSelectedHero(i) then
                    return i
                end
            end
            return -1
        end
        local GetRandomIDInTeam = function(iTeamNumber)
            local hPlayersTeam = ATP_GetPlayersInTeam(iTeamNumber, true, true)
            return TablePick(hPlayersTeam, hPlayersTeam, false)
        end
        local GetRealPlayerIDInTeam = function(iTeamNumber)
            local hPlayersTeam = ATP_GetPlayersInTeam(iTeamNumber, true, true)
            for i, iPlayerID in pairs(hPlayersTeam) do
                if PlayerResource:IsValidPlayerID(iPlayerID) 
                    and not PlayerResource:IsFakeClient(iPlayerID) then
                    return iPlayerID
                end
            end
        end
        local iMaxTeamPlayers = GameRules:GetCustomGameTeamMaxPlayers(iTeamNumber)
        --print(iMaxTeamPlayers)
        local bTeamAlreadyFull = ( PlayerResource:GetPlayerCountForTeam(iTeamNumber) >= GameRules:GetCustomGameTeamMaxPlayers( iTeamNumber ) )
        if not bTeamAlreadyFull then
            local iUsedIDPlayerForSwap  = 0--GetRealPlayerIDInTeam(DOTA_TEAM_FIRST) --GetRandomIDInTeam( DOTA_TEAM_FIRST )
            local iUsedTeamNumberPlayer = PlayerResource:GetTeam(iUsedIDPlayerForSwap)

            PlayerResource:SetCustomTeamAssignment(iUsedIDPlayerForSwap, DOTA_TEAM_NOTEAM)

            local bTutorialBot = Tutorial:AddBot("", "", "", true)
            if bTutorialBot then
                local iFreeBotID = GetFreeFakeID()

                PlayerResource:SetCustomTeamAssignment(iFreeBotID, iTeamNumber )
                PlayerResource:SetCustomTeamAssignment(iUsedIDPlayerForSwap, iUsedTeamNumberPlayer)

                local hBotPlayer = PlayerResource:GetPlayer(iFreeBotID)
                if IsNotNull(hBotPlayer) then
                    local hCreatedBot = CreateUnitByName(sHeroClass, vSpawnPosition, bFindClearSpace, hOptionalOwner or hBotPlayer, hOptionalOwner or hBotPlayer, iTeamNumber)
                    if IsNotNull(hCreatedBot) then
                        hBotPlayer:SetAssignedHeroEntity(hCreatedBot)
                        if IsNotNull(hOptionalOwner) then
                            iFreeBotID = hOptionalOwner:GetMainControllingPlayer()
                            hCreatedBot:SetControllableByPlayer(iFreeBotID, true)
                        end
                        return hCreatedBot
                    end
                end
            end
        end
        print("CAN'T CREATE BOT FOR TEAM: Num: "..iTeamNumber.." TEAM ALREADY HAS MAX PLAYERS")
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    IsInMarbleSphere = function(hObjects, fRadius)
        local hEntities = Entities:FindAllByClassname("npc_dota_thinker")
        for _, hEntity in pairs(hEntities) do
            if IsNotNull(hEntity) then
                local hModifiers = hEntity:FindAllModifiers()
                for i, hModifier in pairs(hModifiers) do
                    if IsNotNull(hModifier) and hModifier:IsMarble() then
                        local hAbility = hModifier:GetAbility()
                        local vEntity  = hEntity:GetAbsOrigin()
                        fRadius = fRadius or ( IsNotNull(hAbility) and hAbility:GetAOERadius() or 0 )
                        for k, hObject in pairs(hObjects) do
                            if IsNotNull(hObject)
                                and GetDistance(hObject, vEntity) > fRadius then
                                return false
                            end
                        end
                    end
                end
            end
        end
        return true
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
   --[[IsInMarbleSphere = function(hObjects, fRadius) TODO: LATER NEED REBUILD WITH ENTITIES FINDER????
        local hEntities = Entities:FindAllByClassname("npc_dota_thinker")
        for _, hEntity in pairs(hEntities) do
            if IsNotNull(hEntity) then
                local hModifiers = hEntity:FindAllModifiers()
                for i, hModifier in pairs(hModifiers) do
                    if IsNotNull(hModifier) and hModifier:IsMarble() then
                        local hAbility = hModifier:GetAbility()
                        local vEntity  = hEntity:GetAbsOrigin()
                        fRadius = fRadius or ( IsNotNull(hAbility) and hAbility:GetAOERadius() or 0 )
                        for k, hObject in pairs(hObjects) do
                            if GetDistance(hObject, vEntity) > fRadius then
                                return false
                            end
                        end
                    end
                end
            end
        end
        return true
    end]]
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CreateAbility = function(sAbilityName, hAbilityOwner, hItemPurchaser, iLevelBeforeIntrinsic) --BETTER NOT USE CREATEITEM AND USE MY CODE BUT... IDK BASICALY WHAT BETTER THEN
        --IF CREATE ITEM AND LVLUP it by upradeability (except setlvl) before caster setuped then will be carsh as for createitemfunction (FIXED IN ADDABILITY)
        hItemPurchaser = hItemPurchaser or hAbilityOwner

        local hCreateOwner = CreateUnitByName("npc_dota_base", Vector(0, 0, 0), false, nil, nil, DOTA_TEAM_NOTEAM)
                             or CreateUnitByName("npc_dota_base_additive", Vector(0, 0, 0), false, nil, nil, DOTA_TEAM_NOTEAM)
                             or hAbilityOwner

        local bCreateEQAbility = hCreateOwner == hAbilityOwner --???? i forget for what is that

        if IsNotNull(hCreateOwner) then
            --!!=====================================================================================================================
            local iMaxIndex     = hCreateOwner:GetAbilityCount() - 1
            local hSwapAbility1 = hCreateOwner:GetAbilityByIndex(iMaxIndex)
            if IsNotNull(hSwapAbility1) then
                hCreateOwner:RemoveAbilityFromIndexByName(hSwapAbility1:GetAbilityName()) --WAS REQUIRED AND STILL NEED IF SOMEHOW MAIN PARENT WILL BE CREATING OWNER
            end
            --!!=====================================================================================================================
            local hSwapAbility2 = hCreateOwner:AddAbility(sAbilityName, nil, iLevelBeforeIntrinsic) --INSTRICT REMOVING REPLACED IN ADD ABILITY INSTEAD
            if IsNotNull(hSwapAbility2) then
                hCreateOwner:RemoveAbilityFromIndexByName(sAbilityName)
                hSwapAbility2:SetParent(hAbilityOwner, nil)
                hSwapAbility2:SetOwner(hAbilityOwner)
                --hAbility:FollowEntity(hHeroPicked, false)
                --hAbility:SetTeam(hHeroPicked:GetTeamNumber())
                hSwapAbility2:SetAbilityIndex(-1)
                --!!=====================================================================================================================
                if type(hSwapAbility2.SetPurchaser) == "function" then
                    hSwapAbility2:SetPurchaser(hItemPurchaser) --IF WILL BE NIL WILL BE CRASH? HMM (when use) - nope, crash will not be
                    hSwapAbility2:SetCanBeUsedOutOfInventory(true)
                    hSwapAbility2:SetItemState(1)
                end
                --!!=====================================================================================================================
                if IsNotNull(hSwapAbility1) then
                    hCreateOwner:SetAbilityByIndex(hSwapAbility1, iMaxIndex)
                end
                --!!=====================================================================================================================
                if not bCreateEQAbility then
                    UTIL_Remove(hCreateOwner)
                end
                --!!=====================================================================================================================
                return hSwapAbility2
            end
        else
            local sBonusInfo =  bCreateEQAbility 
                                and "Can't create npc dota base or additive so using owner instead. raising this error code stopped" .. tostring(bCreateEQAbility)
                                or ""
            return error("CAN'T CREATE ENTITY OR hParent is NULL or NIL, CreateAbility Function   ||   "..sBonusInfo)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --MY FUNCTION FOR SEND MSGS TO CLIENTS, BECAUSE Say(nil, 0, true) crashes...
    SendAnimeMessage = function(iPlayerID, iTeamNumber, bAll, sMessage, sColor, sTextSize, sHeroName, fDuration) --USING NOTIFICATIONS BOTTOM FOR NOW
        local hNotificationTable0 = {   
                                        text       = not sHeroName and "[ANIME] - " or nil,
                                        style   =   {
                                                        color         = "green",
                                                        ["font-size"] = "22px",
                                                        --border        = "2px solid green"
                                                    },
                                        hero       = sHeroName,
                                        imagestyle = 'icon',
                                        duration   = fDuration or 10,
                                    }
        local hNotificationTable1 = {   
                                        text    = sMessage,
                                        style   =   {
                                                        color         = sColor,
                                                        ["font-size"] = sTextSize or "18px",
                                                        --border        = "2px solid green"
                                                    },
                                        continue = true
                                    }
        if bAll then
            Notifications:BottomToAll(hNotificationTable0)
            hNotificationTable1.text = "<font color='#58ACFA'> [TO ALL] : </font>" .. hNotificationTable1.text
            return Notifications:BottomToAll(hNotificationTable1)
        elseif type(iTeamNumber) == "number" then
            Notifications:BottomToTeam(iTeamNumber, hNotificationTable0)
            hNotificationTable1.text = "<font color='#58ACFA'> [TO TEAM] : </font>" .. hNotificationTable1.text
            return Notifications:BottomToTeam(iTeamNumber, hNotificationTable1)
        elseif type(iPlayerID) == "number" then
            Notifications:Bottom(iPlayerID, hNotificationTable0)
            hNotificationTable1.text = "<font color='#58ACFA'> [TO YOU] : </font>" .. hNotificationTable1.text
            return Notifications:Bottom(iPlayerID, hNotificationTable1)
        end
        return error("Can't send custom msg by notifications, because wrong inputs")
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    GetPlayersAssistedKillHero = function(hHero) --NOTE: Record for some time and nullify num attackers after that.
        local hPlayersAssisted = {}
        if IsNotNull(hHero) then
            local iAssistersCount = hHero:GetNumAttackers() - 1
            for i = 0, iAssistersCount do
                local iAssisterID = hHero:GetAttacker(i)
                if PlayerResource:IsValidPlayerID(iAssisterID) then
                    table.insert(hPlayersAssisted, iAssisterID)
                end
            end
        end
        return hPlayersAssisted
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --NOTE: WORK WITH RegisterCustomEventListener("anime_votes_receiver", function(hData), in addon_game_mode inition...
    ANIME_VOTES_GetForAll = function(sVoteName)
        local iResultCount = 0
        local iNeedResult  = 0.50
        for iPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
            local iPlayerResult = ANIME_VOTES_GetForPlayer(iPlayerID, sVoteName)
            if type(iPlayerResult) == "number"
                and iPlayerResult > 0 then
                iResultCount = iResultCount + 1
            end
        end
        return iResultCount >= ( TableLength(ATP_GetAllPlayers(true, false)) * iNeedResult )
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ANIME_VOTES_GetForPlayer = function(iPlayerID, sVoteName)
        local siPlayerID  = tostring(iPlayerID)
        local hPlayerData = CustomNetTables:GetTableValue("anime_players_data", siPlayerID) or {}
              hPlayerData.hAnimeVotes = hPlayerData.hAnimeVotes or {}

        local iResult = hPlayerData.hAnimeVotes[sVoteName] or 0

        return type(sVoteName) == "string"
                and iResult
                or hPlayerData.hAnimeVotes
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ANIME_VOTES_SetForPlayer = function(iPlayerID, hVotesTable)
        local siPlayerID  = tostring(iPlayerID)
        local hPlayerData = CustomNetTables:GetTableValue("anime_players_data", siPlayerID) or {}
              hPlayerData.hAnimeVotes = hPlayerData.hAnimeVotes or {}

        for sVoteName, iVoteResult in pairs(hVotesTable) do
            hPlayerData.hAnimeVotes[tostring(sVoteName)] = tonumber(iVoteResult)
        end

        CustomNetTables:SetTableValue("anime_players_data", siPlayerID, hPlayerData)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ANIME_EVENT_TIMERS_CreateOrUpdate = function(sHeaderText, fDuration, sUniqueName)
        local hData =
        {
            timer_header_text = sHeaderText,
            timer_duration    = fDuration,
            timer_unique_name = sUniqueName or DoUniqueString(tostring(fDuration))
        }

        Timers:CreateTimer(0.1, function()
            return CustomGameEventManager:Send_ServerToAllClients("anime_event_timers", hData) --NOTE: Using timers for create in PreGame moment...
        end)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ANIME_SETTINGS_GetForPlayer = function(iPlayerID, sSettingName)
        local siPlayerID  = tostring(iPlayerID)
        local hPlayerData = CustomNetTables:GetTableValue("anime_players_data", siPlayerID) or {}
              hPlayerData.hAnimeSettings = hPlayerData.hAnimeSettings or {}

        local iResult = hPlayerData.hAnimeSettings[sSettingName] or 0

        return type(sSettingName) == "string"
                and iResult
                or hPlayerData.hAnimeSettings
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    ANIME_SETTINGS_SetForPlayer = function(iPlayerID, hSettingsTable)
        local siPlayerID  = tostring(iPlayerID)
        local hPlayerData = CustomNetTables:GetTableValue("anime_players_data", siPlayerID) or {}
              hPlayerData.hAnimeSettings = hPlayerData.hAnimeSettings or {}

        for sSettingName, iSettingResult in pairs(hSettingsTable) do
            hPlayerData.hAnimeSettings[tostring(sSettingName)] = tonumber(iSettingResult)
        end

        CustomNetTables:SetTableValue("anime_players_data", siPlayerID, hPlayerData)
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
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!DOTA2 CUSTOM CLASS OVERRIDE/ADDITION FUNCTIONS!!----------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTABaseAbility = IsServer() and CDOTABaseAbility or C_DOTABaseAbility
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_Ability_Lua = IsServer() and CDOTA_Ability_Lua or C_DOTA_Ability_Lua
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_Item_Lua = IsServer() and CDOTA_Item_Lua or C_DOTA_Item_Lua
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTABaseAbility_GetBehavior = CDOTABaseAbility.GetBehavior
CDOTABaseAbility.GetBehavior = function(self) --Predict uint64?
    return tonumber(tostring(VALVE_CDOTABaseAbility_GetBehavior(self)))
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTA_Ability_Lua_GetBehavior = CDOTA_Ability_Lua.GetBehavior
CDOTA_Ability_Lua.GetBehavior = function(self) --Predict uint64?
    return tonumber(tostring(VALVE_CDOTA_Ability_Lua_GetBehavior(self)))
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTA_Item_Lua_GetBehavior = CDOTA_Item_Lua.GetBehavior
CDOTA_Item_Lua.GetBehavior = function(self) --Predict uint64?
    return tonumber(tostring(VALVE_CDOTA_Item_Lua_GetBehavior(self)))
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.HasStaticCooldown = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetStaticCooldownModification = function(self, iLevel)
    return 0
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.IsLearned = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.IsUltimate = function(self)
    return IsNotNull(self) and GetAbilityKeyValuesByName(self:GetAbilityName())["AbilityType"] == "DOTA_ABILITY_TYPE_ULTIMATE"
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_IsActivated = CDOTABaseAbility.IsActivated
CDOTABaseAbility.IsActivated = function(self)
    if IsServer() then
        local bIsActivated = VALVE_IsActivated(self)
        if self.___IsActivated ~= bIsActivated then
            self:SetActivated(bIsActivated)
        end
    end
    return self.___IsActivated or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_IsFullyCastable = CDOTABaseAbility.IsFullyCastable
CDOTABaseAbility.IsFullyCastable = function(self)
    if IsServer() then
        local bIsFullyCastable = VALVE_IsFullyCastable(self)
        if self.___IsFullyCastable ~= bIsFullyCastable then
            self:SetFullyCastable(bIsFullyCastable)
        end
    end
    return self.___IsFullyCastable or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_IsHidden = CDOTABaseAbility.IsHidden
CDOTABaseAbility.IsHidden = function(self)
    if IsServer() then
        local bIsHidden = VALVE_IsHidden(self)
        if self.___IsHidden ~= bIsHidden then
            self:SetHidden(bIsHidden)
        end
    end
    return self.___IsHidden or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.IsFrozenCooldown = function(self)
    return self.___IsFrozenCooldown or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------








--[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]
--CHARGES NEW --ATTACHED WITH modifier_anime_mechanic_ability_charges_new --TODO: NOT FINISHED, STILL THINKING
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.HasAnimeCharges = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.IsActiveAC = function(self) --NOTE: Maybe cause bugs with refreshing... and make charges usable while not active...
    return self:HasAnimeCharges()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.IsHiddenAC = function(self)
    return self:IsHidden() or not self:HasAnimeCharges()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetInitialAC = function(self)
    return 1
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetMaxAC = function(self)
    return self:GetInitialAC()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetCooldownAC = function(self)
    return self:GetEffectiveCooldown(-1)--self:GetCooldown(-1) * self:GetCaster():GetCooldownReduction()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetCurrentAC = function(self)
    return self.___GetCurrentAC or 0
end
--[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]


--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--[[local VALVE_GetMaxLevel = CDOTABaseAbility.GetMaxLevel --NOT CHANGING ANYTHING FOR DOTO, NEED CHANGE IN KV... FUCK
CDOTABaseAbility.GetMaxLevel = function(self)
    return 5
end]]



--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetAOERadius = function(self) --Predict Crash???
    return 0
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Ability_Lua.GetAOERadius = function(self) --Predict Crash???
    return 0
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Item_Lua.GetAOERadius = function(self) --Predict Crash???
    return 0
end


--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTABaseAbility.GetCastRangeBonus = function(self, ...) --Crashes normal addons, because gaben released new patch with error in 24.02.2022 pizdec, only for LUA ABILITY, For items i think all fne.... cringe
    return self:GetCaster():GetCastRangeBonus()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTA_Ability_Lua_GetCastRangeBonus = CDOTA_Ability_Lua.GetCastRangeBonus
CDOTA_Ability_Lua.GetCastRangeBonus = function(self, ...) --hTarget, iPseudoCastRange --I DID IT FOR ALL BECASUE NOT WANNA RECIEVE ERRORS IN FUTURE
    return VALVE_CDOTA_Ability_Lua_GetCastRangeBonus(self, ...)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Item_Lua.GetCastRangeBonus = function(self, ...) --THEY ARE FIXED 2:00 25.22.2022 BUT I ADDDED FOR FUTURE (hTarget, iPseudoCastRange)
    return self:GetCaster():GetCastRangeBonus()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------






--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
--TEST CODE FOR NEW MAP
local sMapName = GetMapName()
if ( IsServer() and sMapName == "anime_3x4_lore" )
    or ( IsClient() and sMapName == "maps/anime_3x4_lore.vpk" ) then
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local GetAnimeKVLoreCooldownValueFor = function(hAbility, iLevel)
        --hAbility:IsTrained()
        if IsNotNull(hAbility) then
            local hAbilityTable = hAnimeKVLore[hAbility:GetAbilityName()]
            if IsNotNull(hAbilityTable) then
                local hAbilitySpecial = hAbilityTable["AbilityCooldown"]
                if IsNotNull(hAbilitySpecial) then
                    hAbilitySpecial = string.split(hAbilitySpecial, " ")
                    local iLength = TableLength(hAbilitySpecial)
                    local liLevel = hAbility:GetLevel()
                    if iLength > 0
                        and liLevel > 0 then
                        iLevel = iLevel < 0 
                                    and liLevel
                                    or iLevel + 1
                        iLevel = iLength >= iLevel
                                    and iLevel
                                    or iLength
                        return tonumber(hAbilitySpecial[iLevel])
                    end
                end
            end
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    _G.hAnimeKVLore = _G.hAnimeKVLore or LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTABaseAbility_GetCooldown_KV_Lore = CDOTABaseAbility.GetCooldown
    CDOTABaseAbility.GetCooldown = function(self, iLevel)
        local fCooldown = GetAnimeKVLoreCooldownValueFor(self, iLevel)
        if type(fCooldown) == "number" then
            return fCooldown
        end
        return VALVE_CDOTABaseAbility_GetCooldown_KV_Lore(self, iLevel)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTA_Ability_Lua_GetCooldown_KV_Lore = CDOTA_Ability_Lua.GetCooldown
    CDOTA_Ability_Lua.GetCooldown = function(self, iLevel)
        local fCooldown = GetAnimeKVLoreCooldownValueFor(self, iLevel)
        if type(fCooldown) == "number" then
            return fCooldown
        end
        return VALVE_CDOTA_Ability_Lua_GetCooldown_KV_Lore(self, iLevel)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTA_Item_Lua_GetCooldown_KV_Lore = CDOTA_Item_Lua.GetCooldown
    CDOTA_Item_Lua.GetCooldown = function(self, iLevel)
        local fCooldown = GetAnimeKVLoreCooldownValueFor(self, iLevel)
        if type(fCooldown) == "number" then
            return fCooldown
        end
        return VALVE_CDOTA_Item_Lua_GetCooldown_KV_Lore(self, iLevel)
    end
end
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]

--CODE ABOVE SHOULD BE BEFORE BECAUSE INITIALIZATION IS UP TO DOWN

--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTABaseAbility_GetCooldown = CDOTABaseAbility.GetCooldown --CAN'T BE CALLED IN :SPAWN()
CDOTABaseAbility.GetCooldown = function(self, iLevel)
    local hCaster   = self:GetCaster()
    local fCooldown = VALVE_CDOTABaseAbility_GetCooldown(self, iLevel)
    if IsNotNull(hCaster)
        and self:HasStaticCooldown() then
        fCooldown = fCooldown + self:GetStaticCooldownModification(iLevel)
        local fCDR = hCaster:GetCooldownReduction()
              fCDR = fCDR ~= 0
                     and fCDR
                     or 1
        return fCooldown / fCDR
    end
    return fCooldown
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTA_Ability_Lua_GetCooldown = CDOTA_Ability_Lua.GetCooldown
CDOTA_Ability_Lua.GetCooldown = function(self, iLevel)
    local hCaster   = self:GetCaster()
    local fCooldown = VALVE_CDOTA_Ability_Lua_GetCooldown(self, iLevel)
    if IsNotNull(hCaster)
        and self:HasStaticCooldown() then
        fCooldown = fCooldown + self:GetStaticCooldownModification(iLevel)
        local fCDR = hCaster:GetCooldownReduction()
              fCDR = fCDR ~= 0
                     and fCDR
                     or 1
        return fCooldown / fCDR
    end
    return fCooldown
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_CDOTA_Item_Lua_GetCooldown = CDOTA_Item_Lua.GetCooldown --OVERRIDES WITH IEACH SCRIPT_RELOAD
CDOTA_Item_Lua.GetCooldown = function(self, iLevel)
    local hCaster   = self:GetCaster()
    local fCooldown = VALVE_CDOTA_Item_Lua_GetCooldown(self, iLevel)
    if IsNotNull(hCaster)
        and self:HasStaticCooldown() then
        fCooldown = fCooldown + self:GetStaticCooldownModification(iLevel)
        local fCDR = hCaster:GetCooldownReduction()
              fCDR = fCDR ~= 0
                     and fCDR
                     or 1
        return fCooldown / fCDR
    end
    return fCooldown
end
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_BaseNPC.IsJoJoStandUser = function(self)
    if IsServer() and self.___IsJoJoStandUser == nil then
        self:SetJoJoStandUser(self.___IsJoJoStandUser)
    end
    return self.___IsJoJoStandUser or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_BaseNPC.IsJoJoStand = function(self)
    if IsServer() and self.___IsJoJoStand == nil then
        self:SetJoJoStand(self.___IsJoJoStand)
    end
    return self.___IsJoJoStand or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_BaseNPC_IsChanneling = CDOTA_BaseNPC.IsChanneling
CDOTA_BaseNPC.IsChanneling = function(self)
    if IsServer() then
        local bIsChanneling = VALVE_BaseNPC_IsChanneling(self)
        if self.___IsChanneling ~= bIsChanneling then
            self:SetChanneling(bIsChanneling)
        end
    end
    return self.___IsChanneling or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_BaseNPC.IsFemale = function(self)
    if IsServer() and self.___IsFemale == nil then
        self:SetFemale(self.___IsFemale)
    end
    return self.___IsFemale or false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_GetStatusResistance = CDOTA_BaseNPC.GetStatusResistance
CDOTA_BaseNPC.GetStatusResistance = function(self)
    if IsServer() then
        local fStatusResistance = VALVE_GetStatusResistance(self)
              fStatusResistance = fStatusResistance > 1 and 0.99 or fStatusResistance
        if self.___GetStatusResistance ~= fStatusResistance then
            self:SetStatusResistance(fStatusResistance)
        end
    end
    return self.___GetStatusResistance or 0
end
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
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_BaseNPC.HasShard = function(self)
    return self:HasModifier("modifier_item_aghanims_shard")
end





















--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_BaseNPC_Hero = IsServer() and CDOTA_BaseNPC_Hero or C_DOTA_BaseNPC_Hero
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_GetPrimaryAttribute = CDOTA_BaseNPC_Hero.GetPrimaryAttribute
CDOTA_BaseNPC_Hero.GetPrimaryAttribute = function(self)
    if IsServer() then
        local iGetPrimaryAttribute = VALVE_GetPrimaryAttribute(self)
        if self.___GetPrimaryAttribute ~= iGetPrimaryAttribute then
            self:SetPrimaryAttribute(iGetPrimaryAttribute)
        end
    end
    return self.___GetPrimaryAttribute or DOTA_ATTRIBUTE_INVALID
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_GetPrimaryStatValue = CDOTA_BaseNPC_Hero.GetPrimaryStatValue
CDOTA_BaseNPC_Hero.GetPrimaryStatValue = function(self)
    if IsServer() then
        local iGetPrimaryStatValue = VALVE_GetPrimaryStatValue(self)
        if self.___GetPrimaryStatValue ~= iGetPrimaryStatValue then
            self:SetPrimaryStatValue(iGetPrimaryStatValue)
        end
    end
    return self.___GetPrimaryStatValue or 0
end







--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_Buff = IsServer() and CDOTA_Buff or CDOTA_Buff
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Buff.IsForm = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Buff.IsFormPurgable = function(self)
    return self:IsForm()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Buff.IsMarble = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Buff.IsMarbleException = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
CDOTA_Buff.IsCharges = function(self)
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
local VALVE_StartIntervalThink = CDOTA_Buff.StartIntervalThink
CDOTA_Buff.StartIntervalThink = function(self, flInterval, bIsStatusResistable)
    if flInterval > 0 and bIsStatusResistable then
        self.___flInterval = self.___flInterval or flInterval

        local hParent       = self:GetParent()
        local flGetDuration = self:GetDuration()

        if IsNotNull(hParent) and self.___flGetDuration ~= flGetDuration then
            self.___flGetDuration = flGetDuration
            
            flInterval = flInterval * ( 1 - hParent:GetStatusResistance() )

            if self.___flInterval ~= flInterval then
                self.___flInterval = flInterval
            end
        end

        flInterval = self.___flInterval
    end
    return VALVE_StartIntervalThink(self, flInterval)
end

--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]
CDOTA_Modifier_Lua = IsServer() and CDOTA_Modifier_Lua or CDOTA_Modifier_Lua
--[:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::]

--[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]
if IsServer() then


    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_GetOwner = CBaseEntity.GetOwner
    CBaseEntity.GetOwner = function(self, bOriginal)
        if IsNotNull(self) then --REQUIRE FOR PREVENT IS NULL SAD CAUSE I SHOULD CHECK IT NORMALLY BUT NOT 2 TIMES EACH TIME...
            local hOldOwner = VALVE_GetOwner(self)
            if not bOriginal
                and IsNotNull(hOldOwner)
                and hOldOwner:IsPlayerController() then
                --and hOldOwner:GetClassname() == "player" then
                hOldOwner = hOldOwner:GetAssignedHero()
            end
            return hOldOwner
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_GetOwnerEntity = CBaseEntity.GetOwnerEntity
    CBaseEntity.GetOwnerEntity = function(self, bOriginal)
        if IsNotNull(self) then --REQUIRE FOR PREVENT IS NULL SAD CAUSE I SHOULD CHECK IT NORMALLY BUT NOT 2 TIMES EACH TIME...
            local hOldOwnerEntity = VALVE_GetOwnerEntity(self)
            if not bOriginal
                and IsNotNull(hOldOwnerEntity)
                and hOldOwnerEntity:IsPlayerController() then --NEW FROM 25.03.2022 SUMMER CLEANING BECAUSE PLAYERS IS GONE, now is dota_player_controller
                --and hOldOwnerEntity:GetClassname() == "player" then
                hOldOwnerEntity = hOldOwnerEntity:GetAssignedHero()
            end
            return hOldOwnerEntity
        end
    end















    --CRASHTEST THINGS
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_SetForwardVector = CBaseEntity.SetForwardVector
    CBaseEntity.SetForwardVector = function(self, vVector, bUseAngles) --NEW FEATURE 
        if bUseAngles then
            vVector = VectorToAngles(vVector)
            return self:SetAbsAngles(vVector[1], vVector[2], vVector[3])
        end
        return VALVE_SetForwardVector(self, vVector)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_HorizontalApplyHorizontalMotionController = CDOTA_Modifier_Lua_Horizontal_Motion.ApplyHorizontalMotionController
    CDOTA_Modifier_Lua_Horizontal_Motion.ApplyHorizontalMotionController = function(self)
        local hParent           = self:GetParent()
        local bMotionControlled = hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()
        if not hParent:IsAlive() then
            return error("CHASHTEST VALVE_HorizontalApplyHorizontalMotionController() Entity is DEAD    Motion WAS: "..tostring(bMotionControlled).."Motion Become: "..tostring(hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()), 10)
        end
        return VALVE_HorizontalApplyHorizontalMotionController(self)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_VerticalApplyVerticalMotionController = CDOTA_Modifier_Lua_Vertical_Motion.ApplyVerticalMotionController
    CDOTA_Modifier_Lua_Vertical_Motion.ApplyVerticalMotionController = function(self)
        local hParent           = self:GetParent()
        local bMotionControlled = hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()
        if not hParent:IsAlive() then
            return error("CHASHTEST VALVE_VerticalApplyVerticalMotionController() Entity is DEAD    Motion WAS: "..tostring(bMotionControlled).."Motion Become: "..tostring(hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()), 10)
        end
        return VALVE_VerticalApplyVerticalMotionController(self)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_BothHorizontalApplyVerticalMotionController = CDOTA_Modifier_Lua_Motion_Both.ApplyHorizontalMotionController
    CDOTA_Modifier_Lua_Motion_Both.ApplyHorizontalMotionController = function(self)
        local hParent           = self:GetParent()
        local bMotionControlled = hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()
        if not hParent:IsAlive() then
            return error("CHASHTEST VALVE_BothHorizontalApplyVerticalMotionController() Entity is DEAD    Motion WAS: "..tostring(bMotionControlled).."Motion Become: "..tostring(hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()), 10)
        end
        return VALVE_BothHorizontalApplyVerticalMotionController(self)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_BothVerticalApplyVerticalMotionController = CDOTA_Modifier_Lua_Motion_Both.ApplyVerticalMotionController
    CDOTA_Modifier_Lua_Motion_Both.ApplyVerticalMotionController = function(self)
        local hParent           = self:GetParent()
        local bMotionControlled = hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()
        if not hParent:IsAlive() then
            return error("CHASHTEST VALVE_BothVerticalApplyVerticalMotionController() Entity is DEAD    Motion WAS: "..tostring(bMotionControlled).."Motion Become: "..tostring(hParent:IsCurrentlyHorizontalMotionControlled() or hParent:IsCurrentlyVerticalMotionControlled()), 10)
        end
        return VALVE_BothVerticalApplyVerticalMotionController(self)
    end







    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_AddAbility = CDOTA_BaseNPC.AddAbility
    CDOTA_BaseNPC.AddAbility = function(self, shAbility, iAbilityIndex, iLevelBeforeIntrinsic)
        if IsNotNull(self) then
            if type(shAbility) == "string" then
                shAbility = VALVE_AddAbility(self, shAbility)
                if not IsNotNull(shAbility) then
                    return error("Can't add more than 31 ABILITIES, BE CAREFULL OR ABILITY NOT EXIST BY NAME")
                end
                --!!=====================================================================================================================
                if type(iLevelBeforeIntrinsic) == "number"
                    and iLevelBeforeIntrinsic > 0 then --IF ADDING ITEM IT'S BASICALY 0 LEVEL, WHEN CREATEITEM HAPPENS WITH 1 LVL BY GABEN
                    for i = 1, iLevelBeforeIntrinsic do
                        shAbility:SetLevel(i) --JUST COPYING FEATURE AS LOTUS UPGRADING LIKE NORMAL UPGRADE EACH LVL
                    end
                end
                --!!=====================================================================================================================
                local sIntrinsicModifierName = shAbility:GetIntrinsicModifierName()
                if type(sIntrinsicModifierName) == "string" then
                    --NOW CAN REMOVE NOT CORRECT MODIIFER IF USE FOR ITEMS OR SAME ABILITIES -- NOW ITERATION FOR TRUE CHECK
                    local hModifiers = self:FindAllModifiersByName(sIntrinsicModifierName) --REMOVE FROM INDEX NOT REMOVES MODIFIERS
                    for _, hModifier in pairs(hModifiers) do
                        if IsNotNull(hModifier)
                            and hModifier:GetCaster() == self
                            and hModifier:GetAbility() == shAbility then
                            hModifier:Destroy()
                        end
                    end
                end
            else
                local iMaxCount = self:GetAbilityCount() - 1
                local iMaxIndex = iMaxCount
                if type(iAbilityIndex) == "number" then
                    iMaxIndex = iAbilityIndex
                else
                    for i = 0, iMaxIndex do
                        local hAB = self:GetAbilityByIndex(i)
                        if not IsNotNull(hAB) then
                            iMaxIndex = i
                            break
                        end
                    end
                end
                if iMaxIndex == iMaxCount then
                    return error("Can't add more than 31 ABILITIES, BE CAREFULL, ABILITY STILL IN CODE NOT DESTROYED")
                end

                shAbility:SetParent(self, nil)
                shAbility:SetOwner(self)

                if type(shAbility.SetPurchaser) == "function" then --ITEM SUPPORT FEATURE BECAUSE BASICALY MAKES PURCHASED MAIN CONTROLLING PLAYER ENTITY
                    shAbility:SetPurchaser(self)
                end

                self:SetAbilityByIndex(shAbility, iMaxIndex)
            end
            return shAbility
        end
    end


    --!!!IMPORTANT SOMEDAY ADD EVERYWHERE CHECK PREVENTIONS FOR CRASHES JUST BY ERROR RAISING!!!--- 19.09.2021 -fixing by new modifier - just check hogyoku


    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --[[local VALVE_TriggerSpellAbsorb = CDOTA_BaseNPC.TriggerSpellAbsorb
    CDOTA_BaseNPC.TriggerSpellAbsorb = function(self, hAbility)
        --if IsNotNull(self) then
            local bReturn = VALVE_TriggerSpellAbsorb(self, hAbility)
            print("TriggerSpellAbsorb BASECLASS", bReturn, self:GetUnitName(), hAbility:GetCaster():GetUnitName())
            return bReturn
        --end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_TriggerSpellReflect = CDOTA_BaseNPC.TriggerSpellReflect
    CDOTA_BaseNPC.TriggerSpellReflect = function(self, hAbility)
        --if IsNotNull(self) then
            local bReturn = VALVE_TriggerSpellReflect(self, hAbility)
            print("TriggerSpellReflect BASECLASS", bReturn, self:GetUnitName(), hAbility:GetCaster():GetUnitName())
            return bReturn
        --end
    end]]



    

    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --NOTE: Function which were made because gaben check IsDroppable and IsAlowBackPack when FUCKING CODE SWAPING... SOMEDAY WILL FIX... SOMEHOW, FOR NOW FORGET BECAUSE MADE PUCHASABLE AND MOVABLE ITEM BLINK, SO CRINGE...
    --[[local VALVE_SwapItems = CDOTA_BaseNPC.SwapItems
    CDOTA_BaseNPC.SwapItems = function(self, nSlot1, nSlot2, bIgnoreDroppAbility, bIgnoreBackpackAbility)
        local hItem1 = self:GetItemInSlot(nSlot1)
        local hItem2 = self:GetItemInSlot(nSlot2)

        local bDropState1 = IsNotNull(hItem1) and hItem1:IsDroppable()
        local bDropState2 = IsNotNull(hItem2) and hItem2:IsDroppable()

        ]]










    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --[[
        Example Usage
        
        hCaster:AnimePerformAttack( hTarget,                    --hTarget
                                    true,                       --bProcessProcs
                                    true,                       --bSkipCooldown
                                    true,                       --bBreakInvis
                                    hCaster:IsRangedAttacker,   --bUseProjectile
                                    false,                      --bFakeAttack
                                    true,                       --bNeverMiss
                                    {
                                        __sProjectileName = hCaster:GetRangedProjectileName(),
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
    ]]
    local VALVE_PerformAttack = CDOTA_BaseNPC.PerformAttack
    CDOTA_BaseNPC.AnimePerformAttack = function(self,
                                                hTarget, 
                                                bProcessProcs, 
                                                bSkipCooldown, 
                                                bBreakInvis, 
                                                bUseProjectile, 
                                                bFakeAttack,
                                                bNeverMiss,
                                                hTable)
        if IsNotNull(self) 
            and IsNotNull(hTarget) then

            if ( not IsInMarbleSphere({self}) and IsInMarbleSphere({hTarget}) ) or ( not IsInMarbleSphere({hTarget}) and IsInMarbleSphere({self}) ) then
                return nil
            end

            if type(hTable) == "table" then
                self:AddNewModifier(self, nil, "modifier_anime_mechanic_perform_attack",    {
                                                                                                __sProjectileName = hTable.__sProjectileName,
                                                                                                __fOverrideDamage = hTable.__fOverrideDamage,
                                                                                                __fPostCritDamage = hTable.__fPostCritDamage,
                                                                                                __fCritDamage     = hTable.__fCritDamage,
                                                                                                __sAttackSound    = hTable.__sAttackSound,
                                                                                                __fPhysicalDamage = hTable.__fPhysicalDamage,
                                                                                                __fMagicalDamage  = hTable.__fMagicalDamage,
                                                                                                __fPureDamage     = hTable.__fPureDamage,
                                                                                                __fFeedbackDamage = hTable.__fFeedbackDamage,

                                                                                                __bSupressCleave  = hTable.__bSupressCleave,
                                                                                                __bCleaveRange    = hTable.__bCleaveRange
                                                                                            })
            end

            return VALVE_PerformAttack(self, hTarget, bProcessProcs, bProcessProcs, bSkipCooldown, not bBreakInvis, bUseProjectile, bFakeAttack, bNeverMiss)
        end
    end













    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.UpgradeLearnedAbilities = function(self)
        if IsNotNull(self)
            and not self.___bUpgradeLearnedAbilities then
            local iAC = self:GetAbilityCount() - 1
            for i = 0, iAC do
                local hA = self:GetAbilityByIndex(i)
                if IsNotNull(hA)
                    and not hA:IsTrained() then
                    local iLearned = hA:IsLearned()
                    if iLearned then                    
                        local iAML = type(iLearned) == "number"
                                     and iLearned
                                     or hA:GetMaxLevel()
                        if hA:GetLevel() ~= iAML then --CHANGED FROM < TO ~= 19.09.2021
                            hA:SetLevel(iAML)
                        end
                    end
                end
            end
            self.___bUpgradeLearnedAbilities = true
            return self.___bUpgradeLearnedAbilities
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.ModifyAbilitiesByLevels = function(self, iLevels, fCallBackCheck)
        iLevels = tonumber(iLevels or 0)
        if IsNotNull(self) then
            --and iLevels ~= 0 then --BASICALY NEED BE CAREFULL WITH 0... IDK WHAT CAN BE IN FUTURE 
            local hGetOnUpgradeAbilitiesUpgraded = {}
            local iAbilitiesCount = self:GetAbilityCount() - 1
            for iIndex = 0, iAbilitiesCount do 
                local hAbility = self:GetAbilityByIndex(iIndex)
                if IsNotNull(hAbility)
                    and not hGetOnUpgradeAbilitiesUpgraded[hAbility:GetAbilityName()]
                    and ( type(fCallBackCheck) == "nil" or ( type(fCallBackCheck) == "function" and fCallBackCheck(hAbility) ) ) then
                    --!!===========================================================!!--
                    local iNewLevel = hAbility:GetLevel() + iLevels
                          iNewLevel = iNewLevel < 0
                                      and 0
                                      or iNewLevel
                    --!!===========================================================!!--
                    hAbility:SetLevel(iNewLevel)
                    --!!===========================================================!!--
                    local hUpgradeAbilities = hAbility:GetOnUpgradeAbilities()
                    for _, sAbilityNameUpgrade in pairs(hUpgradeAbilities) do
                        hGetOnUpgradeAbilitiesUpgraded[sAbilityNameUpgrade] = true
                    end
                    --!!===========================================================!!--
                    if iNewLevel <= 0 then
                        local sIntrinsicModifierName = hAbility:GetIntrinsicModifierName()
                        if type(sIntrinsicModifierName) == "string" then
                            local hModifiers = self:FindAllModifiersByName(sIntrinsicModifierName)
                            for _, hModifier in pairs(hModifiers) do
                                if IsNotNull(hModifier)
                                    and hModifier:GetCaster() == self
                                    and hModifier:GetAbility() == hAbility then
                                    hModifier:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end
        return iLevels > 0
    end



















    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_AddNewModifier = CDOTA_BaseNPC.AddNewModifier
    CDOTA_BaseNPC.AddNewModifier = function(self, hCaster, hAbility, pszScriptName, hModifierTable, bIsStatusResistable)
        if IsNotNull(self) then
            hModifierTable = hModifierTable or {}
            
            hModifierTable.duration = hModifierTable.duration or -1
            
            if hModifierTable.duration <= -1 then
                hModifierTable.duration = -1
            end --NEW PREDICTION -20.333 DOT NUMBERS AFTER MINUS NUMBER 23.03.2022
            --IN SOME SKILLS LIKE STAR PLATINUM BUFF It's receive -1 because add -0.03 --REFIXED TO IF -1 THEN -1 because i added new checker for pucci...
            --it's saves numbers like -0.03 -0.9999999 and autocompute then basicaly to 0 in valveaddnewmod
            local fStatusResistance = self:GetStatusResistance()
            if bIsStatusResistable
                and hModifierTable.duration > 0
                and fStatusResistance ~= 0 then
                hModifierTable.duration = hModifierTable.duration * ( 1 - fStatusResistance )
            end
            --print(hModifierTable.duration, "EKKEKE")
            return VALVE_AddNewModifier(self, hCaster, hAbility, pszScriptName, hModifierTable)
        end
    end










    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.SetJoJoStandUser = function(self, bStandUser)
        if IsNotNull(self) then
            local hStandUsersTable =    {
                                            ["npc_dota_hero_chen"] = true,
                                        }
            
            local bValueX = hStandUsersTable[self:GetUnitName()] or false
            bStandUser = bStandUser == nil and bValueX or bStandUser
            --print("DEBUG user", bStandUser, self:GetUnitName()) --REMOVE LATER --WTF IS ALWAYS NILLL
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsJoJoStandUser",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bStandUser,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.SetJoJoStand = function(self, bStand)
        if IsNotNull(self) then
            local hStandsTable =    {
                                        ["npc_anime_stand_gold_experience"] = true,
                                        ["npc_dota_hero_dragon_knight"]  = true,
                                        ["npc_dota_hero_beastmaster"]    = true,    
                                        ["npc_dota_hero_night_stalker"]  = true,   
                                        ["npc_dota_hero_bounty_hunter"]  = true,  
                                        ["npc_dota_hero_riki"]           = true,    
                                        ["npc_dota_hero_phantom_lancer"] = true,    
                                        ["npc_dota_hero_dark_seer"]      = true,
                                        ["npc_dota_hero_medusa"]         = true,    
                                    }
            
            local bValueX = hStandsTable[self:GetUnitName()] or false
            bStand = bStand == nil and bValueX or bStand
            --print("DEBUG STAND", bStand, self:GetUnitName()) --REMOVE LATER --WTF IS ALWAYS NILLL
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsJoJoStand",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bStand,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
            --print(self:IsJoJoStandUser(), self:IsJoJoStand(), "DEBUFIIGG")
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.SetChanneling = function(self, bIsChanneling)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsChanneling",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bIsChanneling,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.SetFemale = function(self, bFemale)
        if IsNotNull(self) then
            local hMaleTable =  {
                                    ["npc_dota_hero_dragon_knight"] = true,
                                    ["npc_dota_hero_phantom_lancer"]= true,
                                    ["npc_dota_hero_chen"]          = true,
                                    ["npc_dota_hero_bounty_hunter"] = true,
                                    ["npc_dota_hero_riki"]          = true,
                                    ["npc_dota_hero_beastmaster"]   = true,
                                    ["npc_dota_hero_night_stalker"] = true,
                                    ["npc_dota_hero_dark_seer"]     = true,
                                    ["npc_dota_hero_juggernaut"]    = true,
                                    ["npc_dota_hero_huskar"]        = true,
                                    ["npc_dota_hero_undying"]       = true,
                                    ["npc_dota_hero_life_stealer"]  = true,
                                    ["npc_dota_hero_earth_spirit"]  = true,
                                    ["npc_dota_hero_troll_warlord"] = true,
                                    ["npc_dota_hero_magnataur"]     = true,
                                    ["npc_dota_hero_ember_spirit"]  = true,
                                    ["npc_dota_hero_oracle"]        = true,
                                    ["npc_dota_hero_necrolyte"]     = true,
                                    ["npc_dota_hero_antimage"]      = true,
                                    ["npc_dota_hero_tusk"]          = true,
                                    ["npc_dota_hero_monkey_king"]   = true,
                                    ["npc_dota_hero_treant"]        = true,
                                    ["npc_dota_hero_slark"]         = true,
                                    ["npc_dota_hero_tidehunter"]    = true,
                                    ["npc_dota_hero_razor"]         = true,
                                    ["npc_dota_hero_void_spirit"]   = true,
                                    ["npc_dota_hero_skeleton_king"] = true,
                                    ["npc_dota_hero_phoenix"]       = true,
                                    ["npc_dota_hero_nevermore"]     = true,
                                    ["npc_dota_hero_slardar"]       = true,
                                    ["npc_dota_hero_sniper"]        = true,
                                    ["npc_dota_hero_terrorblade"]   = true,
                                    ["npc_dota_hero_abyssal_underlord"] = true,
                                    ["npc_dota_hero_skywrath_mage"] = true,
                                    ["npc_dota_hero_kunkka"]        = true,
                                    ["npc_dota_hero_puck"]          = true
                                }
        
            bFemale = bFemale == nil and ( self:IsHero() and not hMaleTable[self:GetUnitName()] ) or bFemale
            
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsFemale",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bFemale,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetBonusRespawnTime = function(self, hKeys)
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierStackingRespawnTime) == "function" then
                    local fIncrease = hModifier:GetModifierStackingRespawnTime(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetTotalDamageNullify = function(self, hKeys) --WORK AFTER MARBLE DAMAGE NULLIFY AND ZEROFILL DAMAGE, ORIGINAL DAMAGE AS EVERYWHERE SAME, SHOULD RETURN DAMAGE TYPE VALUE, IF DAMAGETYPED WILL BE ALL THEN WORK ONLY ONCE FOR RANDOM 
        local fValue = DAMAGE_TYPE_NONE
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierTotalDamageNullify) == "function" then
                    local fIncrease = hModifier:GetModifierTotalDamageNullify(hKeys)
                          bIncrease = type(fIncrease) == "number" and fIncrease > 0
                    if bIncrease then
                        fValue = bit.bor(fValue, fIncrease)
                        if bit.band(fValue, DAMAGE_TYPE_ALL) == DAMAGE_TYPE_ALL then
                            break --UNCOMMENT IF NEED ONLY ONCE AND U NOT WANT STACKING NULLIFICATIONS
                        end
                    end
                end
            end
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetSpellCriticalStrike = function(self, hKeys) --PROC BEFORE TOTAL EVASION
        local fValue = 0
        if IsNotNull(self) then
            local hSortTable = {}
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierSpellCriticalStrike) == "function" then
                    local fIncrease = hModifier:GetModifierSpellCriticalStrike(hKeys)
                    if type(fIncrease) == "number" then
                        table.insert(hSortTable, fIncrease)
                    end
                end
            end
            table.sort(hSortTable, function(fA, fB) return (fA > fB) end)
            fValue = hSortTable[1] or fValue
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetSpellCriticalStrike_Target = function(self, hKeys) --PROC BEFORE TOTAL EVASION
        local fValue = 0
        if IsNotNull(self) then
            local hSortTable = {}
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierSpellCriticalStrike_Target) == "function" then
                    local fIncrease = hModifier:GetModifierSpellCriticalStrike_Target(hKeys)
                    if type(fIncrease) == "number" then
                        table.insert(hSortTable, fIncrease)
                    end
                end
            end
            table.sort(hSortTable, function(fA, fB) return (fA > fB) end)
            fValue = hSortTable[1] or fValue
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --CLAMPING TO -100 AND 100 BY MATH.ABS     --1-(1-0,25)^2
    CDOTA_BaseNPC.GetTotalEvasion = function(self, hKeys) --PROC BEFORE DEPOSIT
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierTotalEvasion) == "function" then
                    local fIncrease = hModifier:GetModifierTotalEvasion(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0
                          fIncrease = ( fIncrease * ( 100 - math.abs(fValue) ) * 0.01 )

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetTotalDamageDeposit = function(self, hKeys) --BEFORE THIS, WORK ONCE FOR PREVENTION OTHER SAME DEPOSIT AND ACTIVATES AFTER IF HAS IT
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierTotalDamageDeposit) == "function" then
                    local fIncrease = hModifier:GetModifierTotalDamageDeposit(hKeys)
                          bIncrease = type(fIncrease) == "number" and fIncrease > 0
                    if bIncrease then
                        fValue = 1
                        break
                    end
                end
            end
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetTotalDamageBlock_Stacking = function(self, hKeys) --WORK AFTER ABOVE FEATURES, AND DAMAGE BLOCK STAKCINGS, THERE AS MB IN OTHER THINGS TOO CAN BE -DAMAGE
        hKeys.damage = math.ceil(hKeys.damage) --FIXED: BY MATH.CEIL keys.DAMAGE!!! BECAUSE GABEN THINKS U DEAD IF UR HP LESS THAN 1., IF NOT DO THAT KOTORI/VIDA WILL DEAD CAUSE HP LESS THAN 1
        --TODO: OR NOT FIXED, SEEN HOW DARKNESS DIED WHEN AE DRIFTED HER STRANGE
        local fValue  = 0
        local fDamage = hKeys.damage
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierTotalDamageBlock_Stacking) == "function"
                    and hKeys.damage > 0 then --COMMENT IF U WANT TRANSFER 0 DAMAGE
                    local fIncrease = hModifier:GetModifierTotalDamageBlock_Stacking(hKeys)
                          bIncrease = type(fIncrease) == "number"
                          --print("KEK", hModifier:GetAbility():GetAbilityName())
                    if bIncrease then
                        --hKeys.original_damage = hKeys.original_damage - fIncrease
                        hKeys.damage = hKeys.damage - fIncrease
                        fValue = fValue + fIncrease
                        fValue = fValue > fDamage
                                 and fDamage
                                 or fValue
                    end
                end
            end
        end
        return math.ceil(fValue) --TODO: Need someday fix maki record damage block value because it can be record always. and kotori record&&&??
        --TODO: ALSO NEED THINK ABOUT PERCANTAGE % BLOCKING CAUSE IT'S CALC % AFTER STACKING BLOCK
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetTotalAttacksForDeath = function(self, hKeys) --WORK AFTER TOTAL BLOCK STACKING BUT BEFORE RECIEVE DAMAGE, REQUIRES FOR UNITS OR ABILITIES WHICH USE HITS AS HEALTH
        if keys.attacker and not keys.attacker:IsNull() and IsValidEntity(keys.attacker) then
            local multi_per_attack = (keys.attacker:IsRealHero() and (keys.attacker:IsRangedAttacker() and self.ranged_hero_attacks or self.melee_hero_attacks) or (keys.attacker:IsRangedAttacker() and self.ranged_creep_attacks or self.melee_creep_attacks))
            local health_per_attack = self.parent:GetMaxHealth() / multi_per_attack
            --print(multi_per_attack, health_per_attack)
            if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
                --print(self.health_attacks)
                self.health_attacks = self.health_attacks - (self.melee_hero_attacks / multi_per_attack)
                self.parent_health = self.parent_health - health_per_attack
                --print(self.health_attacks)
                if self.health_attacks <= 0 then
                    --print("DIEEE")
                    self.parent:Kill(keys.inflictor, keys.attacker)
                else
                    self.parent:SetHealth(self.parent_health)
                end
            end
        end
        return hKeys.damage
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --, CLAMPING TO -100 AND 100 BY MATH.ABS
    CDOTA_BaseNPC.GetAccuracy = function(self, hKeys)
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierAccuracy) == "function" then
                    local fIncrease = hModifier:GetModifierAccuracy(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0
                          fIncrease = ( fIncrease * ( 100 - math.abs(fValue) ) * 0.01 )

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetSpellLifesteal = function(self, hKeys)
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierSpellLifesteal) == "function" then
                    local fIncrease = hModifier:GetModifierSpellLifesteal(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --7.27 Увеличение вампиризма теперь сочетается по закону убывающей полезности, а не складывается.
    --7.27 Увеличение регенерации здоровья теперь сочетается по закону убывающей полезности, а не складывается.
    --7.27 Увеличение лечения теперь сочетается по закону убывающей полезности, а не складывается.
    --7.27 Увеличение вампиризма заклинаниями теперь сочетается по закону убывающей полезности, а не складывается.
    --07.12.2021 NEW FUCKING FUNCTION UGH, CLAMPING TO -100 AND 100 BY MATH.ABS
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetSpellLifestealAmplification = function(self, hKeys, bMechanicReturn) --ATTENTION: SOMEDAY JUST REWORK ITEMS
        local fValue = 0
        if IsNotNull(self) then

            if not bMechanicReturn then
                --=========SPECIAL ADDITION FOR SHIVA'S GUARD AND SKADI==========------
                local hSpecialShivaValue = self:FindModifierByName("modifier_item_shivas_guard_aura")
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and hSpecialShivaValue:GetAbility()
                                           or nil 
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and -hSpecialShivaValue:GetSpecialValueFor("hp_regen_degen_aura")
                                           or 0
                      hSpecialShivaValue = ( hSpecialShivaValue * ( 100 - math.abs(fValue) ) * 0.01 )
                
                fValue = fValue + hSpecialShivaValue
                --===============================================================------
                local hSpecialShivaValue = self:FindModifierByName("modifier_item_skadi_slow")
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and hSpecialShivaValue:GetAbility()
                                           or nil 
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and -hSpecialShivaValue:GetSpecialValueFor("heal_reduction")
                                           or 0
                      hSpecialShivaValue = ( hSpecialShivaValue * ( 100 - math.abs(fValue) ) * 0.01 )

                fValue = fValue + hSpecialShivaValue
                --=========SPECIAL ADDITION FOR SHIVA'S GUARD AND SKADI==========------
            end

            --=========SPECIAL ADDITION FOR KAYAS==========------
            local hResortTable  =   {} --POHUUI
            local hSpecialTable =   {
                                        "item_kaya",
                                        "item_kaya_and_sange",
                                        "item_yasha_and_kaya",
                                        "item_bloodstone",
                                    }
            for _, sItemName in pairs(hSpecialTable) do
                local hItem = self:FindItemInInventory(sItemName)
                if IsNotNull(hItem) then
                    local fIncrease = ( hItem:GetSpecialValueFor("spell_lifesteal_amp") * ( 100 - math.abs(fValue) ) * 0.01 )
                    fValue = fValue + fIncrease
                    break
                end
            end
            --=========SPECIAL ADDITION FOR KAYAS==========------

            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierSpellLifestealRegenAmplify_Percentage) == "function" then
                    local fIncrease = hModifier:GetModifierSpellLifestealRegenAmplify_Percentage(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0
                          fIncrease = ( fIncrease * ( 100 - math.abs(fValue) ) * 0.01 )

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue * 0.01
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetSpellManasteal = function(self, hKeys)
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierSpellManasteal) == "function" then
                    local fIncrease = hModifier:GetModifierSpellManasteal(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetLifesteal = function(self, hKeys)
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierLifesteal) == "function" then
                    local fIncrease = hModifier:GetModifierLifesteal(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --07.12.2021 NEW FUCKING FUNCTION UGH, CLAMPING TO -100 AND 100 BY MATH.ABS
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetLifestealAmplification = function(self, hKeys, bMechanicReturn) --ATTENTION: SOMEDAY JUST REWORK ITEMS
        local fValue = 0
        if IsNotNull(self) then

            if not bMechanicReturn then
                --=========SPECIAL ADDITION FOR SHIVA'S GUARD AND SKADI==========------
                local hSpecialShivaValue = self:FindModifierByName("modifier_item_shivas_guard_aura")
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and hSpecialShivaValue:GetAbility()
                                           or nil 
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and -hSpecialShivaValue:GetSpecialValueFor("hp_regen_degen_aura")
                                           or 0
                      hSpecialShivaValue = ( hSpecialShivaValue * ( 100 - math.abs(fValue) ) * 0.01 )
                
                fValue = fValue + hSpecialShivaValue
                --===============================================================------
                local hSpecialShivaValue = self:FindModifierByName("modifier_item_skadi_slow")
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and hSpecialShivaValue:GetAbility()
                                           or nil 
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and -hSpecialShivaValue:GetSpecialValueFor("heal_reduction")
                                           or 0
                      hSpecialShivaValue = ( hSpecialShivaValue * ( 100 - math.abs(fValue) ) * 0.01 )
                
                fValue = fValue + hSpecialShivaValue
                --=========SPECIAL ADDITION FOR SHIVA'S GUARD AND SKADI==========------
            end

            --=========SPECIAL ADDITION FOR SANGES==========------
            local hResortTable  =   {} --POHUUI
            local hSpecialTable =   {
                                        "item_sange",
                                        "item_heavens_halberd",
                                        "item_sange_and_yasha",
                                        "item_kaya_and_sange",
                                    }
            for _, sItemName in pairs(hSpecialTable) do
                local hItem = self:FindItemInInventory(sItemName)
                if IsNotNull(hItem) then
                    local fIncrease = ( hItem:GetSpecialValueFor("hp_regen_amp") * ( 100 - math.abs(fValue) ) * 0.01 )
                    fValue = fValue + fIncrease
                    break
                end
            end
            --=========SPECIAL ADDITION FOR SANGES==========------

            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierLifestealRegenAmplify_Percentage) == "function" then
                    local fIncrease = hModifier:GetModifierLifestealRegenAmplify_Percentage(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0
                          fIncrease = ( fIncrease * ( 100 - math.abs(fValue) ) * 0.01 )

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue * 0.01
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.GetManasteal = function(self, hKeys)
        local fValue = 0
        if IsNotNull(self) then
            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.GetModifierManasteal) == "function" then
                    local fIncrease = hModifier:GetModifierManasteal(hKeys)
                          fIncrease = type(fIncrease) == "number"
                                      and fIncrease
                                      or 0

                    fValue = fValue + fIncrease
                end
            end
        end
        return fValue
    end
    --07.12.2021 NEW FUCKING FUNCTION UGH, CLAMPING TO -100 AND 100 BY MATH.ABS
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --Modifier property clamped to 100 and -100 but somehow -100+-100 == 0???, also source calc by source + target, by differnt calculations
    --I'M CLAMP VALUES TO -100 AND 100, BY USING MATH.ABS, BECAUSE CRINGE IF LESS THEN -100, BUT ALSO, GABEN ALSO USES THIS CALCULATION
    CDOTA_BaseNPC.GetHealAmplification = function(self, hKeys, bTarget)
        local fValueSource = 0
        local fValueTarget = 0
        if IsNotNull(self) then
            if bTarget then
                --=========SPECIAL ADDITION FOR SHIVA'S GUARD AND SKADI==========------
                local hSpecialShivaValue = self:FindModifierByName("modifier_item_shivas_guard_aura")
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and hSpecialShivaValue:GetAbility()
                                           or nil 
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and -hSpecialShivaValue:GetSpecialValueFor("hp_regen_degen_aura")
                                           or 0
                      hSpecialShivaValue = ( hSpecialShivaValue * ( 100 - math.abs(fValueTarget) ) * 0.01 )
                
                fValueTarget = fValueTarget + hSpecialShivaValue
                --===============================================================------
                local hSpecialShivaValue = self:FindModifierByName("modifier_item_skadi_slow")
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and hSpecialShivaValue:GetAbility()
                                           or nil 
                      hSpecialShivaValue = IsNotNull(hSpecialShivaValue)
                                           and -hSpecialShivaValue:GetSpecialValueFor("heal_reduction")
                                           or 0
                      hSpecialShivaValue = ( hSpecialShivaValue * ( 100 - math.abs(fValueTarget) ) * 0.01 )
                
                fValueTarget = fValueTarget + hSpecialShivaValue
                --=========SPECIAL ADDITION FOR SHIVA'S GUARD AND SKADI==========------
            end

            --=========SPECIAL ADDITION FOR HOLY COCKET==========------
            local hResortTable  =   {} --POHUUI
            local hSpecialTable =   {
                                        "item_holy_locket",
                                    }
            for _, sItemName in pairs(hSpecialTable) do
                local hItem = self:FindItemInInventory(sItemName)
                if IsNotNull(hItem) then
                    local fIncrease = ( hItem:GetSpecialValueFor("heal_increase") * ( 100 - math.abs(fValueSource) ) * 0.01 )
                    fValueSource = fValueSource + fIncrease
                    break
                end
            end
            --=========SPECIAL ADDITION FOR HOLY COCKET==========------

            local hModifiers = self:FindAllModifiers()
            for _, hModifier in pairs(hModifiers) do
                if IsNotNull(hModifier) then
                    if type(hModifier.GetModifierHealAmplify_PercentageSource) == "function" then
                        local fIncrease = hModifier:GetModifierHealAmplify_PercentageSource(hKeys)
                              fIncrease = type(fIncrease) == "number"
                                             and fIncrease
                                             or 0
                              fIncrease = ( fIncrease * ( 100 - math.abs(fValueSource) ) * 0.01 )

                        fValueSource = fValueSource + fIncrease
                    end

                    if bTarget 
                        and type(hModifier.GetModifierHealAmplify_PercentageTarget) == "function" then
                        local fIncrease = hModifier:GetModifierHealAmplify_PercentageTarget(hKeys)
                              fIncrease = type(fIncrease) == "number"
                                             and fIncrease
                                             or 0
                              fIncrease = ( fIncrease * ( 100 - math.abs(fValueTarget) ) * 0.01 )
                              
                        fValueTarget = fValueTarget + fIncrease
                    end
                end
            end
        end
        return ( fValueSource + fValueTarget ) * 0.01
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC.SetStatusResistance = function(self, fStatusResistance)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___GetStatusResistance",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = false,
                                                        fValue        = fStatusResistance,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_SetActivated = CDOTABaseAbility.SetActivated
    CDOTABaseAbility.SetActivated = function(self, bActivated)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsActivated",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bActivated,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
            return VALVE_SetActivated(self, bActivated)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseAbility.SetFullyCastable = function(self, bFullyCastable)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsFullyCastable",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bFullyCastable,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_SetHidden = CDOTABaseAbility.SetHidden
    CDOTABaseAbility.SetHidden = function(self, bHidden)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___IsHidden",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = true,
                                                        fValue        = bHidden,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
            return VALVE_SetHidden(self, bHidden)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_SetFrozenCooldown = CDOTABaseAbility.SetFrozenCooldown
    CDOTABaseAbility.SetFrozenCooldown = function(self, bFrozenCooldown)
        if IsNotNull(self) then
            local bIsNowFrozen = self:IsFrozenCooldown()
            local fThinkCD     = math.ceil(self:GetCooldownTimeRemaining())
            local fThinkACCD   = self:GetACCooldownTimeRemaining()

            bFrozenCooldown = bFrozenCooldown and ( fThinkCD > 0 or fThinkACCD > 0 )

            if bFrozenCooldown ~= bIsNowFrozen then
                local fThinkTime   = 0.1 --0 EQUAL FRAME TIME 0.03
                local sThinkString = "___" .. self:GetAbilityName() .. "_" .. self:entindex() .. "___"

                if bFrozenCooldown then
                    --TIMERS FOR PERFOMANCE BY USING OLD STYLE
                    Timers:CreateTimer(sThinkString,
                    {
                        --useOldStyle = true,
                        endTime = 0,
                        callback = function()
                            if IsNotNull(self) then
                                if not ( self:IsItem() and self:GetItemSlot() == -1 ) then --BECAUSE IT'S TIMER I SHOULD DO THAT
                                    local fCurrentCD = math.ceil(self:GetCooldownTimeRemaining())
                                    if fCurrentCD > 0 then
                                        fThinkCD = fThinkCD > 0
                                                   and fThinkCD
                                                   or fCurrentCD

                                        self:EndCooldown()
                                        self:StartCooldown(fThinkCD)

                                        return fThinkTime
                                    elseif self:GetACCooldownTimeRemaining() > 0 then
                                        return fThinkTime
                                    end
                                end
                                return self:SetFrozenCooldown(false)
                            end
                        end
                    })
                else
                    Timers:RemoveTimer(sThinkString)
                end

                FireGameEvent("anime_cf_server_client", {
                                                            sFunctionName = "___IsFrozenCooldown",
                                                            iEntIndex     = self:entindex(),
                                                            bValue        = true,
                                                            fValue        = bFrozenCooldown,
                                                            iType         = ANIME_SC_TYPE_ENTINDEX
                                                        })
            
                return VALVE_SetFrozenCooldown(self, bFrozenCooldown)
            end
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_SetPrimaryAttribute = CDOTA_BaseNPC_Hero.SetPrimaryAttribute
    CDOTA_BaseNPC_Hero.SetPrimaryAttribute = function(self, nPrimaryAttribute)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___GetPrimaryAttribute",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = false,
                                                        fValue        = nPrimaryAttribute,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
            return VALVE_SetPrimaryAttribute(self, nPrimaryAttribute)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTA_BaseNPC_Hero.SetPrimaryStatValue = function(self, nPrimaryStatValue)
        if IsNotNull(self) then
            FireGameEvent("anime_cf_server_client", {
                                                        sFunctionName = "___GetPrimaryStatValue",
                                                        iEntIndex     = self:entindex(),
                                                        bValue        = false,
                                                        fValue        = nPrimaryStatValue,
                                                        iType         = ANIME_SC_TYPE_ENTINDEX
                                                    })
        end
    end










    
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseAbility.GetIntrinsicModifierNames = function(self)
        return {}
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTABaseAbility_GetIntrinsicModifierName = CDOTABaseAbility.GetIntrinsicModifierName
    CDOTABaseAbility.GetIntrinsicModifierName = function(self)
        if IsNotNull(self) then
            local hNames = self:GetIntrinsicModifierNames()
            if type(hNames) == "table" and TableLength(hNames) > 0 then
                return "modifier_anime_mechanic_intrinsic_modifier_names"
            elseif type(hNames) == "string" then
                return hNames
            end
            return VALVE_CDOTABaseAbility_GetIntrinsicModifierName(self)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTA_Ability_Lua_GetIntrinsicModifierName = CDOTA_Ability_Lua.GetIntrinsicModifierName
    CDOTA_Ability_Lua.GetIntrinsicModifierName = function(self)
        if IsNotNull(self) then
            local hNames = self:GetIntrinsicModifierNames()
            if type(hNames) == "table" and TableLength(hNames) > 0 then
                return "modifier_anime_mechanic_intrinsic_modifier_names"
            elseif type(hNames) == "string" then
                return hNames
            end
            return VALVE_CDOTA_Ability_Lua_GetIntrinsicModifierName(self)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTA_Item_Lua_GetIntrinsicModifierName = CDOTA_Item_Lua.GetIntrinsicModifierName
    CDOTA_Item_Lua.GetIntrinsicModifierName = function(self)
        if IsNotNull(self) then
            local hNames = self:GetIntrinsicModifierNames()
            if type(hNames) == "table" and TableLength(hNames) > 0 then
                return "modifier_anime_mechanic_intrinsic_modifier_names"
            elseif type(hNames) == "string" then
                return hNames
            end
            return VALVE_CDOTA_Item_Lua_GetIntrinsicModifierName(self)
        end
    end





    --NEW FEATURE 19.09.2021
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseAbility.GetOnUpgradeAbilities = function(self) --TRYEING BUT THIS FEATURE PREVENT LEARNING BY LOTUS IF SAME HEROES INGAME OR IF HEROES HAVE SAME ABILITIES
        return {}
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTABaseAbility_OnUpgrade = CDOTABaseAbility.OnUpgrade
    CDOTABaseAbility.OnUpgrade = function(self)
        if IsNotNull(self) then
            local hCaster = self:GetCaster()
            if IsNotNull(hCaster) then
                local bIsSelf = ( self == hCaster:FindAbilityByName(self:GetAbilityName()) ) --THIS CHECK EXCEPT JUST HASABILITY PREVENT LOTUS LEARNING OTHERABILITIES FOR SAME HEROES (on hogyoku we are using entity so it's true always - NO PROBLEMS BASICALY)
                --print(bIsSelf, "PEPEGIUS 1", self:GetAbilityName(), hCaster:GetUnitName())
                if bIsSelf then
                    local iLevel     = self:GetLevel()
                    local hAbilities = self:GetOnUpgradeAbilities()
                    for _, sAbility in pairs(hAbilities) do
                        local hAbility = hCaster:FindAbilityByName(sAbility)
                        if IsNotNull(hAbility)
                            and hAbility:GetLevel() ~= iLevel then --using ~= except < just for tests
                            hAbility:SetLevel(iLevel)
                        end
                    end
                end
            end
            return VALVE_CDOTABaseAbility_OnUpgrade(self)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTA_Ability_Lua_OnUpgrade = CDOTA_Ability_Lua.OnUpgrade
    CDOTA_Ability_Lua.OnUpgrade = function(self)
        if IsNotNull(self) then
            local hCaster = self:GetCaster()
            if IsNotNull(hCaster) then
                local bIsSelf = ( self == hCaster:FindAbilityByName(self:GetAbilityName()) ) --THIS CHECK EXCEPT JUST HASABILITY PREVENT LOTUS LEARNING OTHERABILITIES FOR SAME HEROES (on hogyoku we are using entity so it's true always - NO PROBLEMS BASICALY)
                --print(bIsSelf, "PEPEGIUS 2", self:GetAbilityName(), hCaster:GetUnitName())
                if bIsSelf then
                    local iLevel     = self:GetLevel()
                    local hAbilities = self:GetOnUpgradeAbilities()
                    for _, sAbility in pairs(hAbilities) do
                        local hAbility = hCaster:FindAbilityByName(sAbility)
                        if IsNotNull(hAbility)
                            and hAbility:GetLevel() ~= iLevel then --using ~= except < just for tests
                            hAbility:SetLevel(iLevel)
                        end
                    end
                end
            end
            return VALVE_CDOTA_Ability_Lua_OnUpgrade(self)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_CDOTA_Item_Lua_OnUpgrade = CDOTA_Item_Lua.OnUpgrade --for items right now idk and basicaly no need right now????
    CDOTA_Item_Lua.OnUpgrade = function(self)
        if IsNotNull(self) then
            local hCaster = self:GetCaster()
            return VALVE_CDOTA_Item_Lua_OnUpgrade(self)
        end
    end







    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    --[[local VALVE_OnSpellStart = CDOTABaseAbility.OnSpellStart
    CDOTABaseAbility.OnSpellStart = function(self)
        print("HMMM")
        return VALVE_OnSpellStart(self)
    end]]





    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseAbility.GetACCooldownTimeRemaining = function(self) --NEW FUNCTION FOR CHARGES, 30.11.2021
        if IsNotNull(self) then
            local hCaster = self:GetCaster()
            if IsNotNull(hCaster) then
                local hModifiers = hCaster:FindAllModifiers()
                for _, hModifier in pairs(hModifiers) do
                    if IsNotNull(hModifier)
                        and hModifier:IsCharges()
                        and hModifier:GetAbility() == self
                        and hModifier:GetCaster() == hCaster then
                        --print(hModifier.__fACCooldownTimeRemaining)
                        return hModifier.__fACCooldownTimeRemaining or 0
                    end
                end
            end
        end
        return 0
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_RefreshCharges = CDOTABaseAbility.RefreshCharges
    CDOTABaseAbility.RefreshCharges = function(self, iRefreshCount, bIgnoreMaxCount)
        if IsNotNull(self) then
            local hCaster = self:GetCaster()
            if IsNotNull(hCaster) then
                local bHasAC     = self:HasAnimeCharges() 
                local iMaxAC     = self:GetMaxAC()
                local iCurrentAC = self:GetCurrentAC()

                local iRefreshCount = iCurrentAC + ( iRefreshCount or iMaxAC )

                --if bHasAC then
                local hModifiers = hCaster:FindAllModifiers()
                for _, hModifier in pairs(hModifiers) do
                    if IsNotNull(hModifier)
                        and hModifier:IsCharges()
                        and hModifier:GetAbility() == self
                        and hModifier:GetCaster() == hCaster then
                        hModifier:RefreshCharges(iRefreshCount, bIgnoreMaxCount, true)
                    end
                end
                --end
            end
            return VALVE_RefreshCharges(self)
        end
    end


































    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_MakeRandomHeroSelection = CDOTAPlayerController.MakeRandomHeroSelection
    CDOTAPlayerController.MakeRandomHeroSelection = function(self, bNoLockRandom)
        local PID  = self:GetPlayerID()
        local ID32 = tostring(PlayerResource:GetSteamAccountID(PID))
        if not PlayerResource:HasSelectedHero(PID) or bNoLockRandom then
            VALVE_MakeRandomHeroSelection(self)

            if bNoLockRandom then
                return nil
            end
        end

        local PATRONS_TABLE    = CustomNetTables:GetTableValue("anime_patreon_new", "anime_patreon") or {}
        local PGN_HEROES_TABLE = CustomNetTables:GetTableValue("anime_patreon_new", "anime_patreon_heroes") or {}

        local NewLockTable   = {}   -- "#FF0000", "LOCKED: NEW HERO, IN TESTING"
        local GoldLockTable  = {}   -- "gold", "LOCKED: EXCLUSIVE MADE HERO"
        local PupleLockTable = {}   -- "#E96AFF", "LOCKED: WEEKLY HERO ONLY FOR PATRONS"

        for _, hLockHero in pairs(PGN_HEROES_TABLE) do
            if type(hLockHero) == "table" then
                local heroname    = tostring(hLockHero.heroname)
                local new_lock    = tonumber( ( hLockHero.new_lock or 0 ) ) >= 1
                local gold_lock   = tonumber( ( hLockHero.gold_lock or 0 ) ) >= 1
                local purple_lock = tonumber( ( hLockHero.purple_lock or 0 ) ) >= 1

                NewLockTable[heroname]   = new_lock
                GoldLockTable[heroname]  = gold_lock
                PupleLockTable[heroname] = purple_lock
            end
        end

        --DeepPrintTable(NewLockTable)
        --DeepPrintTable(GoldLockTable)
        --DeepPrintTable(PupleLockTable)

        local UnlockLevel = ( type(PATRONS_TABLE[ID32]) == "table" and tonumber( PATRONS_TABLE[ID32].pactive or 0 ) >= 1 ) and tonumber( PATRONS_TABLE[ID32].heroes_unlock or 0 ) or 0
        local IsPatronNew    = UnlockLevel >= 3
        local IsPatronGold   = UnlockLevel >= 2
        local IsPatronPurple = UnlockLevel >= 1

        local heroname = PlayerResource:GetSelectedHeroName(PID)
        while NewLockTable[heroname] or GoldLockTable[heroname] or PupleLockTable[heroname] do
            local IsPatronTier = ( IsPatronNew and NewLockTable[heroname] ) or ( IsPatronGold and GoldLockTable[heroname] ) or ( IsPatronPurple and PupleLockTable[heroname] )
            if IsPatronTier then
                return nil
            end
            
            VALVE_MakeRandomHeroSelection(self)

            heroname = PlayerResource:GetSelectedHeroName(PID)
        end
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseGameMode.SetControlAnimeMechanic = function(self, bValue)
        if type(bValue) == "boolean" then
            if bValue then
                self.___SetControlAnimeMechanic = CreateModifierThinker(self, nil, "modifier_anime_mechanic_parent_new", {}, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
            elseif not bValue and IsNotNull(self.___SetControlAnimeMechanic) then
                self.___SetControlAnimeMechanic:Destroy()
            end
            return nil
        end
        error("SetControlAnimeMechanic not a boolean")
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    local VALVE_SetPauseEnabled = CDOTABaseGameMode.SetPauseEnabled
    CDOTABaseGameMode.SetPauseEnabled = function(self, bEnable)
        self.___GetPauseEnabled = bEnable
        return VALVE_SetPauseEnabled(self, bEnable)
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseGameMode.GetPauseEnabled = function(self)
        return self.___GetPauseEnabled or false
    end
    --!!----------------------------------------------------------------------------------------------------------------------------------------------------------
    CDOTABaseGameMode.PauseGame = function(self, bPause, fTime, bCanBeUnpaused, bSetPauseEnable)
        if GameRules:IsGamePaused() ~= bPause then            
            bCanBeUnpaused  = bCanBeUnpaused or false
            bSetPauseEnable = bSetPauseEnable or false

            self:SetPauseEnabled(bCanBeUnpaused)
            
            PauseGame(bPause)

            if type(fTime) == "number" then
                self:SetContextThink( "ContextThinkAnimePauseGame", function()
                                                                        PauseGame(not bPause)
                                                                        self:SetPauseEnabled(bSetPauseEnable)
                                                                    end, fTime)
            end
        end
    end
end
--[\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\]










--GetOwner and GetOnwerEntity - CAN GIVE U OR ENTITY ITSELF. NULL OR PLAYER CLASS... WTF












--[[
    for _, hModifier in pairs(hCaster:FindAllModifiers()) do
        if IsNotNull(hModifier) then
            for i = 0, MODIFIER_FUNCTION_LAST - 1 do
                if hModifier:HasFunction(i) then
                    print(hModifier:GetName(), "HAS FUNCTION:", i)
                    local hTableCheck = {}
                    hModifier:CheckStateToTable(hTableCheck)
                    for i, s in pairs(hTableCheck) do
                        print(i, s, "STATE")
                    end
                end
            end
        end
    end
    ]]


    --Error loading resource file "panorama/images/items/anime_items/anime_tear_png.vtex_c" (Error: ERROR_FILEOPEN)
    --[[local hItemsImagesNew = {}
    local hItemsImagesNow = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    for _, hItem in pairs(hItemsImagesNow) do
        local sImageNameRoot = hItem["AbilityTextureName"]
        if not hItemsImagesNew[sImageNameRoot] then
            hItemsImagesNew[sImageNameRoot] = "<Image scaling=" .. '"stretch" ' .. 'defaultsrc="file://{images}/items/' .. sImageNameRoot .. '.png" />'
            print(hItemsImagesNew[sImageNameRoot])
        end
    end]]

--[[

    local hSpecialTable = {}
    for _, hItemTable in pairs(LoadKeyValues("scripts/npc/items.txt")) do
        if type(hItemTable) == "table" then
            --print(hItemTable.ID, _)
            table.insert(hSpecialTable, {id = hItemTable.ID, name = _})
        else
            print("ERROR ISN'T TABLE", _, hItemTable)
        end
    end

    table.sort( hSpecialTable, function(hA, hB) return ( tonumber(hA.id) < tonumber(hB.id) ) end)

    for _, kek in pairs(hSpecialTable) do
        print('"'..kek.name..'"',       '"REMOVE"',     '//"'..kek.id..'"')
    end

]]

return true