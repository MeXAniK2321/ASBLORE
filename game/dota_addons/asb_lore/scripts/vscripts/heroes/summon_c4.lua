
function KillWolves( event )
	local caster = event.caster
	local targets = caster.wolves or {}
for _,unit in pairs(targets) do	
	if unit and IsValidEntity(unit) then
		unit:ForceKill(true)
		end
	end
-- Reset table
caster.wolves = {}
end

--[[
	Author: Noya
	Date: 20.01.2015.
	Gets the summoning forward direction for the new units
]]

function GetSummonPoints( event )

	local caster = event.caster
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local distance = event.distance
-- Gets 2 points facing a distance away from the caster origin and separated from each other at 30 degrees left and right
	
	
	ang_middle = QAngle(0, 0, 0)
local front_position = origin + fv * distance
	
	point_middle = RotatePosition(origin, ang_middle, front_position)
local result = { }
	
	table.insert(result, point_middle)
return result
end

-- Set the units looking at the same point of the caster
function SetUnitsMoveForward( event )
	local caster = event.caster
	local target = event.target
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
target:SetForwardVector(fv)
-- Add the target to a table on the caster handle, to find them later
table.insert(caster.wolves, target)
end