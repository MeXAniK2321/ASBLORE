"use strict";

var heronames = new Array(
    new Array("custom1","custom2","custom3","custom4","custom5","custom6","custom7","custom8"),  //"Heroes A-K"
    new Array("custom9","custom10","custom11","custom12","custom13","custom14","custom15","custom16"),  //"Heroes K-S"
    new Array("custom17","custom18","custom19","custom20","custom21","custom22","custom23","custom24"),  //"Heroes S-W"
    new Array("custom25", "custom26", "custom27", "custom28", "custom29", "custom30", "custom31", "custom32"),
	new Array("Sniper Mask", "AE86", "Itachi", "Emilia", "Ryuko", "Illya", "Yuri", "Raiden"), //New Heroes 2
    new Array("Vergil", "", "", "", "", "", "", "") //New Heroes 3
);
var heronames2 = new Array(
    "anime_custom1",
    "anime_custom2",
    "anime_custom3",
    "anime_custom4",
    "anime_custom5",
    "anime_custom6",
    "anime_custom7",
    "anime_custom8",
    //8
    "anime_custom9",
    "anime_custom10",
    "anime_custom11",
    "anime_custom12",
    "anime_custom13",
    "anime_custom14",
    "anime_custom15",
    "anime_custom16",
    //16
    "anime_custom17",
    "anime_custom18",
	
    //"32",
    "anime_custom19",
    "anime_custom20",
    "anime_custom21",
    "anime_custom22",
    "anime_custom23",
    "anime_custom24",
    "anime_custom25",
    "anime_custom26",
    "anime_custom27",
    "anime_custom28",
    "anime_custom29",
    "anime_custom30",
    "anime_custom31",
	 "anime_custom32",
	  "anime_custom33",
	   "anime_custom34",
	    "anime_custom35",
		 "anime_custom36",
		  "anime_custom37",
		   "anime_custom38",
		    "anime_custom39",
			 "anime_custom40",
			  "anime_custom41"
/*"",
    "",
    "",
    //24
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //32
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //40
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //48
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //56
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //64
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //72
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //80
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //88
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //96
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //104
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    //112
    "",
    "",
    "",
    "",
    ""*/
);
var mesarrs = new Array(
    "_1",
    "_2",
    "_3",
    "_4",
    "_5",
    "_6",
    "_7",
    "_8"
 );
var IsPatronChatWheel = true;
var favourites = new Array();
var herostartnum = 110;
var nowrings = 14;
var herostartrings = nowrings + heronames.length + 1;
var rings = new Array(
    new Array(//0 anime_chatwheel_heroes
        new Array("#anime_chatwheel_non_sorted_new","#anime_chatwheel_new3","#anime_chatwheel_favourites","#anime_chatwheel_non_sorted_11_88","#anime_chatwheel_non_sorted 91 to 168","","","#anime_chatwheel_new2"),
        new Array(false,false,false,false,false,false,false,false),
        new Array(nowrings+2,nowrings+3,nowrings,1,2,13,nowrings+4,nowrings+1)
    ),
    new Array(//1 #anime_chatwheel_non_sorted 11 to 88
        new Array("#anime_chatwheel_non_sorted_1","#anime_chatwheel_non_sorted_2","#anime_chatwheel_non_sorted_3","#anime_chatwheel_non_sorted_4","#anime_chatwheel_non_sorted_5","#anime_chatwheel_non_sorted_6","#anime_chatwheel_non_sorted_7","#anime_chatwheel_non_sorted_8"),
        new Array(false,false,false,false,false,false,false,false),
        new Array(3,4,5,6,7,8,9,10)
    ),
    new Array(//2 #anime_chatwheel_non_sorted 91 to 168
        new Array("#anime_chatwheel_message_non_sorted_9","","","","","","",""),
        new Array(false,false,false,false,false,false,false,false),
        new Array(11,12,0,0,0,0,0,0)
    ),
    new Array(//3 "#anime_chatwheel_message_non_sorted_1"
        new Array("#anime_chatwheel_message_non_sorted_1_1","#anime_chatwheel_message_non_sorted_1_2","#anime_chatwheel_message_non_sorted_1_3","#anime_chatwheel_message_non_sorted_1_4","#anime_chatwheel_message_non_sorted_1_5","#anime_chatwheel_message_non_sorted_1_6","#anime_chatwheel_message_non_sorted_1_7","#anime_chatwheel_message_non_sorted_1_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(1,2,3,4,5,6,7,8)
    ),
    new Array(//4 "#anime_chatwheel_message_non_sorted_2"
        new Array("#anime_chatwheel_message_non_sorted_2_1","#anime_chatwheel_message_non_sorted_2_2","#anime_chatwheel_message_non_sorted_2_3","#anime_chatwheel_message_non_sorted_2_4","#anime_chatwheel_message_non_sorted_2_5","#anime_chatwheel_message_non_sorted_2_6","#anime_chatwheel_message_non_sorted_2_7","#anime_chatwheel_message_non_sorted_2_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(9,10,11,12,13,14,15,16)
    ),
    new Array(//5 "#anime_chatwheel_message_non_sorted_3"
        new Array("#anime_chatwheel_message_non_sorted_3_1","#anime_chatwheel_message_non_sorted_3_2","#anime_chatwheel_message_non_sorted_3_3","#anime_chatwheel_message_non_sorted_3_4","#anime_chatwheel_message_non_sorted_3_5","#anime_chatwheel_message_non_sorted_3_6","#anime_chatwheel_message_non_sorted_3_7","#anime_chatwheel_message_non_sorted_3_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(17,18,19,20,21,22,23,24)
    ),
    new Array(//6 "#anime_chatwheel_message_non_sorted_4"
        new Array("#anime_chatwheel_message_non_sorted_4_1","#anime_chatwheel_message_non_sorted_4_2","#anime_chatwheel_message_non_sorted_4_3","#anime_chatwheel_message_non_sorted_4_4","#anime_chatwheel_message_non_sorted_4_5","#anime_chatwheel_message_non_sorted_4_6","#anime_chatwheel_message_non_sorted_4_7","#anime_chatwheel_message_non_sorted_4_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(25,26,27,28,29,30,31,32)
    ),
    new Array(//7 "#anime_chatwheel_message_non_sorted_5"
        new Array("#anime_chatwheel_message_non_sorted_5_1","#anime_chatwheel_message_non_sorted_5_2","#anime_chatwheel_message_non_sorted_5_3","#anime_chatwheel_message_non_sorted_5_4","#anime_chatwheel_message_non_sorted_5_5","#anime_chatwheel_message_non_sorted_5_6","#anime_chatwheel_message_non_sorted_5_7","#anime_chatwheel_message_non_sorted_5_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(33,34,35,36,37,38,39,40)
    ),
    new Array(//8 "#anime_chatwheel_message_non_sorted_6"
        new Array("#anime_chatwheel_message_non_sorted_6_1","#anime_chatwheel_message_non_sorted_6_2","#anime_chatwheel_message_non_sorted_6_3","#anime_chatwheel_message_non_sorted_6_4","#anime_chatwheel_message_non_sorted_6_5","#anime_chatwheel_message_non_sorted_6_6","#anime_chatwheel_message_non_sorted_6_7","#anime_chatwheel_message_non_sorted_6_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(41,42,43,44,45,46,47,48)
    ),
    new Array(//9 "#anime_chatwheel_message_non_sorted_7"
        new Array("#anime_chatwheel_message_non_sorted_7_1","#anime_chatwheel_message_non_sorted_7_2","#anime_chatwheel_message_non_sorted_7_3","#anime_chatwheel_message_non_sorted_7_4","#anime_chatwheel_message_non_sorted_7_5","#anime_chatwheel_message_non_sorted_7_6","#anime_chatwheel_message_non_sorted_7_7","#anime_chatwheel_message_non_sorted_7_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(49,50,51,52,53,54,55,56)
    ),
    new Array(//10 "#anime_chatwheel_message_non_sorted_8"
        new Array("#anime_chatwheel_message_non_sorted_8_1","#anime_chatwheel_message_non_sorted_8_2","#anime_chatwheel_message_non_sorted_8_3","#anime_chatwheel_message_non_sorted_8_4","#anime_chatwheel_message_non_sorted_8_5","#anime_chatwheel_message_non_sorted_8_6","#anime_chatwheel_message_non_sorted_8_7","#anime_chatwheel_message_non_sorted_8_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(57,58,59,60,61,62,63,64)
    ),
    new Array(//11 "#anime_chatwheel_message_non_sorted_8"
        new Array("#anime_chatwheel_message_non_sorted_9_1","#anime_chatwheel_message_non_sorted_9_2","#anime_chatwheel_message_non_sorted_9_3","#anime_chatwheel_message_non_sorted_9_4","#anime_chatwheel_message_non_sorted_9_5","#anime_chatwheel_message_non_sorted_9_6","#anime_chatwheel_message_non_sorted_9_7","#anime_chatwheel_message_non_sorted_9_8"),
        new Array(true,true,true,true,true,true,true,true),
        new Array(65,66,67,68,69,70,71,72)
    ),
    new Array(//12 Favourites
        new Array("","","","","#anime_chatwheel_add_in_favourites","","",""),
        new Array(false,false,false,false,false,false,false,false),
        new Array(73,0,0,0,0,0,0,0)
    ),
	 new Array(//13 New Heroes Folder 1-8
        new Array("NEW HEROES 1","NEW HEROES 2","NEW HEROES 3","NEW HEROES 4","NEW HEROES 5","NEW HEROES 6","NEW HEROES 7","NEW HEROES 8"),
        new Array(false,false,false,false,false,false,false,false),
        new Array(nowrings+5,nowrings+6,0,0,0,0,0,0)
    ),
    new Array(//14 Favourites
        new Array("","","","","#anime_chatwheel_add_in_favourites","","",""),
        new Array(false,false,false,false,false,false,false,false),
        new Array(0,0,0,0,0,0,0,0)
    )
);
for ( var i = 0; i < heronames.length; i++ )
{
    var msg = heronames[i];
    var numsb = new Array(false,false,false,false,false,false,false,false);
    var numsi = new Array(herostartrings+i*8,herostartrings+i*8+1,herostartrings+i*8+2,herostartrings+i*8+3,herostartrings+i*8+4,herostartrings+i*8+5,herostartrings+i*8+6,herostartrings+i*8+7);
    rings[rings.length] = new Array(msg,numsb,numsi);
}
for ( var i = 0; i < heronames2.length; i++ )
{
    var msg = new Array();
    var numsb = new Array(true,true,true,true,true,true,true,true);
    var numsi = new Array();
    for ( var x = 0; x < 8; x++ )
    {
        msg[x] = "#anime_chatwheel_message_"+heronames2[i]+mesarrs[x];
        numsi[x] = herostartnum+(i*8)+x;
    }
    rings[herostartrings+i] = new Array(msg,numsb,numsi);
}
var nowselect = 0;

function StartWheel() {
    $("#Wheel").visible = true;
    $("#Bubble").visible = true;
    $("#PhrasesContainer").visible = true;
}

function StopWheel() {
    $("#Wheel").visible = false;
    $("#Bubble").visible = false;
    $("#PhrasesContainer").visible = false;
    $("#WHTooltip").visible = false;
    if (nowselect != 0)
    {
        $("#PhrasesContainer").RemoveAndDeleteChildren();
        for ( var i = 0; i < 8; i++ )
        {
            const hPanelProperties =    {
                                            class           : "MyPhrases",
                                            onmouseactivate : "OnSelect(" + i + ")",
                                            onmouseover     : "OnMouseOver(" + i + ")",
                                            onmouseout      : "OnMouseOut(" + i + ")"
                                        };
            $.CreatePanelWithProperties("Button", $("#PhrasesContainer"), "Phrase"+i, hPanelProperties);

            //$("#PhrasesContainer").BCreateChildren("<Button id='Phrase"+i+"' class='MyPhrases' onmouseactivate='OnSelect("+i+")' onmouseover='OnMouseOver("+i+")' onmouseout='OnMouseOut("+i+")' />");//class='Phrase HasSound RequiresHeroBadgeTier BronzeTier'
            //$("#Phrase"+i).hittest = false;
            $("#Phrase"+i).BLoadLayoutSnippet("Phrase");
            $("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[0][1][i];
            $("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[0][0][i]);
        }
        nowselect = 0;
    }
}

function StartOrStopChatWheel()
{
    if ($("#Wheel").visible)
    {
        StopWheel();
    }
    else
    {
        StartWheel();
    }   
}

function OnSelect(num) {
    var newnum = rings[nowselect][2][num];
    if (rings[nowselect][1][num])
    {
        GameEvents.SendCustomGameEventToServer("SelectVO", {num: newnum});
    }
    else
    {
        $("#PhrasesContainer").RemoveAndDeleteChildren();
        for ( var i = 0; i < 8; i++ )
        {
            var onmouseactivate = " onmouseactivate='OnSelect("+i+")'";
            var dopstr = "";

            const hPanelProperties =    {
                                            class           : "MyPhrases",
                                            onmouseactivate : "OnSelect(" + i + ")",
                                            onmouseover     : "OnMouseOver(" + i + ")",
                                            onmouseout      : "OnMouseOut(" + i + ")"
                                        };

            var NANIFUCKIT = rings[newnum] && rings[newnum][1] && rings[newnum][1][i];
            if (NANIFUCKIT)
            {
                hPanelProperties.oncontextmenu = "AddOnFavourites(" + i + ")"
                //dopstr = " oncontextmenu='AddOnFavourites("+i+")'";
            }


            $.CreatePanelWithProperties("Button", $("#PhrasesContainer"), "Phrase"+i, hPanelProperties);

            //$("#PhrasesContainer").BCreateChildren("<Button id='Phrase"+i+"' class='MyPhrases'"+onmouseactivate+" onmouseover='OnMouseOver("+i+")' onmouseout='OnMouseOut("+i+")'"+dopstr+" />");//class='Phrase HasSound RequiresHeroBadgeTier BronzeTier'
            //$("#Phrase"+i).hittest = anime_patron;//--AddClass('Phrase HasSound RequiresHeroBadgeTier BronzeTier');
            
            
            $("#Phrase"+i).BLoadLayoutSnippet("Phrase");
            $("#Phrase"+i).GetChild(0).GetChild(0).visible = NANIFUCKIT;
            $("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[newnum][0][i]);

            $("#Phrase"+i).GetChild(0).SetHasClass("ChatWheelRequiredTierLockIconText", !IsPatronChatWheel);
            $("#Phrase"+i).GetChild(0).GetChild(0).SetHasClass("ChatWheelRequiredTierLockIcon", !IsPatronChatWheel);
        }

        nowselect = newnum;
    }
}


function AddOnFavourites(num) {
    if (nowselect != nowrings)
    {
        favourites.unshift(rings[nowselect][2][num]);
        if (favourites.length > 8)
            favourites[8] = null;
        favourites = favourites.filter(function (el) {
            return el != null;
        });
        Game.EmitSound( "ui.crafting_gem_create" )
        UpdateFavourites();
    }
    else
    {
        favourites[num] = null;
        favourites = favourites.filter(function (el) {
            return el != null;
        });
        UpdateFavourites();
        nowselect = 0;
        OnSelect(2);
    }

	GameEvents.SendCustomGameEventToServer("anime_chatwheel_update_favorites", { favourites: favourites });
}
function UpdateFavourites() {
    var msg = new Array();
    var numsb = new Array();
    var numsi = new Array();
    for ( var i = 0; i < 8; i++ )
    {
        if (favourites[i])
        {
            msg[i] = FindLabelByNum(favourites[i]);
            numsi[i] = favourites[i];
            numsb[i] = true;
        }
        else
        {
            msg[i] = "";
            numsi[i] = 0;
            numsb[i] = false;
        }
    }
    rings[nowrings] = new Array(msg,numsb,numsi);
}
function FindLabelByNum(num) {
    for (var key in rings) {
        var element = rings[key];
        for ( var i = 0; i < 8; i++ )
        {
            if (element[1][i] == true && element[2][i] == num)
            {
                return element[0][i];
            }
        }
    }
}

function OnMouseOver(num) {
    //$.Msg(num);
    $( "#WheelPointer" ).RemoveClass( "Hidden" );
    $( "#Arrow" ).RemoveClass( "Hidden" );
    for ( var i = 0; i < 8; i++ )
    {
        if ($("#Wheel").BHasClass("ForWheel"+i))
            $( "#Wheel" ).RemoveClass( "ForWheel"+i );
    }
    $( "#Wheel" ).AddClass( "ForWheel"+num );
    //$.Msg($.Localize("#whsoundtooltip"));
    $("#WHTooltip").visible = rings[nowselect][1][num];
    $("#WHTooltip").SetDialogVariableInt( "num", rings[nowselect][2][num]);
}

function OnMouseOut(num) {
    //$.Msg(num);
    $( "#WheelPointer" ).AddClass( "Hidden" );
    $( "#Arrow" ).AddClass( "Hidden" );
    $("#WHTooltip").visible = false;
}

(function() {
	GameUI.CustomUIConfig().chatWheelLoaded = true;



    //var hero = Players.GetPlayerSelectedHero(Game.GetLocalPlayerID());
    //$("#HeroImage").heroname = hero;
    for ( var i = 0; i < 8; i++ )
    {   
        const hPanelProperties =    {
                                        class           : "MyPhrases",
                                        onmouseactivate : "OnSelect(" + i + ")",
                                        onmouseover     : "OnMouseOver(" + i + ")",
                                        onmouseout      : "OnMouseOut(" + i + ")"
                                    };
        $.CreatePanelWithProperties("Button", $("#PhrasesContainer"), "Phrase"+i, hPanelProperties);

        //$("#PhrasesContainer").BCreateChildren("<Button id='Phrase"+i+"' class='MyPhrases' onmouseactivate='OnSelect("+i+")' onmouseover='OnMouseOver("+i+")' onmouseout='OnMouseOut("+i+")' />");//class='Phrase HasSound RequiresHeroBadgeTier BronzeTier'
        //$("#Phrase"+i).hittest = false;
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");
        $("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[0][1][i];
        $("#Phrase"+i).GetChild(0).GetChild(1).text = $.Localize(rings[0][0][i]);
    }

    Game.AddCommand("+WheelButton", StartWheel, "", 0);
    Game.AddCommand("-WheelButton", StopWheel, "", 0);

    GameUI.CustomUIConfig().AnimeStartOrStopChatWheel = StartOrStopChatWheel;

    $("#Wheel").visible = false;
    $("#Bubble").visible = false;
    $("#PhrasesContainer").visible = false;
    $("#WHTooltip").visible = false;

    GameEvents.Subscribe( "anime_chatwheel_sound_play", OnAnimeSoundPlay );

})();



function OnAnimeSoundPlay(event)
{
    var player_id = event.player_id;
    var sound = event.sound;

    var mute = Game.IsPlayerMuted(player_id);

    if (!mute)
    {
        Game.EmitSound(sound);
    }
}


