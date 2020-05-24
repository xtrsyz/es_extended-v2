local self = ESX.Modules['__MAIN__']

AddEventHandler('esx:module:load:before', function(name, isCore)

  if isCore then
    print('^5load^7 [^3@' .. name .. '^7]')
  else
    print('^5load^7 [^3'  .. name .. '^7]')
  end

end)

AddEventHandler('luaconsole:getHandlers', function(cb)

  local name = GetCurrentResourceName()

  cb(name, function(code, env)
    if env ~= nil then
      for k,v in pairs(env) do _ENV[k] = v end
      return load(code, 'lc:' .. name, 'bt', _ENV)
    else
      return load(code, 'lc:' .. name, 'bt')
    end
  end)

end)
