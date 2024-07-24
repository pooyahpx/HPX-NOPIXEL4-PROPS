playerData = {}
cacheData = {}
buildCacheData = {}
allObject = {}
sell = false
randomCoords = nil
torbaci = nil
currentObject = nil
objectHash = nil
lastPropItem = nil
itemSell = nil
coinSell = 0
local modelsToLoad = {"w_am_case","ch_prop_casino_drone_02a"}
menuId = 0

RegisterCommand("propsystem", function()
    SetNuiFocus(1, 1)
    SendNUIMessage({
        action = "openProps",
        data = QB.PropsAll,
    })
end)


RegisterNUICallback("openProps", function(data, cb)
    flag = false
    TriggerCallback('qb-props:propItemControl', function(serverCb) 
        if serverCb then
            lastPropItem = data.itemName
            objectName = data.propName
            objectHash = data.hash
            local playerPed = PlayerPedId()
            local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0, 1.0, 0)
            local model = joaat(objectName)

            currentObject = CreateObject(model, offset.x, offset.y, offset.z, true, false, false)

            Citizen.CreateThread(function()
                while flag do 
                    Wait(100)
                    SendNUIMessage({
                        action = "setPropsData",
                        data = {
                            rotation = GetEntityRotation(currentObject),
                            position = GetEntityCoords(currentObject),
                        }
                    })
                end
            end)

            local objectPositionData = exports.object_gizmo:useGizmo(currentObject) 

            FreezeEntityPosition(currentObject, true)

        else
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('deleteProp',function()
    DeleteEntity(currentObject)
    DeleteObject(currentObject)
    currentObject = nil
    TriggerServerEvent('pa-money:addLastProp', lastPropItem)
    lastPropItem = nil
end)

RegisterNUICallback("close", function()
    SetNuiFocus(0, 0)
end)

function loadModels(models)
    for _, model in ipairs(models) do
        RequestModel(model)
    end
    while not AreModelsLoaded(models) do
        Wait(500)
    end
end

function AreModelsLoaded(models)
    for _, model in ipairs(models) do
        if not HasModelLoaded(model) then
            return false
        end
    end
    return true
end

RegisterNUICallback("close", function()
    SetNuiFocus(0, 0)
end)


RegisterNUICallback('saveBuild', function(data,cb)

    for k , v in pairs(QB.PropsAll) do
        if v.hash == tostring(objectHash) then
            data = {
                rotation = GetEntityRotation(currentObject),
                position = GetEntityCoords(currentObject),
                heading = GetEntityHeading(currentObject),
                name = v.name,
                hash = v.hash,
                propname = v.propname,
                objId = math.random(1, 1000000),
            }
            TriggerServerEvent('qb-props:createProp', data, menuId)
        end
    end

end)

RegisterNetEvent('qb-props:setClient')
AddEventHandler('qb-props:setClient',function(data)
    cacheData = data

    if cacheData then
        for k, v in pairs(cacheData) do
                id = v.id
                identifier = v.identifier
                props = v.props
                miner = v.miner
                canvas = v.canvas
        end
    end

end)

RegisterNetEvent('qb-props:notify')
AddEventHandler('qb-props:notify',function(data)
    Notify(data)
end)

RegisterNetEvent('qb-props:spawnProp')
AddEventHandler('qb-props:spawnProp',function(data,obj)

    SetEntityAsMissionEntity(NetworkGetNetworkIdFromEntity(obj), true, true)
    SetEntityHeading(NetworkGetNetworkIdFromEntity(obj), data.heading)
    FreezeEntityPosition(NetworkGetNetworkIdFromEntity(obj), true)
    SetModelAsNoLongerNeeded(data.hash)
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    playerData = GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded', function()
    playerData = GetPlayerData()
end)


Citizen.CreateThread(function()
    while true do
         Citizen.Wait(500)
         if NetworkIsPlayerActive(PlayerId()) then 
            playerData = GetPlayerData()
            TriggerServerEvent('qb-props:dataPostClient')
            Wait(5000)
            TriggerEvent('qb-props:createObject', cacheData)
            break
        end 
    end
end)



RegisterNetEvent('qb-props:createObject')
AddEventHandler('qb-props:createObject', function(cacheData)
    
    for _, v1 in pairs(cacheData) do
        if CoreName == "es_extended" then
            if playerData.identifier == v1.identifier then
                for _, v2 in pairs(v1.props) do
                    obj = CreateObject(tonumber(v2.hash), v2.position.x, v2.position.y, v2.position.z, true, true, true)
                    SetEntityAsMissionEntity(obj, true, true)
                    SetEntityHeading(obj, v2.heading)
                    FreezeEntityPosition(obj, true)
                    SetModelAsNoLongerNeeded(model)
                    table.insert(allObject, obj)
                end
            end
        else
            if tonumber(playerData.citizenid) == tonumber(v1.identifier) then
                for _, v2 in pairs(v1.props) do
                    obj = CreateObject(tonumber(v2.hash), v2.position.x, v2.position.y, v2.position.Z, true, true, true)
                    SetEntityAsMissionEntity(obj, true, true)
                    SetEntityHeading(obj, v2.heading)
                    FreezeEntityPosition(obj, true)
                    SetModelAsNoLongerNeeded(model)
                    table.insert(allObject, obj)
                end
            end
        end
    end
end)


RegisterNetEvent('qb-props:deleteProp')
AddEventHandler('qb-props:deleteProp',function()
    DeleteEntity(currentObject)
    DeleteObject(currentObject)
    for k, v in pairs(allObject) do
        DeleteEntity(v)
        DeleteObject(v)
    end
    allObject = {}
    currentObject = nil
end)


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 500
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end


function loadAnimDict(dict)  
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(500)
    end
end 

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k, v in pairs(allObject) do
        DeleteEntity(v)
        DeleteObject(v)
        end
        DeleteEntity(currentObject)
        DeleteObject(currentObject)
        currentObject = nil
        allObject = {}
end)
