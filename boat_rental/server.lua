---By Icy https://github.com/icyly-n
---enjoy with it

local QBCore = exports['qb-core']:GetCoreObject()

local boats = {
    ["dinghy"]  = { price = 1500, time = 10 },
    ["jetmax"]  = { price = 3000, time = 10 },
    ["suntrap"] = { price = 5000, time = 15 },
}


local activeRentals = {}


RegisterNetEvent("boat:rentBoat", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

  
    if activeRentals[src] then
        TriggerClientEvent('QBCore:Notify', src, "عندك قارب مؤجر بالفعل!", "error")
        return
    end

    if not boats[model] then
        TriggerClientEvent('QBCore:Notify', src, "موديل غير صالح", "error")
        return
    end

    local price = boats[model].price
    local time  = boats[model].time

    if Player.Functions.RemoveMoney("cash", price) then
     
        activeRentals[src] = {
            model     = model,
            price     = price,
            startTime = os.time(),
            duration  = time * 60, 
        }

        TriggerClientEvent("boat:spawnRentedBoat", src, model, time)
    else
        TriggerClientEvent('QBCore:Notify', src, "ما عندك فلوس كافية 💸", "error")
    end
end)


RegisterNetEvent("boat:returnBoat", function(timePassed, rentDuration)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end
    if not activeRentals[src] then return end

    local rental = activeRentals[src]


    local refund = 0
    local timeLeft = rental.duration - (os.time() - rental.startTime)

    if timeLeft > 0 then
        local percentage = timeLeft / rental.duration
        refund = math.floor(rental.price * percentage)
    end

    if refund > 0 then
        Player.Functions.AddMoney("cash", refund)
    end


    TriggerClientEvent("boat:notifyRefund", src, refund)


    activeRentals[src] = nil
end)


RegisterNetEvent("boat:expireBoat", function()
    local src = source
    activeRentals[src] = nil
end)


AddEventHandler("playerDropped", function()
    local src = source
    activeRentals[src] = nil
end)
