local Menu = M('ui.menu')

on('esx:nui_ready', function()
  ESX.CreateFrame('menu_dialog', 'nui://' .. __RESOURCE__ .. '/modules/menu_dialog/data/html/ui.html')
end)

on('menu_dialog:message:menu_submit', function(data)

	local menu = Menu.GetOpened(self.MenuType, data._namespace, data._name)

	if menu.submit ~= nil then
		menu.submit(data, menu)
  end

end)

on('menu_dialog:message:menu_cancel', function(data)
	local menu = Menu.GetOpened(self.MenuType, data._namespace, data._name)

	if menu.cancel ~= nil then
		menu.cancel(data, menu)
	end
end)

on('menu_dialog:message:menu_change', function(data)
	local menu = Menu.GetOpened(self.MenuType, data._namespace, data._name)

	if menu.change ~= nil then
		menu.change(data, menu)
	end
end)
