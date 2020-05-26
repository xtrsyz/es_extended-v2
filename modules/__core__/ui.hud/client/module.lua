M('events')

ESX.CreateFrame = function(name, url, visible)

  if visible == nil then
    visible = true
  end

  if not self.Ready then

    Citizen.CreateThread(function()

      while not self.Ready do
        Citizen.Wait(0)
      end

      SendNUIMessage({action = 'create_frame', name = name, url = url, visible = visible})

    end)

  else

    SendNUIMessage({action = 'create_frame', name = name, url = url, visible = visible})

  end

end

ESX.DestroyFrame = function(name)
	SendNUIMessage({action = 'destroy_frame', name = name})
end

ESX.SendFrameMessage = function(name, msg)
	SendNUIMessage({target = name, data = msg})
end

ESX.FocusFrame = function(name, cursor)
	SendNUIMessage({action = 'focus_frame', name = name})
	SetNuiFocus(true, cursor)
end

self.Ready  = false
self.Frames = {}

Frame = Extends(nil)

Frame.unfocus = function()
  SetNuiFocus(false)
end

function Frame:constructor(name, url, visible)

  self.name      = name
  self.url       = url
  self.handlers  = {}
  self.destroyed = false

  ESX.CreateFrame(name, url, visible)

  module.Frames[self.name] = self

end

function Frame:destroy(name)
  self.destroyed = true
  ESX.DestroyFrame(name)
end

function Frame:onMessage(fn)
  self.handlers[#self.handlers + 1] = fn
end

function Frame:postMessage(msg)
  ESX.SendFrameMessage(self.name, msg)
end

function Frame:focus(cursor)
  ESX.FocusFrame(self.name, cursor)
end
