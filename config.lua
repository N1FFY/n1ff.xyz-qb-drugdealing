Config = {}

Config.MinimumPoliceDrugSelling = 2

------- DRUGS ---------

Config.DispatchSystem = "qb-dispatch" -- qb-dispatch or linden_outlawalert

Config.DrugSellingReward = "item" -- Either money, or item
Config.DrugSellingRewardType = "cash" -- ONLY USE IF ABOVE IS SET TO MONEY [cash, bank, crypto]
Config.DrugSellingRewardItem = "loosenotes" -- ONLY USE IF Config.DrugSellingReward IS SET TO ITEM

Config.TimerMessage = "You must wait before selling again." -- Message given on cooldown
Config.NotIntrestedMessage = "The customer wasn't interested." -- Message given when drugs aren't sold
Config.NotEnoughCopsMessage = "There are not enough cops in the city, try again later." -- Not enough cops online
Config.SameCustomerMessage = "You have already sold to me, leave before i call the cops." -- Message sent when they try to sell to the same ped
Config.DeadOrFarAwayMessage = "The customer is dead or too far away." -- Message sent when players are too far away from the ped.
Config.NoDrugsMessage = "You don't have enough drugs for the customer." -- Message when no drugs left

Config.MinSaleAmount = 1 -- Minimum drug sale amount
Config.MaxSaleAmount = 10 -- Maximum drug sale amount

Config.Cooldown = 15 -- In Seconds
Config.SaleTime = 5 -- In Seconds

Config.PedAcceptanceRate = 20 -- Percentage Rate to call the Cops

----- DRUG NAMES [CHANGE TO YOUR DRUGS] -----

Config.DrugsList = {
		'caixaweed_amnesia',
		'caixaweed_skunk',
		'caixaweed_og-kush',
		'caixaweed_ak47',
		'caixaweed_purple-haze',
		'caixaweed_white-widow',
		'meth',
		'dollcoke',
		'pillscoke',
}

----- DRUG PRICES [CHANGE TO YOUR DRUG PRICES] -----

Config.DrugsPrice = {
    ["caixaweed_amnesia"] = {
        min = 3,
        max = 5,
    },
    ["caixaweed_skunk"] = {
        min = 4,
        max = 5,
    },
    ["caixaweed_og-kush"] = {
        min = 4,
        max = 6,
    },
    ["caixaweed_ak47"] = {
        min = 4,
        max = 6,
    },
    ["caixaweed_purple-haze"] = {
        min = 5,
        max = 7,
    },
    ["caixaweed_white-widow"] = {
        min = 5,
        max = 8,
    },
    ["meth"] = {
        min = 8,
        max = 10,
    },
	["dollcoke"] = {
        min = 10,
        max = 15,
    },
	["pillscoke"] = {
        min = 2,
        max = 4,
    },
}

-------- MONEY WASHING CONFIG --------
Config.Minigame = "on" -- For if you want to stop AFK idling washing. 5 minigames will pop up and they get 20% per game. [on or off]
Config.WashLocation = vector3(1135.97, -989.41, 46.11)
Config.WashRewardType = "bank"


-------- MINIGAME CONFIG --------
Config.HackTime = 60
Config.MinigameWaitTime = 15
Config.MinigameOffWaitTime = 300 -- If the minigame is disabled, make people wait 5 minutes in order to wash
Config.MoneyWashMessage = "Placing cash into washer."
Config.MoneyWashMessage2 = "You need to place the Acetone into the washer."
Config.MoneyWashMessage3 = "You need to dilute the acetone."
Config.MoneyWashMessage4 = "You need to add the final primer."

Config.MoneyWashInteractonMessage = "Pouring Acetone into the washer"
Config.MoneyWashInteractonMessage2 = "Diluting the Acetone"
Config.MoneyWashInteractonMessage3 = "Pouring Primer into the washer"

Config.NeededItem1 = "acetone"
Config.NeededItem2 = "water_bottle"
Config.NeededItem3 = "primer"
------- MONEY WASHING MESSAGES --------
Config.CollectMessage = "You collected your dirty laundry"


----- MONEY WASH ITEMS AND VALUES ------
Config.WashList = {
    [1] = {
        item = "markedbills",
        price = 1000
    },
    [2] = {
        item = "stackofnotes",
        price = 5000
    },
    [3] = {
        item = "inkedbills",
        price = 10000
    },
}

----------- BULK SELLING CONFIG ---------------
Config.BulkSellingItem = "pbmember" -- Your Item to gain access to the bulk selling.
--Config.DispatchSystem = "qb-dispatch"
Config.CarPrice = 250
Config.CarSpawns = {
    [1] =  { ['x'] = 89.62,['y'] = -2702.7,['z'] = 5.0,['h'] = 182.32, ['info'] = 'Van' },
}
Config.Cars = {
        [1] = "benson",
}

Config.BulkList = {
    [1] = {
        item = "caixaweed_amnesia",
        price = 1000
    },
    [2] = {
        item = "caixaweed_skunk",
        price = 5000
    },
    [3] = {
        item = "caixaweed_og-kush",
        price = 10000
    },
    [4] = {
        item = "caixaweed_ak47",
        price = 10000
    },
    [5] = {
        item = "caixaweed_purple-haze",
        price = 10000
    },
    [6] = {
        item = "caixaweed_white-widow",
        price = 10000
    },
    [7] = {
        item = "meth",
        price = 10000
    },
    [8] = {
        item = "dollcoke",
        price = 10000
    },
    [9] = {
        item = "pillscoke",
        price = 10000
    },
}