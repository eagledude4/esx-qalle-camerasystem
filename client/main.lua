ESX                           = nil

local Markers = {
    ['OpenWitnessMenu'] = { ['x'] = 440.56942749023, ['y'] = -993.33453369141, ['z'] = 30.689599990845 }
}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(1)
    end

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()

        LoadMarkers()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(response)
    ESX.PlayerData = response

    LoadMarkers()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(response)
    ESX.PlayerData["job"] = response
end)

function LoadMarkers()
    Citizen.CreateThread(function()
        while true do
            local sleep = 500

            for place, val in pairs(Markers) do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), val.x, val.y, val.z, true)

                if distance < 4.5 then
                    sleep = 5

                    if place == 'OpenWitnessMenu' then
                        DrawM('[E] Witness Reports', 27, val.x, val.y, val.z - 0.945, 255, 255, 255, 0.7, 0.7)
                    end

                    if distance < 0.5 then
                        if IsControlJustReleased(0, 38) and ESX.PlayerData["job"]["name"] == "police" then
                            OpenWitnessMenu()
                        end
                    end
                end
            end

            Citizen.Wait(sleep)
        end

    end)
end

--[[## Code to add to witness menu ##
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin)
    end)
]]

function loadSuspect(pedID)
  SetFrontendActive(true)
  ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_EMPTY"), false, -1)

  Citizen.Wait(100)
  N_0x98215325a695e78a(false)

  local PlayerPedPreview = ClonePed(PlayerPedId(), GetEntityHeading(PlayerPedId()), false, false)
  SetEntityVisible(PlayerPedPreview, false, false)

  Wait(200)
  GivePedToPauseMenu(PlayerPedPreview, 2)
  SetPauseMenuPedLighting(true)
  SetPauseMenuPedSleepState(true)
end


function OpenWitnessMenu()
    local elements = {}

    ESX.TriggerServerCallback('esx-qalle-camerasystem:getSuspects', function(value)

        for k,v in pairs(value) do

            if v.action ~= nil then
                table.insert(elements, { label = v.action .. " - Suspect ID: " .. v.number, pedID = v.pedID })
            else
                table.insert(elements, { label = "Suspect ID: " .. v.number, pedID = v.pedID })
            end

        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'suspect_menu',
            {
                title    = "Suspects",
                align    = "right",
                elements = elements
            },
        function(data, menu)
            local action = data.current.value
            local ped = data.current.pedID
            loadSuspect(ped)
        end, function(data, menu)
            SetFrontendActive(false)
            menu.close()
        end)
    end)
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end
