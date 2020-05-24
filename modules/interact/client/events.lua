on('esx:interact:register', self.Register)

-- Do not use this in prod ! internal event only
on('esx:interact:enter', function(name, data)
  emit('esx:interact:enter:' .. name, data)
end)

on('esx:interact:exit', function(name, data)
  emit('esx:interact:exit:' .. name, data)
end)
