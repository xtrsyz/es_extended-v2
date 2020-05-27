M('events')

local chunks = {}

RegisterNUICallback('__chunk', function(data, cb)

	chunks[data.id] = chunks[data.id] or ''
	chunks[data.id] = chunks[data.id] .. data.chunk

	if data['end'] then
		local msg = json.decode(chunks[data.id])
		emit(data.__namespace .. ':message:' .. data.__type, msg)
		chunks[data.id] = nil
	end

  cb('')

end)

RegisterNUICallback('nui_ready', function(data, cb)
  self.Ready = true
  emit('esx:nui:ready')
  cb('')
end)

RegisterNUICallback('frame_load', function(data, cb)
  emit('esx:frame:load', data.name)
  cb('')
end)

RegisterNUICallback('frame_message', function(data, cb)
  emit('esx:frame:message', data.name, data.msg)
  cb('')
end)

on('esx:frame:load', function(name)

  local frame = self.Frames[name]

  if frame == nil then

    print('error, frame [' .. name .. '] not found')

  else

    frame:emit('load')

  end

end)

on('esx:frame:message', function(name, msg)

  local frame = self.Frames[name]

  if frame == nil then

    print('error, frame [' .. name .. '] not found')

  else

    frame:emit('message', msg)

  end

end)
