LinkLuaModifier( "modifier_disconnect", "modifier_disconnect", LUA_MODIFIER_MOTION_NONE )

ASBEvents = class({})
ASB_ABAN_PLAYERS_EVENTS = {}
ASB_PLAYER_CONNECT_INFO = {}

function ASBEvents:RegListeners()
    ListenToGameEvent( "player_disconnect", Dynamic_Wrap( self, 'OnDisconnect' ), self )
    ListenToGameEvent("player_reconnected", Dynamic_Wrap( self, 'OnPlayerReconnect'), self)
end

function ASBEvents:OnDisconnect(table)
    ASB_PLAYER_CONNECT_INFO[table.PlayerID] = ASB_PLAYER_CONNECT_INFO[table.PlayerID] or {}
    ASB_PLAYER_CONNECT_INFO[table.PlayerID].connection = "disconnected"
    local player = PlayerResource:GetPlayer(table.PlayerID)
    if player then
        local hero = player:GetAssignedHero()
        if hero then
            if hero:IsIllusion() then return end
            hero:AddNewModifier(hero, nil, "modifier_disconnect", {})
        end
    end
end     

function ASBEvents:OnPlayerReconnect(table)
    local id = tonumber(table.PlayerID)
    ASB_PLAYER_CONNECT_INFO[id] = ASB_PLAYER_CONNECT_INFO[id] or {}
    ASB_PLAYER_CONNECT_INFO[id].connection = "connected"
    local player = PlayerResource:GetPlayer(id)
    local hero = player:GetAssignedHero()
    hero:RemoveModifierByName("modifier_disconnect")
end

function ASBEvents:SendJsEventAllClients(event_name, t)
    for id = 0, PlayerResource:GetPlayerCount() - 1 do
        if not IsPlayerDisconnected(id) then
            CustomGameEventManager:Send_ServerToAllClients(event_name, t)
        else
            ASB_ABAN_PLAYERS_EVENTS[id] = ASB_ABAN_PLAYERS_EVENTS[id] or {}
            table.insert(ASB_ABAN_PLAYERS_EVENTS[id], {event_n = event_name, table = t})
        end    
    end
end

function IsPlayerDisconnected(id)
    local table = ASB_PLAYER_CONNECT_INFO[tonumber(id)] or {}
    return table.connection == "disconnected"
end
