M('ui.menu')

local utils = M('utils')

on('esx:ready', function()
  request('esx:identity:check', function(result)
    if not result then
      emit('esx:identity:prompt')
    end
  end)
end)

on('esx:identity:prompt', function()
  utils.ui.showNotification("Please register your character.")

    local char_create = Menu:create('identity', {
    title = 'Create Character',
    items = {
      {name = 'first', label = "First name", type = "text"},
      {name = 'last', label = "Last name", type = 'text'},
      {name = 'dob', label = "Date of birth", type = 'text'},
      {name = 'gender', label = "Gender", type = 'slider'},
      {name = 'submit', label = "Submit", type = 'button'},
    }
  })

  char_create:on('ready', function()
    first_name = char_create:by('name')
    last_name = char_create:by('surname')
    dob = char_create:by('date')
    gender = char_create:by('sex')
  end)

  char_create:on('item.change', function(item, prop, val, index)

    if (item.name == 'first') and (prop == 'value') then
      if val ~= nil then
        first_name.name = val
      end
    end

    if (item.name == 'last') and (prop == 'value') then
      if val ~= nil then
        last_name.surname = val
      end
    end

    if (item.name == 'dob') and (prop == 'value') then
      if val ~= nil then
        dob.date = val
      end
    end

    if (item.name == 'gender') and (prop == 'value') then
      if val ~= nil then
        if val > 50 then
          item.label = 'Gender M'
          gender.sex = "Male"
        else
          item.label = 'Gender F'
          gender.sex = "Female"
        end
      end
    end

  end)

  char_create:on('item.click', function(item, index)

    if item.name == 'submit' then
      if (first_name.name ~= nil) and (last_name.surname ~= nil) and (dob.date ~= nil) and (gender.sex ~= nil) then
        char_create:destroy('identity')
        utils.ui.showNotification("Character created!")

        emit('esx:identity:register', first_name.name, last_name.surname, dob.date, gender.sex)
      else
        utils.ui.showNotification("Please fill in all fields before submitting!")
      end
    end

  end)

end)