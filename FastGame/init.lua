pluginInfo = {
    id = "FG",
    name = "Gamemode - FastGame",
    author = "Andrey::Dono",
    version = "1.0"
}

function Init()

end

function WarheadStart(env, args)
    if(not timer.Exists("Warhead")) then
        timer.Create("Warhead",10*60*1000,1,function()
            warhead.Enable()
            timer.Simple(1500,function()
                warhead.Start()
                warhead.Lock()
            end)
        end)
    end
end

function WarheadStop(env, args)
    if(timer.Exists("Warhead")) then
        timer.Destroy("Warhead")
    end
end

hook.Add("OnRoundStart","WarheadTimerStart",WarheadStart)
hook.Add("OnRoundEnd","WarheadTimerEnd",WarheadStop)
hook.Add("OnRoundRestart","WarheadTimerRestart",WarheadStop)

--hook.onRoundStart.add(RoundStart)
--hook.onRoundEnd.add(RoundEnd)