local QBCore = exports['qb-core']:GetCoreObject()
local Vehicle = 0
local ItemSale = 0
local DropPed = nil
local madeDeal = nil
local started = false

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
			if cash >= Config.CarPrice then
    			QBCore.Functions.TriggerCallback('qb-drugdealing:server:CheckForBulk', function(ItemData)
       	 			if ItemData ~= nil then
						QBCore.Functions.Notify("Welcome back, reknowned member.", 'success')
						TriggerEvent('qb-drugdealing:client:openBulkSelling')
						TriggerServerEvent('qb-drugdealing:server:bulkfee')
					else
						QBCore.Functions.Notify("Scram loser, before you get yourself killed.", 'error')
       				end
  	    		end)
			else
				QBCore.Functions.Notify("You think this a free club? Piss off.", 'error')
			end
		else
			QBCore.Functions.Notify("There isn't enough cops around, try again later.", 'error')
		end
	end)
end)

exports['qb-target']:AddBoxZone("qb-drugdealing:bulksell", vector3(94.23, -2694.03, 6.0), 0.4, 2.5, {
	name = "qb-drugdealing:bulksell",
	heading = 96,
	debugPoly = true,
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
						event = "qb-drugdealing:client:startbulksell",
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


function CreateBulkVehicle()
	if DoesEntityExist(Vehicle) then
	    SetVehicleHasBeenOwnedByPlayer(Vehicle,false)
		SetEntityAsNoLongerNeeded(Vehicle)
		DeleteEntity(Vehicle)
	end
    local car = GetHashKey(Config.Cars[math.random(#Config.Cars)])
    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end
    local spawnpoint = 1
    for i = 1, #Config.CarSpawns do
	    local Car = GetClosestVehicle(Config.CarSpawns[i]["x"], Config.CarSpawns[i]["y"], Config.CarSpawns[i]["z"], 3.500, 0, 70)
		if not DoesEntityExist(Car) then
			spawnpoint = i
		end
    end
    Vehicle = CreateVehicle(car, Config.CarSpawns[spawnpoint]["x"], Config.CarSpawns[spawnpoint]["y"], Config.CarSpawns[spawnpoint]["z"], Config.CarSpawns[spawnpoint]["h"], true, false)
    while true do
    	Citizen.Wait(1)
    	 QBCore.Functions.DrawText3D(Config.CarSpawns[spawnpoint]["x"], Config.CarSpawns[spawnpoint]["y"], Config.CarSpawns[spawnpoint]["z"], "Your Delivery Car (Stolen).")
    	 if #(GetEntityCoords(PlayerPedId()) - vector3(Config.CarSpawns[spawnpoint]["x"], Config.CarSpawns[spawnpoint]["y"], Config.CarSpawns[spawnpoint]["z"])) < 8.0 then
    	 	return
    	 end
    end
end

RegisterNetEvent("qb-drugdealing:client:startbulksell", function(item)
	if started then return end
	started = true
	ItemSale = item
	QBCore.Functions.Notify("You will need to hotwire the vehicle as it's stolen.", 'success')
	CreateBulkVehicle()
	CreateDropOff()
end)

local CreateDropOffBlip = function(coords)
	dropOffBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dropOffBlip, 51)
    SetBlipScale(dropOffBlip, 1.0)
    SetBlipAsShortRange(dropOffBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off Point")
    EndTextCommandSetBlipName(dropOffBlip)
end

local CreateDropOffPed = function(coords)
	if DropPed ~= nil then return end
	local model = peds[math.random(#peds)]
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
				icon = 'fas fa-fishing-rod',
				label = 'Hand over bait.',
			}
		},
		distance = 2.0
	})
end

local CreateDropOff = function()
	hasDropOff = true
	TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "Head over to the drop off point.", 'fas fa-fishing-rod', '#3480eb', 8000)
	dropOffCount += 1
	local randomLoc = Config.Locations[math.random(#Config.Locations)]
	CreateDropOffBlip(randomLoc)
	BulkSellArea = CircleZone:Create(randomLoc.xyz, 85.0, {
		name = "BulkSellArea",
		debugPoly = false
	})
	BulkSellArea:onPlayerInOut(function(isPointInside, point)
		if isPointInside then
			if DropPed == nil then
				TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "Make the delivery..", 'fas fa-fishing-rod', '#3480eb', 8000)
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

RegisterNetEvent('qb-drugdealing:client:handover', function()
	if madeDeal then return end
	ped = PlayerPedId()
	if not IsPedOnFoot(ped) then return end
	if #(GetEntityCoords(ped) - GetEntityCoords(DropPed)) < 5.0 then
		-- Anti spam
		madeDeal = true
		exports['qb-target']:RemoveTargetEntity(DropPed)

		-- Alert Cops
		if math.random(100) <= Config.CallCopsChance then
			AlertCops()
		end
		-- Face each other
		TurnToPed()
		-- Playerped animation
		PlayerAnimation()
		-- DropPed animation
		DropPedAnimation()
		-- Remove blip
		RemoveBlip(dropOffBlip)
		dropOffBlip = nil
		-- Reward
		
		BulkSellArea:destroy()
		Wait(2000)
		if dropOffCount == Config.RunAmount then
			TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "You're getting a little too much attention, you're done for now.", 'fas fa-fishing-rod', '#3480eb', 20000)
			started = false
			dropOffCount = 0
		else
			TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "Good job on the drop, GPS location for the next coming soon...", 'fas fa-fishing-rod', '#3480eb', 20000)
		end
		DeleteDropPed()
		hasDropOff = false
		madeDeal = false
	end
end)

local DeleteDropPed = function()
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