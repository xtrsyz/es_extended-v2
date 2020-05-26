onRequest('esx:identity:check', function(source, cb)

  local player = xPlayer.fromId(source)

  MySQL.Async.fetchAll('SELECT first_name, last_name, dob FROM users WHERE identifier = @identifier', {['@identifier'] = player.identifier}, function(result)
    if result then
      if result[1] then
        if result[1].first_name and result[1].last_name and result[1].dob then
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

  MySQL.Async.execute('UPDATE users SET first_name = @first_name, last_name = @last_name, dob = @dob, sex = @sex WHERE identifier = @identifier', {
    ['@identifier'] = player.identifier,
    ['@first_name'] = firstName,
    ['@last_name']  = lastName,
    ['@dob']        = dob,
    ['@sex']        = sex
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

  add({
    first_name = player:getFirstName(),
    last_name  = player:getLastName(),
    dob        = player:getDOB(),
    sex        = player:getSex()
  })

end)

on('esx:player:serialize:db', function(player, add)

  add({
    first_name = player:getFirstName(),
    last_name  = player:getLastName(),
    dob        = player:getDOB(),
    sex        = player:getSex()
  })

end)

on('esx:player:load:first_name', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)
    cb({first_name = row.first_name})
  end)

end)

on('esx:player:load:last_name', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)
    cb({last_name = data})
  end)

end)

on('esx:player:load:dob', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)
    cb({dob = data})
  end)

end)

on('esx:player:load:sex', function(identifier, playerId, row, userData, addTask)

  addTask(function(cb)
    cb({sex = data})
  end)

end)
