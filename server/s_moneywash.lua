local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-drugdealing:server:getMoneyWashList', function(source, cb)
    local MoneyWashList = {}
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        for i = 1, #Config.WashList, 1 do
            local item = Player.Functions.GetItemByName(Config.WashList[i])

            if item ~= nil then
                MoneyWashList[#MoneyWashList+1] = {
                    item = item.name,
                    amount = item.amount,
                    label = QBCore.Shared.Items[item.name]["label"]
                }
            end
        end
        if next(MoneyWashList) ~= nil then
            cb(MoneyWashList)
        else
            cb(nil)
        end
    end
end)

RegisterNetEvent('qb-drugdealing:server:ExchangeMoneyItems', function(item, amount, price)
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
            for i = 1, #Config.WashList, 1 do
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

RegisterServerEvent('qb-drugdealing:server:nowash')
AddEventHandler('qb-drugdealing:server:nowash', function()
	TriggerClientEvent('QBCore:Notify', source, Config.NoWash)
end)
