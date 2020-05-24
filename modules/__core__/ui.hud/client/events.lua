M('events')

RegisterNUICallback('nui_ready', function(data, cb)
  emit('esx:nui_ready')
  cb('')
end)

RegisterNUICallback('frame_message', function(data, cb)
  emit('esx:frame_message', data.name, data.msg)
  cb('')
end)
