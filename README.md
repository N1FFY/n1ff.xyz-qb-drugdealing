# qb-drugdealing
## Description:

QB-Target based drug selling system allowing players to sell drugs to any pedestrians on the street. Fully configurable with more options coming soon, qb-dispatch and linden_outlawalert support



## Features:
- Easy Installation
- QB-Target based, all peds interactable
- QB-Dispatch Support.
- Linden_Outlawalert support.
- Allows for unlimited drug types.
- Configurable prices and amount sold.
- Configurable alert notifications.
- Runs at 0.00 ms idle and in use except when listening for keypress

## Dependencies:
[QB-Target](https://github.com/BerkieBb/qb-target)
[boostinghack](https://github.com/Lionh34rt/boostinghack)

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
