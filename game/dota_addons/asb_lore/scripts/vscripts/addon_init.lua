if IsClient() then
	AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    require( 'functions/functions_client' )
    require("anime_functions_server_client")
    require("anime_modifiers_server_client")
    require("internal/indicator_menu_no_panorama")

    --require("anime_requires/anime_error_handler_server_client")
end
