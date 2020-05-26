local self     = ESX.Modules['boot']
local hasError = false

for i=1, #self.CoreEntries, 1 do

  local name = self.CoreEntries[i]

  if self.ModuleHasEntryPoint(name, true) then
    
    local module, _error = self.LoadModule(name, true)

    if _error then
      hasError = true
      break
    end

  end

end

if not hasError then

  for i=1, #self.Entries, 1 do

    local name = self.Entries[i]

    if Config.Modules[name] and self.ModuleHasEntryPoint(name, false) then
      
      local module, _error = self.LoadModule(name, false)

      if _error then
        break
      end

    end

  end

end

Citizen.CreateThread(function()

  if not IsDuplicityVersion() then
    AddTextEntry('FE_THDR_GTAO', 'ESX')
  end

end)
