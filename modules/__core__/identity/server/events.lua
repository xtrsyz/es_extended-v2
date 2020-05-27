
M('player')

onRequest('esx:identity:check', function(source, cb)

  local player = xPlayer.fromId(source)

  print(player:getFirstName(), player:getLastName(), player:getDOB())

  cb(player:getFirstName() and player:getLastName() and player:getDOB())
end)

onClient('esx:identity:register', function(data)

  local source = source
  local player = xPlayer.fromId(source)

  player.setFirstName(data.firstName)
  player.setLastName (data.lastName)
  player.setDOB      (data.dob)
  player.setIsMale   (data.isMale)

end)
