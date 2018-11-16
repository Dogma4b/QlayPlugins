pluginInfo = {
    id = "MF",
    name = "Mute Fix",
    author = "Andrey::Dono",
    version = "1.0"
}

function Init()
    
end

function MuteUpdate( ply )
    ply:SetMute(false)
    ply:SetMute(true)
end

function PlayerJoinHandler( ply )
    local players = player.GetAll()
    if players ~= nil then
        for k,v in pairs(player.GetMuteList()) do
            for kv,ply in pairs(players) do
                if(v ~= "" and not string.find( v,"ICOM-" )) then
                    if (ply.SteamId == v) then
                        timer.Simple(3000, function()
                            MuteUpdate(ply)
                        end)
                    end
                end
            end
        end
    end
end

function OnRoundStart()
    local players = player.GetAll()
    if players ~= nil then
        for k,v in pairs(player.GetMuteList()) do
            for kv,ply in pairs(players) do
                if(v ~= "" and not string.find( v,"ICOM-" )) then
                    if (ply.SteamId == v) then
                        MuteUpdate(ply)
                    end
                end
            end
        end
    end
end

hook.Add("OnPlayerJoin", "PlayerMute", PlayerJoinHandler)
hook.Add("OnRoundStart", "UpdateTimersMuteDestroyed", OnRoundStart)