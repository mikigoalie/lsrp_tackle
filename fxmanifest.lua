fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'lsrp_tackle'
author 'mikigoalie'
version '1.0.0'
repository 'https://github.com/mikigoalie/lsrp_tackle'
description 'Enhanced and updated tackling system'

shared_scripts { '@ox_lib/init.lua', '@es_extended/imports.lua', 'config.lua' }
server_scripts { 'server/main.lua' }
client_scripts { 'client/main.lua' }
