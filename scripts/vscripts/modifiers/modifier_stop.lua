modifier_stop = class({})

function modifier_stop:modifier_stopAllMusic()
	if IsServer() then
		

		for i = 1, 49 do
			StopGlobalSound("item_anime_boombox_anime_themes_anime_theme_"..i)
		end

		for i = 1, 47 do
			StopGlobalSound("item_anime_boombox_anime_memes_anime_meme_"..i)
		end
		for i = 1, 3 do
			StopGlobalSound("item_anime_boombox_anime_legends_anime_legend_"..i)
		end

		

		
	end
end