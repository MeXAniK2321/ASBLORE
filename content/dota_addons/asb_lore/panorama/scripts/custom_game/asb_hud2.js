(function () {
    GameEvents.Subscribe("hero_selection", HeroSelection )
})();

function HeroSelection() {
	$.Schedule(0.1, HeroSelection)

	let selectionBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PregameBGStatic")
	//selectionBg.BLoadLayoutFromString('<root><styles><include src="file://{resources}/styles/custom_game/hud.css" /></styles><Panel><Panel id="PregameBGStatic" /></Panel></root>', false, false)
	let SceneLoaded = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PregameBG")
	//SceneLoaded.BLoadLayoutFromString('<root><styles><include src="file://{resources}/styles/custom_game/hud.css" /></styles><DOTAScenePanel/></root>', false, false)
	let removeMinimap = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPickMinimap")
	removeMinimap.style.visibility = "collapse"
	let removeFooter = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Footer")
	removeFooter.style.visibility = "collapse"
	let MItems = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("AvailableItemsContainer")
	MItems.style.visibility = "collapse"
	MItems.enabled = false
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
	PregameFastBuy.style.backgroundColor = "gradient( linear, 0% -30%, 0% 70%, from( #FF00AA ), color-stop(100, #2A001C), to( transparent ) )";
	PregameFastBuy.style.margin = "250px 300px 0px 270px";
	PregameFastBuy.style.width = "1000px";
	PregameFastBuy.style.marginRight = "24px";
	PregameFastBuy.style.boxShadow = "0px 0px 10px 0px #FF00AA";
	let PregameInventory = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StartingItemsInventory")
	PregameInventory.style.visibility = "visible"
	PregameInventory.enabled = true
	PregameInventory.style.backgroundColor = "transparent";
	let HeroBlock = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPickRightColumn")
	HeroBlock.style.visibility = "visible"
	HeroBlock.style.margin = "0px 22px 0px 0px";
	HeroBlock.style.boxShadow = "0px 0px 10px 0px red"
	HeroBlock.style.backgroundColor = "gradient( linear, 0% -30%, 0% 100%, from( #ff0000 ), to( black ) )";
	let PickButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("LockInButton")
	PickButton.style.visibility = "visible"
	PickButton.style.borderTop = "3px solid red"
	PickButton.style.borderRight = "3px solid red"
	PickButton.style.backgroundColor = "black"
	let RandomButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("RandomButton")
	RandomButton.style.visibility = "visible"
	RandomButton.style.borderTop = "3px solid red"
	RandomButton.style.borderLeft = "3px solid red"
	RandomButton.style.backgroundColor = "black"
	let PickBottom = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HeroPickControls")
	PickBottom.style.visibility = "visible"
	PickBottom.style.backgroundColor = "black"
	let Scan = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("NormalRoot")
	Scan.style.visibility = "visible"
	let ScanImage = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("RadarIcon")
	ScanImage.style.backgroundImage = "url('file://{images}/custom_game/icon_scan_off.png')";
	let RightMapContainers = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GlyphScanContainer")
	RightMapContainers.style.marginLeft = "244px"
	RightMapContainers.style.marginBottom = "-50px"
	RightMapContainers.style.backgroundImage = "url('file://{images}/custom_game/scan.png')";
	let Minimap = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("minimap")
	Minimap.style.boxShadow = "-7px 7px 10px 0px red"
	let heropanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("center_bg")
	heropanel.style.boxShadow = "0px -1px 10px 0px red"
	heropanel.style.width = "100%";
	heropanel.style.backgroundImage = "url('file://{images}/custom_game/inventorybg.png')";
	//heropanel.style.backgroundColor = "gradient( linear, 0% -30%, 0% 100%, from( blue ), to( #ff00ec ) )"
	let InventoryBackgroundBot = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory_items")
	InventoryBackgroundBot.style.backgroundImage = "url('file://{images}/custom_game/inventorybgboy.png')";
	InventoryBackgroundBot.style.backgroundColor = "transparent"
	let InventoryBackgroundTop = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("InventoryBG")
	InventoryBackgroundTop.style.backgroundImage = "url('file://{images}/custom_game/none.png')";
	InventoryBackgroundTop.style.backgroundColor = "transparent"
	InventoryBackgroundTop.style.marginBottom = "1000px"
	let InventoryTop = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("inventory")
	InventoryTop.style.boxShadow = "45px 0px 12px 0px red"
	let Talents = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("StatBranchBG")
	Talents.style.backgroundImage = "url('file://{images}/custom_game/talent.png')";
	let RightFlare = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("right_flare")
	RightFlare.style.height = "160px"
	RightFlare.style.backgroundImage = "url('file://{images}/custom_game/rightflare.png')";
	let LeftFlare = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("left_flare")
	LeftFlare.style.height = "138px";
	LeftFlare.style.width = "52px";
	LeftFlare.style.backgroundImage = "url('file://{images}/custom_game/leftflare.png')";
	let LevelLabel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("LevelLabel")
	LevelLabel.style.color = "red"
	LevelLabel.style.textShadow = "0px 0px 0px transparent"
	let LevelProgressBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgress_BG")
	LevelProgressBg.style.border = "0px solid transparent"
	LevelProgressBg.style.backgroundColor = "black"
	LevelProgressBg.style.borderRadius = "0%"
	let LevelProgressFg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgress_FG")
	LevelProgressFg.style.border = "3px solid red"
	LevelProgressFg.style.borderRadius = "0%"
	let LevelBG = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("LevelBackground")
	LevelBG.style.visibility = "collapse"
	LevelBG.style.borderRadius = "0%";
	let LevelBlur = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgressBlur_BG")
	LevelBlur.style.visibility = "visible"
	LevelBlur.style.border = "1px solid red"
	let LevelBlur2 = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CircularXPProgressBlur_FG")
	LevelBlur2.style.visibility = "collapse"
	let HeroOverlay = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PortraitGroup")
	HeroOverlay.style.boxShadow = "0px 0px 10px -2px red"
	HeroOverlay.style.borderBottom = "10px red"
	let ShopBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("shop_launcher_bg")
	ShopBg.style.backgroundImage = "url('file://{images}/custom_game/courier_gold_bg_262.png')";
	ShopBg.style.width = "290px"
	ShopBg.style.height = "73px"
	let QuicbuyBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("QuickBuyRows")
	QuicbuyBg.style.backgroundImage = "url('file://{images}/custom_game/quickbuybg.png')";
	QuicbuyBg.style.marginLeft = "3px"
	let ShopButtonBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("ShopButton")
	ShopButtonBg.style.backgroundImage = "url('file://{images}/custom_game/shop_button.png')";
	let ShopGold = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("GoldIcon")
	ShopGold.style.backgroundImage = "url('file://{images}/custom_game/gold_small.png')";
	let CourIcon = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("SelectCourierButton")
	CourIcon.style.backgroundImage = "url('file://{images}/custom_game/icon_courier.png')"
	let CourBust = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CourierBurstButton")
	CourBust.style.backgroundImage = "url('file://{images}/custom_game/icon_courier_boost.png')"
	let CourProtect = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("CourierShieldButton")
	CourProtect.style.backgroundImage = "url('file://{images}/custom_game/icon_courier_shield.png')"
	let CourGiveButton = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("DeliverItemsButton")
	CourGiveButton.style.backgroundImage = "url('file://{images}/custom_game/icon_courier_deliver.png')"
	let CourDeliverSpinner = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("Spinner")
	CourDeliverSpinner.style.backgroundImage = "url('file://{images}/custom_game/none.png')"
	let StashBg = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("stash_bg")
	StashBg.style.backgroundImage = "url('file://{images}/custom_game/stash_bg.png')"
	StashBg.style.boxShadow = "0px 0px 12px red"
	let PreGame = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("GridCategories");
    let PickIconArray = PreGame.FindChildrenWithClassTraverse("HeroCard")
    
    for (let key in PickIconArray)
    {
        PickIconArray[key].style.height = "107px"
         PickIconArray[key].style.width = "66px"
    }
    $.Msg("works")
	/*let PreGameHeroIcons = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("MainContents").FindChildTraverse("HeroList")
    let PregameHeroicon = PreGameHeroIcons.FindChildrenWithClassTraverse("HeroCard")
    for (let i=0; i<=20; i++)
    {
       PregameHeroicon[i].style.washColor = "transparent"
       PregameHeroicon[i].style.width = "51px"
       PregameHeroicon[i].style.height = "83px"
    }*/
}
HeroSelection()