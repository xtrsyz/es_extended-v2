local self = ESX.Modules['__MAIN__']

for i=1, #self.CoreEntries, 1 do

  local name = self.CoreEntries[i]

  if self.ModuleHasEntryPoint(name, true) then
    self.LoadModule(name, true)
  end

end

for i=1, #self.Entries, 1 do

  local name = self.Entries[i]

  if Config.Modules[name] and self.ModuleHasEntryPoint(name, false) then
    self.LoadModule(name, false)
  end

end

-- ESX.SetTimeout
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		local currTime = GetGameTimer()

		for i=1, #ESX.TimeoutCallbacks, 1 do
			if ESX.TimeoutCallbacks[i] then
				if currTime >= ESX.TimeoutCallbacks[i].time then
					ESX.TimeoutCallbacks[i].cb()
					ESX.TimeoutCallbacks[i] = nil
				end
			end
    end

	end
end)

-- ESX.Loop
Citizen.CreateThread(function()

  if not IsDuplicityVersion() then
    AddTextEntry('FE_THDR_GTAO', 'ESX')
  end

  local logLoopError = function(err)
    ESX.LogLoopError(name, err)
  end

  local runLoop = function(name, loop)

    local conditionsMet = true

    for j=1, #loop.conditons, 1 do
      if not loop.conditons[j]() then
        conditionsMet = false
        break
      end
    end

    if conditionsMet then

      ESX.LoopsRunning[name] = true

      Citizen.CreateThread(function()
        while true do

          local tests = #loop.conditons

          for i=1, #loop.conditons, 1 do

            if not loop.conditons[i]() then
              break
            end

            tests = tests - 1

          end

          if tests > 0 then
            ESX.LoopsRunning[name] = false
            return
          end

          local status, result = xpcall(loop.func, logLoopError)

          if not status then
            ESX.Loops[name]        = nil
            ESX.LoopsRunning[name] = false
            return
          end

          Citizen.Wait(loop.wait)

        end
      end)

    end

  end

  while true do

    for name, loop in pairs(ESX.Loops) do

      if ESX.LoopsRunning[name] ~= true then
        local status, result = xpcall(runLoop, ESX.LogError, name, loop)
      end

    end

    Citizen.Wait(250)

  end
end)
