self.RegisteredTypes = {}
self.Opened          = {}

self.RegisterType = function(type, open, close)
	self.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

self.Open = function(type, namespace, name, data, submit, cancel, change, close)

  local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		self.RegisteredTypes[type].close(namespace, name)

		for i=1, #self.Opened, 1 do
			if self.Opened[i] then
				if self.Opened[i].type == type and self.Opened[i].namespace == namespace and self.Opened[i].name == name then
					self.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		self.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setElements = function(newElements)
		menu.data.elements = newElements
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(self.Opened, menu)
	self.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

self.Close = function(type, namespace, name)
	for i=1, #self.Opened, 1 do
		if self.Opened[i] then
			if self.Opened[i].type == type and self.Opened[i].namespace == namespace and self.Opened[i].name == name then
				self.Opened[i].close()
				self.Opened[i] = nil
			end
		end
	end
end

self.CloseAll = function()
	for i=1, #self.Opened, 1 do
		if self.Opened[i] then
			self.Opened[i].close()
			self.Opened[i] = nil
		end
	end
end

self.GetOpened = function(type, namespace, name)
	for i=1, #self.Opened, 1 do
		if self.Opened[i] then
			if self.Opened[i].type == type and self.Opened[i].namespace == namespace and self.Opened[i].name == name then
				return self.Opened[i]
			end
		end
	end
end

self.GetOpenedMenus = function()
	return self.Opened
end

self.IsOpen = function(type, namespace, name)
	return self.GetOpened(type, namespace, name) ~= nil
end
