
-- BEGIN extend player stuff

  -- add properties and methods to player when bulding its instance
  on('esx:player:create', function(player)

    player:setField('getAccessories', function()
      return player:getField('accessories')
    end)

    player:setField('setAccessories', function(accessories)
      player:setField('accessories', accessories)
    end)

  end)

  -- add field when serializing player instance (for sending in event for example)
  on('esx:player:serialize', function(player, add)
    add({accessories = player:getAccessories()})
  end)

  -- add field when serializing player instance to DB
  on('esx:player:serialize:db', function(player, add)
    add({accessories = json.encode(player:getAccessories())})
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

-- END extend player stuff

onRequest('esx_accessories:pay', function()

  local player = ESX.GetPlayerFromId(source)
  player:removeMoney(self.Config.Price)
  TriggerClientEvent('esx:showNotification', source, _U('accesories:you_paid', ESX.Math.GroupDigits(self.Config.Price)))

end)

onRequest('esx_accessories:save', function(skin, accessory)

	local _source     = source
	local player      = xPlayer.fromId(_source)
  local item1       = string.lower(accessory) .. '_1'
  local item2       = string.lower(accessory) .. '_2'
  local accessories = player:getAccessories()

  accessories[accessory] = {
    [item1] = skin[item1],
    [item2] = skin[item2],
  }

  player:setAccessories(accessories)

end)

onRequest('esx_accessories:get', function(source, cb, accessory)

  local player       = xPlayer.fromId(source)
  local skin         = player:getAccessories()[accessory]
  local hasAccessory = skin ~= nil

	cb(hasAccessory, skin)

end)

onRequest('esx_accessories:checkMoney', function(source, cb)

  local player = xPlayer.fromId(source)
  cb(player:getMoney() >= self.Config.Price)

end)
