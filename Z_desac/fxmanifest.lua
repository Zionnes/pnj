fx_version 'adamant'
game 'gta5'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'server/server.lua',
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/client.lua'

}
