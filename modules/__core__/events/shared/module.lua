local handlers = {}
local eventId  = 0

local getEventId = function()

  if (eventId + 1) == 1000000 then
    eventId = 1
  else
    eventId = eventId + 1
  end

  return eventId

end

on = function(name, cb)

  local id = getEventId()

  handlers[name]     = handlers[name] or {}
  handlers[name][id] = cb

  return id

end

off = function(name, id)

  handlers[name]     = handlers[name] or {}
  handlers[name][id] = nil

end

emit = function(name, ...)

  handlers[name] = handlers[name] or {}

  for k,v in pairs(handlers[name]) do
    v(...)
  end

end

if IsDuplicityVersion() then

  onClient = function(name, cb)
    RegisterNetEvent(name)
    return AddEventHandler(name, cb)
  end

  offClient = function(name, id)
    RemoveEventHandler(id)
  end

else

  onServer = function(name, cb)
    RegisterNetEvent(name)
    return AddEventHandler(name, cb)
  end

  offServer = function(name, id)
    RemoveEventHandler(id)
  end

end

