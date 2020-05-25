local self = ESX.Modules['boot']

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

-- ESX.Loop
Citizen.CreateThread(function()

  if not IsDuplicityVersion() then
    AddTextEntry('FE_THDR_GTAO', 'ESX')
  end

end)
