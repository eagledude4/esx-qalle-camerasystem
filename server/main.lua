ESX = nil
local SuspectPeds = {}
local lastId = 0

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('esx-qalle-camerasystem:addSuspect')
AddEventHandler('esx-qalle-camerasystem:addSuspect', function(pedID, action)
    local pedID = pedID
    local newNumber = lastId + 1

    if action ~= nil then
        table.insert(SuspectPeds, {random = newNumber, pedID = pedID, action = action})
    else
        table.insert(SuspectPeds, {random = newNumber, pedID = pedID})
    end
end)

ESX.RegisterServerCallback('esx-qalle-camerasystem:getSuspects', function(source, cb)
    local suspects = {}

    for index, value in pairs(SuspectPeds) do
        if val.action ~= nil then
            table.insert(suspects, { number = value.random, pedID = value.pedID, action = value.action })
        else
            table.insert(suspects, { number = value.random, pedID = value.pedID })
        end
    end

    cb(suspects)
end)
