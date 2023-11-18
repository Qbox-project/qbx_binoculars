fx_version 'cerulean'
game 'gta5'

description 'qbx_binoculars'
repository 'https://github.com/Qbox-project/qbx_binoculars'
version '1.0.0'

shared_scripts {
	'@ox_lib/init.lua',
	'@qbx_core/modules/utils.lua',
}

client_script 'client/main.lua'

server_script 'server/main.lua'

lua54 'yes'
use_experimental_fxv2_oal 'yes'