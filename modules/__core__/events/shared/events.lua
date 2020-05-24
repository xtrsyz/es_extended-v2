if IsDuplicityVersion() then

  onClient('esx:request', function(id, ...)

    local client = source

    if self.callbacks[id] == nil then
      return
    end

    self.callbacks[id](client, ...)
    self.callbacks[id] = nil

  end)

else

  onServer('esx:request', function(id, ...)

    if self.callbacks[id] == nil then
      return
    end

    self.callbacks[id](...)
    self.callbacks[id] = nil

  end)

end
