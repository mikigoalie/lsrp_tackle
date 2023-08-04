fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts { '@ox_lib/init.lua', '@es_extended/imports.lua' }

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}
