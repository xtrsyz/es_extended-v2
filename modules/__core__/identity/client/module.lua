
local utils = M('utils')

self.Menu = nil

self.CheckIdentity = function()

  request('esx:identity:check', function(hasRegistered)

    if not hasRegistered then
      self.OpenMenu()
    end
  end)

end

self.OpenMenu = function()

  utils.ui.showNotification('Please register your character.')

  self.Menu = Menu:create('identity', {
    float = 'center|middle',
    title = 'Create Character',
    items = {
      {name = 'firstName', label = 'First name',    type = 'text',  placeholder = 'John'},
      {name = 'lastName',  label = 'Last name',     type = 'text',  placeholder = 'Smith'},
      {name = 'dob',       label = 'Date of birth', type = 'text',  placeholder = '01/02/1234'},
      {name = 'isMale',    label = 'Gender M',      type = 'check', value = true},
      {name = 'submit',    label = 'Submit',        type = 'button'},
    }
  })

  self.Menu:on('item.change', function(item, prop, val, index)

    if (item.name == 'isMale') and (prop == 'value') then

      if val then
        item.label = 'Man'
      else
        item.label = 'Woman'
      end

    end

  end)

  self.Menu:on('item.click', function(item, index)

    if item.name == 'submit' then

      local props = self.Menu:kvp()

      print(json.encode(props))

      if (props.firstName ~= '') and (props.lastName ~= '') and (props.dob ~= '') then

        emitServer('esx:identity:register', props)

        self.Menu:destroy()
        self.Menu = nil

        utils.ui.showNotification('Welcome, ' .. props.firstName .. ' ' .. props.lastName)

      else
        utils.ui.showNotification('Please fill in all fields before submitting !')
      end
    end

  end)

end
