"use strict";

function OnCustomButton(args)
{
	var MainHUDPanel = $.GetContextPanel().GetParent();
	var Panel = MainHUDPanel;

	if (args == 2)
	{
		Panel = FindDotaHudElement("ChatWheelRelease");

		//$.Msg(Panel);
	}
	else return;

	Panel.visible = !Panel.visible;

	//$.Msg(Panel);
}

function CloseAllAfterDelay()
{
	$.Msg("FFHHF");
	var MainHUDPanel = $.GetContextPanel().GetParent();
	var Panel = MainHUDPanel;

	Panel = MainHUDPanel.FindChildTraverse("HeroReleasePanel");
	Panel.visible = false;

	Panel = FindDotaHudElement("ChatWheelRelease");
	Panel.visible = false;
}

(function()
{
	//$.Schedule(5, CloseAllAfterDelay);

})();
