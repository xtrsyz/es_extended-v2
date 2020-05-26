M('events')

local Chunks = {}

RegisterNUICallback('__chunk', function(data, cb)
	Chunks[data.id] = Chunks[data.id] or ''
	Chunks[data.id] = Chunks[data.id] .. data.chunk

	if data['end'] then
		local msg = json.decode(Chunks[data.id])
		emit(data.__namespace .. ':message:' .. data.__type, msg)
		Chunks[data.id] = nil
	end

  cb('')

end)

RegisterNUICallback('nui_ready', function(data, cb)
  self.Ready = true
  emit('esx:nui_ready')
  cb('')
end)

RegisterNUICallback('frame_message', function(data, cb)
  emit('esx:frame_message', data.name, data.msg)
  cb('')
end)

on('esx:frame_message', function(name, msg)

  local frame = self.Frames[name]

  if frame == nil then

    print('error, frame [' .. name .. '] not found')

  else

    local handlers = frame.handlers

    for i=1, #handlers, 1 do
      handlers[i](msg)
    end

  end

end)
