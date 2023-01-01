'use strict';


//[[function disable_ui () {
	//check ();
	//$.Msg("bro");
//}]]


function disable_ui(data) {
	var check2 = data.angles
	$.Msg(check2);
	var check1 = $.GetContextPanel().GetParent().GetParent()
    $.Msg(check1);
	check1.FindChildTraverse("CustomUIContainer_HudTopBar").style.opacity = 0;
	
	//$.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("combat_events").style.opacity = 0;
	
	$("#Background").style.opacity = 1;
	// $.Schedule(1.3, function() { checkcamera() })
	var check2 = $.GetContextPanel().FindChildInLayoutFile( "Background" );
	GameUI.SetCameraPitchMax(15);
	//GameUI.SetCameraPitchMax(90);
		GameUI.SetCameraDistance(550);
		//GameUI.SetCameraDistance(1134);
		GameUI.SetCameraYaw(data.angles);
		GameUI.SetCameraLookAtPositionHeightOffset(75);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false)
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false)
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_QUICK_STATS, false);
}
		
function checkcamera() {
GameUI.SetCameraYaw(-110);
GameUI.SetCameraPitchMax(15);
		GameUI.SetCameraLookAtPositionHeightOffset(25);
 $.Schedule(1.2, function() { checkcamera1() })
}

function checkcamera1() {
GameUI.SetCameraYaw(0);
}
		
function nanaya_screen() {	
 //$("#Background").style.visibility = 'collapse';
 
 $("#Background").style.opacity = 0;
 $("#gaysex").AddClass("animate");
 
$("#gaysex").Play();
	 $("#gaysex").style.visibility = 'visible';
	$("#gaysex").SetPlaybackVolume(10);
	var check2 = $.GetContextPanel();
	$.Msg(check2);
	
	$.Schedule(9.4, function() { $("#gaysex").style.visibility = 'collapse';
	 $("#gaysex").RemoveClass("animate");
	 enable_ui()});
	//$("#gaysex").Stop();
	//9.4
}
		
function enable_ui() {
	GameUI.SetCameraYaw(0);
	GameUI.SetCameraDistance(1134);
	GameUI.SetCameraLookAtPositionHeightOffset(100);
	GameUI.SetCameraPitchMax(0);
	var check1 = $.GetContextPanel().GetParent().GetParent()
	check1.FindChildTraverse("CustomUIContainer_HudTopBar").style.opacity = 1;
	
	$.GetContextPanel().FindChildInLayoutFile("Background").style.opacity = 0;
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, true);
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, true)
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, true)
		GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_QUICK_STATS, true);	
}
    
(function () {
	//Set panel visibility
	//$('#blackscrn').style.visibility = 'collapse';
	GameEvents.Subscribe( "disable_ui", disable_ui);
	GameEvents.Subscribe( "nanaya_screen", nanaya_screen);
	GameEvents.Subscribe( "enable_ui", enable_ui);
	
})();


