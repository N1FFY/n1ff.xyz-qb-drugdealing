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
            PriceOfWashed = math.random(MoneyWashData.min, MoneyWashData.max) * MoneyWashAmount
        end
    end)
    if MoneyWashList ~= nil then
        if MoneyWashAmount <= MoneyWashList[MoneyWashType].amount then
            PlayerPed = PlayerPedId()
            ClearPedTasksImmediately(PlayerPed)
            TaskPlayAnim( PlayerPed, "anim@gangops@facility@servers@", "hotwire", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
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
        end
        TriggerServerEvent('qb-drugdealing:server:nowash')
    else
    TriggerServerEvent('qb-drugdealing:server:nowash')
    end
end)
        

