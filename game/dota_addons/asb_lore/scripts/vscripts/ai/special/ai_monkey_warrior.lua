function Spawn( entityKeyValues )
	TargetAbility = thisEntity:FindAbilityByName( "monkey_king_warrior_attack" )

	thisEntity:SetContextThink("Think", function()
		if not thisEntity:IsAlive() then
			return
		end
		MonkeyWarriorThink()

		return RandomFloat(0.5, 1)
	end, RandomFloat(0.5, 1))
end

function MonkeyWarriorThink()
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
            thisEntity:SetAbsOrigin(Owner_location + RandomVector( RandomFloat(0, 250)))
            --			thisEntity:Stop()
        end
    else
        if distance > 900 then
            thisEntity:SetAbsOrigin(Owner_location + RandomVector( RandomFloat(0, 250)))
            thisEntity:Stop()
        else
            order = {
                UnitIndex = thisEntity:entindex(),	--индекс кастера
                OrderType = DOTA_UNIT_ORDER_CAST_POSITION,	-- тип приказа
                AbilityIndex = TargetAbility:entindex(), -- индекс способности
                Position = enemies[1]:GetAbsOrigin(),
                Queue = false,
            }

            ExecuteOrderFromTable(order)
        end
    end

end
