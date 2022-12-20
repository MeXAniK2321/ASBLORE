"use strict";

function AnimeEscapeHtml(text)
{
    return text
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#039;");
}

function AnimeFloatRandom(min, max)
{
    return Math.random() * (max - min) + min;
}

function AnimeClamp(num, min, max)
{
    return num <= min ? min : (num >= max ? max : num);
}

function AnimeLerp(percent, a, b)
{
    return a + percent * (b - a);
}

function AnimeRemapValClamped(num, a, b, c, d)
{
    if (a == b) return c;

    var percent = (num - a) / (b - a);
        percent = AnimeClamp(percent, 0.0, 1.0);

    return AnimeLerp(percent, c, d);
}

function AnimeShallowCopyWithIndex(table, key)
{
    var NewTable = {};
    for (var i in table)
    {   
        var value = table[i];
        NewTable[value[key]] = value;
    }

    return NewTable;
}

function GetAnimeSteamID32(PID)
{   
    var PID = PID || Game.GetLocalPlayerID();

    if ( !Game.GetPlayerInfo(PID) || Game.GetPlayerInfo(PID).player_steamid === undefined ) return 0;
    
    var steamID64 = Game.GetPlayerInfo(PID).player_steamid,
        steamIDPart = Number(steamID64.substring(3)),
        steamID32 = String(steamIDPart - 61197960265728);

    return steamID32;
}

function SubscribeToNetTableKey(tableName, key, callback)
{
	var immediateValue = CustomNetTables.GetTableValue(tableName, key) || {};

	if (immediateValue != null) callback(immediateValue);

    CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value)
    {
        if (currentKey === key && value != null) callback(value);
    });
}

function GetDotaHud()
{
	var panel = $.GetContextPanel();
	while (panel && panel.id !== 'Hud')
	{
        panel = panel.GetParent();
	}

	if (!panel)
	{
        throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return panel;
}

function FindDotaHudElement(id)
{
	return GetDotaHud().FindChildTraverse(id);
}

function FindDotaHudElementByClass(className)
{
    var comp = GetDotaHud().FindChildrenWithClassTraverse(className);
    
    return ( comp.length > 0 ) && comp[0] || null;
}

function ShowCustomTextTip(message, pos)
{   
    if ( $( "#" + pos ) != undefined )
    {
       $.DispatchEvent( "DOTAShowTextTooltip", $( "#" + pos ), $.Localize( message ));
    }
}

function HideCustomTextTip()
{
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}