Config = {}

Config.MinimumPolice = 1

Config.DispatchSystem = "qb-dispatch" -- qb-dispatch or linden_outlawalert

Config.DrugSellingReward = "item" -- Either money, or item
Config.DrugSellingRewardType = "cash" -- ONLY USE IF ABOVE IS SET TO MONEY
Config.DrugSellingRewardItem = "loosenotes" -- ONLY USE IF Config.DrugSellingReward IS SET TO ITEM

Config.TimerMessage = "You must wait before selling again."
Config.NotIntrestedMessage = "The customer wasn't interested."
Config.NotEnoughCopsMessage = "There are not enough cops in the city, try again later."
Config.SameCustomerMessage = "You have already sold to me, leave before i call the cops."
Config.DeadOrFarAwayMessage = "The customer is dead or too far away."
Config.NoDrugsMessage = "You don't have enough drugs for the customer."

Config.MinSaleAmount = 1
Config.MaxSaleAmount = 5

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

Config.Washers = {
    {x=-576.36, y=243.63, z=74.2, h=356.7, length=1.8, width=1.8},
}

Config.WashList = {
    "markedbills",
    "stackofnotes",
    "inkedbills",
}