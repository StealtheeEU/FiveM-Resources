------------------------------------------------------------------------------------------------------------------------------------------------------

-- Location Coords

borisbikemarkerlocations = {
  [1] = {"borisbliphospital",295.95858764648, -611.47515869141, 42.97,38,70.0}, --(Name, X,Y, Z, Blip, RotZ)
  [2] = {"borisblipairport",-1050.6302490234, -2741.1262207031, 14.17,38,-30.0},
  [3] = {"borisblippier",-1637.2801513672, -1012.6521606445, 12.7,38,50.0},
  [4] = {"borisbliplegion",189.57662963867, -845.60565185547, 30.62,38,30.0}
}

------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3D Marker

Citizen.CreateThread(function()
  while true do
    for i,v in pairs(borisbikemarkerlocations) do -- i = index so going through the diffrent parts of the table and v = the value in the decleration
       DrawMarker(v[5],v[2],v[3],v[4], 0.0, 0.0, 0.0, 0.0, 0.0, v[6], 2.0, 2.0, 2.0, 255, 128, 0, 50, false, false, 2, nil, nil, false)
    end
    Wait(0)
  end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------

-- Map Marker

Citizen.CreateThread(function()
    for i,v in pairs(borisbikemarkerlocations) do
        local borisblip = AddBlipForCoord(v[2],v[3])
        -- sets the blip id (which icon will be desplayed)
        SetBlipSprite(borisblip, 536)
        -- sets where the blip to be shown on both the minimap and the menu map
        SetBlipColour(borisblip, 46)
        -- colour of blip
        SetBlipDisplay(borisblip, 6)
        -- how big the blip will be
        SetBlipScale(borisblip, 0.6)
        -- blip entry type
        SetBlipAsShortRange(borisblip, true)
        -- Sets whether or not the specified blip should only be displayed when nearby, or on the minimap.
        BeginTextCommandSetBlipName("STRING")
        -- The title of the blip
        AddTextComponentString("Boris Bike")
        EndTextCommandSetBlipName(borisblip)
        end
        Wait(0)
end)

------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3D Text

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (0.25 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    for i,v in pairs(borisbikemarkerlocations) do
        Citizen.CreateThread(
            function()
                local distance_until_text_disappears = 2.5
                while true do
                    Citizen.Wait(0)
                    -- the "Vdist2" native checks how far two vectors are from another.
                    if Vdist2(GetEntityCoords(PlayerPedId(), false), v[2],v[3],v[4]) < distance_until_text_disappears then
                        Draw3DText(v[2],v[3],v[4], 1.5, "Press E for a Boris Bike")
                    end
                end
            end
        )
    end
        Wait(0)
end
)

------------------------------------------------------------------------------------------------------------------------------------------------------

-- Boris Bike Function

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            for i,v in pairs(borisbikemarkerlocations) do
                local clientlocation = GetEntityCoords(PlayerPedId())
                local bikelocations = vector3(v[2],v[3],v[4])
                local distance = #(clientlocation - bikelocations) -- Hashtag means number
                if distance <= 2.5 then
                    if IsControlJustReleased(0, 46) then
                        exports['ProgressBar']:startUI(10000, "Retreving")
                        Wait(10000)
                        RequestModel("BMX")
                            while not HasModelLoaded("BMX") do
                                Citizen.Wait(1)
                                RequestModel("BMX")
                            end
                        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
                        CreateVehicle("BMX", x, y + 2 , z + 0.25 , GetEntityHeading(PlayerPedId()), true, false)
                    end
                end
            end
    end
end)

------------------------------------------------------------------------------------------------------------------------------------------------------
