name 'pc-loot-crates'
description ''
version '0.0.1'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script 'client/main.lua'
server_scripts {
    'server/config.lua',
    'server/main.lua'
}

dependencies {
    '/onesync'
}
