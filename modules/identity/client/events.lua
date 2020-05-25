local Menu = M('ui.menu')

on('esx:ready', function()
	print('Checking Identity')
	request('esx:identity:check', function(result)
        if result then
            emit('esx:identity:loaded')
        else
            emit('esx:identity:prompt')
        end
    end)
end)

on('esx:identity:loaded', function(playerData)
    ESX.ShowNotification("Loaded, but doesn\'t do shit yet.")
end)

on('esx:identity:prompt', function()
	Menu.Open('dialog', GetCurrentResourceName(), 'identity_name', {
		title = "Enter Your Name"
	}, function(data, menu)
		local name = tostring(data.value)

		if name == nil then
			ESX.ShowNotification("Invalid Name")
		else
			menu.close()
			Menu.Open('dialog', GetCurrentResourceName(), 'identity_dob', {
				title = "Enter Your DOB"
			}, function(data2, menu2)
				local dob = tostring(data2.value)

				if dob == nil then
					ESX.ShowNotification("Invalid DOB")
				else
					menu2.close()
					ESX.ShowNotification("You did it you crazy son of a bitch, you did it!")
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end)
