local QBCore = exports['qb-core']:GetCoreObject()
local MoneyWashList = {}
local percentage = 0

RegisterNetEvent('qb-drugdealing:client:startMoneyWash')
AddEventHandler('qb-drugdealing:client:startMoneyWash', function(data)
    amount = tonumber(data)
    QBCore.Functions.TriggerCallback('qb-drugdealing:server:getMoneyWashList', function(result)
    availableDrugs = result
        if availableDrugs ~= nil then
            drugType = math.random(1, #availableDrugs)
            bagAmount = math.random(Config.MinSaleAmount, Config.MaxSaleAmount)
            currentOfferDrug = availableDrugs[drugType]
            data = Config.WashPrice[currentOfferDrug.item]
            randomPrice = math.random(data.min, data.max) * bagAmount
        end
    end)
    if availableDrugs ~= nil then
        if availableDrugs[drugType].amount >= amount then
            QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage1, Config.MinigameWaitTime*1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
            }, {}, {}, {}, function()
            if Config.Minigame == "on" then
                TriggerEvent("datacrack:start", 1, function(output)
                    if output == true then
                        TriggerServerEvent('qb-drugdealing:server:washed20')
                        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage2, Config.MinigameWaitTime*1000, false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                            }, {}, {}, {}, function()    
                                TriggerEvent("datacrack:start", 2, function(output)
                                    if output == true then
                                        TriggerServerEvent('qb-drugdealing:server:washed20')
                                        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage3, Config.MinigameWaitTime*1000, false, true, {
                                            disableMovement = false,
                                            disableCarMovement = false,
                                            disableMouse = false,
                                            disableCombat = true,
                                            }, {}, {}, {}, function()    
                                                TriggerEvent("datacrack:start", 1, function(output)
                                                    if output == true then
                                                        TriggerServerEvent('qb-drugdealing:server:washed20')
                                                        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage4, Config.MinigameWaitTime*1000, false, true, {
                                                            disableMovement = false,
                                                            disableCarMovement = false,
                                                            disableMouse = false,
                                                            disableCombat = true,
                                                            }, {}, {}, {}, function()   
                                                                TriggerEvent("datacrack:start", 1, function(output)
                                                                    if output == true then
                                                                        TriggerServerEvent('qb-drugdealing:server:washed20')
                                                                        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage5, Config.MinigameWaitTime*1000, false, true, {
                                                                            disableMovement = false,
                                                                            disableCarMovement = false,
                                                                            disableMouse = false,
                                                                            disableCombat = true,
                                                                            }, {}, {}, {}, function()    
                                                                                TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, rewardgiven)
                                                                            end)
                                                                    else
                                                                        local percentage = 80
                                                                        local reward = PriceOfWashed / 100
                                                                        local rewardgiven = reward * percentage
                                                                        TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, rewardgiven)
                                                                    end
                                                                end)  
                                                            end)
                                                    else
                                                        local percentage = 60
                                                        local reward = PriceOfWashed / 100
                                                        local rewardgiven = reward * percentage
                                                        TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, rewardgiven)
                                                    end
                                                end) 
                                            end)
                                    else
                                        local percentage = 40
                                        local reward = PriceOfWashed / 100
                                        local rewardgiven = reward * percentage
                                        TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, rewardgiven)
                                    end
                                end) 
                            end)
                    else
                        local percentage = 20
                        local reward = PriceOfWashed / 100
                        local rewardgiven = reward * percentage
                        TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, rewardgiven)
                    end
                end) 
            elseif Config.Minigame == "off" then
                QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage1, Config.MinigameOffWaitTime*1000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                    }, {}, {}, {}, function()
                    TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', MoneyWashList[MoneyWashType].item, MoneyWashAmount, PriceOfWashed)
                    end)
            end
            end)
        else
        TriggerServerEvent('qb-drugdealing:server:nowash')
        end
    else
    TriggerServerEvent('qb-drugdealing:server:nowash')
    end
end)

RegisterNetEvent("qb-drugdealing:client:amount", function()
    local WashingItem = exports['qb-input']:ShowInput({
        header = "Laundry Simulator 9000",
        submitText = "Submit",
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = "Amount to wash", {value = amount}
            }
        }
    })
    if WashingItem then
        if not WashingItem.amount then
            return
        end

        if tonumber(WashingItem.amount) > 0 then
            TriggerEvent('qb-drugdealing:client:startMoneyWash', WashingItem.amount)
        end
    end
end)

