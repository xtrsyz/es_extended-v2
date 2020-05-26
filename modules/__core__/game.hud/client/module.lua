self.RegisteredElements = {}

self.SetDisplay = function(opacity)

	ESX.SendFrameMessage('hud', {
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

self.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #self.RegisteredElements, 1 do
		if self.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(self.RegisteredElements, name)

	ESX.SendFrameMessage('hud', {
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

  self.UpdateElement(name, data)

end

self.RemoveElement = function(name)
	for i=1, #self.RegisteredElements, 1 do
		if self.RegisteredElements[i] == name then
			table.remove(self.RegisteredElements, i)
			break
		end
	end

	ESX.SendFrameMessage('hud', {
		action    = 'deleteHUDElement',
		name      = name
	})
end

self.UpdateElement = function(name, data)
	ESX.SendFrameMessage('hud', {
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end
