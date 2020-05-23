local self = ESX.Modules['__MAIN__']

AddEventHandler('esx:module:load:before', function(name)
  print('[^3' .. name .. '^7] ^5load^7')
end)
