ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("WASHMAN:WASHMONEY")
AddEventHandler("WASHMAN:WASHMONEY", function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)   
    local blackMoney = xPlayer.getAccount('black_money').money
    print("amount: "..amount)
    if amount >= Config.Minwashing and blackMoney - amount >= 0 then
        local X = math.random(Config.PorcentageMin, Config.PorcentageMax)
        local washMoney = amount - (amount / 100 * X)
        local washMoney =  math.floor(washMoney)
        xPlayer.removeAccountMoney('black_money', amount)
        TriggerClientEvent('WASHMAN:RETURN', source, washMoney)
        TriggerClientEvent('PLAYANIM', source)        
    else
        TriggerClientEvent('WASHMAN:NOMONEY', source)
    end
end)


--SQL CODE
RegisterNetEvent("WASHMAN:GET")
AddEventHandler("WASHMAN:GET", function(hour,money)
    local money = money
    print("MONEY: "..money)
    local hour = hour
    local playerid = source
    local steamPlayer = infoplayer(playerid)
    local time = os.time()
    MySQL.Async.execute("INSERT INTO moneywash (id, time, amount, ostime) VALUES (@a, @b, @c, @d)", {['a'] = steamPlayer, ['b'] = hour, ['c'] = money, ['d'] = time}, function()
        print("^2Requête envoiyé")
    end)
end)

function recup()
    local result = MySQL.Sync.fetchAll('SELECT * FROM moneywash', {})
    
    for i,v in ipairs(result)do
           
        local line = result[i]
        local time = line.ostime
        local Numero = line.Numero
        local id = line.id
        local amount = line.amount
        diff = os.date("*t", os.difftime(os.time(), time))
        if diff.sec >= Config.time.second or diff.min >= Config.time.minute+1 or diff.hour > Config.time.hour+1 or diff.day > Config.time.days+1 or diff.month > 1 then  
            local isconnected = verfieIsConnected(id)
            local isco = isconnected[1]
            local playerId = isconnected[2]
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if isconnected and xPlayer ~= nil then
                MySQL.Sync.execute("DELETE FROM moneywash WHERE moneywash.Numero = @a", {['a'] = Numero})
                TriggerClientEvent('WASHMAN:MONEYISWASHING', playerId, amount)
                xPlayer.addAccountMoney('bank', amount)
            end
        end
    end
end



function verfieIsConnected(steam)
    for _, playerId in ipairs(GetPlayers()) do
        steamid = infoplayer(playerId)
        if steam == steamid then
            return{true, playerId}
        end
    end
    return {false, null}
end


function infoplayer(playerid)
    for k,v in ipairs(GetPlayerIdentifiers(playerid))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifier = v
        end
    end
    return identifier
end

Citizen.CreateThread(function()
    Citizen.CreateThread(function()
        while true do  
            recup()
            Citizen.Wait(5000)
        end
    end)
end)