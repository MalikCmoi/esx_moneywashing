
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'WashMan for washing your dirty Money'

version '0.1.0'

author 'Twitch @KillamOFF'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependencies {
	'mysql-async',
	'es_extended'
}