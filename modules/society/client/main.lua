self.Init()

Citizen.CreateThread(function()

	while (ESX.PlayerData == nil) or (ESX.PlayerData.job == nil) do
		Citizen.Wait(10)
	end

  self.RefreshBossHUD()

end)
