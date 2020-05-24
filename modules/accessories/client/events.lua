local Input = M('input')

on('esx:db:init', function(initTable, extendTable)

  extendTable('users', {
    {name = 'accessories', type = 'TEXT', length = nil, default = nil, extra = nil},
  })

end)

on('esx_accessories:hasEnteredMarker', function(zone)
	self.CurrentAction     = 'shop_menu'
	self.CurrentActionMsg  = _U('accessories:press_access')
	self.CurrentActionData = { accessory = zone }
end)

on('esx_accessories:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	self.CurrentAction = nil
end)

-- Key Controls
Input.On('released', Input.Groups.MOVE, Input.Controls.PICKUP, function(lastPressed)

  if self.CurrentAction and (not ESX.IsDead) then
    self.CurrentAction()
    self.CurrentAction = nil
  end

end)

if self.Config.EnableControls then

  Input.On('released', Input.Groups.MOVE, Input.Controls.REPLAY_SHOWHOTKEY, function(lastPressed)

    if not ESX.IsDead then
      self.OpenAccessoryMenu()
    end

  end)

end



