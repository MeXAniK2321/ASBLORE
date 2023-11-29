

_G.nNEUTRAL_TEAM = 4
_G.nCOUNTDOWNTIMER = 990
_G.AnimeGameKills = 0
_G.CurrentMusic = {}
_G.MusicBox = {}
_G.CurrentMusicUltima = {}
_G.SoundCheck = {}
_G.ToumaCombo = 0
_G.ToumaGenderCombo = 0
_G.LoreStartWithUlts = true
_G.LoreStartUltsCD = 400
---------------------------------------------------------------------------
-- COverthrowGameMode class
---------------------------------------------------------------------------
if COverthrowGameMode == nil then
	_G.COverthrowGameMode = class({}) 
	
end

---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------
require( "disconnect_events" )
require("anime_events")
require("anime_functions_server_client")
require("illusion")
require( "events" )
require('internal/util')
require('internal/gold_filter')
require("internal/custom_func")
require( "items" )
require( "utility_functions" )
require("playertables")
require("timers")
require("libraries/physics")
require("vector_target")
require("anime_control_keys")
require("anime_chatwheel")
require("addon_init")
require("modifiers/modifiers")
require("functions/functions")
require('libraries/animations')
require('libraries/projectiles')
require("modifiers/player")
require("util/tempTable")
require("anime_modifiers_server_client")

--require('libraries/ai_behaviours')
--require('ai/core/ai_core')

---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
function Precache( context )
	--Cache the gold bags
		PrecacheItemByNameSync( "item_bag_of_gold", context )
		PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )	

		PrecacheItemByNameSync( "item_treasure_chest", context )
		PrecacheModel( "item_treasure_chest", context )

	--Cache the creature models
		PrecacheUnitByNameSync( "npc_dota_creature_basic_zombie", context )
        PrecacheModel( "npc_dota_creature_basic_zombie", context )

        PrecacheUnitByNameSync( "npc_dota_creature_berserk_zombie", context )
        PrecacheModel( "npc_dota_creature_berserk_zombie", context )

        PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )
        PrecacheModel( "npc_dota_treasure_courier", context )

    -- Cache Particle for fountain range
		PrecacheResource( "particle", "particles/heroes/anime_hero_kc/kc_erase_ring.vpcf", context )
	
	--Cache new particles
       	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
       	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
       	PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
		PrecacheResource( "particle", "particles/lyre_shockwave.vpcf", context )
       	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
       	PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
       	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
       	PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )
       	PrecacheResource( "particle", "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", context )
       	PrecacheResource( "particle", "particles/econ/items/lone_druid/lone_druid_cauldron/lone_druid_bear_entangle_dust_cauldron.vpcf", context )
       	PrecacheResource( "particle", "particles/newplayer_fx/npx_landslide_debris.vpcf", context )
		PrecacheResource( "particle", "particles/hien.vpcf", context )
		PrecacheResource( "particle", "particles/crucible.vpcf", context )
		PrecacheResource( "particle", "particles/chomusuke.vpcf", context )
		PrecacheResource( "particle", "particles/plot_armor.vpcf", context )
		
       	
	--Cache particles for traps
		PrecacheResource( "particle", "particles/generic_buff_2.vpcf", context )
		PrecacheResource( "particle", "particles/holy_lyre_aura_spd.vpcf", context )
		PrecacheResource( "particle", "particles/spd_great.vpcf", context )
		PrecacheResource( "particle", "particles/attack_great.vpcf", context )
		PrecacheResource( "particle", "particles/holy_lyre_aura.vpcf", context )
		PrecacheResource( "particle", "particles/holy_lyre_aura_armor.vpcf", context )
		PrecacheResource( "particle", "particles/holy_lyre_aura_diff.vpcf", context )
		PrecacheResource( "particle", "particles/altair_explosion2.vpcf", context )
		PrecacheResource( "particle", "particles/armor_great.vpcf", context )
		PrecacheResource( "particle", "particles/emergency_food.vpcf", context )
		PrecacheResource( "particle", "particles/blink_dagger_ti9_lvl2_end1.vpcf", context )
		PrecacheResource( "particle", "particles/blink_dagger_ti9_start1.vpcf", context )
		PrecacheResource( "particle", "particles/serp_molot1.vpcf", context )
		PrecacheResource( "particle", "particles/sword_circle.vpcf", context )
		PrecacheResource( "particle", "particles/sword_circle_exp.vpcf", context )
		PrecacheResource( "particle", "particles/test_hit.vpcf", context )
		PrecacheResource( "particle", "particles/judgment_end.vpcf", context )
		PrecacheResource( "particle", "particles/end_cut1.vpcf", context )
		PrecacheResource( "particle", "particles/devil_trigger.vpcf", context )
		PrecacheResource( "particle", "particles/devil_trigger_exp.vpcf", context )
		PrecacheResource( "particle", "particles/stul.vpcf", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_venomancer", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_life_stealer", context )

	--Cache sounds for traps
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_mars.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/naofumi.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/aizen.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/baal.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/yukari_yakumo.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/Hatsune_miku.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/billy.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/makima/makima.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/sans.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/kagamine_rin.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/pikachu.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/edward.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/esdeath_ability.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/reinforce.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/keyaru.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/ryougisounds.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/hero_nanaya.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/hero_muramasa.vsndevts", context )
        PrecacheResource( "soundfile", "soundevents/ichigosounds.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/keyaru_music.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/touma.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/tohka.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/tatsuya.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/ae86.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/kumagawa.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/hero_fa.vsndevts", context )
		PrecacheResource( "model", "models/susano/susano1.vmdl", context )
		PrecacheResource( "model", "models/shinobu_vampie/shinobu_success.vmdl", context )
		PrecacheResource( "model", "models/yoshinon/yoshino.vmdl", context )
		PrecacheResource( "model", "models/zayac/zayac.vmdl", context )
		PrecacheResource( "model", "models/bogdan/hurk.vmdl", context )
		PrecacheResource( "model", "models/tohka/arcana/tohka_arcana.vmdl", context )
		PrecacheResource( "model", "models/tohka/inversion/inversion_arcana.vmdl", context )
		PrecacheResource( "model", "models/hatsune_miku/arcana/arcana_form/arcana_monster.vmdl", context )
		
		PrecacheResource( "soundfile", "soundevents/yoshino.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/items/item_axis_sheet.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/esdeath_ability4.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/items/item_soul_scythe.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/items/item_ultra_instinct.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/anime_chatwheel.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_kunkka.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_legion_commander.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/items/item_minato_kunai.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/hero_themes.vsndevts", context )

		PrecacheResource( "soundfile", "soundevents/seva_nasral.vsndevts", context )

		PrecacheResource( "soundfile", "soundevents/items/item_walter_white.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/items/item_idol_water.vsndevts", context )
		
		-- Load Screen
        PrecacheResource( "soundfile", "soundevents/anime_special.vsndevts", context )
		-- Temporarily Here
		PrecacheResource( "soundfile", "soundevents/heroes/gogeta.vsndevts", context )
		PrecacheResource( "soundfile", "soundevents/kizuna_ai.vsndevts", context )
	    PrecacheResource("particle", 	"particles/custom/units/elite_creeps/legendary_creep/effect.vpcf", context)
		
end

function Activate()
	-- Create our game mode and initialize it
	COverthrowGameMode:InitGameMode()
	-- Custom Spawn
	
end



---------------------------------------------------------------------------
-- Initializer
---------------------------------------------------------------------------
function COverthrowGameMode:InitGameMode()
	print( "Overthrow is loaded." )
	
--	CustomNetTables:SetTableValue( "test", "value 1", {} );
--	CustomNetTables:SetTableValue( "test", "value 2", { a = 1, b = 2 } );

    -- Gold Filter
	local hGameModeEntity = GameRules:GetGameModeEntity()
    hGameModeEntity:SetModifyGoldFilter( self.OnModifyGoldFilter, self )
	GameRules:SetUseBaseGoldBountyOnHeroes( true )
	GameRules:SetFilterMoreGold( false )
    

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }	--		Teal
	self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.m_VictoryMessages = {}
	self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
	self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
	self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

	self.m_GatheredShuffledTeams = {}
	self.numSpawnCamps = 5
	self.specialItem = ""
	self.spawnTime = 80
	self.nNextSpawnItemNumber = 1
	self.hasWarnedSpawn = false
	self.allSpawned = false
	self.leadingTeam = -1
	self.runnerupTeam = -1
	self.leadingTeamScore = 0
	self.runnerupTeamScore = 0
	self.isGameTied = true
	self.countdownEnabled = false
	self.itemSpawnIndex = 1
	self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
	self.tier1ItemBucket = {}
	self.tier2ItemBucket = {}
	self.tier3ItemBucket = {}
	self.tier4ItemBucket = {}

	self.TEAM_KILLS_TO_WIN = 50
	self.CLOSE_TO_VICTORY_THRESHOLD = 5
	


	---------------------------------------------------------------------------

	self:GatherAndRegisterValidTeams()

	GameRules:GetGameModeEntity().COverthrowGameMode = self
	
	
	

	-- Adding Many Players
	if GetMapName() == "ruin_solo" then
	    GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(0)
		GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(60)
		GameRules:SetCustomGameBansPerTeam(0)
		self.m_GoldRadiusMin = 250
		self.m_GoldRadiusMax = 550
		self.m_GoldDropPercent = 15
		elseif GetMapName() == "balance_duo" then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(0)
		GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(45)
		GameRules:SetCustomGameBansPerTeam(0)
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 2 )
			self.m_GoldRadiusMin = 400
		self.m_GoldRadiusMax = 700
		self.m_GoldDropPercent = 15
        elseif GetMapName() == "birzhamemov_5v5" then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( IsInToolsMode() and 0 or 20.0 )
		GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(45)
		GameRules:SetCustomGameBansPerTeam(1)
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
		self.m_GoldRadiusMin = 100
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 20
		self.effectradius = 1400
	elseif GetMapName() == "desert_quintet" then
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( IsInToolsMode() and 0 or 20.0 )
		GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(45)
		GameRules:SetCustomGameBansPerTeam(2)
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 5 )
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 35
	elseif GetMapName() == "temple_quartet" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 3 )
		self.m_GoldRadiusMin = 300
		self.m_GoldRadiusMax = 1400
		self.m_GoldDropPercent = 35
	elseif GetMapName() == "asb_fate_nasral" then
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 7 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 7 )
		GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(45)
		GameRules:SetCustomGameBansPerTeam(7)
		self.m_GoldRadiusMin = 600
		self.m_GoldRadiusMax = 3000
		self.m_GoldDropPercent = 0
		CreateUnitByName("npc_dota_xp_global", Vector(944, 2120, 368), false, nil, nil, DOTA_TEAM_NOTEAM)
	else
		self.m_GoldRadiusMin = 250
		self.m_GoldRadiusMax = 550
		self.m_GoldDropPercent = 15
	end
	

	-- Show the ending scoreboard immediately
	
	GameRules:SetCustomGameEndDelay( 0 )
	
	GameRules:SetCustomVictoryMessageDuration( 10 )
	GameRules:SetPreGameTime( 10 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(true)
	--GameRules:SetHideKillMessageHeaders( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
	GameRules:SetHideKillMessageHeaders( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , false ) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true ) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, false ) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, false ) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, true ) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, false ) --Arcane
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, true ) --Bounty
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 0 )
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 0 )
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( COverthrowGameMode, "BountyRunePickupFilter" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( COverthrowGameMode, "ExecuteOrderFilter" ), self )

	GameRules:GetGameModeEntity():SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESIST, 0)

	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( COverthrowGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( COverthrowGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( COverthrowGameMode, 'OnTeamKillCredit' ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( COverthrowGameMode, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( COverthrowGameMode, "OnItemPickUp"), self )
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( COverthrowGameMode, "OnNpcGoalReached" ), self )
	ListenToGameEvent( "player_disconnect", Dynamic_Wrap( COverthrowGameMode, "OnDisconnect"), self)
	

	Convars:RegisterCommand( "overthrow_force_item_drop", function(...) self:ForceSpawnItem() end, "Force an item drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_gold_drop", function(...) self:ForceSpawnGold() end, "Force gold drop.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_set_timer", function(...) return SetTimer( ... ) end, "Set the timer.", FCVAR_CHEAT )
	Convars:RegisterCommand( "overthrow_force_end_game", function(...) return self:EndGame( DOTA_TEAM_GOODGUYS ) end, "Force the game to end.", FCVAR_CHEAT )
	Convars:SetInt( "dota_server_side_animation_heroesonly", 0 )

	COverthrowGameMode:SetUpFountains()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 


	-- Spawning monsters
	spawncamps = {}
	for i = 1, self.numSpawnCamps do
		local campname = "camp"..i.."_path_customspawn"
		spawncamps[campname] =
		{
			NumberToSpawn = RandomInt(3,5),
			WaypointName = "camp"..i.."_path_wp1"
		}
	end
	
end

---------------------------------------------------------------------------
-- Set up fountain regen
---------------------------------------------------------------------------
function COverthrowGameMode:SetUpFountains()

	LinkLuaModifier( "modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_linken_lua", "modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_knockback", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fountain_damage", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_fount_invul", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifiers/modifier_fount_invul_effect", LUA_MODIFIER_MOTION_NONE )

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		--print("fountain unit " .. tostring( fountainEnt ) )
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_linken_lua", {} )
		--fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_knockback", {} )
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_damage", {} )
	end
	
	-- Fountain Rings Credits: @EYEOFLIE
	Timers:CreateTimer(1, function()
      if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        return 1
      end
        
		local hFountainEnts = Entities:FindAllByClassname("ent_dota_fountain")
        for _, hFountainEnt in pairs(hFountainEnts) do
            if IsNotNull(hFountainEnt) then
                --local iIDFowViewer = AddFOWViewer(hFountainEnt:GetTeamNumber(), hFountainEnt:GetAbsOrigin(), 2750, 99999, false)
                --print(iIDFowViewer, "PEPEGS")
                local iRingPFX =    ParticleManager:CreateParticle("particles/heroes/anime_hero_kc/kc_erase_ring.vpcf", PATTACH_WORLDORIGIN, nil)
                                    ParticleManager:SetParticleShouldCheckFoW(iRingPFX, false)
                                    ParticleManager:SetParticleControl(iRingPFX, 0, hFountainEnt:GetAbsOrigin())
                                    ParticleManager:SetParticleControl(iRingPFX, 1, Vector(hFountainEnt:Script_GetAttackRange() + hFountainEnt:GetAttackRangeBuffer(), 0, 0))
                                    ParticleManager:SetParticleControl(iRingPFX, 2, hFountainEnt:GetAbsOrigin())

                                    ParticleManager:SetParticleControl(iRingPFX, 60, Vector(255, 0, 0))
                                    ParticleManager:SetParticleControl(iRingPFX, 61, Vector(255, 0, 0))
                                    ParticleManager:SetParticleControl(iRingPFX, 62, Vector(255, 0, 0))

            end
        end
	end)
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function COverthrowGameMode:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
function COverthrowGameMode:EndGame( victoryTeam )
	local overBoss = Entities:FindByName( nil, "@overboss" )
	if overBoss then
		local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
		if celebrate then
			overBoss:CastAbilityNoTarget( celebrate, -1 )
		end
	end

	GameRules:SetGameWinner( victoryTeam )
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function COverthrowGameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end


---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function COverthrowGameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	-- table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	-- for _, t in pairs( sortedTeams ) do
	-- 	local clr = self:ColorForTeam( t.teamID )

	-- 	-- Scaleform UI Scoreboard
	-- 	local score = 
	-- 	{
	-- 		team_id = t.teamID,
	-- 		team_score = t.teamScore
	-- 	}
	-- 	FireGameEvent( "score_board", score )
	-- end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	self.leadingTeam = leader
	self.runnerupTeam = sortedTeams[2].teamID
	--self.thirdTeam = sortedTeams[3].teamID
	self.leadingTeamScore = sortedTeams[1].teamScore
	self.runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		self.isGameTied = true
	else
		self.isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
       			if existingParticle == -1 then
       				local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function COverthrowGameMode:OnThink()
	for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	self:UpdateScoreboard()
	-- Stop thinking if game is paused
	if GameRules:IsGamePaused() == true then
        return 1
    end

	if self.countdownEnabled == true then
		CountdownTimer()
		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end
		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if self.isGameTied == false then
				GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
				COverthrowGameMode:EndGame( self.leadingTeam )
				self.countdownEnabled = false
			else
				self.AnimeGameKills = self.leadingTeamScore + 1
				local anime_killcount = 
				{
					killcount = self.AnimeGameKills
				}
				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", anime_killcount )
			end
       	end
	end
	
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--Spawn Gold Bags
		COverthrowGameMode:ThinkGoldDrop()
		COverthrowGameMode:ThinkSpecialItemDrop()
	end
	

	return 1
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function COverthrowGameMode:GatherAndRegisterValidTeams()
--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
	
	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

	self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	print( "Final shuffled team list:" )
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	end

	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0
		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

-- Spawning individual camps
function COverthrowGameMode:spawncamp(campname)
	spawnunits(campname)
end

-- Simple Custom Spawn


--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function COverthrowGameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
	]]

	local orderType = filterTable["order_type"]
	if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
		return true
	else
		local item = EntIndexToHScript( filterTable["entindex_target"] )
		if item == nil then
			return true
		end
		local pickedItem = item:GetContainedItem()
		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end
		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 9 then
				--print("inventory has space")
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()
				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
				return true
			end
		end
	end
	return true
end

