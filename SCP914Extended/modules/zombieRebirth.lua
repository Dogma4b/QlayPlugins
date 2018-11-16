
local Settings = GlobalSettings.zombieRebirth or {
    FINE = {
        HealInterval = 1000,
        HealCycle = 300,
        HealingAmount = 5,
        Classes = {"SCP_049_2"},
        IsRandom = true,
        Chance = 25
    },
    VERY_FINE = {
        Classes = {"SCP_049_2"},
        IsRandom = true,
        Chance = 40
    }
}
GlobalSettings.zombieRebirth = Settings

Modules.zombieRebirth = {
    FINE = {
        Action = function (self, player )
            
        end
    },
    VERY_FINE = {
        Action = function (self, player )
            player:ChangeRole(static.Role.CLASSD, true, false)
        end
    }
}
