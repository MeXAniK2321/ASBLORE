function Spawn(entityKeyValues)
	local npc = thisEntity
	npc.bInitialized = false

	if not IsServer() then return end
	if npc == nil then return end

	JumpAbility = npc:FindAbilityByName("watermelon_jump")
	DivingAbility = npc:FindAbilityByName("watermelon_diving")
	MovingAbility = thisEntity:FindAbilityByName("watermelon_moving")
	TentacleAbility = npc:FindAbilityByName("watermelon_tentacle")
	TentacleDivingAbility = npc:FindAbilityByName("watermelon_tentacle_diving")
	WaveAbility = npc:FindAbilityByName("watermelon_wave")
	SuperWaveAbility = npc:FindAbilityByName("watermelon_wave_cast")
	MadnessAbility = npc:FindAbilityByName("watermelon_madness")
	BonusAttackRangeAbility = npc:FindAbilityByName("watermelon_bonus_attack_range")

	JumpAbility:SetLevel(1)
	TentacleAbility:SetLevel(1)
	WaveAbility:SetLevel(1)
	DivingAbility:SetLevel(1)
	SuperWaveAbility:SetLevel(1)
	MovingAbility:SetLevel(1)
	TentacleDivingAbility:SetLevel(1)
	MadnessAbility:SetLevel(1)
	BonusAttackRangeAbility:SetLevel(1)

	npc:SetContextThink("WatermelonThink", WatermelonThink, 1)
end

function WatermelonPointsCheck()
	local watermelon_points = Entities:FindAllByName("BOSS_WM_POINT")
	local k = 0
	for _,wm_point in pairs(watermelon_points) do
		if wm_point.tentacle and ( not IsValidEntity(wm_point.tentacle) or not wm_point.tentacle:IsAlive()) then
			wm_point.tentacle = nil
		end
		if wm_point.tentacle then
			k = k + 1
		end
	end
end

function FindNearestPoint(pos)
	local nearest_point = Entities:FindByNameNearest("BOSS_WM_POINT", pos, 1000)

	if nearest_point then
		return nearest_point
	else
		return Entities:FindByName(nil, "BOSS_WM_SPAWN_POINT")
	end
end

function WatermelonThink()
	npc = thisEntity
	local watermelon_points = Entities:FindAllByName("BOSS_WM_POINT")
	WatermelonPointsCheck()
	if not npc.bSpawnInit then
		npc.bSpawnInit = true
		npc:SetAbsOrigin(Entities:FindByName(nil, "BOSS_WM_SPAWN_POINT"):GetAbsOrigin())

		local thinker_point = Entities:FindByName(nil, "BOSS_WM_PORTAL_END"):GetAbsOrigin() 
		npc.thinker = CreateModifierThinker(thisEntity:GetAbilityByIndex(0), thisEntity, "modifier_watermelon_portal", {duration = -1}, thinker_point, npc:GetTeam(), false)
		npc.thinker.active = true
	end

	if not npc:IsAlive() then 
		npc.thinker.active = true
		return -1 
	end
	if GameRules:IsGamePaused() then return 1 end
	if npc:IsChanneling() or npc:IsStunned() then return 0.5 end

	local boss_hp = npc:GetHealthPercent()
	local boss_origin = npc:GetAbsOrigin()
	local spawn_point = Entities:FindByName(nil, "BOSS_WM_SPAWN_POINT")
	local closest_enemy
	local closest_distance
	local farthest_enemy
	local farthest_distance


	if not npc.bInitialized then
		if boss_hp<100 then
			npc.bInitialized = true
			npc.diving = false
			npc.vMaxArenaPoint = Entities:FindByName(nil, "point_boss_arena_max_2"):GetAbsOrigin()
			npc.vMinArenaPoint = Entities:FindByName(nil, "point_boss_arena_min_2"):GetAbsOrigin()
			if npc.vMaxArenaPoint.x > 0 then
				local temp = npc.vMinArenaPoint
				npc.vMinArenaPoint = npc.vMaxArenaPoint
				vMaxArenaPoint = temp
			end
			npc.arena_center = (npc.vMaxArenaPoint + npc.vMinArenaPoint) / 2
			npc.search_radius = (npc.vMaxArenaPoint - npc.vMinArenaPoint):Length2D() / 2

			npc.thinker.active = false
			npc:EmitSound("tidehunter_tide_spawn_0"..RandomInt(1, 9))
		end
		return 1
	end

	local enemies = FindUnitsInRadius(
		npc:GetTeamNumber(), 
		npc.arena_center, 
		nil, 
		npc.search_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 
		0, 
		false)

	local enemies_on_arena = {}
	for _, enemy in pairs(enemies) do
		local enemy_origin = enemy:GetAbsOrigin()
		if enemy_origin.x < npc.vMinArenaPoint.x and enemy_origin.x > npc.vMaxArenaPoint.x and not enemy:IsCourier() then
			table.insert(enemies_on_arena, enemy)

			local distance = (boss_origin - enemy_origin):Length2D()
			if not closest_enemy then
				closest_distance = distance
				closest_enemy = enemy
				farthest_distance = distance
				farthest_enemy = enemy
			elseif distance < closest_distance then
				closest_distance = distance
				closest_enemy = enemy
			elseif distance > farthest_distance then
				farthest_distance = distance
				farthest_enemy = enemy
			end
		end
	end

	if #enemies_on_arena > 0 then
		local farthest_point = FindNearestPoint(farthest_enemy:GetAbsOrigin())
		local closest_point = FindNearestPoint(closest_enemy:GetAbsOrigin())
		local random_enemy = enemies_on_arena[RandomInt(1, #enemies_on_arena)]
		local random_enemy_point = FindNearestPoint(random_enemy:GetAbsOrigin())
		local random_point = watermelon_points[RandomInt(1, #watermelon_points)]

		if npc:HasModifier("modifier_watermelon_madness") then
			if npc.madness_cycle == 1 then
				npc.madness_cycle = 2
				JumpAbility:EndCooldown()
				return CastJumpAbility(random_point:GetAbsOrigin())
			elseif npc.madness_cycle == 2 then
				npc.madness_cycle = 1
				DivingAbility:EndCooldown()
				return CastDivingAbility(random_enemy_point:GetAbsOrigin())
			end
		end

		if npc.diving then
			npc.diving = false
			return CastJumpAbility(npc:GetAbsOrigin())
		end

		if boss_hp <= 25 then -- 4 стадия
			if MadnessAbility:IsFullyCastable() then
				return CastMadnessAbility()
			end
		end

		if boss_hp <= 50 then -- 3 стадия
			if TentacleDivingAbility:IsFullyCastable() then
				return CastTentacleDivingAbility(spawn_point:GetAbsOrigin())
			end

			if MovingAbility:IsFullyCastable() then
				return CastMovingAbility(random_point:GetAbsOrigin())
			end
		end

		if boss_hp < 75 then -- 2 стадия
			if DivingAbility:IsFullyCastable() then
				return CastDivingAbility(random_enemy_point:GetAbsOrigin())
			end

			if SuperWaveAbility:IsFullyCastable() then
				return CastSuperWaveAbility()
			end
		end

		if JumpAbility:IsFullyCastable() then
			return CastJumpAbility(farthest_point:GetAbsOrigin())
		end

		if WaveAbility:IsFullyCastable() then
			return CastWaveAbility(farthest_enemy:GetAbsOrigin())
		end

		if TentacleAbility:IsFullyCastable() then
			return CastTentacleAbility(random_enemy_point:GetAbsOrigin())
		end
	end
	return 0.5
end

function CastJumpAbility(position)
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = JumpAbility:entindex(),
		Position = position,
		Queue = false
	})

	return 0.5
end

function CastWaveAbility(position)
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = WaveAbility:entindex(),
		Position = position,
		Queue = false
	})

	return 0.5
end

function CastTentacleAbility(position)
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = TentacleAbility:entindex(),
		Position = position,
		Queue = false
	})

	return 0.5
end

function CastMovingAbility(position)
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = MovingAbility:entindex(),
		Position = position,
		Queue = false
	})

	return 0.5
end

function CastDivingAbility(position)
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = DivingAbility:entindex(),
		Position = position,
		Queue = false
	})
	npc.diving = true
	JumpAbility:EndCooldown()

	return 0.5
end

function CastTentacleDivingAbility(position)
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = TentacleDivingAbility:entindex(),
		Position = position,
		Queue = false
	})
	npc.diving = true
	JumpAbility:EndCooldown()

	return 0.5
end

function CastSuperWaveAbility()
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SuperWaveAbility:entindex(),
		Queue = false
	})
	return 0.5
end


function CastMadnessAbility()
	ExecuteOrderFromTable({
		UnitIndex = npc:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = MadnessAbility:entindex(),
		Queue = false
	})
	npc.madness_cycle = 1

	return 0.5
end
