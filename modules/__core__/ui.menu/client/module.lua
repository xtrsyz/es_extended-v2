M('class')
M('events')

local HUD = M('ui.hud')

Menu = Extends(nil)

function Menu:constructor(name, data, focus)

  self.name     = name
  self.float    = data.float or 'top|left'
  self.title    = data.title or 'Untitled ESX Menu'
  self.items    = {}
  self.frame    = nil
  self.handlers = {}

  if focus == nil then
    focus = true
  end

  local _items = data.items or {}

  for i=1, #_items, 1 do

    local scope = function(i)

      local item = _items[i]

      if item.visible == nil then
        item.visible = true
      end

      if item.type == 'slider' then

        if item.min == nil then
          item.min = 0
        end

        if item.max == nil then
          item.max = 100
        end

      end

      self.items[i] = setmetatable({}, {

        __index = function(t, k)
          return item[k]
        end,

        __newindex = function(t, k, v)
          item[k] = v
          self.frame:postMessage({action = 'set_item', index = i - 1, prop = k, val = v})
        end,

      })

    end

    scope(i)

  end

  self.frame = Frame:create('ui:menu:' .. name, 'nui://' .. __RESOURCE__ .. '/modules/__core__/ui.menu/data/html/index.html', true)

  self.frame:onMessage(function(msg)

    if msg.action == 'ready' then
      self:emit('internal:ready')
    elseif msg.action == 'item.change' then
      self:emit('internal:item.change', msg.prop, msg.val, msg.index + 1)
    elseif msg.action == 'item.click' then
      self:emit('internal:item.click', msg.index + 1)
    end

  end)

  self:on('internal:ready', function()

    self.frame:postMessage({action = 'set', data = {
      float = self.float,
      title = self.title,
      items = _items,
    }})

    if focus then
      self.frame:focus(true)
    end

    self:emit('ready')

  end)

  self:on('internal:item.change', function(prop, val, index)

    local prev = {}

    for k,v in pairs(_items[index]) do
      prev[k] = v
    end

    for k,v in pairs(data) do
      _items[index][k] = data[k]
    end

    self:emit('item.change', self.items[index], prop, val, index)

  end)

  self:on('internal:item.click', function(index)
    self:emit('item.click', self.items[index], index)
  end)

end

function Menu:on(name, fn)
  self.handlers[name]     = self.handlers[name] or {}
  local handlers          = self.handlers[name]
  handlers[#handlers + 1] = fn
end

function Menu:emit(name, ...)

  self.handlers[name] = self.handlers[name] or {}
  local handlers      = self.handlers[name]

  for i=1, #handlers, 1 do
    handlers[i](...)
  end

end

function Menu:by(k)
  return table.by(self.items, k)
end

function Menu:destroy(name)
  Frame:destroy('ui:menu:' .. name)
  Frame:unfocus()
end

Menu = Menu

-- Temp shit old menus compat
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

--[[ Temp test menu

local menu = Menu:create('test', {
  title = 'Test menu',
  items = {
    {name= 'a', label= 'Fufu c\'est ma bro', type= 'slider'},
    {name= 'b', label= 'Fuck that shit',     type= 'check'},
    {name= 'c', label= 'Fuck that shit',     type= 'text'},
    {name= 'd', label= 'Lorem ipsum'},
    {name= 'e', label= 'Submit',             type= 'button'},
  }
})

menu:on('ready', function()
  menu.items[1].label = 'TEST';-- label changed instantly in webview
end);

menu:on('item.change', function(item, prop, val, index)

  if (item.name == 'a') and (prop == 'value') then

    item.label = 'Dynamic label ' .. tostring(val);

  end

  if (item.name == 'b') and (prop == 'value') then

    table.find(menu.items, function(e) return e.name == 'c' end).value = 'Dynamic text ' .. tostring(val);

  end

end);

menu:on('item.click', function(item, index)
  print('index', index)
end)
]]--