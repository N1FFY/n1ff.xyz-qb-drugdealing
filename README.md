# n1ff.xyz-qb-drugdealing
## Description:

###### n1ff.xyz-qb-selldrugstolocals
QB-Target based drug selling system allowing players to sell drugs to any pedestrians on the street. Fully configurable with more options coming soon, qb-dispatch and linden_outlawalert support.

IMPORTANT: THIS USES QB-TARGET GLOBAL PEDS. IF YOU ARE USING BOXZONES OVER PEDS IT WILL OVERWRITE IT, I WILL NOT BE GIVING SUPPORT FOR INCOMPENTENT DEVELOPERS

###### n1ff.xyz-qb-moneywash
QB-Target, QB-Menu and QB-Input based moneywashing system allowing users to select the type of money they want to wash and the amount, with required items and minigames to determine the percentage that the player will get if they fail or succed. 

###### n1ff.xyz-bulkselling

## Features:
###### n1ff.xyz-qb-selldrugstolocals
- Easy Installation
- QB-Target based, all peds interactable
- QB-Dispatch Support.
- Linden_Outlawalert support.
- Allows for unlimited drug types.
- Configurable prices and amount sold.
- Configurable alert notifications.
- Runs at 0.00 ms idle and in use except when listening for keypress

###### n1ff.xyz-qb-moneywash
- Easy Installation
- QB-Target based to interact
- Allows for unlimited money items to be used.
- Configurable prices for the drugs
- Configurable config amounts.
- Configurable messages and item requirements
- Noobie Friendly
- Runs at 0.00 ms idle and in use

## Dependencies:
[QB-Target](https://github.com/BerkieBb/qb-target)

[qb-lock](https://github.com/Nathan-FiveM/qb-lock)

[Polyzone](https://github.com/mkafrin/PolyZone)

[qb-menu](https://github.com/qbcore-framework/qb-menu)


## Installation:
Under qb-target/init.lua look for Config.GlobalPedOptions and add the code below :)
```
Config.GlobalPedOptions = {
	options = {
		{
			type = "client",
			event = "niff-selldrugs:client:selldrugs",
			icon = "fa-solid fa-cannabis",
			label = "Sell Drugs",
		},
	},
	distance = 5,
}
```
For the moneywash minigame
```
	['acetone'] 			 = {['name'] = 'acetone', 				['label'] = 'Acetone', 	 			['weight'] = 500, 		['type'] = 'item', 		['image'] = 'REPLACE.png', 		['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Acetone used for things...'},
	['primer'] 			 = {['name'] = 'primer', 				['label'] = 'Ink Primer', 	 			['weight'] = 500, 		['type'] = 'item', 		['image'] = 'REPLACE.png', 		['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Primes the ink for  the final product ;)'},


```
