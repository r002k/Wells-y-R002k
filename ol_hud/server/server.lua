ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local policeCount = 0

ESX.RegisterServerCallback('saaweel_hud:obtenermodo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT hudmodo FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] then
			cb(result[1].hudmodo)
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('saaweel_hud:setmodo', function(modo)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Sync.execute('UPDATE users SET hudmodo = @modo WHERE identifier = @identifier', {
        ['@modo'] = modo,
        ['@identifier'] = xPlayer.identifier
    })
end)

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(source ,xPlayer)
	if xPlayer.job.name == "lspd" or xPlayer.job.name == "bcso" then
		policeCount = policeCount + 1
	end
	TriggerClientEvent("saaweel_hud:updatePolice", -1, policeCount)
end)

RegisterServerEvent('esx:setJob')
AddEventHandler('esx:setJob', function(source, job, lastJob)
	if lastJob.name == "lspd" or lastJob.name == "bcso" then
		policeCount = policeCount - 1
		TriggerClientEvent("saaweel_hud:updatePolice", -1, policeCount)
	elseif job.name == "lspd" or job.name == "bcso" then
		policeCount = policeCount + 1
		TriggerClientEvent("saaweel_hud:updatePolice", -1, policeCount)
	end
end)

ESX.RegisterServerCallback('saaweel_hud:obtenerpolice', function(source, cb)
	cb(policeCount)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == "lspd" or xPlayer.job.name == "bcso" then
                policeCount = policeCount + 1
            end
        end
	end
end)

AddEventHandler('playerDropped', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "lspd" or xPlayer.job.name == "bcso" then
		policeCount = policeCount - 1
	end
end)

RegisterCommand('cops', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == 'mod' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'fundador' or xPlayer.getGroup() == 'director' then
		if args[1] ~= nil then
			policeCount = args[1]
			TriggerClientEvent("saaweel_hud:updatePolice", -1, policeCount)
		else
			xPlayer.showNotification('Pon un numero')
		end
	else
		xPlayer.showNotification('No eres admin')
	end
end)

RegisterCommand('listapolicias', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() == 'mod' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'fundador' or xPlayer.getGroup() == 'director' then
		local xPlayers = ESX.GetPlayers()
		print("Lista de jugadores como Policías")
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer.job.name == "lspd" or xPlayer.job.name == "bcso" then
				print("Nombre IC: ".. "[" .. xPlayer.job.name .. "] " .. xPlayer.name .. "[" .. xPlayers[i] .. "], Grado: " .. xPlayer.job.grade .. " Steam: " .. GetPlayerName(xPlayers[i]))			  
			end

		end	
	else
		xPlayer.showNotification('No eres admin')
	end
end)