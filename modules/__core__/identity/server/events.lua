onRequest('esx:identity:check', function(source, cb)
  local player = xPlayer.fromId(source)

  MySQL.Async.fetchAll('SELECT first_name, last_name, dateofbirth FROM users WHERE identifier = @identifier', {['@identifier'] = player.identifier}, function(result)
    if result then
      if result[1] then
        if result[1].first_name and result[1].last_name and result[1].dateofbirth then
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

  MySQL.Sync.execute('UPDATE users SET first_name = @first_name, last_name = @last_name, dateofbirth = @dob, sex = @sex WHERE identifier = @identifier', {
    ['@identifier'] 	= player.identifier,
	['@first_name'] 	= firstName,
	['@last_name'] 		= lastName,
    ['@dateofbirth']	= dob,
    ['@sex']       		= sex
  })
end)
