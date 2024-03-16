(function () {
    GameEvents.Subscribe("hero_selection", HeroSelection )
	const iRandomNumberCringe = Math.floor(Math.random() * 99999999);
    const sConvarCommandName  = "anime_controll_key_move" + "_number_" + iRandomNumberCringe;

    Game.AddCommand("+" + sConvarCommandName + "_up", ACKMoveCheck(1, -1, 0, -1), "" + iRandomNumberCringe, 512);
    Game.AddCommand("-" + sConvarCommandName + "_up", ACKMoveCheck(0, -1, -1, -1), "" + iRandomNumberCringe, 512);

    Game.AddCommand("+" + sConvarCommandName + "_left", ACKMoveCheck(-1, 1, -1, 0), "" + iRandomNumberCringe, 512);
    Game.AddCommand("-" + sConvarCommandName + "_left", ACKMoveCheck(-1, 0, -1, -1), "" + iRandomNumberCringe, 512);

    Game.AddCommand("+" + sConvarCommandName + "_down", ACKMoveCheck(0, -1, 1, -1), "" + iRandomNumberCringe, 512);
    Game.AddCommand("-" + sConvarCommandName + "_down", ACKMoveCheck(-1, -1, 0, -1), "" + iRandomNumberCringe, 512);

    Game.AddCommand("+" + sConvarCommandName + "_right", ACKMoveCheck(-1, 0, -1, 1), "" + iRandomNumberCringe, 512);
    Game.AddCommand("-" + sConvarCommandName + "_right", ACKMoveCheck(-1, -1, -1, 0), "" + iRandomNumberCringe, 512);

    Game.CreateCustomKeyBind("UPARROW", "+" + sConvarCommandName + "_up");
    Game.CreateCustomKeyBind("LEFTARROW", "+" + sConvarCommandName + "_left");
    Game.CreateCustomKeyBind("RIGHTARROW", "+" + sConvarCommandName + "_right");
    Game.CreateCustomKeyBind("DOWNARROW", "+" + sConvarCommandName + "_down");
})();

function ACKMoveCheck(bACK_MOVE_UP, bACK_MOVE_LEFT, bACK_MOVE_DOWN, bACK_MOVE_RIGHT)
{   
    return function()
    {   
        const iPID = Players.GetLocalPlayer();

        const iTest_PlayerID    = Players.GetLocalPlayer();
        const bTest_IsSpectator = Players.IsSpectator(iTest_PlayerID);
        if ( iTest_PlayerID === -1 && !bTest_IsSpectator )
        {
            $.Msg(iTest_PlayerID, ' -- ', bTest_IsSpectator, ' ЕБАТЬ КЛОУНАДА СУКА ACKMoveCheck , IS VALID PLAYER???', Players.IsValidPlayerID(iTest_PlayerID));
            return
        }
        
        if ( iPID !== -1 )
        {   
            const iEnt  = Players.GetPlayerHeroEntityIndex(iPID);
            const sName = Entities.GetUnitName(iEnt);
            if (sName === "npc_dota_hero_skywrath_mage")
            {
                GameEvents.SendCustomGameEventToServer("ACK_MOVE_CHECK",    {
                                                                                bACK_MOVE_UP: bACK_MOVE_UP, 
                                                                                bACK_MOVE_LEFT: bACK_MOVE_LEFT, 
                                                                                bACK_MOVE_DOWN: bACK_MOVE_DOWN, 
                                                                                bACK_MOVE_RIGHT: bACK_MOVE_RIGHT
                                                                            });
            }
        }
    }
}


let InterfaceID = 0;

	let Scan = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("NormalRoot")
	Scan.style.visibility = "visible"
	let ScanImage = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("RadarIcon")
	let RightMapContainers = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GlyphScanContainer")
	RightMapContainers.style.marginTop = "50px"
	RightMapContainers.style.marginLeft = "244px"
	RightMapContainers.style.marginBottom = "-50px"
	let Minimap = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("minimap")
	let heropanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("center_bg")
	heropanel.style.width = "100%";
	let InventoryBackgroundBot = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory_items")
	InventoryBackgroundBot.style.backgroundColor = "transparent"
	let InventoryBackgroundTop = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("InventoryBG")
	InventoryBackgroundTop.style.backgroundColor = "transparent"
	InventoryBackgroundTop.style.marginBottom = "1000px"
	let InventoryTop = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory")
	let Talents = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranchBG")
	let RightFlare = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("right_flare")
	RightFlare.style.height = "160px"
	let LeftFlare = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("left_flare")
	LeftFlare.style.height = "138px";
	LeftFlare.style.width = "52px";
	let LevelLabel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("LevelLabel")
	LevelLabel.style.textShadow = "0px 0px 0px transparent"
	let LevelProgressBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgress_BG")
	LevelProgressBg.style.border = "0px solid transparent"
	LevelProgressBg.style.borderRadius = "50%"
	let LevelProgressFg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgress_FG")
	LevelProgressFg.style.borderRadius = "50%"
	let LevelBG = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("LevelBackground")
	LevelBG.style.visibility = "collapse"
	LevelBG.style.borderRadius = "50%";
	let LevelBlur = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgressBlur_BG")
	LevelBlur.style.visibility = "visible"
	let LevelBlur2 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgressBlur_FG")
	LevelBlur2.style.visibility = "collapse"
	LevelProgressBg.style.backgroundColor = "black"
	let HeroOverlay = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PortraitGroup")
	let ShopBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("shop_launcher_bg")
	ShopBg.style.width = "290px"
	ShopBg.style.height = "73px"
	let QuicbuyBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("QuickBuyRows")
	QuicbuyBg.style.marginLeft = "3px"
	let ShopButtonBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ShopButton")
	let ShopGold = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("GoldIcon")
	ShopGold.style.backgroundImage				= "url('file://{images}/custom_game/gold_small.png')";
	let CourIcon = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("SelectCourierButton")
	let CourBust = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CourierBurstButton")
	let CourProtect = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CourierShieldButton")
	let CourGiveButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("DeliverItemsButton")
	let CourDeliverSpinner = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Spinner")
	let StashBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("stash_bg")
	StashBg.style.backgroundImage 				= "url('file://{images}/custom_game/stash_bg.png')"
	InventoryBackgroundTop.style.backgroundImage= "url('file://{images}/custom_game/int_pink/none.png')"
	CourDeliverSpinner.style.backgroundImage 	= "url('file://{images}/custom_game/int_pink/none.png')"

function HeroSelection() {
	$.Schedule(1, HeroSelection)
	let selectionBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PregameBGStatic")
	//selectionBg.BLoadLayoutFromString('<root><styles><include src="file://{resources}/styles/custom_game/hud.css" /></styles><Panel><Panel id="PregameBGStatic" /></Panel></root>', false, false)
	let SceneLoaded = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PregameBG")
	//SceneLoaded.BLoadLayoutFromString('<root><styles><include src="file://{resources}/styles/custom_game/hud.css" /></styles><DOTAScenePanel/></root>', false, false)
	let removeMinimap = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPickMinimap")
	removeMinimap.style.visibility = "collapse"
	let removeFooter = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Footer")
	removeFooter.style.visibility = "collapse"
	let MItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("AvailableItemsContainer")
	//MItems.style.visibility = "collapse"
	//MItems.enabled = false
	let Mmap = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("StrategyMap")
	Mmap.style.visibility = "collapse"
	Mmap.enabled = false
	let Mplus = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("StrategyFriendsAndFoes")
	Mplus.style.visibility = "collapse"
	Mplus.enabled = false
	let Mlist = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("HeroLockedNav")
	Mlist.style.visibility = "collapse"
	Mlist.enabled = false
	let Cmonitems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("TeamSharedItemsStrategyControl")
	Cmonitems.style.visibility = "collapse"
	Cmonitems.enabled = false
	let TeamItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("StartingItemsRightColumnRow")
	TeamItems.style.visibility = "collapse"
	let PregameBuyLeft = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("StartingItemsLeftColumn")
	PregameBuyLeft.style.backgroundImage = "url('file://{images}/custom_game/prebuy_bg.png')";
	let PregameBuyRight = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("StartingItemsRightColumn")
	PregameBuyRight.style.backgroundImage = "url('file://{images}/custom_game/prebuy_bg2.png')";
	let PregameBuyGold = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("RemainingGoldContainer")
	PregameBuyGold.style.marginLeft = "80px"
	PregameBuyGold.style.marginTop = "-16px"
	let PregameFastBuy = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StartingItems")
	PregameFastBuy.style.visibility = "visible"
	PregameFastBuy.enabled = true
	PregameFastBuy.style.backgroundColor = "gradient( linear, 0% -30%, 0% 70%, from( #050505 ), color-stop(100, #000000), to( transparent ) )";
	PregameFastBuy.style.margin = "250px 300px 0px 270px";
	PregameFastBuy.style.width = "1000px";
	PregameFastBuy.style.marginRight = "24px";
	PregameFastBuy.style.boxShadow = "0px 0px 10px 0px #000000";
	let PregameInventory = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StartingItemsInventory")
	PregameInventory.style.visibility = "visible"
	PregameInventory.enabled = true
	PregameInventory.style.backgroundColor = "transparent";
	let HeroBlock = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPickRightColumn")
	HeroBlock.style.visibility = "visible"
	HeroBlock.style.margin = "0px 22px 0px 0px";
	HeroBlock.style.boxShadow = "0px 0px 10px 0px black"
	HeroBlock.style.backgroundColor = "gradient( linear, 0% -30%, 0% 100%, from( #292929 ), to( black ) )";
	let PickButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("LockInButton")
	PickButton.style.visibility = "visible"
	PickButton.style.borderTop = "3px black"
	PickButton.style.borderRight = "3px black"
	PickButton.style.backgroundColor = "black"
	let RandomButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("RandomButton")
	RandomButton.style.visibility = "visible"
	RandomButton.style.borderTop = "3px black"
	RandomButton.style.borderLeft = "3px black"
	RandomButton.style.backgroundColor = "black"
	let PickBottom = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPickControls")
	PickBottom.style.visibility = "visible"
	PickBottom.style.backgroundColor = "black"
	let PreGame = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("GridCategories");
	let PickIconArray = PreGame.FindChildrenWithClassTraverse("HeroCard")
	    
	for (let key in PickIconArray)
	{
	    PickIconArray[key].style.height = "107px"
	    PickIconArray[key].style.width = "66px"
	}
	let sceptershard = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("AghsStatusShard")
	let scepterscepter = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("AghsStatusScepter")
	sceptershard.style.visibility = "visible"
	scepterscepter.style.visibility = "visible"
	let BotomPanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("BottomPanels")
	let PlusPaned = BotomPanel.FindChildTraverse("FriendsAndFoes")
	PlusPaned.style.visibility = "collapse"
	let SimilarHero1 = HeroBlock.FindChildTraverse("HeroInspect").FindChildTraverse("HeroSimpleDescription").FindChildTraverse("SimilarHero1")
	let SimilarHero2 = HeroBlock.FindChildTraverse("HeroInspect").FindChildTraverse("HeroSimpleDescription").FindChildTraverse("SimilarHero2")
	let SimilarHero3 = HeroBlock.FindChildTraverse("HeroInspect").FindChildTraverse("HeroSimpleDescription").FindChildTraverse("SimilarHero3")
	SimilarHero1.style.visibility = "collapse"
	SimilarHero2.style.visibility = "collapse"
	SimilarHero3.style.visibility = "collapse"
	//talenttable.style.backgroundImage = "url('file://{images}/custom_game/int_pink/shop_button.png')";

	// НАЧАЛО ИГРЫ

	

		  // $.Msg("works");
		 //  $.Msg(InterfaceID);
	}
	/*let PreGameHeroIcons = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("HeroList")
    let PregameHeroicon = PreGameHeroIcons.FindChildrenWithClassTraverse("HeroCard")
    for (let i=0; i<=20; i++)
    {
       PregameHeroicon[i].style.washColor = "transparent"
       PregameHeroicon[i].style.width = "51px"
       PregameHeroicon[i].style.height = "83px"
    }*/

HeroSelection()