local QBCore = exports['qb-core']:GetCoreObject()

local npcModel = `s_m_m_dockwork_01`
local coords = vector4(-1605.27, 5258.55, 2.08, 217.69)

local boats = {
    { label = "قارب صغير", model = "dinghy", price = 1500, time = 10 },
    { label = "قارب سريع", model = "jetmax", price = 3000, time = 10 },
    { label = "يخت صغير", model = "suntrap", price = 5000, time = 15 },
}

local rentedBoat = nil
local rentStartTime = nil
local rentDuration = nil


local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
SetBlipSprite(blip, 410)
SetBlipDisplay(blip, 4)
SetBlipScale(blip, 0.85)
SetBlipColour(blip, 3)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("تأجير قوارب")
EndTextCommandSetBlipName(blip)


CreateThread(function()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do Wait(10) end

    local ped = CreatePed(4, npcModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)

    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    RequestAnimDict("amb@world_human_clipboard@male@base")
    while not HasAnimDictLoaded("amb@world_human_clipboard@male@base") do Wait(10) end
    TaskPlayAnim(ped, "amb@world_human_clipboard@male@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                icon = "fas fa-ship",
                label = "تأجير قارب",
                action = function()
                    OpenBoatMenu()
                end
            }
        },
        distance = 2.5
    })
end)


function OpenBoatMenu()
    if rentedBoat and DoesEntityExist(rentedBoat) then
        QBCore.Functions.Notify("عندك قارب مؤجر بالفعل! أرجعه أول", "error")
        return
    end

    local menu = {}

    for _, v in pairs(boats) do
        menu[#menu + 1] = {
            header = v.label,
            txt = "السعر: $" .. v.price .. " | المدة: " .. v.time .. " دقيقة",
            params = {
                event = "boat:clientRent",
                args = v.model
            }
        }
    end

    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent("boat:clientRent", function(model)
    TriggerServerEvent("boat:rentBoat", model)
end)

RegisterNetEvent("boat:spawnRentedBoat", function(model, time)
    local ped = PlayerPedId()
    local spawnCoords = vector3(-1604.3, 5271.47, -0.48)

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    local boat = CreateVehicle(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 90.0, true, false)

    SetVehicleNumberPlateText(boat, "RENT")
    SetPedIntoVehicle(ped, boat, -1)

    rentedBoat = boat
    rentStartTime = GetGameTimer()
    rentDuration = time * 60000


    exports['qb-target']:AddTargetEntity(boat, {
        options = {
            {
                icon = "fas fa-undo",
                label = "إرجاع القارب",
                action = function()
                    ReturnBoat()
                end
            }
        },
        distance = 3.0
    })

    QBCore.Functions.Notify("تم تأجير القارب لمدة " .. time .. " دقائق", "success")


    CreateThread(function()
        Wait(rentDuration)

        if rentedBoat and DoesEntityExist(rentedBoat) then
            TriggerServerEvent("boat:expireBoat")
            rentedBoat = nil
            rentStartTime = nil
            rentDuration = nil
            QBCore.Functions.Notify("انتهى وقت الإيجار", "error")
        end
    end)
end)

function ReturnBoat()
    if not rentedBoat or not DoesEntityExist(rentedBoat) then
        QBCore.Functions.Notify("ما عندك قارب", "error")
        return
    end

    if not rentStartTime or not rentDuration then return end


    local timePassed = GetGameTimer() - rentStartTime
    TriggerServerEvent("boat:returnBoat", timePassed, rentDuration)


    DeleteEntity(rentedBoat)
    rentedBoat = nil
    rentStartTime = nil
    rentDuration = nil
end

RegisterNetEvent("boat:notifyRefund", function(refund)
    if refund > 0 then
        QBCore.Functions.Notify("استرجعت $" .. refund .. " 💰", "success")
    else
        QBCore.Functions.Notify("تم إرجاع القارب", "primary")
    end
end)
