fx_version 'cerulean'
game 'gta5'

description 'n1ff.xyz-criminalpackage'
author 'N1FF'
version '1.0.0'

dependencies {
	'PolyZone',
	'qb-target',
    'qb-menu',
}

shared_script 'config.lua'
server_script 'server/*.lua'
client_script {
    '@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'client/*.lua'
}


lua54 'yes'