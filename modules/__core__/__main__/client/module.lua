local self = ESX.Modules['__MAIN__']

ESX.IsLoadoutLoaded = false
ESX.IsPaused        = false
ESX.Pickups         = {}

ESX.CreateFrame = function(name, url, visible)
	visible = (visible == nil) and true or false
	SendNUIMessage({action = 'create_frame', name = name, url = url, visible = visible})
end

ESX.SendFrameMessage = function(name, msg)
	SendNUIMessage({target = name, data = msg})
end

ESX.FocusFrame = function(name, cursor)
	SendNUIMessage({action = 'focus_frame', name = name})
	SetNuiFocus(true, cursor)
end

