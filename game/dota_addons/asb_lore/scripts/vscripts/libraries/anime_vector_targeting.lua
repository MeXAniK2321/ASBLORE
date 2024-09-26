--Created by EIEOFLIE V0.07
--NOTE: Some Parts into Order Filter, be carefull. Inject Shell on any pc which isn't gaben dediсated
--NOTE: Some day will fix wrong direction reselection arrow and in server
if not AnimeVectorTargeting and IsServer() then --NOTE: NOW NOT WORK WITH PROTECTED EVENTS.... PIZDEC
    local sPlayersTableName = "anime_vector_targeting"

    AnimeVectorTargeting = class({})

    function AnimeVectorTargeting:UpdateAnimeVectorTargetingAbility(hAbility, hUnit, hTarget, vPosition, iOrder)
        if IsNotNull(hAbility) and type(hAbility.GetBehavior) == "function" then
            local iBehavior = hAbility:GetBehavior()
            local bBehavior = ( bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0
                                or bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 )
                                and bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) ~= 0
        
            if bBehavior 
                and ( iOrder == DOTA_UNIT_ORDER_CAST_POSITION 
                      or iOrder == DOTA_UNIT_ORDER_CAST_TARGET
                      or iOrder == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION ) then

                --CHANGED SIMPLE CHECKS TO BAND CHECKS -BAD IDEA CAUSE BAND IT'S MFK BAND, can't be used for iOrder cause not bitwise operators
                if iOrder == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
                    hAbility.___GetAnimeVectorTargetingCursorPosition = vPosition
                else
                    hAbility.___GetAnimeVectorTargetingLockingPosition = iOrder == DOTA_UNIT_ORDER_CAST_POSITION
                                                                         and vPosition
                                                                         or ( IsNotNull(hTarget)
                                                                              and hTarget:GetAbsOrigin()--GetGroundPosition(hTarget:GetAbsOrigin(), hTarget)
                                                                              or vPosition )
                    local vUnitPosition      = hUnit:GetAbsOrigin()--GetGroundPosition(hUnit:GetAbsOrigin(), hUnit)
                          vUnitPosition.z    = 0
                    local vUnitVector        = hUnit:GetForwardVector()
                          vUnitVector.z      = 0
                    local vLockingPosition   = hAbility:GetAnimeVectorTargetingLockingPosition()
                          vLockingPosition.z = 0
                    local vVectorPosition    = hAbility:GetAnimeVectorTargetingCursorPosition()
                          vVectorPosition.z  = 0

                    local bUnitEqualLocking   = GetDistance(vUnitPosition, vLockingPosition)   <= 0.05
                    local bUnitEqualVector    = GetDistance(vUnitPosition, vVectorPosition)    <= 0.05
                    local bLockingEqualVector = GetDistance(vLockingPosition, vVectorPosition) <= 0.05

                    local vDirection = ( bUnitEqualLocking
                                         and bUnitEqualVector
                                         and bLockingEqualVector)
                                         and vUnitVector
                                         or ( bLockingEqualVector
                                              and GetDirection(vLockingPosition, vUnitPosition)
                                              or GetDirection(vVectorPosition, vLockingPosition) )

                    hAbility.___GetAnimeVectorTargetingMainDirection = vDirection
                end
                return true
            end
        end
        return false
    end
    
    local function UpdateAnimeVectorTargetingAbility(args)
        local hAbility  = EntIndexToHScript(args.iAbilityIndex)
        local hEntities = args.hEntities
        local hPosition = args.hPosition

        if IsNotNull(hAbility) and string.find(hAbility:GetClassname(), "_lua") then
            if not PlayerTables:TableExists(sPlayersTableName) then
                PlayerTables:CreateTable(sPlayersTableName, {}, true)
            end
            ------------------------------------------------------------------------
            local hEntitiesScript = {}
            local iEntitiesLength = table.len(hEntities)
            if iEntitiesLength > 0 then
                iEntitiesLength = iEntitiesLength - 1
                for i = 0, iEntitiesLength do
                    local iEntity = hEntities[tostring(i)]
                    local hEntity = EntIndexToHScript(iEntity)
                    if IsNotNull(hEntity)
                        and IsValidEntity(hEntity)
                        and hEntity:IsAlive() then
                        table.insert(hEntitiesScript, hEntity)
                    end
                end
            end
            ------------------------------------------------------------------------
            hEntitiesScript = hAbility:GetAnimeVectorTargetingTarget(hEntitiesScript)
            hEntitiesScript = IsNotNull(hEntitiesScript)
                              and hEntitiesScript:entindex()
                              or nil
            ------------------------------------------------------------------------
            local vPosition = nil
            if table.len(hPosition) >= 3 then
                vPosition = hAbility:GetAnimeVectorTargetingPosition(Vector(hPosition["0"], hPosition["1"], hPosition["2"]))
                vPosition = IsNotNull(vPosition)
                            and { ["0"] = vPosition.x, ["1"] = vPosition.y, ["2"] = vPosition.z }
                            or nil
            end
            ------------------------------------------------------------------------
            local hCallBackTable = {
                                        GetAnimeVectorTargetingTarget      = hEntitiesScript,
                                        GetAnimeVectorTargetingPosition    = vPosition,

                                        GetAnimeVectorTargetingRange       = hAbility:GetAnimeVectorTargetingRange(),
                                        GetAnimeVectorTargetingStartRadius = hAbility:GetAnimeVectorTargetingStartRadius(),
                                        GetAnimeVectorTargetingEndRadius   = hAbility:GetAnimeVectorTargetingEndRadius(),
                                        GetAnimeVectorTargetingColor       = hAbility:GetAnimeVectorTargetingColor(),
                                        
                                        IsAnimeVectorTargetingIgnoreWidth  = hAbility:IsAnimeVectorTargetingIgnoreWidth(),
                                        IsAnimeVectorTargetingDual         = hAbility:IsAnimeVectorTargetingDual()
                                    }

            --if not TableEqual(PlayerTables:GetTableValue(sPlayersTableName, args.iAbilityIndex), hCallBackTable) then
            PlayerTables:SetTableValue(sPlayersTableName, args.iAbilityIndex, hCallBackTable, args.PlayerID, true)

            --TODO: Need Check, removes index or not from unit... hmmm
            
            --end
        end
    end

    CustomGameEventManager:RegisterListener("update_anime_vector_targeting_ability", function(nEventIndex, tEventData) return UpdateAnimeVectorTargetingAbility(tEventData) end)
    --RegisterCustomEventListener("update_anime_vector_targeting_ability", UpdateAnimeVectorTargetingAbility)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingRange()
    return 800
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingStartRadius()
    return 125
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingEndRadius()
    return self.GetAnimeVectorTargetingStartRadius(self)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingColor()
    return Vector(0, 255, 0)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:IsAnimeVectorTargetingIgnoreWidth()
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:IsAnimeVectorTargetingDual()
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingLockingPosition()
    return self.___GetAnimeVectorTargetingLockingPosition or Vector(0, 0, 0)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingCursorPosition()
    return self.___GetAnimeVectorTargetingCursorPosition or Vector(0, 0, 0)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingMainDirection()
    return self.___GetAnimeVectorTargetingMainDirection or self:GetCaster():GetForwardVector()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingTarget(hEntitiesScript)
    for i, hEntity in pairs(hEntitiesScript) do
        if (self:CastFilterResultTarget(hEntity) == UF_SUCCESS) then
            return hEntity
        end
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetAnimeVectorTargetingPosition(vPosition)
    if (self:CastFilterResultLocation(vPosition) == UF_SUCCESS) then
        return vPosition
    end
end

--return AnimeVectorTargeting


if IsInToolsMode() then
    print("[REQUIRING][IsServer] == ", IsServer(), "anime_vector_targeting ==> LOADED")
end