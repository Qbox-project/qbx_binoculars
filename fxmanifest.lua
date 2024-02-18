fx_version 'cerulean'
game 'gta5'

description 'qbx_binoculars'
repository 'https://github.com/Qbox-project/qbx_binoculars'
version '1.1.1'

shared_script '@ox_lib/init.lua'

client_scripts {
	'@qbx_core/modules/playerdata.lua',
    'client/main.lua'
}

server_script 'server/main.lua'

lua54 'yes'
use_experimental_fxv2_oal 'yes'
