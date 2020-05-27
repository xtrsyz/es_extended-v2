local HUD = M('game.hud')

self.Init()

Citizen.CreateThread(function()

	while (ESX.PlayerData == nil) or (ESX.PlayerData.job == nil) do
		Citizen.Wait(0)
  end


  while (not HUD.Frame) or (not HUD.Frame.loaded) do
    Citizen.Wait(0)
  end

  self.RefreshBossHUD()

end)
