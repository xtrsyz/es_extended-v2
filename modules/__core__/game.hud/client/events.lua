M('events')
M('ui.hud')

on('esx:nui:ready', function()

  self.Frame = Frame:create('hud', 'nui://' .. __RESOURCE__ .. '/modules/__core__/game.hud/data/html/ui.html')

  self.Frame:on('load', function()
    emit('esx:game.hud:ready')
  end)

end)
