pluginInfo = {
    id = "SCP914",
    name = "SCP 914 Extended version",
    author = "Andrey::Dono",
    version = "1.0"
}

function Init()
    GlobalSettings = json.parse(file.read("settings.json"))
    Modules, ActionData, Timers = {}, {}, {}

    local dir = "modules"
    for key, module in pairs(file.Find(dir)) do
        include(dir .. "/" .. module)
    end

    for name, module in pairs(Modules) do
        for knob, data in pairs(module) do
            for key, class in pairs(GlobalSettings[name][knob].Classes) do
                ActionData[knob] = ActionData[knob] or {}
                ActionData[knob][class] = ActionData[knob][class] or {}
                ActionData[knob][class][name] = data
            end
        end
    end
end

function SCP914ActivateHandler( players, knobSetting, inputPos, outputPos )
    for key, player in pairs(players) do
        Timers[player.SteamId] = Timers[player.SteamId] or {}
        local playerTeam, playerRole = player.TeamRole.Team, player.TeamRole.Role
        if ActionData[tostring(knobSetting)][tostring(playerRole)] ~= nil then
            local module, moduleName = table.Random(ActionData[tostring(knobSetting)][tostring(playerRole)])
            local rnd = math.random( 100 )
            if not GlobalSettings[moduleName][tostring(knobSetting)].IsRandom or GlobalSettings[moduleName][tostring(knobSetting)].Chance >= rnd then
                module:Action(player)
            else
                if 50 >= rnd then
                    player:Kill(static.DamageType.DECONT)
                end
            end
        end
    end
end

function CreatePlayerTimers(ply)
    Timers[ply.SteamId] = Timers[ply.SteamId] or {}
end

function PlayerClearingBuffsOnChangeClass( player )
    if Timers[player.SteamId] ~= nil then
        for id, tmr in pairs(Timers[player.SteamId]) do
            tmr.Stop()
            --table.remove( Timers[ply.SteamId], id )
            MsgN("Timer Destroyed " .. id)
        end
    end
end

function DestroyPlayerTimers(connection)
    local players = player.GetAll()
    if players ~= nil then
        for k, ply in pairs(players) do
            if (connection.IpAddress == ply.IpAddress and Timers[ply.SteamId] ~= nil) then
                for id, timer in pairs(Timers[ply.SteamId]) do
                    timer.Stop()
                end
                Timers[ply.SteamId] = {}
            end
        end
    end
end

function DestroyTimersHandler()
    for key, players in pairs(Timers) do
        for id, timer in pairs(players) do
            timer.Stop()
        end
    end
    Timers = {}
end

--function SaveRecipes()
    --file:write("914_recipes.json", json.serialize(scp914.GetRecepies()))
--end

--hook.Add("OnRoundStart", "914SaveRecipes", SaveRecipes)
hook.Add("OnPlayerJoin", "SCP914", CreatePlayerTimers)
hook.Add("OnDisconnect", "SCP914", DestroyPlayerTimers)
hook.Add("OnSCP914Activate", "SCP914", SCP914ActivateHandler)
hook.Add("OnSetRole", "Remove healing buff's", PlayerClearingBuffsOnChangeClass)
hook.Add("OnRoundEnd", "SCP914", DestroyTimersHandler)
hook.Add("OnRoundRestart", "SCP914", DestroyTimersHandler)