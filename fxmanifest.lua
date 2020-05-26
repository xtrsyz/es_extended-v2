local esx_config = {
  enable_loadscreen = true
}

fx_version 'adamant'

game 'gta5'

description 'ESX'

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
  'data/**/*',
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
  'boot/shared/module.lua',
  'boot/client/module.lua',
  'boot/shared/events.lua',
  'boot/client/events.lua',
  'boot/shared/main.lua',
  'boot/client/main.lua',
}

server_scripts{
  'boot/shared/module.lua',
  'boot/server/module.lua',
  'boot/shared/events.lua',
  'boot/server/events.lua',
  'boot/shared/main.lua',
  'boot/server/main.lua',
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
