
------------------------------------------------------------------------------------------------------------------------------------------------------------
---EVENT: OnNPCSpawned
------------------------------------------------------------------------------------------------------------------------------------------------------------
function COverthrowGameMode:OnNPCSpawned(hEventTable)
	local spawnedUnit = EntIndexToHScript(hEventTable.entindex)

	if IsNotNull(spawnedUnit)
		and type(spawnedUnit.UpgradeLearnedAbilities) == "function" then
		spawnedUnit:UpgradeLearnedAbilities()
		--print(spawnedUnit:GetName())
	end
end
