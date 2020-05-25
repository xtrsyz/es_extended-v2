onRequest('esx:identity:check', function(source, cb)
	local player = xPlayer.fromId(source)
  
	MySQL.Async.fetchAll('SELECT character_name, dateofbirth FROM users WHERE identifier = @identifier', {
		['@identifier'] = player.identifier
	}, function(result)
		if result then
			if result[1] then
				if result[1].character_name and result[1].dateofbirth then
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

onRequest('esx:identity:register', function(source, cb, data)
	local player = xPlayer.fromId(source)
  
	MySQL.Sync.execute('UPDATE users SET character_name = @character_name, dateofbirth = @dateofbirth WHERE identifier = @identifier', {
		['@identifier']  = player.identifier,
		['@character_name'] = data.name,
		['@dateofbirth'] = data.dob,
	}, function(rowsChanged)
		if rowsChanged then
			cb(true)
		else
			cb(false)
		end
	end)
end)
