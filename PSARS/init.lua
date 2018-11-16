pluginInfo = {
    id = "psars",
    name = "Player spawn after round start",
    author = "Andrey::Dono",
    version = "1.0"
}

function Init()
    SpawnAllow = false
    NewPlayers = {}
end

function RoundStart()
    if(not timer.Exists("PSARS")) then
        SpawnAllow = true
        MsgN("Spawn after start allowed")
        timer.Create("PSARS", 90000, 1, function()
            MsgN("Spawn after start restricted")
            SpawnAllow = false
        end)
    end
end

function RoundEnd()
    NewPlayers = {}
    MsgN("Player list cleaning...")
end

function PlayerJoin( ply )
    if (ply.Name ~= nil) then
        NewPlayers[ply.Name] = true
    end
    --print(ply.Name .. " has added to list")
end

function PlayerSpawn( ply, role )
    if (role ~= static.Role.SPECTATOR) then
        NewPlayers[ply.Name] = false
    end
    if (SpawnAllow and NewPlayers[ply.Name]) then
        NewPlayers[ply.Name] = false
        if(role == static.Role.SPECTATOR) then
            timer.Simple(250, function()
                ply:ChangeRole(static.Role.CLASSD, true, true, true, true)
                MsgN(ply.Name .. " has been spawned")
            end)
        end
    end
end

hook.Add("OnRoundStart", "PSARS", RoundStart)
hook.Add("OnRoundEnd", "PSARS", RoundEnd)
hook.Add("OnPlayerJoin", "PSARS", PlayerJoin)
hook.Add("OnSetRole", "PSARS", PlayerSpawn)