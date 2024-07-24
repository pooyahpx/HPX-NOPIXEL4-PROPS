Core = nil
CoreName = nil
CoreReady = false
Citizen.CreateThread(function()
    for k, v in pairs(Cores) do
        if GetResourceState(v.ResourceName) == "starting" or GetResourceState(v.ResourceName) == "started" then
            CoreName = v.ResourceName
            Core = v.GetFramework()
            CoreReady = true
        end
    end
end)

function GetPlayer(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player
    else
        --CUSTOM GET PLAYER FUNCTION HERE
    end
end

function GetPlayerCid(source)
    if CoreName == "qb-core" then
        local player = Core.Functions.GetPlayer(source)
        if player ~= nil then
            return player.PlayerData.citizenid
        else
            return nil
        end
        -- return player.PlayerData.citizenid
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player.getIdentifier()
    else
        --CUSTOM GET PLAYER CID FUNCTION HERE
    end
end


function Notify(source, text, length, type)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        Core.Functions.Notify(source, text, length, type)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        player.showNotification(text)
    else
    --CUSTOM NOTIFY FUNCTION HERE
    end
end

function GetPlayerMoney(src, type)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(src)
        return player.PlayerData.money[type]
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        local acType = "bank"
        if type == "cash" then
            acType = "money"
        end
        local account = player.getAccount(acType).money
        return player
    else
        --CUSTOM ACCOUNT GET MONEY FUNCTION HERE
    end
end

function AddMoney(src, type, amount, description)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(src)
        player.Functions.AddMoney(type, amount, description)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        if type == "bank" then
            player.addAccountMoney("bank", amount, description)
        elseif type == "cash" then
            player.addMoney(amount, description)
        end
    end
end


function RemoveMoney(src, type, amount, description)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(src)
        player.Functions.RemoveMoney(type, amount, description)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        if type == "bank" then
            player.removeAccountMoney("bank", amount, description)
        elseif type == "cash" then
            player.removeMoney(amount, description)
        else
            --CUSTOM ACCOUNT REMOVE MONEY FUNCTION HERE
        end
    end
end



function AddItem(source, name, amount, metadata)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        player.Functions.AddItem(name, amount)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qb-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('pa_inventory') == 'started'

        if hasQs then
            return exports['qb-inventory']:AddItem(source, name, amount)
        elseif hasEsx then
            return player.addInventoryItem(name, amount)
        elseif hasOx then
            return exports["pa_inventory"]:AddItem(source, name, amount, metadata)
        else
            --CUSTOM INVENTORY ADD ITEM FUNCTION HERE
        end

    end
end

function RemoveItem(source, name, amount, metadata)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        player.Functions.RemoveItem(name, amount, metadata)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qb-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('pa_inventory') == 'started'

        if hasQs then
            return exports['qb-inventory']:RemoveItem(source, name, amount, metadata)
        elseif hasEsx then
            return player.removeInventoryItem(name, amount)
        elseif hasOx then
            return exports["pa_inventory"]:RemoveItem(source, name, amount, metadata)
        else
        end
    end
end

function GetItem(source, name)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.Functions.GetItemByName(name)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qb-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('pa_inventory') == 'started'

        if hasQs then
            return exports['qb-inventory']:GetItem(source, name)
        elseif hasEsx then
            return player.getInventoryItem(name)
        elseif hasOx then
            return exports["pa_inventory"]:GetItem(source, name)
        else

        end
    end
end

function GetInventory(source)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.PlayerData.items
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qb-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('pa_inventory') == 'started'

        if hasQs then
            return exports['qb-inventory']:GetPlayerInventory(source)
        elseif hasEsx or hasOx then
            return player.getInventory()

        else
            --CUSTOM INVENTORY GET INVENTORY FUNCTION HERE
        end
    end
end

function ItemCountControl(source, name, amount)
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player.Functions.GetItemByName(name).amount >= amount
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        local hasQs = GetResourceState('qb-inventory') == 'started'
        local hasEsx = GetResourceState('esx_inventoryhud') == 'started'
        local hasOx = GetResourceState('pa_inventory') == 'started'

        if hasQs then
            return exports['qb-inventory']:GetItem(source, name).amount >= amount
        elseif hasEsx then
            return player.getInventoryItem(name).count >= amount
        elseif hasOx then
            return exports["pa_inventory"]:GetItem(source, name).amount >= amount
        else
            --CUSTOM INVENTORY ITEM COUNT CONTROL FUNCTION HERE
        end
    end
end

function RegisterUseableItem(name)
    while CoreReady == false do Citizen.Wait(0) end
    if CoreName == "qb-core" or CoreName == "qbx_core" then
        Core.Functions.CreateUseableItem(name, function(source, item)
            TriggerClientEvent('pa-moneylaunder:showIdCard:client', source, item.info or item.metadata)
        end)
    elseif CoreName == "es_extended" then
        local hasQs = GetResourceState('qb-inventory') == 'started'
        if hasQs then
            Core.RegisterUsableItem(name, function(source, item)
                TriggerClientEvent('pa-moneylaunder:showIdCard:client', source, item.info)
            end)
            return
        end
        Core.RegisterUsableItem(k, function(source, _, item)
            TriggerClientEvent('pa-moneylaunder:showIdCard:client', source, item.metadata)
        end)
    end
end

QB.ServerCallbacks = {}
function CreateCallback(name, cb)
    QB.ServerCallbacks[name] = cb
end

function TriggerCallback(name, source, cb, ...)
    if not QB.ServerCallbacks[name] then return end
    QB.ServerCallbacks[name](source, cb, ...)
end

RegisterNetEvent('pa-moneylaunder:server:triggerCallback', function(name, ...)
    local src = source
    TriggerCallback(name, src, function(...)
        TriggerClientEvent('pa-moneylaunder:client:triggerCallback', src, name, ...)
    end, ...)
end)