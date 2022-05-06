local QBCore = exports['qb-core']:GetCoreObject()
local money = 0

RegisterNetEvent('qb-drugdealing:server:bulkfee', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', Config.CarPrice)
end)

QBCore.Functions.CreateCallback('qb-drugdealing:server:CheckForBulk', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items
    local ItemData = Player.Functions.GetItemByName(Config.BulkSellingItem)
    return cb(ItemData)
end)

RegisterServerEvent('qb-drugdealing:server:NoSale')
AddEventHandler('qb-drugdealing:server:NoSale', function()
	TriggerClientEvent('QBCore:Notify', source, Config.NoMoney)
end)


RegisterServerEvent('qb-drugdealing:server:bulksellsale')
AddEventHandler('qb-drugdealing:server:bulksellsale', function(item, price)
	if math.random(1,100) <= Config.ChanceOfSale then
        local src = source
        local amount = math.random(1,Config.MaxSaleAmount)
        local price = price*amount
        local Player = QBCore.Functions.GetPlayer(src)
            if Player then
                local hasItem = Player.Functions.GetItemByName(item)
                if hasItem.amount >= amount then
                    if Config.BulkSaleReward == "money" then
                        Player.Functions.RemoveItem(item, amount)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
                        Player.Functions.AddMoney(Config.BulkSaleRewardMoney, price, "sold-cornerdrugs")
                    elseif Config.BulkSaleReward == "item" then
                        Player.Functions.RemoveItem(item, amount)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
                        Player.Functions.AddItem(Config.BulkSaleRewardItem, price)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.BulkSaleRewardItem], "add")
                    end
                else
                    TriggerNetEvent('qb-drugdealing:server:NoSale')
                end
            end
    else
        TriggerNetEvent('qb-drugdealing:server:NoSale')
    end
end)


QBCore.Functions.CreateCallback('qb-drugdealing:server:getCopsBulk', function(source, cb)
	local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        if Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cb(amount)
end)
