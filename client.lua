local QBCore = exports['qb-core']:GetCoreObject()

local lastPed = {}
local timer = 0

function playerAnim()
	loadAnimDict( "mp_safehouselost@" )
    TaskPlayAnim( PlayerPedId(), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function giveAnim()
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        loadAnimDict( "amb@code_human_cross_road@male@idle_a" )
        if ( IsEntityPlayingAnim( ped, "amb@code_human_cross_road@male@idle_a", "idle_a", 3 ) ) then 
            TaskPlayAnim( ped, "amb@code_human_cross_road@male@idle_a", "idle_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else	
            TaskPlayAnim( ped, "amb@code_human_cross_road@male@idle_a", "idle_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end

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

RegisterNetEvent('niff-selldrugs:client:selldrugs')
AddEventHandler('niff-selldrugs:client:selldrugs', function()
	ped = GetPedInFront()
	QBCore.Functions.TriggerCallback('niff-selldrugs:server:getAvailableDrugs', function(result)
	availableDrugs = result
	coords = GetEntityCoords(PlayerPedId(), true)
	if availableDrugs ~= nil then
		drugType = math.random(1, #availableDrugs)
		bagAmount = math.random(Config.MinSaleAmount, Config.MaxSaleAmount)
		currentOfferDrug = availableDrugs[drugType]
		ddata = Config.DrugsPrice[currentOfferDrug.item]
		randomPrice = math.random(ddata.min, ddata.max) * bagAmount
	end
	end)
	QBCore.Functions.TriggerCallback('niff-selldrugs:server:getCops', function(cops)
		if availableDrugs ~= nil then
			if availableDrugs[drugType].amount >= bagAmount then
				if ped ~= oldped then 
					if ped ~= oldped and not IsPedDeadOrDying(ped) then
						if cops >= Config.MinimumPolice then
							if timer == 0 then
								ClearPedTasksImmediately(ped)
								TaskTurnPedToFaceEntity(ped, PlayerPedId(), -1)
								Wait(1000)
								giveAnim()
								playerAnim()
								QBCore.Functions.Progressbar("Drug Sale", "Attempting Sale..", Config.SaleTime*1000, false, true, {
									disableMovement = false,
									disableCarMovement = false,
									disableMouse = false,
									disableCombat = true,
								}, {}, {}, {}, function()
								local luck = math.random(1,100)
								if luck <= Config.PedAcceptanceRate then
									CallCops()
									TriggerServerEvent('niff-selldrugs:server:nodrugs')
								else
									TriggerServerEvent('niff-selldrugs:server:sellCornerDrugs', availableDrugs[drugType].item, bagAmount, randomPrice)
								end
								timer = timer + 1
								oldped = ped
								ClearPedTasksImmediately(ped)
								Wait(Config.Cooldown*1000)
								timer = 0
								end)
							else
							TriggerServerEvent('niff-selldrugs:server:timer')
							end
						else
						TriggerServerEvent('niff-selldrugs:server:cops')
						CallCops()
						end
					else
					TriggerServerEvent('niff-selldrugs:server:dead')
					end
				else
				TriggerServerEvent('niff-selldrugs:server:oldped')
				end
			else
			TriggerServerEvent('niff-selldrugs:server:nodrugsleft')
			end
		else
		TriggerServerEvent('niff-selldrugs:server:nodrugsleft')
		end
	end)
end)