local Input = M('input')

self.Init()

Citizen.CreateThread(function()

	if NetworkIsPlayerTalking(PlayerId()) then
		self.DrawLevel(41, 128, 185, 255)
	else
		self.DrawLevel(185, 185, 185, 255)
  end

  Citizen.Wait(0)

end)
