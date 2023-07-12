------------------------------------------------------------------------------------------------------------------------------------------------------------
---FILTER: OnModifyGoldFilter
------------------------------------------------------------------------------------------------------------------------------------------------------------
function COverthrowGameMode:OnModifyGoldFilter(hFilterTable)
	--if hFilterTable.reason_const == DOTA_ModifyGold_GameTick then return end
	--DeepPrintTable(hFilterTable)

		if hFilterTable.reason_const == DOTA_ModifyGold_HeroKill then
			local hKilledHero = ( type(hFilterTable.source_entindex_const) == "number" ) and EntIndexToHScript(hFilterTable.source_entindex_const) or nil
			if IsNotNull(hKilledHero) then
				local nLevelDifference = math.max(0, hKilledHero:GetLevel() - PlayerResource:GetLevel(hFilterTable.player_id_const) )

				hFilterTable.gold = ( 100 + nLevelDifference * 50 ) * 0.5 --+ ( (GameRules:GetDOTATime(false, false) / 60) * 50 )
				print(hFilterTable.gold)
			end
		end

	return true
end