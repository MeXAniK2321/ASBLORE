"use strict";

var PlayerTables = GameUI.CustomUIConfig().PlayerTables;

function UpdateHero(tInfo)
{
	// let nPlayerID = Players.GetLocalPlayer();

	// let nHeroID = Players.GetPlayerHeroEntityIndex(nPlayerID);

	let pManaBar = FindDotaHudElement("ManaProgress_Left");
	let pManaBar2 = FindDotaHudElement("ManaProgress_Right");

	if (!pManaBar || !pManaBar2) return;

	let nPlayerUnit = Players.GetLocalPlayerPortraitUnit();

	let nRolandTurnID = Entities.GetAbilityByName(nPlayerUnit, "roland_turn_start");
	if (Entities.IsValidEntity(nRolandTurnID))
	{
		pManaBar.style["background-color"] = `gradient( linear, 0% 0%, 0% 100%, 
	from( #fff4c2 ), 
	color-stop( 0.2, #fff9dc ), 
	color-stop( 0.5, #ffe27a ), 
	to( #fff4c2 ) 
)`;
		pManaBar2.style["background-color"] = `gradient( linear, 0% 0%, 0% 100%, 
	from( #1f1a0d ), 
	color-stop( 0.2, #2e2612 ), 
	color-stop( 0.5, #261f0f ), 
	to( #1f1a0d ) 
)`;
	}
	else
	{
		pManaBar.style["background-color"] = "gradient( linear, 0% 0%, 0% 100%, from( #2b4287 ), color-stop( 0.2, #4165ce ), color-stop( .5, #4a73ea), to( #2b4287 ) )";
		pManaBar2.style["background-color"] = "gradient( linear, 0% 0%, 0% 100%, from( #101932 ), color-stop( 0.2, #172447 ), color-stop( .5, #162244), to( #101932 ) )";
	};
};

(function () {

	const pCTX = $.GetContextPanel();

	const PT_NAME = "roland_cards_active";

	// const container = $("#RolandCardsContainer");
	// container.RemoveAndDeleteChildren();

	let CURRENT_UNIT = -1;
	const PANELS = {};

	// =========================
	// UTILS
	// =========================
	function GetCurrentData()
	{
		if (CURRENT_UNIT === -1) return null;
		return PlayerTables.GetTableValue(PT_NAME, String(CURRENT_UNIT));
	};

	function GetSortedCards(data)
	{
		return Object.values(data).sort((a, b) =>
		{
			if (a.order === b.order)
				return a.order_id - b.order_id;

			return a.order - b.order;
		});
	};

	// =========================
	// CARD UI
	// =========================
	function CreateCard(uid, data)
	{
		const container = $("#RolandCardsContainer");

		const panel = $.CreatePanel("Panel", container, "card_" + uid);
		panel.AddClass("RolandCard");

		const pCost = $.CreatePanel("Label", panel, "card_cost_" + uid);
		pCost.AddClass("CardCost");

		pCost.text = data.card_cost || 0;

		const pName = $.CreatePanel("Label", panel, "card_name_" + uid);
		pName.AddClass("CardName");

		pName.text = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName(data.card_id));

		if (data.card_rarity)
		{
			const pRarity = $.CreatePanel("Panel", panel, "card_rarity_" + uid);
			pRarity.AddClass("RolandCardRarity");
			pRarity.AddClass("Rarity" + data.card_rarity);
			pCost.AddClass("Cost" + data.card_rarity);
		};

		if (data.card_type)
		{
			const pRarity = $.CreatePanel("Panel", panel, "card_type_" + uid);
			pRarity.AddClass("RolandCardType");
			pRarity.AddClass("Type" + data.card_type);
		};

		if (container.Children().length > 9)
		{
			panel.AddClass("BackCard");
		};

		const img = $.CreatePanel("DOTAAbilityImage", panel, "");
		img.abilityname = Abilities.GetAbilityName(data.card_id);

		PANELS[uid] = panel;

		$.Schedule(0.01, () => panel.AddClass("Show"));
	};

	function RemoveCard(uid)
	{
		const panel = PANELS[uid];
		if (!panel) return;

		panel.AddClass("Hide");

		$.Schedule(0.25, () =>
		{
			if (panel && panel.IsValid())
				panel.DeleteAsync(0);
		});

		delete PANELS[uid];
	};

	function UpdateCard(uid, data)
	{
		let panel = PANELS[uid];

		if (!panel)
		{
			CreateCard(uid, data);
			return;
		};

		const img = panel.GetChild(0);
		if (img)
			img.abilityname = Abilities.GetAbilityName(data.card_id);
	};

	// =========================
	// SYNC
	// =========================
	function RefreshCards()
	{
		const data = GetCurrentData();

		const existing = {...PANELS};

		if (!data)
		{
			for (let uid in PANELS)
				RemoveCard(uid);
			return;
		};

		const sorted = GetSortedCards(data);

		sorted.forEach(card =>
		{
			UpdateCard(card.uid, card);
			delete existing[card.uid];
		});

		for (let uid in existing)
		{
			RemoveCard(uid);
		};
	};

	function OnTableUpdate(tableName, changes, dels)
	{
		const key = String(CURRENT_UNIT);

		if (!changes[key] && !dels[key]) return;

		RefreshCards();
	};

	function OnUnitChanged()
	{
		CURRENT_UNIT = Players.GetLocalPlayerPortraitUnit();
		RefreshCards();
		UpdateHero();
	};

	// =========================
	// INIT
	// =========================
	function Init()
	{
		if (pCTX.listener_id)
		{
			PlayerTables.UnsubscribeNetTableListener(pCTX.listener_id);
			pCTX.listener_id = null;
		};
		pCTX.listener_id = PlayerTables.SubscribeNetTableListener(PT_NAME, OnTableUpdate);

		GameEvents.Subscribe("dota_player_update_selected_unit", OnUnitChanged);
		GameEvents.Subscribe("dota_player_update_query_unit", OnUnitChanged);
		GameEvents.Subscribe("dota_player_update_assigned_hero", OnUnitChanged);

		OnUnitChanged();
	};

	Init();

})();