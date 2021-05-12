ESX              = nil
local PlayerData = {}

player = PlayerPedId()


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent("WASHMAN:NOMONEY")
AddEventHandler("WASHMAN:NOMONEY",function()
	AddTextEntry("NoMoney", "Vous n'avais pas assez ~r~d'argent sale~w~! (min: "..Config.Minwashing.."€)")
	DisplayHelpTextThisFrame("NoMoney", false)
end)

RegisterNetEvent("WASHMAN:MONEYISWASHING")
AddEventHandler("WASHMAN:MONEYISWASHING", function(money)
	money =	math.floor(money)
	ESX.ShowAdvancedNotification("#######", "Blanchiment","Merci vous avais ~r~blanchis "..money.."€",   "CHAR_DEFAULT", 1)
end)



--SQL CODE
RegisterNetEvent("WASHMAN:RETURN")
AddEventHandler("WASHMAN:RETURN", function(money)
	local amount = money
	local year,month,day,hour,minute,second = GetUtcTime()
    local hour = (hour..":"..minute..":"..second)
    TriggerServerEvent("WASHMAN:GET", hour, amount)
end)

Citizen.CreateThread(function()
	local location =  Config.Location
	local inmap, floorZ = GetGroundZFor_3dCoord(
		location.x , 
		location.y, 
		location.z, 
		0
	)
	local proche = false
	local hash = GetHashKey('a_m_m_hasjew_01')
	RequestModel(hash)
	while not HasModelLoaded(hash) do Citizen.Wait(0) end
	local NewLoc = vector3(location.x, location.y, location.z)
	while true do
		local distance = IsNear(NewLoc)
		if distance < 20 then	
			if not proche then
				washMan = CreatePed(1, hash, location.x, location.y, floorZ, location.w, false, false)
				SetBlockingOfNonTemporaryEvents(washMan, true)
				SetEntityInvincible(washMan, true)
				Citizen.CreateThread(function()
					Citizen.Wait(1000)
					FreezeEntityPosition(washMan, true)
				end)
			end
			proche = true
		else
			proche = false
			if not proche then
				DeleteEntity(washMan)
			end
		end
		Citizen.Wait(4)
	end

end)

RegisterNetEvent("PLAYANIM")
AddEventHandler("PLAYANIM", function(hour,money)
    PlayGiveAnim()
end)

Citizen.CreateThread(function() 
	
	local location = Config.Location
	local inmap, floorZ = GetGroundZFor_3dCoord(location.x , location.y, location.z, 0)
	while true do
		local player = PlayerPedId()
		local distance = IsNear(location)
		local refresh  = 4
		if distance < Config.Distance then
			Draw3DText(location.x, location.y, floorZ, "Appuyer sur [E]", 4 , 0.1, 0.1)
			if distance < 2 and IsControlJustPressed("1", 51) then
				open()
			end
		elseif distance > 100 then
			refresh = 200
		else 
			refresh = 50
		end
		Citizen.Wait(refresh)
	end
end)

function IsNear(vector)
	
	local player = PlayerPedId()
	local coordPlayer = GetEntityCoords(player)
	isNear = GetDistanceBetweenCoords(coordPlayer, vector, true)
	return isNear
end

function open()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_', {
        title = "WashMan"
    }, function(data, menu)
		
        local amount = tonumber(data.value)
        
		if amount == nil then
			
        else
            
			menu.close()
			TriggerServerEvent("WASHMAN:WASHMONEY", amount)

        end
    end, function(data, menu)
        menu.close()
	end)
	
	return 
end

function PlayGiveAnim()
	RequestAnimDict("mp_common")
	while (not HasAnimDictLoaded("mp_common")) do			
		Citizen.Wait(5)
	end
	TaskPlayAnim(washMan, "mp_common", "givetake1_a", 8.0, 8.0, -1, 12, 0, false, false, false)
	TaskPlayAnim(player, "mp_common", "givetake1_a", 8.0, 8.0, -1, 12, 0, false, false, false)
	ClearPedTasks(washMan)
	ClearPedTasks(player)

end

Citizen.CreateThread(function()
	while true do
		local player = PlayerPedId()
		local enter = Config.Enter
		local out = Config.Out
		if Config.Enter ~= nil and Config.Out ~= nil then
			DrawMarker(2, enter.x, enter.y, enter.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 128, 0, 50, true, false, 2, true,nil, nil, false)
			DrawMarker(2, out.x, out.y, out.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 128, 0, 50, true, false, 2, true,nil, nil, false)
			local distanceEnter = IsNear(enter)
			local distanceOut = IsNear(out)
			local inmapEnter, floorZEnter = GetGroundZFor_3dCoord(enter.x, enter.y, enter.z, 0)
			local inmapOut, floorZOut = GetGroundZFor_3dCoord(out.x, out.y, out.z, 0)
			if distanceEnter < 1 then
				AddTextEntry("ENTER","Appuye sur ~INPUT_CONTEXT~ pour ~r~sortir")
				DisplayHelpTextThisFrame("ENTER", false)
				if IsControlJustPressed(1, 51) then
					SetPedCoordsKeepVehicle(player, out.x, out.y, floorZOut)				
				end
			elseif distanceOut < 1 then
				AddTextEntry("ENTER","Appuye sur ~INPUT_CONTEXT~ pour ~r~sortir")
				DisplayHelpTextThisFrame("ENTER", false)
				if IsControlJustPressed(1, 51) then
					SetPedCoordsKeepVehicle(player, enter.x, enter.y, floorZEnter)
				end
			end
		end
		Citizen.Wait(4)
	end
end)

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
	local px,py,pz = table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov   
	SetTextScale(scaleX * scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, 255)		-- You can change the text color here
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end