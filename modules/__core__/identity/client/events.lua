local Menu  = M('ui.menu')
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
  Menu.Open('dialog', GetCurrentResourceName(), 'identity_first_name', {
    title = "Enter Your First Name (Max 10 Characters)"
  }, function(data, menu)

    local firstName = tostring(data.value)

    if firstName == nil then
      utils.ui.showNotification("Invalid First Name. Try again. (Max 10 Characters)")
    else
      menu.close()

      Menu.Open('dialog', GetCurrentResourceName(), 'identity_last_name', {
        title = "Enter Your Last Name (Max 10 Characters)"
      }, function(data2, menu2)
        local lastName = tostring(data2.value)

        if lastName == nil then
          utils.ui.showNotification("Invalid Last Name. Try again. (Max 10 Characters)")
        else
          menu2.close()
          Menu.Open('dialog', GetCurrentResourceName(), 'identity_dob', {
            title = "Enter Your DOB (Max 10 Characters)"
          }, function(data3, menu3)

            local dob = tostring(data3.value)

            if dob == nil or GetLengthOfLiteralString(dob) > 10 then
              utils.ui.showNotification("Invalid DOB. Try again. (XX/XX/XXXX)")
            else
              menu3.close()

              Menu.Open('dialog', GetCurrentResourceName(), 'identity_sex', {
                title = "Enter Your Sex (m or f)"
              }, function(data4, menu4)

                local sexVal = tostring(data4.value)
                local sex

                if sexVal == "M" or sexVal == "m" then
                  sex = "Male"
                elseif sexVal == "F" or sexVal == "f" then
                  sex = "Female"
                end

                if not sex then
                  utils.ui.showNotification("Invalid Sex. Try again. (M or F)")
                else
                  menu4.close()
                  emitServer('esx:identity:register', firstName, lastName, dob, sex)
                  utils.ui.showNotification("Thank you for registering.")
                end
              end, function(data4, menu4)
                menu4.close()
              end)
            end
          end, function(data3, menu3)
            menu3.close()
          end)
        end
      end, function(data2, menu2)
        menu2.close()
      end)
    end
  end, function(data, menu)
    menu.close()
  end)
end)
