Object.values = function(object) {
	return Object.keys(object).map(function(key) { return object[key] });
}

Array.prototype.includes = function(searchElement, fromIndex) {
	return this.indexOf(searchElement, fromIndex) !== -1;
}

String.prototype.includes = function(searchString, position) {
	return this.indexOf(searchString, position) !== -1
}

function setInterval(callback, interval) {
	interval = interval / 1000;
	$.Schedule(interval, function reschedule() {
		$.Schedule(interval, reschedule);
		callback();
	});
}

function createEventRequestCreator(eventName) {
	var idCounter = 0;
	return function(data, callback) {
		var id = ++idCounter;
		data.id = id;
		GameEvents.SendCustomGameEventToServer(eventName, data);
		var listener = GameEvents.Subscribe(eventName, function(data) {
			if (data.id !== id) return;
			GameEvents.Unsubscribe(listener);
			callback(data)
		});

		return listener;
	}
}

function SubscribeToNetTableKey(tableName, key, callback) {
    var immediateValue = CustomNetTables.GetTableValue(tableName, key) || {};
    if (immediateValue != null) callback(immediateValue);
    CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value) {
        if (currentKey === key && value != null) callback(value);
    });
}

function GetDotaHud() {
    var panel = $.GetContextPanel();
    while (panel && panel.id !== 'Hud') {
        panel = panel.GetParent();
	}

    if (!panel) {
        throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return panel;
}

function FindDotaHudElement(id) {
	return GetDotaHud().FindChildTraverse(id);
}

var useChineseDateFormat = $.Language() === 'schinese' || $.Language() === 'tchinese';
/** @param {Date} date */
function formatDate(date) {
	return useChineseDateFormat
		? date.getFullYear() + '-' + date.getMonth() + '-' + date.getDate()
		: date.getMonth() + '/' + date.getDate() + '/' + date.getFullYear();
}






function SetImageForPanelDemonNasral(pPanel, sHeroName)
{
	if(pPanel)
	{
		if (sHeroName == "npc_dota_hero_abaddon")
		{
			pPanel.SetImage( "file://{images}/custom_game/hight_hood/heroes/vergil.png" );
		}
		else if (sHeroName == "npc_dota_hero_alchemist")
		{
			pPanel.SetImage( "file://{images}/heroes/goku.png" );
		}
		else if (sHeroName == "npc_dota_hero_axe")
		{
			pPanel.SetImage( "file://{images}/heroes/bogdan.png" );
		}
		else if (sHeroName == "npc_dota_hero_elder_titan")
		{
			pPanel.SetImage( "file://{images}/heroes/reinforce.png" );
		}
		else if (sHeroName == "npc_dota_hero_beastmaster")
		{
			pPanel.SetImage( "file://{images}/heroes/billy.png" );
		}
		else if (sHeroName == "npc_dota_hero_bristleback")
		{
			pPanel.SetImage( "file://{images}/heroes/accelerator.png" );
		}
		else if (sHeroName == "npc_dota_hero_bounty_hunter")
		{
			pPanel.SetImage( "file://{images}/heroes/edward_elric.png" );
		}
		else if (sHeroName == "npc_dota_hero_chaos_knight")
		{
			pPanel.SetImage( "file://{images}/heroes/flandre.png" );
		}
		else if (sHeroName == "npc_dota_hero_sven")
		{
			pPanel.SetImage( "file://{images}/heroes/tohka.png" );
		}
		else if (sHeroName == "npc_dota_hero_marci")
		{
			pPanel.SetImage( "file://{images}/heroes/naofumi.png" );
		}
		else if (sHeroName == "npc_dota_hero_slark")
		{
			pPanel.SetImage( "file://{images}/heroes/arcueid.png" );
		}
		else if (sHeroName == "npc_dota_hero_dragon_knight")
		{
			pPanel.SetImage( "file://{images}/heroes/issei.png" );
		}
		else if (sHeroName == "npc_dota_hero_life_stealer")
		{
			pPanel.SetImage( "file://{images}/heroes/shuichi.png" );
		}
		else if (sHeroName == "npc_dota_hero_omniknight")
		{
			pPanel.SetImage( "file://{images}/heroes/keyaru.png" );
		}
		else if (sHeroName == "npc_dota_hero_pangolier")
		{
			pPanel.SetImage( "file://{images}/heroes/ulquiorra.png" );
		}
		else if (sHeroName == "npc_dota_hero_kunkka")
		{
			pPanel.SetImage( "file://{images}/heroes/madara.png" );
		}
		else if (sHeroName == "npc_dota_hero_antimage")
		{
			pPanel.SetImage( "file://{images}/heroes/tanjiro.png" );
		}
		else if (sHeroName == "npc_dota_hero_phantom_lancer")
		{
			pPanel.SetImage( "file://{images}/heroes/baal.png" );
		}
		else if (sHeroName == "npc_dota_hero_lycan")
		{
			pPanel.SetImage( "file://{images}/heroes/jellal.png" );
		}
		else if (sHeroName == "npc_dota_hero_magnataur")
		{
			pPanel.SetImage( "file://{images}/heroes/kambe.png" );
		}
		else if (sHeroName == "npc_dota_hero_night_stalker")
		{
			pPanel.SetImage( "file://{images}/heroes/subaru.png" );
		}
		else if (sHeroName == "npc_dota_hero_juggernaut")
		{
			pPanel.SetImage( "file://{images}/heroes/ikki.png" );
		}
		else if (sHeroName == "npc_dota_hero_centaur")
		{
			pPanel.SetImage( "file://{images}/heroes/shu.png" );
		}
		else if (sHeroName == "npc_dota_hero_undying")
		{
			pPanel.SetImage( "file://{images}/heroes/touma.png" );
		}
		else if (sHeroName == "npc_dota_hero_pudge")
		{
			pPanel.SetImage( "file://{images}/heroes/pika.png" );
		}
		else if (sHeroName == "npc_dota_hero_abyssal_underlord")
		{
			pPanel.SetImage( "file://{images}/heroes/escanor.png" );
		}
		else if (sHeroName == "npc_dota_hero_bloodseeker")
		{
			pPanel.SetImage( "file://{images}/heroes/aizen.png" );
		}
		else if (sHeroName == "npc_dota_hero_tusk")
		{
			pPanel.SetImage( "file://{images}/heroes/shinobu.png" );
		}
		else if (sHeroName == "npc_dota_hero_drow_ranger")
		{
			pPanel.SetImage( "file://{images}/heroes/ikaros.png" );
		}
		else if (sHeroName == "npc_dota_hero_faceless_void")
		{
			pPanel.SetImage( "file://{images}/heroes/kumagawa.png" );
		}
		else if (sHeroName == "npc_dota_hero_monkey_king")
		{
			pPanel.SetImage( "file://{images}/heroes/mori.png" );
		}
		else if (sHeroName == "npc_dota_hero_naga_siren")
		{
			pPanel.SetImage( "file://{images}/heroes/brs.png" );
		}
		else if (sHeroName == "npc_dota_hero_nyx_assassin")
		{
			pPanel.SetImage( "file://{images}/heroes/kurapika.png" );
		}
		else if (sHeroName == "npc_dota_hero_nevermore")
		{
			pPanel.SetImage( "file://{images}/heroes/rumia.png" );
		}
		else if (sHeroName == "npc_dota_hero_spectre")
		{
			pPanel.SetImage( "file://{images}/heroes/frisk.png" );
		}
		else if (sHeroName == "npc_dota_hero_terrorblade")
		{
			pPanel.SetImage( "file://{images}/heroes/miku.png" );
		}
		else if (sHeroName == "npc_dota_hero_ursa")
		{
			pPanel.SetImage( "file://{images}/heroes/kanade.png" );
		}
		else if (sHeroName == "npc_dota_hero_ancient_apparition")
		{
			pPanel.SetImage( "file://{images}/heroes/yoshino.png" );
		}
		else if (sHeroName == "npc_dota_hero_bane")
		{
			pPanel.SetImage( "file://{images}/heroes/yukari.png" );
		}
		else if (sHeroName == "npc_dota_hero_dark_seer")
		{
			pPanel.SetImage( "file://{images}/heroes/tsuna.png" );
		}
		else if (sHeroName == "npc_dota_hero_dark_willow")
		{
			pPanel.SetImage( "file://{images}/heroes/jibril.png" );
		}
		else if (sHeroName == "npc_dota_hero_obsidian_destroyer")
		{
			pPanel.SetImage( "file://{images}/heroes/pandora.png" );
		}
		else if (sHeroName == "npc_dota_hero_lich")
		{
			pPanel.SetImage( "file://{images}/heroes/sans.png" );
		}
		else if (sHeroName == "npc_dota_hero_oracle")
		{
			pPanel.SetImage( "file://{images}/heroes/rimuru.png" );
		}
		else if (sHeroName == "npc_dota_hero_arc_warden")
		{
			pPanel.SetImage( "file://{images}/heroes/tatsuya.png" );
		}
		else if (sHeroName == "npc_dota_hero_queenofpain")
		{
			pPanel.SetImage( "file://{images}/heroes/homura.png" );
		}
		else if (sHeroName == "npc_dota_hero_techies")
		{
			pPanel.SetImage( "file://{images}/heroes/deidara.png" );
		}
		else if (sHeroName == "npc_dota_hero_void_spirit")
		{
			pPanel.SetImage( "file://{images}/heroes/rin.png" );
		}
		else if (sHeroName == "npc_dota_hero_winter_wyvern")
		{
			pPanel.SetImage( "file://{images}/heroes/lelouch.png" );
		}
		else if (sHeroName == "npc_dota_hero_ember_spirit")
		{
			pPanel.SetImage( "file://{images}/heroes/shana.png" );
		}
		else if (sHeroName == "npc_dota_hero_legion_commander")
		{
			pPanel.SetImage( "file://{images}/heroes/esdeath.png" );
		}
		else if (sHeroName == "npc_dota_hero_mars")
		{
			pPanel.SetImage( "file://{images}/heroes/dante.png" );
		}
		else if (sHeroName == "npc_dota_hero_riki")
		{
			pPanel.SetImage( "file://{images}/heroes/shiki.png" );
		}
		else if (sHeroName == "npc_dota_hero_razor")
		{
			pPanel.SetImage( "file://{images}/heroes/ichigo.png" );
		}
		else if (sHeroName == "npc_dota_hero_skywrath_mage")
		{
			pPanel.SetImage( "file://{images}/heroes/ae86.png" );
		}
		else if (sHeroName == "npc_dota_hero_dawnbreaker")
		{
			pPanel.SetImage( "file://{images}/heroes/makima.png" );
		}
		else if (sHeroName == "npc_dota_hero_tiny")
		{
			pPanel.SetImage( "file://{images}/heroes/muramasa.png" );
		}
		else if (sHeroName == "npc_dota_hero_brewmaster")
		{
			pPanel.SetImage( "file://{images}/heroes/nanaya.png" );
		}
		else if (sHeroName == "npc_dota_hero_skeleton_king")
		{
			pPanel.SetImage( "file://{images}/heroes/shu.png" );
		}
		else if (sHeroName == "npc_dota_hero_earthshaker")
		{
			pPanel.SetImage( "file://{images}/heroes/gogeta.png" );
		}
		else if (sHeroName == "npc_dota_hero_dazzle")
		{
			pPanel.SetImage( "file://{images}/heroes/gojo.png" );
		}
		else if (sHeroName == "npc_dota_hero_ringmaster")
		{
			pPanel.SetImage( "file://{images}/heroes/ringmaster.png" );
		}
		else
		{
			pPanel.SetImage( "file://{images}/custom_game/unassigned.png" );
		}
	};
};

GameUI.CustomUIConfig().SetImageForPanelDemonNasral = SetImageForPanelDemonNasral;