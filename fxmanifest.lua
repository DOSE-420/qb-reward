fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'VNS Playtime Reward'
version '1.0.4'

shared_scripts {
    'config.lua',
}

client_script 'client.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
	'html/vue.js',
	'html/index.html',
	'html/styles.css',
	'html/app.js',
}



escrow_ignore {
  '**/*',
  '*'
}