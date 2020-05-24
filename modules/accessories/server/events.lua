
-- BEGIN extend xPlayer stuff

  -- add properties and methods to xPlayer when bulding its instance
  on('esx:player:create', function(xPlayer)

    xPlayer.set('getAccessories', function()
      return xPlayer.get('accessories')
    end)

    xPlayer.set('setAccessories', function(accessories)
      xPlayer.set('accessories', accessories)
    end)

  end)

  -- add field when serializing xPlayer instance (for sending in event for example)
  on('esx:player:serialize', function(xPlayer, add)
    add({accessories = xPlayer.getAccessories()})
  end)

  -- add field when serializing xPlayer instance to DB
  on('esx:player:serialize:db', function(xPlayer, add)
    add({accessories = json.encode(xPlayer.getAccessories())})
  end)

  -- handle sql field loading from DB
  on('esx:player:load:accessories', function(identifier, playerId, row, userData, addTask)

    addTask(function(cb)

      local data = {}

      if row.accessories and row.accessories ~= '' then
        data = json.decode(row.accessories)
      else
        data = {}
      end

      cb({accessories = data})

    end)

  end)

-- END extend xPlayer stuff

onRequest('esx_accessories:pay', function()

  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeMoney(self.Config.Price)
  TriggerClientEvent('esx:showNotification', source, _U('accesories:you_paid', ESX.Math.GroupDigits(self.Config.Price)))

end)

onRequest('esx_accessories:save', function(skin, accessory)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

  local item1 = string.lower(accessory) .. '_1'
  local item2 = string.lower(accessory) .. '_2'

  local accessories = xPlayer.getAccessories()

  accessories[accessory] = {
    [item1] = skin[item1],
    [item2] = skin[item2],
  }

  xPlayer.setAccessories(accessories)

end)

onRequest('esx_accessories:get', function(source, cb, accessory)

  local xPlayer = ESX.GetPlayerFromId(source)

  local skin         = xPlayer.accessories[accessory]
  local hasAccessory = skin ~= nil

	cb(hasAccessory, skin)

end)

onRequest('esx_accessories:checkMoney', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  cb(xPlayer.getMoney() >= self.Config.Price)

end)
