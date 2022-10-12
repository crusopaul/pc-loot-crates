name "pc-loot-crates"
description ''
version '0.0.1'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

dependencies {
    '/onesync'
}
