local QBCore = exports['qb-core']:GetCoreObject()
	
QBCore.Functions.CreateCallback('niff-selldrugs:server:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        for i = 1, #Config.DrugsList, 1 do
            local item = Player.Functions.GetItemByName(Config.DrugsList[i])

            if item ~= nil then
                AvailableDrugs[#AvailableDrugs+1] = {
                    item = item.name,
                    amount = item.amount,
                    label = QBCore.Shared.Items[item.name]["label"]
                }
            end
        end
        if next(AvailableDrugs) ~= nil then
            cb(AvailableDrugs)
        else
            cb(nil)
        end
    end
end)

RegisterNetEvent('niff-selldrugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local hasItem = Player.Functions.GetItemByName(item)
        local AvailableDrugs = {}
        if hasItem.amount >= amount then
            Player.Functions.RemoveItem(item, amount)
			Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")
            --TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
			--Player.Functions.AddItem('loosenotes', price)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['loosenotes'], "add")
            for i = 1, #Config.DrugsList, 1 do
                local item = Player.Functions.GetItemByName(Config.DrugsList[i])
                if item ~= nil then
                    AvailableDrugs[#AvailableDrugs+1] = {
                        item = item.name,
                        amount = item.amount,
                        label = QBCore.Shared.Items[item.name]["label"]
                    }
                end
            end
        end
    end
end)

RegisterServerEvent('niff-selldrugs:server:nodrugs')
AddEventHandler('niff-selldrugs:server:nodrugs', function()
	TriggerClientEvent('QBCore:Notify', source, Config.NotIntrestedMessage)
end)

RegisterServerEvent('niff-selldrugs:server:timer')
AddEventHandler('niff-selldrugs:server:timer', function()
	TriggerClientEvent('QBCore:Notify', source, Config.TimerMessage)
end)

RegisterServerEvent('niff-selldrugs:server:cops')
AddEventHandler('niff-selldrugs:server:cops', function()
	TriggerClientEvent('QBCore:Notify', source, Config.NotEnoughCopsMessage)
end)

RegisterServerEvent('niff-selldrugs:server:oldped')
AddEventHandler('niff-selldrugs:server:oldped', function()
	TriggerClientEvent('QBCore:Notify', source, Config.SameCustomerMessage)
end)

RegisterServerEvent('niff-selldrugs:server:dead')
AddEventHandler('niff-selldrugs:server:dead', function()
	TriggerClientEvent('QBCore:Notify', source, Config.DeadOrFarAwayMessage)
end)

RegisterServerEvent('niff-selldrugs:server:nodrugsleft')
AddEventHandler('niff-selldrugs:server:nodrugsleft', function()
	TriggerClientEvent('QBCore:Notify', source, Config.NoDrugsMessage)
end)


QBCore.Functions.CreateCallback('niff-selldrugs:server:getCops', function(source, cb)
	local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)
