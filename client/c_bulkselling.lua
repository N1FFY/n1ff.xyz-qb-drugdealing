local QBCore = exports['qb-core']:GetCoreObject()
local Vehicle = 0


function CallCops()
	if Config.DispatchSystem == "linden_outlawalert" then
        local data = {displayCode = '10-50', description = 'Drug Sale', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fa-cannabis', 
        info = ('[%s]'):format(vehInfo.plate).. " Drug Sale in progress", info2 = vehInfo.name
        , blipSprite = 326, blipColour = 1}
        local dispatchData = {dispatchData = data, caller = 'Alarm', coords = carPos}
        TriggerServerEvent('wf-alerts:svNotify', dispatchData)
    elseif Config.DispatchSystem == "qb-dispatch" then
        exports["qb-dispatch"]:DrugSale()
	end
end

local CreateDropOffBlip = function(coords)
	dropOffBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dropOffBlip, 51)
    SetBlipScale(dropOffBlip, 1.0)
    SetBlipAsShortRange(dropOffBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop Off Point")
    EndTextCommandSetBlipName(dropOffBlip)
end

RegisterNetEvent('qb-drugdealing:client:knockondoor')
AddEventHandler('qb-drugdealing:client:knockondoor', function()
	local Player = QBCore.Functions.GetPlayerData()
    local cash = Player.money.cash
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
	ItemSale = item
	QBCore.Functions.Notify("You will need to hotwire the vehicle as it's stolen.", 'success')
	CreateBulkVehicle()
	TriggerEvent('qb-phone:client:CustomNotification', 'Pacific Bait', "Make your way to the first drop-off..", 'fas fa-capsules', '#3480eb', 8000)
end)
