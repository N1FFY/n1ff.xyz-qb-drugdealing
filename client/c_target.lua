exports['qb-target']:AddBoxZone("qb-drugdealing:moneywash", Config.WashLocation, 0.4, 2.5, {
	name = "qb-drugdealing:moneywash",
	heading = 160 ,
	debugPoly = false,
	minZ = 0,
	maxZ = 255,
}, {
	options = {
		{
            type = "client",
            event = "qb-drugdealing:client:amount",
			icon = "fas fa-circle",
			label = "Start Moneywashing",
		},
	},
	distance = 2.5
})