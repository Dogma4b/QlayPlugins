pluginInfo = {
    id = "Inv",
    name = "Custom inventory",
    author = "Andrey::Dono",
    version = "1.1"
}

function Init()
    Inventory = json.parse(file:read("Inventory.json"))
end

function InventoryHandler( ply, role, inv ) 
    inv = {}
    if(ply.Name ~= "Server") then
        for class, obj in pairs(Inventory) do 
            if(static.Role[class] == role) then
                inv[static.Role[class]] = {}
                for key, item in pairs(obj) do
                    if(type(item) == "table") then
                        for item, value in pairs(item) do
                            if(item == "Ammo") then
                                ply:SetAmmo(static.Ammo[value.type], math.random( value.count[1], value.count[2] ))
                            else
                                if (value >= math.random( 100 )) then
                                    table.insert( inv, static.Item[item] )
                                    break
                                end
                            end
                        end
                    else
                        table.insert( inv, static.Item[item] )
                    end
                end
            end
        end
        return {Items = inv}
    end
end

hook.Add("OnSetInventory", "CustomInventory", InventoryHandler)