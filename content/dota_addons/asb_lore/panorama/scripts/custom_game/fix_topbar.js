function FixHeroIcons()
{
    var topbar = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("topbar") // Ето топбар и его мы будем насиловать
    var playerSlots = topbar.FindChildrenWithClassTraverse("ScoreboardPlayer") // Находим в етом топбаре все панели с классом TopBarPlayerSlot, ибо каждая такая панель соответствует одному игроку.

    for ( k in playerSlots )
    {
        var img = playerSlots[k].FindChildTraverse("HeroImage")
        if ( img.Children().length == 0 )
        {
            var new_img = $.CreatePanel( "Image", img, "ImageOverride" )
            if (img.heroname) 
            {
                 new_img.SetImage( "file://{images}/custom_game/heroes/" + img.heroname + ".png" );
            } 
        }
    }
    $.Schedule( 0.1, FixHeroIcons ) // В течение игры топбар может меняться, при этом все наши внесенные в него изменения сбрасываются. Чтобы избежать потери изменений, заставим этот код выполняться с постоянной периодичностью.
}

FixHeroIcons()