local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-drugdealing:client:startMoneyWash')
AddEventHandler('qb-drugdealing:client:startMoneyWash', function()
    QBCore.Functions.TriggerCallback('niff-selldrugs:server:getAvailableDrugs', function(result)
        MoneyWashList = result
        if MoneyWashList ~= nil then
            MoneyWashType = math.random(1, #MoneyWashList)
            MoneyWashAmount = math.random(Config.MinSaleAmount, Config.MaxSaleAmount)
            MoneyWashItem = availableDrugs[drugType]
            MoneyWashData = Config.DrugsPrice[currentOfferDrug.item]
            AmountToWash = math.random(ddata.min, ddata.max) * bagAmount
        end
    end)