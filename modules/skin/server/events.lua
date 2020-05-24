local Command = M('command', true)

onClient('esx_skin:save', function(skin)
	local player = xPlayer.fromId(source)
	local defaultMaxWeight = ESX.GetConfig().MaxWeight
	local backpackModifier = Config.BackpackWeight[skin.bags_1]

	if backpackModifier then
		player:setMaxWeight(defaultMaxWeight + backpackModifier)
	else
		player:setMaxWeight(defaultMaxWeight)
	end

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

onClient('esx_skin:responseSaveSkin', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() == 'admin' then
		local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

		file:write(json.encode(skin) .. "\n\n")
		file:flush()
		file:close()
	else
		print(('esx_skin: %s attempted saving skin to file'):format(xPlayer.getIdentifier()))
	end
end)

onRequest('esx_skin:getPlayerSkin', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
  }, function(users)

		local user, skin = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

Command.Register('skin', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_skin:openSaveableMenu')
end, false, {help = _U('skin')})

Command.Register('skinsave', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx_skin:requestSaveSkin')
end, false, {help = _U('saveskin')})
