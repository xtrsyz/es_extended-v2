onRequest('esx:identity:check', function(source, cb)
  local player = xPlayer.fromId(source)

  MySQL.Async.fetchAll('SELECT first_name, last_name, dob FROM users WHERE identifier = @identifier', {['@identifier'] = player.identifier}, function(result)
    if result then
      if result[1] then
        if result[1].first_name and result[1].last_name and result[1].dob then

          print(xPlayer.first_name)
          print(xPlayer.last_name)
          print(xPlayer.dob)
          print(xPlayer.sex)

          cb(true)
        else
          cb(false)
        end
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)
end)

onClient('esx:identity:register', function(firstName, lastName, dob, sex)
  local player = xPlayer.fromId(source)

  MySQL.Sync.execute('UPDATE users SET first_name = @first_name, last_name = @last_name, dob = @dob, sex = @sex WHERE identifier = @identifier', {
    ['@identifier'] 	= player.identifier,
	  ['@first_name'] 	= firstName,
	  ['@last_name'] 		= lastName,
    ['@dob']	        = dob,
    ['@sex']       		= sex
  })
end)

-- Extend xPlayer

on('esx:player:create', function(player)

  player:setField('getFirstName', function()
    return player:getField('first_name')
  end)

  player:setField('setFirstName', function(first_name)
    player:setField('first_name', first_name)
  end)

  player:setField('getLastName', function()
    return player:getField('last_name')
  end)

  player:setField('setLastName', function(last_name)
    player:setField('last_name', last_name)
  end)

  player:setField('getDOB', function()
    return player:getField('dob')
  end)

  player:setField('setDOB', function(dob)
    player:setField('dob', dob)
  end)

  player:setField('getSex', function()
    return player:getField('sex')
  end)

  player:setField('setSex', function(sex)
    player:setField('sex', sex)
  end)

end)

on('esx:player:serialize', function(player, add)
  add({first_name = player:getFirstName()})
  add({last_name = player:getLastName()})
  add({dob = player:getDOB()})
  add({sex = player:getSex()})
end)

on('esx:player:serialize:db', function(player, add)
  add({first_name = player:getFirstName()})
  add({last_name = player:getLastName()})
  add({dob = player:getDOB()})
  add({sex = player:getSex()})
end)

on('esx:player:load:first_name', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)

    local data = {}

    if row.first_name and row.first_name ~= '' then
      data = row.first_name
    else
      data = {}
    end

    cb({first_name = data})

  end)

end)

on('esx:player:load:last_name', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)

    local data = {}

    if row.last_name and row.last_name ~= '' then
      data = row.last_name
    else
      data = {}
    end

    cb({last_name = data})

  end)

end)

on('esx:player:load:dob', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)

    local data = {}

    if row.dob and row.dob ~= '' then
      data = row.dob
    else
      data = {}
    end

    cb({dob = data})

  end)

end)

on('esx:player:load:sex', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)

    local data = {}

    if row.sex and row.sex ~= '' then
      data = row.sex
    else
      data = {}
    end

    cb({sex = data})

  end)

end)