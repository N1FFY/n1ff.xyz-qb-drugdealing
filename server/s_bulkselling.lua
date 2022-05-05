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

RegisterServerEvent('qb-drugdealing:server:NotEnoughMoney')
AddEventHandler('qb-drugdealing:server:NotEnoughMoney', function()
	TriggerClientEvent('QBCore:Notify', source, Config.NoMoney)
end)