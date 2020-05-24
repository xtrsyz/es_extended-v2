AddEventHandler("playerSpawned", function ()

	if GetIsLoadingScreenActive() then

		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()

	end
end)
