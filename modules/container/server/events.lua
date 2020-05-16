local self = ESX.Modules['container']

AddEventHandler('esx_datastore:ready',      self.OnDependencyReady)
AddEventHandler('esx_addonaccount:ready',   self.OnDependencyReady)
AddEventHandler('esx_addoninventory:ready', self.OnDependencyReady)

ESX.RegisterServerCallback('esx:container:get', function(source, cb, name, restrict)

  restrict = restrict or {
    'account',
    'item',
    'weapon'
  }

  local container = self.Get(name)
  local _items    = container.getAll()

  local items = ESX.Table.Filter(_items, function(e) return ESX.Table.IndexOf(restrict, e.type) ~= -1 end)

  cb(items)

end)

ESX.RegisterServerCallback('esx:container:get:user', function(source, cb, restrict)

  restrict = restrict or {
    'account',
    'item',
    'weapon'
  }

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = {}

  if ESX.Table.IndexOf(restrict, 'account') ~= -1 then
    items[#items + 1] = {type = 'account', name = 'money', count = xPlayer.getMoney()}
  end

  if ESX.Table.IndexOf(restrict, 'item') ~= -1 then

    local inventory = xPlayer.getInventory()

    for i=1, #inventory, 1 do
      local inventoryItem = inventory[i]
      items[#items + 1] = {type = 'item', name = inventoryItem.name, count = inventoryItem.count, label = inventoryItem.label}
    end

  end

  if ESX.Table.IndexOf(restrict, 'weapon') ~= -1 then

    local loadout = xPlayer.getLoadout()

    for i=1, #loadout, 1 do
      local weapon = loadout[i]
      items[#items + 1] = {type = 'weapon', name = weapon.name, count = 1, label = ESX.GetWeaponLabel(weapon.name)}
    end

  end

  cb(items)

end)

-- TODO more checks on weight and such
ESX.RegisterServerCallback('esx:container:pull', function(source, cb, name, itemType, itemName, itemCount)

  local xPlayer   = ESX.GetPlayerFromId(source)
  local container = self.Get(name)

  local item = container.get(itemType, itemName)

  if item.count >= itemCount then

    container.remove(itemType, itemName, itemCount)

    if itemType == 'account' then
      xPlayer.addMoney(itemCount)
    elseif itemType == 'item' then
      xPlayer.addInventoryItem(itemName, itemCount)
    elseif itemType == 'weapon' then
      xPlayer.addWeapon(itemName, itemCount)
    end

    cb(true)

  else
    cb(false)
  end

end)

-- TODO more checks on weight and such
ESX.RegisterServerCallback('esx:container:put', function(source, cb, name, itemType, itemName, itemCount)

  local xPlayer   = ESX.GetPlayerFromId(source)
  local container = self.Get(name)

  local count = 0

  if itemType == 'account' then
    count = xPlayer.getMoney()
  elseif itemType == 'item' then
    local inventoryItem = xPlayer.getInventoryItem(itemName)
    count = inventoryItem.count
  elseif itemType == 'weapon' then

    local loadout = xPlayer.getLoadout()

    local weapon  = ESX.Table.FindIndex(loadout, function(e)
      return e.name == itemName
    end)

    count = weapon and 1 or 0
  end

  if count >= itemCount then

    if itemType == 'account' then
      xPlayer.removeMoney(itemCount)
    elseif itemType == 'item' then
      xPlayer.removeInventoryItem(itemName, itemCount)
    elseif itemType == 'weapon' then
      xPlayer.removeWeapon(itemName)
    end

    container.add(itemType, itemName, itemCount)

    cb(true)

  else
    cb(false)
  end

end)
