local THINK = 1.0

function Spawn( entityKeyValues )
	if(not IsServer()) then
		return
	end
	if (thisEntity == nil) then
		return
	end
	thisEntity:SetContextThink("PetPremiumThink", PetPremiumThink, THINK)
end

function PetPremiumThink()
	if thisEntity.PID == nil then
		thisEntity.PID = thisEntity:GetPlayerOwnerID()
	end
	
	local OWNER = PlayerResource:GetSelectedHeroEntity(thisEntity.PID)
	local Owner_location = OWNER:GetAbsOrigin()
	local Owner_team = OWNER:GetTeam()
	local Pet_location = thisEntity:GetAbsOrigin()
	local vector_distance = Owner_location - Pet_location
	local distance = vector_distance:Length2D()
	
	if OWNER:FindAbilityByName("phoenix_fire_spirits_custom") then
		thisEntity:RemoveAbility("pocket_phoenix_fire_spirits")
	end
	
	
	if distance > 400 and distance < 900 then
		local order = 
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			TargetIndex = OWNER:entindex()
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
		thisEntity:SetAbsOrigin(Owner_location + RandomVector( RandomFloat(0, 100)))
	end
	return THINK
end