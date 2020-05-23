local Input = M('input')

self.Init()

ESX.Loop('draw-voice-level',function ()
	if NetworkIsPlayerTalking(PlayerId()) then
		self.DrawLevel(41, 128, 185, 255)
	else
		self.DrawLevel(185, 185, 185, 255)
  end
end,0)
