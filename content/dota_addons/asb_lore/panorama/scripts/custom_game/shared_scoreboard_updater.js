"use strict";
var END_GAME_VALUE = {};
GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD = GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD || {};
//=============================================================================
//=============================================================================
function _ScoreboardUpdater_SetTextSafe( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName )
	if ( childPanel === null )
		return;
	
	childPanel.text = textValue;
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
{
	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playersContainer, playerPanelName );
		playerPanel.SetAttributeInt( "player_id", playerId );
		playerPanel.BLoadLayout( scoreboardConfig.playerXmlName, false, false );
	}

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
	
	var ultStateOrTime = PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN; // values > 0 mean on cooldown for that many seconds
	var goldValue = -1;
	var isTeammate = false;

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( playerInfo )
	{
		isTeammate = ( playerInfo.player_team_id == localPlayerTeamId );
		if ( isTeammate )
		{
			ultStateOrTime = Game.GetPlayerUltimateStateOrTime( playerId );
		}
		goldValue = playerInfo.player_gold;
		
		playerPanel.SetHasClass( "player_dead", ( playerInfo.player_respawn_seconds >= 0 ) );
		playerPanel.SetHasClass( "local_player_teammate", isTeammate && ( playerId != Game.GetLocalPlayerID() ) );

		_ScoreboardUpdater_SetTextSafe( playerPanel, "RespawnTimer", ( playerInfo.player_respawn_seconds + 1 ) ); // value is rounded down so just add one for rounded-up
		_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerName", playerInfo.player_name );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Level", playerInfo.player_level );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Kills", playerInfo.player_kills );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Deaths", playerInfo.player_deaths );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Assists", playerInfo.player_assists );

		var playerPortrait = playerPanel.FindChildInLayoutFile( "HeroIcon" );
		if ( playerPortrait )
		{
			if ( playerInfo.player_selected_hero !== "" )
			{
				var hero_entindex = Players.GetPlayerHeroEntityIndex( playerId )
				if (playerInfo.player_selected_hero == "npc_dota_hero_abaddon")
				{
			    		playerPortrait.SetImage( "file://{images}/custom_game/hight_hood/heroes/vergil.png" );
                }
               else if (playerInfo.player_selected_hero == "npc_dota_hero_alchemist")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/goku.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_axe")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/bogdan.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_elder_titan")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/reinforce.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_beastmaster")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/billy.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_bristleback")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/accelerator.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_bounty_hunter")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/edward_elric.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_chaos_knight")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/flandre.png" );
				}
					else if (playerInfo.player_selected_hero == "npc_dota_hero_sven")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/tohka.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_tidehunter")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/naofumi.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_slark")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/arcueid.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_dragon_knight")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/issei.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_life_stealer")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/shuichi.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_omniknight")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/keyaru.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_pangolier")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/ulquiorra.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_kunkka")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/madara.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_antimage")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/tanjiro.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_phantom_lancer")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/baal.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_lycan")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/jellal.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_magnataur")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/kambe.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_night_stalker")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/subaru.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_juggernaut")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/ikki.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_centaur")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/shu.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_undying")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/touma.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_pudge")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/pika.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_abyssal_underlord")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/escanor.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_bloodseeker")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/aizen.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_tusk")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/shinobu.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_drow_ranger")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/ikaros.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_faceless_void")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/kumagawa.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_monkey_king")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/mori.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_naga_siren")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/brs.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_nyx_assassin")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/kurapika.png" );
				}
					else if (playerInfo.player_selected_hero == "npc_dota_hero_nevermore")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/rumia.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_spectre")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/frisk.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_terrorblade")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/miku.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_ursa")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/kanade.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_ancient_apparition")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/yoshino.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_bane")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/yukari.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_dark_seer")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/tsuna.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_dark_willow")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/jibril.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_obsidian_destroyer")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/pandora.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_lich")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/sans.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_oracle")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/rimuru.png" );
				}
					else if (playerInfo.player_selected_hero == "npc_dota_hero_arc_warden")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/tatsuya.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_queenofpain")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/homura.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_techies")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/deidara.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_void_spirit")
				{
			    		playerPortrait.SetImage( "file://{images}/heroes/rin.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_winter_wyvern")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/lelouch.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_ember_spirit")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/shana.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_legion_commander")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/esdeath.png" );
				}
					else if (playerInfo.player_selected_hero == "npc_dota_hero_mars")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/dante.png" );
				}
					else if (playerInfo.player_selected_hero == "npc_dota_hero_riki")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/shiki.png" );
				}
				else if (playerInfo.player_selected_hero == "npc_dota_hero_chen")
				{
			    		playerPortrait.SetImage( "file://{images}heroes/new_leloch.png" );
				}
				else
				{
					playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
				}
			}
			else
			{
				playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
			}
		}

		playerPanel.SetHasClass( "player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
		playerPanel.SetHasClass( "player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
		playerPanel.SetHasClass( "player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );

		var playerAvatar = playerPanel.FindChildInLayoutFile( "AvatarImage" );
		if ( playerAvatar )
		{
			playerAvatar.steamid = playerInfo.player_steamid;
		}		

		var playerColorBar = playerPanel.FindChildInLayoutFile( "PlayerColorBar" );
		if ( playerColorBar !== null )
		{
			if ( GameUI.CustomUIConfig().team_colors )
			{
				var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
				if ( teamColor )
				{
					playerColorBar.style.backgroundColor = teamColor;
				}
			}
			else
			{
				var playerColor = "#000000";
				playerColorBar.style.backgroundColor = playerColor;
			}
		}
	}
	var heroNameAndDescription = playerPanel.FindChildInLayoutFile( "HeroNameAndDescription" );
		if ( heroNameAndDescription )
		{
			if ( playerInfo.player_selected_hero_id == -1 )
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#DOTA_Scoreboard_Picking_Hero" ) );
			}
			else
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#"+playerInfo.player_selected_hero ) );
			}
			heroNameAndDescription.SetDialogVariableInt( "hero_level",  playerInfo.player_level );
		}
	
	var playerItemsContainer = playerPanel.FindChildInLayoutFile( "PlayerItemsContainer" );
	if ( playerItemsContainer )
	{
		var playerItems = Game.GetPlayerItems( playerId );
		if ( playerItems )
		{
	//		$.Msg( "playerItems = ", playerItems );
			for ( var i = playerItems.inventory_slot_min; i < playerItems.inventory_slot_max; ++i )
			{
				var itemPanelName = "_dynamic_item_" + i;
				var itemPanel = playerItemsContainer.FindChild( itemPanelName );
				if ( itemPanel === null )
				{
					itemPanel = $.CreatePanel( "Image", playerItemsContainer, itemPanelName );
					itemPanel.AddClass( "PlayerItem" );
				}

				var itemInfo = playerItems.inventory[i];
				if ( itemInfo )
				{
					var item_image_name = "file://{images}/items/" + itemInfo.item_name.replace( "item_", "" ) + ".png"
					if ( itemInfo.item_name.indexOf( "recipe" ) >= 0 )
					{
						item_image_name = "file://{images}/items/recipe.png"
					}
					itemPanel.SetImage( item_image_name );
				}
				else
				{
					itemPanel.SetImage( "" );
				}
			}
		}
	}

	if ( isTeammate )
	{
		_ScoreboardUpdater_SetTextSafe( playerPanel, "TeammateGoldAmount", goldValue );
	}

	_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerGoldAmount", goldValue );

	playerPanel.SetHasClass( "player_ultimate_ready", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY ) );
	playerPanel.SetHasClass( "player_ultimate_no_mana", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA) );
	playerPanel.SetHasClass( "player_ultimate_not_leveled", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED) );
	playerPanel.SetHasClass( "player_ultimate_hidden", ( ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN) );
	playerPanel.SetHasClass( "player_ultimate_cooldown", ( ultStateOrTime > 0 ) );
	_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerUltimateCooldown", ultStateOrTime );
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateTeamPanel( scoreboardConfig, containerPanel, teamDetails, teamsInfo )
{
	if ( !containerPanel )
		return;

	var teamId = teamDetails.team_id;
//	$.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

	var teamPanelName = "_dynamic_team_" + teamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
//		$.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ", scoreboardConfig.teamXmlName );
		teamPanel = $.CreatePanel( "Panel", containerPanel, teamPanelName );
		teamPanel.SetAttributeInt( "team_id", teamId );
		teamPanel.BLoadLayout( scoreboardConfig.teamXmlName, false, false );

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if ( logo_xml )
		{
			var teamLogoPanel = teamPanel.FindChildInLayoutFile( "TeamLogo" );
			if ( teamLogoPanel )
			{
				teamLogoPanel.SetAttributeInt( "team_id", teamId );
				teamLogoPanel.BLoadLayout( logo_xml, false, false );
			}
		}
	}
	
	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}
	teamPanel.SetHasClass( "local_player_team", localPlayerTeamId == teamId );
	teamPanel.SetHasClass( "not_local_player_team", localPlayerTeamId != teamId );

	var teamPlayers = Game.GetPlayerIDsOnTeam( teamId )
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	if ( playersContainer )
	{
		for ( var playerId of teamPlayers )
		{
			_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
		}
	}
	
	teamPanel.SetHasClass( "no_players", (teamPlayers.length == 0) )
	teamPanel.SetHasClass( "one_player", (teamPlayers.length == 1) )
	
	if ( teamsInfo.max_team_players < teamPlayers.length )
	{
		teamsInfo.max_team_players = teamPlayers.length;
	}
if (GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId])
	{
		//$.Msg(GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId].teamScore, "   ", teamId);
		teamDetails.team_score = GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId].teamScore || 0;
	}
	_ScoreboardUpdater_SetTextSafe( teamPanel, "TeamScore", teamDetails.team_score )
	_ScoreboardUpdater_SetTextSafe( teamPanel, "TeamName", $.Localize( teamDetails.team_name ) )
	
	if ( GameUI.CustomUIConfig().team_colors )
	{
		var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
		var teamColorPanel = teamPanel.FindChildInLayoutFile( "TeamColor" );
		
		teamColor = teamColor.replace( ";", "" );

		if ( teamColorPanel )
		{
			teamNamePanel.style.backgroundColor = teamColor + ";";
		}
		
		var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile( "TeamColor_GradentFromTransparentLeft" );
		if ( teamColor_GradentFromTransparentLeft )
		{
			var gradientText = 'gradient( linear, 0% 0%, 800% 0%, from( #00000000 ), to( ' + teamColor + ' ) );';
//			$.Msg( gradientText );
			teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
		}
	}
	
	return teamPanel;
}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_ReorderTeam( scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel )
{
//	$.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
	var oldPlace = null;
	if ( GameUI.CustomUIConfig().teamsPrevPlace.length > teamId )
	{
		oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[ teamId ];
	}
	GameUI.CustomUIConfig().teamsPrevPlace[ teamId ] = newPlace;
	
	if ( newPlace != oldPlace )
	{
//		$.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
		teamPanel.RemoveClass( "team_getting_worse" );
		teamPanel.RemoveClass( "team_getting_better" );
		if ( newPlace > oldPlace )
		{
			teamPanel.AddClass( "team_getting_worse" );
		}
		else if ( newPlace < oldPlace )
		{
			teamPanel.AddClass( "team_getting_better" );
		}
	}

	teamsParent.MoveChildAfter( teamPanel, prevPanel );
}

// sort / reorder as necessary
function compareFunc( a, b ) // GameUI.CustomUIConfig().sort_teams_compare_func;
{
	if ( a.team_score < b.team_score )
	{
		return 1; // [ B, A ]
	}
	else if ( a.team_score > b.team_score )
	{
		return -1; // [ A, B ]
	}
	else
	{
		return 0;
	}
};

function stableCompareFunc( a, b )
{
	var unstableCompare = compareFunc( a, b );
	if ( unstableCompare != 0 )
	{
		return unstableCompare;
	}
	
	if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id )
	{
		return 0;
	}
	
	if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id )
	{
		return 0;
	}
	
//			$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

	var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[ a.team_id ];
	var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[ b.team_id ];
	if ( a_prev < b_prev ) // [ A, B ]
	{
		return -1; // [ A, B ]
	}
	else if ( a_prev > b_prev ) // [ B, A ]
	{
		return 1; // [ B, A ]
	}
	else
	{
		return 0;
	}
};

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, teamsContainer )
{
//	$.Msg( "_ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );
	
	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{	
		var hTeamDetails = Game.GetTeamDetails( teamId );
		if (GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId])
		{
			hTeamDetails.team_score = GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId].teamScore || 0;
		}
		
		teamsList.push( hTeamDetails );
	}


	// update/create team panels
	var teamsInfo = { max_team_players: 0 };
	var panelsByTeam = [];
	for ( var i = 0; i < teamsList.length; ++i )
	{
		var teamPanel = _ScoreboardUpdater_UpdateTeamPanel( scoreboardConfig, teamsContainer, teamsList[i], teamsInfo );
		if ( teamPanel )
		{
			panelsByTeam[ teamsList[i].team_id ] = teamPanel;
		}
	}

	if ( teamsList.length > 1 )
	{
//		$.Msg( "panelsByTeam: ", panelsByTeam );

		// sort
		if ( scoreboardConfig.shouldSort )
		{
			teamsList.sort( stableCompareFunc );
		}

//		$.Msg( "POST: ", teamsAndPanels );

		// reorder the panels based on the sort
		var prevPanel = panelsByTeam[ teamsList[0].team_id ];
		for ( var i = 0; i < teamsList.length; ++i )
		{
			var teamId = teamsList[i].team_id;
			var teamPanel = panelsByTeam[ teamId ];
			_ScoreboardUpdater_ReorderTeam( scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel );
			prevPanel = teamPanel;
		}
//		$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );
	}

//	$.Msg( "END _ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, scoreboardPanel )
{
	GameUI.CustomUIConfig().teamsPrevPlace = [];
	if ( typeof(scoreboardConfig.shouldSort) === 'undefined')
	{
		// default to true
		scoreboardConfig.shouldSort = true;
	}
	_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, scoreboardPanel );
	return { "scoreboardConfig": scoreboardConfig, "scoreboardPanel":scoreboardPanel }
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_SetScoreboardActive( scoreboardHandle, isActive )
{
	if ( scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}
	
	if ( isActive )
	{
		_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel );
	}
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetTeamPanel( scoreboardHandle, teamId )
{
	if ( scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}
	
	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild( teamPanelName );
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList( scoreboardHandle )
{
	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		var hTeamDetails = Game.GetTeamDetails( teamId );
		if (GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId])
		{
			hTeamDetails.team_score = GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD[teamId].teamScore || 0;
		}
		
		teamsList.push( hTeamDetails );
	}


	if ( teamsList.length > 1 )
	{
		teamsList.sort( stableCompareFunc );		
	}
	
	return teamsList;
}


function OnFireScoreBoard(args)
{
	GameUI.CustomUIConfig().ON_FIRE_SCORE_BOARD = args;
}

(function()
{
	GameEvents.Subscribe( "score_board", OnFireScoreBoard );
})();