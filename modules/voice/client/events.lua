local self = ESX.Modules['voice']
local Input = ESX.Modules['input']

Input.On('pressed', 1, 74, function(lastPressed)

  if Input.IsControlPressed(1, 21) then

    self.voice.current = (self.voice.current + 1) % 3

    if self.voice.current == 0 then
      NetworkSetTalkerProximity(self.voice.default)
      self.voice.level = _U('voice:normal')
    elseif self.voice.current == 1 then
      NetworkSetTalkerProximity(self.voice.shout)
      self.voice.level = _U('voice:shout')
    elseif self.voice.current == 2 then
      NetworkSetTalkerProximity(self.voice.whisper)
      self.voice.level = _U('voice:whisper')
    end
  end
end)
