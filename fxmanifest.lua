local esx_config = {
  enable_loadscreen = true
}

fx_version  'adamant'
game        'gta5'
description 'ESX'
version     '2.0.0'
ui_page     'hud/index.html'

dependencies {
  'spawnmanager',
  'baseevents',
  'mysql-async',
  'async',
  'cron',
  'skinchanger'
}

files {

  'data/**/*',
  'hud/**/*',
  'modules.json',

  'modules/__core__/modules.json',
  'modules/__core__/*/data/**/*',
  'modules/__core__/*/*.lua',

  'modules/**/data/**/*',
  'modules/**/*.lua',

}

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

  'boot/shared/module.lua',
  'boot/server/module.lua',
  'boot/shared/events.lua',
  'boot/server/events.lua',
  'boot/shared/main.lua',
  'boot/server/main.lua',

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

  'boot/shared/module.lua',
  'boot/client/module.lua',
  'boot/shared/events.lua',
  'boot/client/events.lua',
  'boot/shared/main.lua',
  'boot/client/main.lua',

}

if esx_config.enable_loadscreen then

  files {
    'loadscreen/data/index.html',
    'loadscreen/data/css/index.css',
    'loadscreen/data/js/index.js',
    'loadscreen/data/vid/esx_intro.mp4',
    'loadscreen/data/vid/esx_loop.mp4'
  }

  loadscreen 'loadscreen/data/index.html'
  loadscreen_manual_shutdown 'yes'

end
