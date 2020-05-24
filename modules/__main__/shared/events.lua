local self = ESX.Modules['__MAIN__']

AddEventHandler('esx:module:load:before', function(name, isCore)

  if isCore then
    print('^5load^7 [^3@' .. name .. '^7]')
  else
    print('^5load^7 [^3'  .. name .. '^7]')
  end

end)
