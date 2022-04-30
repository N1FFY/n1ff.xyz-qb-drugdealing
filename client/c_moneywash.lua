local QBCore = exports['qb-core']:GetCoreObject()

-- I KNOW THE CODE IS SLOPPY HERE. REWORK COMING SOON

function playerAnim()
	loadAnimDict( "anim@gangops@facility@servers@" )
    TaskPlayAnim( PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", -1, 1.0, -1, 49, 0, 0, 0, 0 )
end

RegisterNetEvent('qb-drugdealing:client:openMoneyWashMenu', function()
        local WashMenu = {
            {
                header = "Laundry Simulator 9000",
                isMenuHeader = true,
            },
            {
                header = "Wash your cash",
                txt = "Wash it!",
                params = {
                    event = "qb-drugdealing:client:openWash",
                    args = {
                        items = Config.WashList
                    }
                }
            }
        }
        exports['qb-menu']:openMenu(WashMenu)
end)

RegisterNetEvent('qb-drugdealing:client:openWash', function(data)
    QBCore.Functions.TriggerCallback('qb-drugdealing:server:getInv', function(inventory)
        local PlyInv = inventory
        local washMenu = {
            {
                header = "Laundry Washer 9000",
                isMenuHeader = true,
            }
        }

        for k,v in pairs(PlyInv) do
            for i = 1, #data.items do
                if v.name == data.items[i].item then
                    washMenu[#washMenu +1] = {
                        header = QBCore.Shared.Items[v.name].label,
                        txt = "Wash your dirty cash!",{value = data.items[i].price},
                        params = {
                            event = "qb-drugdealing:client:washitems",
                            args = {
                                label = QBCore.Shared.Items[v.name].label,
                                price = data.items[i].price,
                                name = v.name,
                                amount = v.amount
                            }
                        }
                    }
                end
            end
        end

        washMenu[#washMenu+1] = {
            header = "Go Back",
            params = {
                event = "qb-drugdealing:client:openMoneyWashMenu"
            }
        }
        exports['qb-menu']:openMenu(washMenu)
    end)
end)

RegisterNetEvent("qb-drugdealing:client:washitems", function(item)
    local sellingItem = exports['qb-input']:ShowInput({
        header = "Laundrymat Simulator 9000",
        submitText = "Wash your cash!",
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = "Amount to wash", {value = item.amount}
            }
        }
    })

    if sellingItem then
        if not sellingItem.amount then
            return
        end

        if tonumber(sellingItem.amount) > 0 then
            TriggerEvent('qb-drugdealing:client:startMoneyWash', item.name, sellingItem.amount, item.price)
        else
            QBCore.Functions.Notify("You do not have that amount.", 'error')
        end
    end
end)


RegisterNetEvent('qb-drugdealing:client:startMoneyWash')
AddEventHandler('qb-drugdealing:client:startMoneyWash', function(item, amount, price)
    if Config.Minigame == "on" then
        playerAnim()
        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage, Config.MinigameWaitTime*1000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = true,
            disableCombat = true,
            }, {}, {}, {}, function()
                QBCore.Functions.TriggerCallback('qb-drugdealing:server:CheckForItems', function(ItemData)
                    if ItemData ~= nil then
                        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage, Config.MinigameWaitTime*1000, false, true, {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = true,
                            disableCombat = true,
                            }, {}, {}, {}, function()
                            end)
                    else
                        TriggerServerEvent('qb-drugdealing:server:noitem')
                    end
                end)
            end)
    elseif Config.Minigame == "off" then
        local player = PlayerPedId()
        playerAnim()
        QBCore.Functions.Progressbar("Moneywash", Config.MoneyWashMessage, Config.MinigameOffWaitTime*1000, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = true,
            disableCombat = true,
            }, {}, {}, {}, function()
            TriggerServerEvent('qb-drugdealing:server:ExchangeMoneyItems', item, amount, price)
            ClearPedTasksImmediately(player)
        end)
    end
end)