pluginInfo = {
    id = "soe",
    name = "Spawn on Escape",
    author = "Andrey::Dono",
    version = "1.0"
}

function EscapeHandler(ply, role, allowEscape)
    if (allowEscape) then
        local pos = ply:GetPosition()
        timer.Simple(1, function()
            ply:Teleport(pos)
        end)
    end
end

hook.Add("OnCheckEscape", "SpawnPlayerOnEscape", EscapeHandler)