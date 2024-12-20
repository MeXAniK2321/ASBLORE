function Spawn( entityKeyValues )
	thisEntity:SetContextThink("Think", function()
		if not thisEntity:IsAlive() then
			return
		end
		MarsWarriorThink()

		return 1.0
	end, 1.0)
end

function MarsWarriorThink()
    if thisEntity.PID == nil then
        thisEntity.PID = thisEntity:GetPlayerOwnerID()
    end

    local OWNER = PlayerResource:GetSelectedHeroEntity(thisEntity.PID)
    local Owner_location = OWNER:GetAbsOrigin()
    local Pet_location = thisEntity:GetAbsOrigin()
    local vector_distance = Owner_location - Pet_location
    local distance = vector_distance:Length2D()

    local enemies = FindUnitsInRadius(
        OWNER:GetTeamNumber(),
        OWNER:GetOrigin(),
        nil,
        600,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST,
        false )
    if #enemies == 0 then
        if distance > 400 and distance < 900 then
            local order =
                {
                    UnitIndex = thisEntity:entindex(),
                    OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                    Position = 	OWNER:GetAbsOrigin()
                }
            ExecuteOrderFromTable(order)
        elseif distance < 325 then
            thisEntity:Stop()
            local order =
                {
                    UnitIndex = thisEntity:entindex(),
                    OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                    Position = Owner_location + RandomVector( RandomFloat(0, 300))
                }
            ExecuteOrderFromTable(order)
        elseif distance > 900 then
            --thisEntity:SetAbsOrigin(Owner_location + RandomVector( RandomFloat(0, 250)))
            FindClearSpaceForUnit(thisEntity, Owner_location, true)
            --			thisEntity:Stop()
        end
    else
        if distance > 900 then
            --thisEntity:SetAbsOrigin(Owner_location + RandomVector( RandomFloat(0, 250)))
            FindClearSpaceForUnit(thisEntity, Owner_location, true)
            thisEntity:Stop()
        else
            local order =
                {
                    UnitIndex = thisEntity:entindex(),
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                    Position = 	OWNER:GetAbsOrigin()
                }
            ExecuteOrderFromTable(order)
        end
    end
end
