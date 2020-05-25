fx_version 'adamant'

game 'gta5'

description 'ES Extended'

version '2.0.0'

server_scripts {
	'@async/async.lua',
  '@mysql-async/lib/MySQL.lua',

	'locale.lua',
  'locales/*.lua',

	'config/default/config.lua',
  'config/default/config.weapons.lua',
  'config/default/modules/core/*.lua',
  'config/default/modules/*.lua',
  'config/modules/core/*.lua',
  'config/modules/*.lua',
}

client_scripts {
	'locale.lua',
  'locales/*.lua',

	'config/default/config.lua',
  'config/default/config.weapons.lua',
  'config/default/modules/core/*.lua',
  'config/default/modules/*.lua',
  'config/modules/core/*.lua',
  'config/modules/*.lua',
}

ui_page {
	'hud/index.html'
}

files {
	'client/bootstrap.lua',
	'data/**/*',
	'locale.js',
	'hud/**/*',
}

dependencies {
	'spawnmanager',
	'baseevents',
	'mysql-async',
	'async',
	'cron',
	'skinchanger'
}

-- Modules
files {
	'modules.json',
	'modules/__core__/modules.json',
  'modules/**/data/**/*',
	'modules/**/shared/module.lua',
  'modules/**/client/module.lua',
	'modules/**/shared/events.lua',
  'modules/**/client/events.lua',
	'modules/**/shared/main.lua',
	'modules/**/client/main.lua',
}

client_scripts{
  'modules/__core__/__main__/shared/module.lua',
  'modules/__core__/__main__/client/module.lua',
  'modules/__core__/__main__/shared/events.lua',
  'modules/__core__/__main__/client/events.lua',
  'modules/__core__/__main__/shared/main.lua',
  'modules/__core__/__main__/client/main.lua',
}

server_scripts{
  'modules/__core__/__main__/shared/module.lua',
  'modules/__core__/__main__/server/module.lua',
  'modules/__core__/__main__/shared/events.lua',
  'modules/__core__/__main__/server/events.lua',
  'modules/__core__/__main__/shared/main.lua',
  'modules/__core__/__main__/server/main.lua',
}

-- Loadscreen
files {
  'loadscreen/data/index.html',
  'loadscreen/data/css/index.css',
  'loadscreen/data/js/index.js',
  'loadscreen/data/vid/esx_intro.mp4',
  'loadscreen/data/vid/esx_loop.mp4'
}

loadscreen 'loadscreen/data/index.html'
loadscreen_manual_shutdown 'yes'
