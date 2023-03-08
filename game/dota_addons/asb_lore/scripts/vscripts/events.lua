-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
LinkLuaModifier( "modifier_replaced", "items/item_pandora_replacer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disconnect", "modifier_disconnect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pukachu_replaced", "modifiers/modifier_pukachu_replaced", LUA_MODIFIER_MOTION_NONE )
-- Cleanup a player when they leave
function COverthrowGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	local state = GameRules:State_Get()
	local map_name = GetMapName()
	local EachPlayerKill  = 2
	--print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
     
	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		local numberOfPlayers = PlayerResource:GetPlayerCount()
		if numberOfPlayers > 7 then
			--self.AnimeGameKills = 25
			nCOUNTDOWNTIMER = 2800
		elseif numberOfPlayers > 4 and numberOfPlayers <= 7 then
			--self.AnimeGameKills = 20
			nCOUNTDOWNTIMER = 2600
		else
			--self.AnimeGameKills = 15
			nCOUNTDOWNTIMER = 2400
		end
		if GetMapName() == "forest_solo" then
			self.AnimeGameKills = 30
			self.ban  = 0
		elseif GetMapName() == "balance_duo" then
			self.AnimeGameKills = 48
			self.ban = 1
        elseif GetMapName() == "mines_trio" then
			self.AnimeGameKills = 60		
            self.ban = 0			
		elseif GetMapName() == "desert_quintet" then
			self.AnimeGameKills = 100
		elseif GetMapName() == "temple_quartet" then
			self.AnimeGameKills = 100
		else
			self.AnimeGameKills = 30
		end
		--print( "Kills to win = " .. tostring(self.AnimeGameKills) )
		AnimeGameKills = math.ceil(self.AnimeGameKills + (EachPlayerKill * numberOfPlayers))
		self.AnimeGameKills = AnimeGameKills
		CustomNetTables:SetTableValue( "game_state", "victory_condition", {kills_to_win = AnimeGameKills} );
		

		self._fPreGameStartTime = GameRules:GetGameTime()
    	
	    --      	local pause = function(pause)
		-- 	GameRules:GetGameModeEntity():SetPauseEnabled(false)
		-- 	PauseGame(pause)
		-- end

		-- pause(true)

    	-- GameRules:GetGameModeEntity():SetContextThink( "OnGameStartUnpauseGame10Sec", function() return pause(false) end, 10)
      
    end
	

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then		
		self.countdownEnabled = true
		CustomGameEventManager:Send_ServerToAllClients( "show_timer", {} )
		DoEntFire( "center_experience_ring_particles", "Start", "0", 0, self, self  )
	end
end

--------------------------------------------------------------------------------
-- Event: OnNPCSpawned
--------------------------------------------------------------------------------
function COverthrowGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit:IsRealHero() then
		local player = EntIndexToHScript(event.entindex)
		local playerID = player:GetPlayerID()
		local playerSteamID = PlayerResource:GetSteamAccountID(playerID)

		if IsPlayerDisconnected(playerID) then
	        player:AddNewModifier(player, nil, "modifier_disconnect", {})
		end
		-- Destroys the last hit effects
		local deathEffects = spawnedUnit:Attribute_GetIntValue( "effectsID", -1 )
		if deathEffects ~= -1 then
			ParticleManager:DestroyParticle( deathEffects, true )
			spawnedUnit:DeleteAttribute( "effectsID" )
		end
		
		local PID = player:GetPlayerOwnerID()
	    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
		local hero = PlayerResource:GetSelectedHeroEntity(PID)
	
			if IsASBAdmin(player) then
				--local item = CreateItem("item_gay_hammer", player, self)
				if player:HasModifier( "modifier_replaced" ) then
				else
	    			--player:AddItem(item)
					player:AddNewModifier(caster, self, "modifier_replaced", {})
				end
			end
	   
			if player:GetUnitName() == "npc_dota_hero_axe" then
				if IsASBPatreon(player) then
					player:SetOriginalModel("models/bogdan/hurk.vmdl")
					player:SetModelScale(1.4)
				end
			end

			if player:GetUnitName() == "npc_dota_hero_alchemist" then
				if IsASBPatreon(player) then
					player:SetOriginalModel("models/goku/drip/drip_goku.vmdl")
					player:SetModelScale(1.0)
				end
			end

			if player:GetUnitName() == "npc_dota_hero_sven" then
				if IsASBPatreon(player) then
					player:SetOriginalModel("models/tohka/arcana/tohka_arcana.vmdl")
					player:SetModelScale(1.4)
				end
			end

			if player:GetUnitName() == "npc_dota_hero_terrorblade" then
				if IsASBPatreon(player) then
					player:SetOriginalModel("models/hatsune_miku/arcana/arcana_form/arcana_monster.vmdl")
					player:SetModelScale(1.25)
				end
			end
	

		if self.allSpawned == false then
			if GetMapName() == "mines_trio" then
				--print("mines_trio is the map")
				--print("self.allSpawned is " .. tostring(self.allSpawned) )
				local unitTeam = spawnedUnit:GetTeam()
				local particleSpawn = ParticleManager:CreateParticleForTeam( "particles/addons_gameplay/player_deferred_light.vpcf", PATTACH_ABSORIGIN, spawnedUnit, unitTeam )
				ParticleManager:SetParticleControlEnt( particleSpawn, PATTACH_ABSORIGIN, spawnedUnit, PATTACH_ABSORIGIN, "attach_origin", spawnedUnit:GetAbsOrigin(), true )
			end
		end

			local FastAbilities = 
			{
				"determination",
				"do_you_wanna_touch_the_child",
				"frisk_return",
				"knife_dance",
				"knife_toss",
				"mercyfull_reaper",
				"devilovania",
				"true_fear",
				"pleades",
				"sin_blood_pact",
				"lunatic_nightmare",
				"deidara_c4",
				"issei_promotion",
				"subaru_heart_crash",
				"exploding_dignity",
				"mael_sun",
				"world_revolwing",
				"cerceus",
				"chocolate",
				"aegis_activate",
				"appolon_bow",
				"artemis_launcher",
				"uranys_system_initialization",
				"rimuru_demon_lord",
				"slime_shot",
				"rimuru_black_lightning",
				"rimuru_beelzebub",
				"rimuru_harvest_festival",
				"rimuru_merciless",
				"good_loser",
				"start_hunting",
				"death_exe",
				"yoshino_black_age",
				"yoshino_black_blizzard",
				"pop_up_kick",
				"pop_up_murder",
				"kigurumi_overheat",
				"tanjiro_9",
				"rumia_ex_slash",
				"rumia_guilty",
				"rumia_step_of_darkness",
				"rumia_backwark_slash",
				"rumia_night_time",
				"slark_shadow_dance_lua",
				"shadow_fiend_necromastery_lua",
				"dante_hell_rockets",
				"dante_hell_portal",
				"dante_striptiz",
				"vision_hunt_decree",
				"divine_punishment",
				"blood_chains_palace",
				"blood_arc",
				"blood_moon_rise",
				"neko_punch",
				"neko_jump",
				"chibi_army",
				"edward_armor_alchemy",
				"edward_stone_spikes",
						"archetype_light_collumn",
				"archetype_last_arc",
				"archetype_earth",
					"sans_punch",
				"sans_slap",
						"circle_gaster_blaster",
				"sans_evade",
				"sans_global_shortcut",
				"sans_multiple_boner",
				"style_close",
				"shield_hero",
				"shield_book_close",
				"rage_shield_close",
				"black_gas_burning",
				"wrath_fire",
				"naofumi_fast_heal",
				"blood_sacrifice",

				-- "tohka_inversion", --ULTIMATES LEARN'S ON 30 LVL
				-- "tatsuya_seal_off", --ULTIMATES LEARN'S ON 30 LVL
				"regrowth",
				"flash_cast",
			}

			for _,FastAbility in pairs(FastAbilities) do
				FastAbility = spawnedUnit:FindAbilityByName(FastAbility)
				if spawnedUnit:IsRealHero() then
				    if FastAbility then
				        FastAbility:SetLevel(1)
				    end
				end
			end

	end
end

--------------------------------------------------------------------------------
-- Event: BountyRunePickupFilter
--------------------------------------------------------------------------------
function COverthrowGameMode:BountyRunePickupFilter( filterTable )
      filterTable["xp_bounty"] = 2*filterTable["xp_bounty"]
      filterTable["gold_bounty"] = 2*filterTable["gold_bounty"]
      return true
end

---------------------------------------------------------------------------
-- Event: OnTeamKillCredit, see if anyone won
---------------------------------------------------------------------------
function COverthrowGameMode:OnTeamKillCredit( event )
--	print( "OnKillCredit" )
--	DeepPrint( event )

	local nKillerID = event.killer_userid
	local nTeamID = event.teamnumber
	local nTeamKills = event.herokills
	local nKillsRemaining = self.AnimeGameKills - nTeamKills
	
	local broadcast_kill_event =
	{
		killer_id = event.killer_userid,
		team_id = event.teamnumber,
		team_kills = nTeamKills,
		kills_remaining = nKillsRemaining,
		victory = 0,
		close_to_victory = 0,
		very_close_to_victory = 0,
	}

	if nKillsRemaining <= 0 then
		GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[nTeamID] )
		GameRules:SetGameWinner( nTeamID )
		broadcast_kill_event.victory = 1
	elseif nKillsRemaining == 1 then
		EmitGlobalSound( "ui.npe_objective_complete" )
		broadcast_kill_event.very_close_to_victory = 1
	elseif nKillsRemaining <= self.CLOSE_TO_VICTORY_THRESHOLD then
		EmitGlobalSound( "ui.npe_objective_given" )
		broadcast_kill_event.close_to_victory = 1
	end

	CustomGameEventManager:Send_ServerToAllClients( "kill_event", broadcast_kill_event )
end

---------------------------------------------------------------------------
-- Event: OnEntityKilled
---------------------------------------------------------------------------
function COverthrowGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	local extraTime = 0
	if killedUnit:IsRealHero() then
		self.allSpawned = true
		--print("Hero has been killed")
		--Add extra time if killed by Necro Ult
		
		if hero:IsRealHero() and heroTeam ~= killedTeam then
			--print("Granting killer xp")
			if killedUnit:GetTeam() == self.leadingTeam and self.isGameTied == false then
			local level_target = killedUnit:GetLevel()
            local level_unit = hero:GetLevel()		
                if level_unit > 17 then			
			   local expirience = -(level_target * 53)
			     hero:AddExperience( expirience, 0, false, false )
				 end
				local memberID = hero:GetPlayerID()
				local kill_bounty_lead = (GameRules:GetGameTime() * 0.3) + 400
				PlayerResource:ModifyGold( memberID, kill_bounty_lead, true, 0 )
				
				local name = hero:GetClassname()
				local victim = killedUnit:GetClassname()
				local kill_alert =
					{
						hero_id = hero:GetClassname()
					}
				CustomGameEventManager:Send_ServerToAllClients( "kill_alert", kill_alert )
			else
						 local level_target = killedUnit:GetLevel()
            local level_unit = hero:GetLevel()		
                if level_unit > 17 then			
			   local expirience = -(level_target * 53)
			     hero:AddExperience( expirience, 0, false, false )
				 end
			    local memberID = hero:GetPlayerID()
			    local kill_bounty = (GameRules:GetGameTime() * 0.3)
				PlayerResource:ModifyGold( memberID, kill_bounty, true, 0 )
			end
		end
		if killedUnit:GetRespawnTime() > 5 then
			--print("Hero has long respawn time")
			if killedUnit:IsReincarnating() == true then
				--print("Set time for Wraith King respawn disabled")
				return nil
			else
				COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
			end
		else
			COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
		end
	end
end
function COverthrowGameMode:OnDisconnect(event)
  	local player_id = event.PlayerID
  	local hPlayer = PlayerResource:GetPlayer(player_id)
	local GameState = GameRules:State_Get()

	if GameState >= DOTA_GAMERULES_STATE_HERO_SELECTION and GameState <= DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
    	if PlayerResource:IsValidPlayerID(player_id) and hPlayer and not PlayerResource:HasSelectedHero(player_id) then
          	hPlayer:MakeRandomHeroSelection()
        end
    end

    
end


function COverthrowGameMode:SetRespawnTime( killedTeam, killedUnit, extraTime )
    	
 local ability = killedUnit:FindAbilityByName("all_fiction_self")
 

  if killedUnit:GetUnitName()== "npc_dota_hero_faceless_void" and killedUnit:HasModifier("modifier_all_fiction_self") then
	killedUnit:SetTimeUntilRespawn(0)
	elseif killedUnit:HasModifier("modifier_debuff_10") or  killedUnit:HasModifier("modifier_emit_video") then
	killedUnit:SetTimeUntilRespawn(25)
elseif
 killedTeam == self.leadingTeam  then
		killedUnit:SetTimeUntilRespawn( 10 )
		elseif
 killedTeam == self.runnerupTeam  then
		killedUnit:SetTimeUntilRespawn( 10 )
		elseif
 killedTeam == self.thirdTeam  then
		killedUnit:SetTimeUntilRespawn( 10 )
	else 
killedUnit:SetTimeUntilRespawn( 2 )
end
end
--------------------------------------------------------------------------------
-- Event: OnItemPickUp
--------------------------------------------------------------------------------
function COverthrowGameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	r = 300
	--r = RandomInt(200, 400)
	if event.itemname == "item_bag_of_gold" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Stop", "0", 0, self, self )
		COverthrowGameMode:SpecialItemAdd( event )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end


--------------------------------------------------------------------------------
-- Event: OnNpcGoalReached
--------------------------------------------------------------------------------
function COverthrowGameMode:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )
	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		COverthrowGameMode:TreasureDrop( npc )
	end
end




_G.registeredCustomEventListeners = registeredCustomEventListeners or {}
for _, listenerId in ipairs(registeredCustomEventListeners) do
    CustomGameEventManager:UnregisterListener(listenerId)
end

function RegisterCustomEventListener(eventName, callback)
    local listenerId = CustomGameEventManager:RegisterListener(eventName, function(_, args)
        callback(args)
    end)

    table.insert(registeredCustomEventListeners, listenerId)
end

_G.registeredGameEventListeners = registeredGameEventListeners or {}
for _, listenerId in ipairs(registeredGameEventListeners or {}) do
    StopListeningToGameEvent(listenerId)
end

function RegisterGameEventListener(eventName, callback)
    local listenerId = ListenToGameEvent(eventName, callback, nil)
    
    table.insert(registeredGameEventListeners, listenerId)
end

function DisplayError(playerId, message)
    local player = PlayerResource:GetPlayer(playerId)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = message })
    end
end