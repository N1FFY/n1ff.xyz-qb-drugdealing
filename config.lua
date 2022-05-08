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
Config.BulkSaleReward = "money"
Config.BulkSaleRewardItem = "loosenotes"
Config.BulkSaleRewardMoney = "cash"
Config.BulkSaleRewardType= "cash"


Config.MinimumPoliceBulkSelling = 1
Config.BulkSellingItem = "pbmember" -- Your Item to gain access to the bulk selling.
--Config.DispatchSystem = "qb-dispatch"
-- Config.SaleTime = 15
Config.CallCopsChance = 55
Config.ChanceOfSale = 80
Config.RunAmount = math.random(7, 10)

Config.Tier1 = 100 -- Amount of drugs that are in a group, so anything below 100 is tier 1
Config.Tier2 = 200 -- Anything between 1 hundred and 2 hundred is tier 2
Config.Tier3 = 300 -- 2 to 3

Config.Tier1Runs = 10
Config.Tier2Runs = 20
Config.Tier3Runs = 30
Config.Tier4Runs = 40

Config.NoSale = "The buyer wasn't interested..."

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

Config.Bulkpeds = {
	'a_m_y_mexthug_01'
}

Config.Locations = { -- Drop-off locations
    vector4(74.5, -762.17, 31.68, 160.98),
    vector4(100.58, -644.11, 44.23, 69.11),
    vector4(175.45, -445.95, 41.1, 92.72),
    vector4(130.3, -246.26, 51.45, 219.63),
    vector4(198.1, -162.11, 56.35, 340.09),
    vector4(341.0, -184.71, 58.07, 159.33),
    vector4(-26.96, -368.45, 39.69, 251.12),
    vector4(-155.88, -751.76, 33.76, 251.82),
    vector4(-305.02, -226.17, 36.29, 306.04),
    vector4(-347.19, -791.04, 33.97, 3.06),
    vector4(-703.75, -932.93, 19.22, 87.86),
    vector4(-659.35, -256.83, 36.23, 118.92),
    vector4(-934.18, -124.28, 37.77, 205.79),
    vector4(-1214.3, -317.57, 37.75, 18.39),
    vector4(-822.83, -636.97, 27.9, 160.23),
    vector4(308.04, -1386.09, 31.79, 47.23),
    vector4(-1041.13, -392.04, 37.81, 25.98),
    vector4(-731.69, -291.67, 36.95, 330.53),
    vector4(-835.17, -353.65, 38.68, 265.05),
    vector4(-1062.43, -436.19, 36.63, 121.55),
    vector4(-1147.18, -520.47, 32.73, 215.39),
    vector4(-1174.68, -863.63, 14.11, 34.24),
    vector4(-1688.04, -1040.9, 13.02, 232.85),
    vector4(-1353.48, -621.09, 28.24, 300.64),
    vector4(-1029.98, -814.03, 16.86, 335.74),
    vector4(-893.09, -723.17, 19.78, 91.08),
    vector4(-789.23, -565.2, 30.28, 178.86),
    vector4(-345.48, -1022.54, 30.53, 341.03),
    vector4(218.9, -916.12, 30.69, 6.56),
    vector4(57.66, -1072.3, 29.45, 245.38)
}