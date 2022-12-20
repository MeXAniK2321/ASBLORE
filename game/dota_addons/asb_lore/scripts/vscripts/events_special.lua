StarEvents = class({})
STAR_ABAN_PLAYERS_EVENTS = {}
function StarEvents:SendJsEventAllClients(event_name, t)
    for id = 0, PlayerResource:GetPlayerCount() - 1 do
        if not IsPlayerDisconnected(id) then
            CustomGameEventManager:Send_ServerToAllClients(event_name, t)
        else
            STAR_ABAN_PLAYERS_EVENTS[id] = STAR_ABAN_PLAYERS_EVENTS[id] or {}
            table.insert(STAR_ABAN_PLAYERS_EVENTS[id], {event_n = event_name, table = t})
        end    
    end
end