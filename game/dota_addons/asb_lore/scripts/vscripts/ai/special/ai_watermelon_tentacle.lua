function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	NoTargetAbility = thisEntity:FindAbilityByName( "watermelon_tentacle_circular_blow" )

	thisEntity:SetContextThink( "WatermelonTentacleThink", WatermelonTentacleThink, 1 )
end

function WatermelonTentacleThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Increase acquisition range after the initial aggro

	local enemies = FindUnitsInRadius( 
									thisEntity:GetTeamNumber(),	--команда юнита
									thisEntity:GetOrigin(),		--местоположение юнита
									nil,	--айди юнита (необязательно)
									600,	--радиус поиска
									DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
									DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	--поиск по флагам
									FIND_CLOSEST,	--сортировка от ближнего к дальнему или от дальнего к ближнему
									false )

	if #enemies > 0 	then

		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
			return CastNoTargetAbility()
		end

		return AttackTarget(enemies[1])
	end
	
	return 0.5
end

function AttackTarget( enemy )
	if enemy == nil then
		return
	end	

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = enemy:entindex(),
	})

	return 1
end

function CastNoTargetAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = NoTargetAbility:entindex(),
		Queue = false,
	})
	
	return 1
end
