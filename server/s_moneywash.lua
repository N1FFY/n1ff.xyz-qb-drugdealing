local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-drugdealing:server:ExchangeMoneyItems', function(item, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local hasItem = Player.Functions.GetItemByName(item)
        local amountNum = tonumber(amount)
        if hasItem.amount >= amountNum then
            local reward = price*amount
            Player.Functions.RemoveItem(item, amountNum)
			Player.Functions.AddMoney(Config.WashRewardType, reward, "sold-moneywash")
            TriggerClientEvent('QBCore:Notify', src, Config.CollectMessage)
        else
            TriggerClientEvent('QBCore:Notify', src, "You don't have the amount you specified.")
        end
    end
end)

RegisterServerEvent('qb-drugdealing:server:nowash')
AddEventHandler('qb-drugdealing:server:nowash', function()
	TriggerClientEvent('QBCore:Notify', source, "You failed")
end)


QBCore.Functions.CreateCallback('qb-drugdealing:server:getInv', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items

    return cb(inventory)
end)
