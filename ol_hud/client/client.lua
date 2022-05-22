ESX = nil
local status = nil
local hudmodo = 3
local polices = 0
local police = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('saaweel_hud:obtenerpolice', function(count)
        polices = count
    end)
    
    while true do
        Citizen.Wait(200)
        if IsPauseMenuActive() then
            SendNUIMessage({
                show = false
            })
        else
            local radar = 0
            local oxigeno = GetPlayerUnderwaterTimeRemaining(PlayerId())*10

            if oxigeno > 100 then
                oxigeno = 100
            end

            if IsMinimapRendering() then
                radar = 1
            end

            if IsMinimapRendering() and IsBigmapActive() then
                radar = 2
            end

            if polices > 1 then
                police = true
            else
                police = false
            end

            SendNUIMessage({
                show = true,
                health = GetEntityHealth(PlayerPedId()) - 100,
                armor = GetPedArmour(PlayerPedId()),
                nadando = IsPedSwimmingUnderWater(PlayerPedId()),
                oxigeno = oxigeno,
                st = status,
                radar = radar,
                police = police
            })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if hudmodo == 3 then
            WichVehicleItIs(GetVehiclePedIsIn(PlayerPedId()))

            if PedVehIsBike == false and IsPedInAnyVehicle(PlayerPedId(), false) then
                DisplayRadar(true)
            else
                Citizen.Wait(500)
                DisplayRadar(false)
            end
        elseif hudmodo == 4 then
            DisplayRadar(false)
        else
            Citizen.Wait(500)
            DisplayRadar(true)
        end
    end
end)

RegisterNetEvent('saaweel_hud:updatePolice')
AddEventHandler('saaweel_hud:updatePolice', function(count)
    police = count
end)

RegisterNetEvent('saaweel_hud:updateStatus')
AddEventHandler('saaweel_hud:updateStatus', function(Status)
    status = Status
end)

-- RegisterNetEvent('esx:setJob')
-- AddEventHandler('esx:setJob', function(job)
--     SendNUIMessage({
--         trabajo = job.label .. ' - ' .. job.grade_label,
--     })
-- end)


AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
        while ESX == nil do Citizen.Wait(10) end
        ESX.TriggerServerCallback('saaweel_hud:obtenermodo', function(modo)
            SendNUIMessage({
                -- trabajo = ESX.GetPlayerData().job.label .. ' - ' .. ESX.GetPlayerData().job.grade_label,
                cambiarhud = tonumber(modo)
            })
            hudmodo = tonumber(modo)
        end)
	end
end)

AddEventHandler('skinchanger:modelLoaded', function()
    while ESX == nil do Citizen.Wait(10) end
    ESX.TriggerServerCallback('saaweel_hud:obtenermodo', function(modo)
        SendNUIMessage({
            -- trabajo = ESX.GetPlayerData().job.label .. ' - ' .. ESX.GetPlayerData().job.grade_label,
            cambiarhud = tonumber(modo)
        })
        hudmodo = tonumber(modo)
    end)
end)

RegisterCommand('hud', function(src, args, raw)
    if tonumber(args[1]) == 1 or tonumber(args[1]) == 2 or tonumber(args[1]) == 3 or tonumber(args[1]) == 4 then
        SendNUIMessage({
            cambiarhud = tonumber(args[1])
        })
        hudmodo = tonumber(args[1])
        TriggerServerEvent('saaweel_hud:setmodo', tonumber(args[1]))
    else
        TriggerEvent('chat:addMessage', {args = {'^4HUD', "Debes poner un valor válido (1, 2, 3, 4)"}})
    end
end)

function WichVehicleItIs(veh)
	if(lastVehCache == nil or lastVehCache ~= veh) then
		lastVehCache = veh
		PedVehIsHeli = false
		PedVehIsPlane = false
		PedVehIsBoat = false 
		PedVehIsBike = false 
		PedVehIsCar = false
		PedVehIsMotorcycle = false
		local vc = GetVehicleClass(veh)
		local vehiclemodel = GetEntityModel(veh)

		if( (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20 and vehiclemodel ~= GetHashKey("policemoto") and vehiclemodel ~= GetHashKey("policemoto") and vehiclemodel ~= GetHashKey("policeb2") and vehiclemodel ~= GetHashKey("emsbike") and vehiclemodel ~= GetHashKey("emsbike2"))) then
			PedVehIsCar = true
		elseif(vc == 8) then
			PedVehIsMotorcycle = true
		elseif(vc == 13) then
			PedVehIsBike = true
		elseif(vc == 14) then
			PedVehIsBoat = true
		elseif(vc == 15) then
			PedVehIsHeli = true
		elseif(vc == 16) then
			PedVehIsPlane = true
		elseif vehiclemodel == GetHashKey("policemoto") then
			PedVehIsMotorcycle = true
		elseif vehiclemodel == GetHashKey("policeb2") then
			PedVehIsMotorcycle = true
		elseif vehiclemodel == GetHashKey("sheriffb") then
			PedVehIsMotorcycle = true
		elseif vehiclemodel == GetHashKey("sheriffb2") then
			PedVehIsMotorcycle = true
		end
	end
end

RegisterCommand('minimapa', function(src, args, raw)
    if IsMinimapRendering() then
        if IsBigmapActive() then
            SetBigmapActive(false, false)
        else
            SetBigmapActive(true, false)
        end
    end
end)

RegisterKeyMapping("minimapa", "Cambiar tamaño del minimapa", "keyboard", "º")