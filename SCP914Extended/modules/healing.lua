
local Settings = GlobalSettings.healing or {
    FINE = {
        HealInterval = 1000,
        HealCycle = 300,
        HealingAmount = 5,
        Classes = {"CLASSD","SCIENTIST","FACILITY_GUARD","NTF_SCIENTIST","NTF_CADET","NTF_LIEUTENANT","NTF_COMMANDER","CHAOS_INSUGENCY"},
        IsRandom = true,
        Chance = 25
    },
    VERY_FINE = {
        HealInterval = 500,--2 tick in 1 sec
        HealCycle = 240,--120 seconds
        GhostMode = false,
        GhostTime = 20000,
        HealingAmount = 25,
        Classes = {"CLASSD","SCIENTIST","FACILITY_GUARD","NTF_SCIENTIST","NTF_CADET","NTF_LIEUTENANT","NTF_COMMANDER","CHAOS_INSUGENCY"},
        IsRandom = true,
        Chance = 30
    }
}
GlobalSettings.healing = Settings

Modules.healing = {
    FINE = {
        Action = function (self, player )
            if player:GetHealth() <= 100 then
                if not timer.Exists("PlayerHealingFINE_" .. player.SteamId) then
                    local timer = timer.Create("PlayerHealingFINE_" .. player.SteamId, Settings.FINE.HealInterval, Settings.FINE.HealCycle, function()
                        if player:GetHealth() <= 100 then
                            player:SetHealth(player:GetHealth() + Settings.FINE.HealingAmount)
                        end
                    end)
                    player:SendConsoleMessage("Вы чувствуете прилив сил", "green")
                    table.insert( Timers[player.SteamId], timer )
                end
            end
        end
    },
    VERY_FINE = {
        PlayersTick = {},
        Action = function (self, player )
            if not timer.Exists("PlayerHealingVERY_FINE_" .. player.SteamId) then
                if Settings.VERY_FINE.GhostMode then
                    player:SetGhostMode(true, true)
                    timer.Simple(Settings.VERY_FINE.GhostTime, function()
                        player:SetGhostMode(false)
                    end)
                end
                self.PlayersTick[player.SteamId] = 1
                local timer = timer.Create("PlayerHealingVERY_FINE_" .. player.SteamId, Settings.VERY_FINE.HealInterval, Settings.VERY_FINE.HealCycle, function()
                    -- \/ Yep it's slow... but not so ugly xD \/
                    local playerTicks = self.PlayersTick[player.SteamId]
                    if playerTicks ~= Settings.VERY_FINE.HealCycle then
                        if player:GetHealth() <= 100 then
                            player:SetHealth(player:GetHealth() + Settings.VERY_FINE.HealingAmount)
                        end
                        playerTicks = playerTicks + 1
                    else
                        player:Kill(static.DamageType.DECONT)
                    end
                    self.PlayersTick[player.SteamId] = playerTicks
                end)
                player:SendConsoleMessage("Вы чувствуете что стали совершенно иным существом, что-то тут не так...", "red")
                table.insert( Timers[player.SteamId], timer )
            end
        end
    }
}
