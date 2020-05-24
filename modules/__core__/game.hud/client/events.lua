M('events', true)

on('esx:nui_ready', function()
  ESX.CreateFrame('hud', 'nui://' .. __RESOURCE__ .. '/modules/__core__/game.hud/data/html/ui.html')
end)
