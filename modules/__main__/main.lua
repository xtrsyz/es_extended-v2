local self = ESX.Modules['__MAIN__']

for i=1, #self.Entries, 1 do

  local name = self.Entries[i]

  if Config.Modules[name] and self.ModuleHasEntryPoint(name) then
    self.LoadModule(name)
  end

end
