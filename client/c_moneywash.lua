local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-drugdealing:client:startMoneyWash')
AddEventHandler('qb-drugdealing:client:startMoneyWash', function()
    QBCore.Functions.TriggerCallback('qb-drugdealing:server:getMoneyWashList', function(result)
        MoneyWashList = result
        if MoneyWashList ~= nil then
            MoneyWashType = math.random(1, #MoneyWashList)
            MoneyWashAmount = math.random(Config.MinWashAmount, Config.MaxWashAmount)
            MoneyWashItem = MoneyWashList[MoneyWashType]
            MoneyWashData = Config.WashPrice[MoneyWashItem.item]
            PriceOfWashed = math.random(MoneyWashData.min, MoneyWashData.max) * bagAmount
        end
    end)
    if MoneyWashList ~= nil then
        PlayerPed = PlayerPedId()
        ClearPedTasksImmediately(PlayerPed)
        TaskPlayAnim( PlayerPed, "anim@gangops@facility@servers@", "hotwire", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        QBCore.Functions.Progressbar("Moneywash", "Starting the Moneywash Process..", Config.SaleTime*1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, PriceOfWashed)
    end
end)
        