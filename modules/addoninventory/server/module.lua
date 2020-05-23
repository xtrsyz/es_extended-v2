module = {}
local self = module

self.Ready             = false
self.Items             = {}
self.InventoriesIndex  = {}
self.Inventories       = {}
self.SharedInventories = {}

self.GetInventory = function(name, owner)
	for i=1, #self.Inventories[name], 1 do
		if self.Inventories[name][i].owner == owner then
			return self.Inventories[name][i]
		end
	end
end

self.GetSharedInventory = function(name)
	return self.SharedInventories[name]
end

self.CreateAddonInventory = function(name, owner, items)

  local _self = {}

	_self.name  = name
	_self.owner = owner
	_self.items = items

  _self.getItems = function()
    return _self.items
  end

	_self.addItem = function(name, count)
		local item = _self.getItem(name)
		item.count = item.count + count

		_self.saveItem(name, item.count)
	end

	_self.removeItem = function(name, count)
		local item = _self.getItem(name)
		item.count = item.count - count

		_self.saveItem(name, item.count)
	end

	_self.setItem = function(name, count)
		local item = _self.getItem(name)
		item.count = count

		_self.saveItem(name, item.count)
	end

  _self.getItem = function(name)

		for i=1, #_self.items, 1 do
			if _self.items[i].name == name then
				return _self.items[i]
			end
		end

		item = {
			name  = name,
			count = 0,
			label = self.Items[name]
		}

		table.insert(_self.items, item)

		if _self.owner == nil then
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)',
			{
				['@inventory_name'] = _self.name,
				['@item_name']      = name,
				['@count']          = 0
			})
		else
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)',
			{
				['@inventory_name'] = _self.name,
				['@item_name']      = name,
				['@count']          = 0,
				['@owner']          = _self.owner
			})
		end

		return item
	end

	_self.saveItem = function(name, count)
		if _self.owner == nil then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name', {
				['@inventory_name'] = _self.name,
				['@item_name']      = name,
				['@count']          = count
			})
		else
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner', {
				['@inventory_name'] = _self.name,
				['@item_name']      = name,
				['@count']          = count,
				['@owner']          = _self.owner
			})
		end
	end

  return _self

end
