local QBCore = exports['qb-core']:GetCoreObject()
local ItemSaleName = 0
local ItemSalePrice = 0
local AmountToSell = 0
local DropPed = nil
local madeDeal = nil
local started = false
local dropOffCount = 0
local payment = false
local Runs = 0

function CallCops()
	if math.random(100) <= Config.CallCopsChance then
		if Config.DispatchSystem == "linden_outlawalert" then
        	local data = {displayCode = '10-50', description = 'Drug Sale', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-cannabis', 
        	info = ('[%s]'):format(vehInfo.plate).. " Drug Sale in progress", info2 = vehInfo.name, blipSprite = 326, blipColour = 1}
        	local dispatchData = {dispatchData = data, caller = 'Alarm', coords = carPos}
        	TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    	elseif Config.DispatchSystem == "qb-dispatch" then
        	exports["qb-dispatch"]:DrugSale()
		end
	end
end

RegisterNetEvent('qb-drugdealing:client:knockondoor')
AddEventHandler('qb-drugdealing:client:knockondoor', function()
	local Player = QBCore.Functions.GetPlayerData()
    local cash = Player.money.cash
	QBCore.Functions.TriggerCallback('qb-drugdealing:server:getCops', function(cops)
		if cops >= Config.MinimumPoliceBulkSelling then
    		QBCore.Functions.TriggerCallback('qb-drugdealing:server:CheckForBulk', function(ItemData)
       	 		if ItemData ~= nil then
					QBCore.Functions.Notify("Welcome back, reknowned member.", 'success')
					TriggerEvent('qb-drugdealing:client:openBulkSelling')
				else
					QBCore.Functions.Notify("Scram loser, before you get yourself killed.", 'error')
       			end
  	    	end)
		else
			QBCore.Functions.Notify("There isn't enough cops around, try again later.", 'error')
		end
	end)
end)

RegisterNetEvent('qb-drugdealing:client:collectpayment')
AddEventHandler('qb-drugdealing:client:collectpayment', function()
	payment = false
	TriggerServerEvent('qb-drugdealing:server:bulksellsalefinish')
end)

exports['qb-target']:AddBoxZone("qb-drugdealing:bulksell", vector3(94.23, -2694.03, 6.0), 0.4, 2.5, {
	name = "qb-drugdealing:bulksell",
	heading = 96,
	debugPoly = false,
	minZ = 0,
	maxZ = 255,
}, {
	options = {
		{
            type = "client",
            event = "qb-drugdealing:client:knockondoor",
			icon = "fas fa-circle",
			label = "Knock on the Door",
		},
		{
            type = "client",
            event = "qb-drugdealing:client:collectpayment",
			icon = "fas fa-circle",
			label = "Collect Payment",
			canInteract = function()
                if payment == true then return true else return false end 
            end
		},
	},
	distance = 2.5
})

RegisterNetEvent('qb-drugdealing:client:openBulkSelling', function()
	local bulkMenu = {
		{
			header = "Pacific Bait",
			isMenuHeader = true,
		},
		{
			header = "Sell your 'Bait'.",
			txt = "Sell to the Fishermen of the Streets.",
			params = {
				event = "qb-drugdealing:client:openBulk",
				args = {
					items = Config.BulkList
				}
			}
		}
	}
	exports['qb-menu']:openMenu(bulkMenu)
end)


RegisterNetEvent('qb-drugdealing:client:openBulk', function(data)
QBCore.Functions.TriggerCallback('qb-drugdealing:server:getInv', function(inventory)
	local PlyInv = inventory
	local bulkMenu2 = {
		{
			header = "Pacific Bait",
			isMenuHeader = true,
		}
	}

	for k,v in pairs(PlyInv) do
		for i = 1, #data.items do
			if v.name == data.items[i].item then
				bulkMenu2[#bulkMenu2 +1] = {
					header = QBCore.Shared.Items[v.name].label,
					txt = "Sell your presitgous bait, to the hungry fishermen of the streets.",{value = data.items[i].price},
					params = {
						event = "qb-drugdealing:client:bulkitemsamount",
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

	bulkMenu2[#bulkMenu2+1] = {
		header = "Go Back",
		params = {
			event = "qb-drugdealing:client:openBulkSelling"
		}
	}
	exports['qb-menu']:openMenu(bulkMenu2)
end)
end)

RegisterNetEvent("qb-drugdealing:client:bulkitemsamount", function(item)
    local sellingItem = exports['qb-input']:ShowInput({
        header = "Pacific Bait",
        submitText = "The Finest Bait for the Streets.",
        inputs = {
            {
                type = 'number',
                isRequired = false,
                name = 'amount',
                text = "Amount of Bait to sell", {value = item.amount}
            }
        }
    })

    if sellingItem then
        if not sellingItem.amount then
            return
        end

        if tonumber(sellingItem.amount) > 0 then
            TriggerEvent('qb-drugdealing:client:startbulksell', item.name, sellingItem.amount, item.price)
        else
            QBCore.Functions.Notify("You do not have that amount.", 'error')
        end
    end
end)

RegisterNetEvent("qb-drugdealing:client:startbulksell", function(salename, sellingItemamount, itemprice)
	if started then return end
	started = true
	ItemSaleName = salename
	ItemSalePrice = itemprice
	AmountToSell = tonumber(sellingItemamount)
	if AmountToSell < Config.Tier1 then tier = 1 elseif AmountToSell >= Config.Tier1 and AmountToSell < Config.Tier2 then tier = 2 elseif AmountToSell >= Config.Tier2 and AmountToSell < Config.Tier3 then tier = 3 else tier = 4 end
	if tier == 1 then Runs = Config.Tier1Runs elseif tier == 2 then Runs = Config.Tier2Runs elseif tier == 3 then Runs = Config.Tier3Runs elseif tier == 4 then Runs = Config.Tier4Runs end
	QBCore.Functions.Notify("You will need to find your own vehicle, i don't supply that.", 'success')
	CreateDropOff()
end)


local CreateDropOffBlip = function(coords)
	dropOffBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dropOffBlip, 514)
    SetBlipScale(dropOffBlip, 1.0)
    SetBlipAsShortRange(dropOffBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Fishing Bait Buyer")
    EndTextCommandSetBlipName(dropOffBlip)
end

local CreateDropOffPed = function(coords)
	if DropPed ~= nil then return end
	local model = Config.Bulkpeds[math.random(#Config.Bulkpeds)]
	local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end
	DropPed = CreatePed(5, hash, coords.x, coords.y, coords.z-1, coords.w, true, true)
	while not DoesEntityExist(DropPed) do Wait(10) end
	ClearPedTasks(DropPed)
    ClearPedSecondaryTask(DropPed)
    TaskSetBlockingOfNonTemporaryEvents(DropPed, true)
    SetPedFleeAttributes(DropPed, 0, 0)
    SetPedCombatAttributes(DropPed, 17, 1)
    SetPedSeeingRange(DropPed, 0.0)
    SetPedHearingRange(DropPed, 0.0)
    SetPedAlertness(DropPed, 0)
    SetPedKeepTask(DropPed, true)
	FreezeEntityPosition(DropPed, true)
	exports['qb-target']:AddTargetEntity(DropPed, {
		options = {
			{
				type = "client",
				event = "qb-drugdealing:client:handover",
				icon = 'fa-fishing-rod',
				label = 'Hand over bait.',
			}
		},
		distance = 2.0
	})
end

function CreateDropOff()
	hasDropOff = true
	TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "Head over to the drop off point.", 'fa-fishing-rod', '#3480eb', 8000)
	dropOffCount = dropOffCount + 1
	local randomLoc = Config.Locations[math.random(#Config.Locations)]
	CreateDropOffBlip(randomLoc)
	BulkSellArea = CircleZone:Create(randomLoc.xyz, 85.0, {
		name = "BulkSellArea",
		debugPoly = false
	})
	BulkSellArea:onPlayerInOut(function(isPointInside, point)
		if isPointInside then
			if DropPed == nil then
				TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "Make the delivery..", 'fa-fishing-rod', '#3480eb', 8000)
				CreateDropOffPed(randomLoc)
			end
		end
	end)
end

function TurnToPed()
	TaskTurnPedToFaceEntity(DropPed, ped, 1.0)
	TaskTurnPedToFaceEntity(ped, DropPed, 1.0)
	Wait(1500)
	PlayAmbientSpeech1(DropPed, "Generic_Hi", "Speech_Params_Force")
	Wait(1000)
end

function DropPedAnimation()
	PlayAmbientSpeech1(DropPed, "Chat_State", "Speech_Params_Force")
	Wait(500)
	RequestAnimDict("mp_safehouselost@")
	while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
	TaskPlayAnim(DropPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
	Wait(3000)
end

function PlayerAnimation()
	RequestAnimDict("mp_safehouselost@")
    while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
    TaskPlayAnim(ped, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
	Wait(800)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


RegisterNetEvent('qb-drugdealing:client:handover', function()
	if madeDeal then return end
	ped = PlayerPedId()
	if not IsPedOnFoot(ped) then return end
	if #(GetEntityCoords(ped) - GetEntityCoords(DropPed)) < 5.0 then
		madeDeal = true
		exports['qb-target']:RemoveTargetEntity(DropPed)
		CallCops()
		TurnToPed()
		PlayerAnimation()
		DropPedAnimation()
		RemoveBlip(dropOffBlip)
		dropOffBlip = nil
		giveAnim()
		QBCore.Functions.Progressbar("Price", "Negotiating a Price..", Config.SaleTime*1000, false, true, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function()
			TriggerServerEvent('qb-drugdealing:server:bulksellsale', ItemSaleName, ItemSalePrice)
			BulkSellArea:destroy()
			Wait(2000)
			if dropOffCount == Runs then
				TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "You're done, return to Pacific Bait", 'fa-fishing-rod', '#3480eb', 20000)
				started = false
				dropOffCount = 0
				payment = true
				DeleteDropPed()
			else
				TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "GPS coming soon for the next drop.", 'fa-fishing-rod', '#3480eb', 20000)
				DeleteDropPed()
				Wait(20000)
				CreateDropOff()
			end
			hasDropOff = false
			madeDeal = false
		end)
	end
end)

function DeleteDropPed()
	FreezeEntityPosition(DropPed, false)
	SetPedKeepTask(DropPed, false)
	TaskSetBlockingOfNonTemporaryEvents(DropPed, false)
	ClearPedTasks(DropPed)
	TaskWanderStandard(DropPed, 10.0, 10)
	SetPedAsNoLongerNeeded(DropPed)
	Wait(20000)
	DeletePed(DropPed)
	DropPed = nil
end