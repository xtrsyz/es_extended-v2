local ModuleController = {}
local self = ModuleController

self.Table_load = json.decode(LoadResourceFile(GetCurrentResourceName(), './modules.json'))

self.LoadModule = function(name)

  if ESX.Modules[name] == nil then

    local envCopy = {
      LoadModule = self.LoadModule
    }

    for k,v in pairs(_ENV) do
      envCopy[k] = v
    end

    envCopy._G = envCopy

    local env = ESX.EvalFile(GetCurrentResourceName(), 'modules/' .. name .. '/server/module.lua', envCopy)

    ESX.EvalFile(GetCurrentResourceName(), 'modules/' .. name .. '/server/main.lua', env)
    ESX.EvalFile(GetCurrentResourceName(), 'modules/' .. name .. '/server/events.lua', env)

    local module = env['module']

    ESX.Modules[name] = module

  end

  return ESX.Modules[name]

end

for i=1, #self.Table_load, 1 do
  if Config.Modules[self.Table_load[i]] then
    self.LoadModule(self.Table_load[i])

    print("Module loaded: " .. self.Table_load[i])

  else
    print("Module disabled: " .. self.Table_load[i])

  end
end

--[[

if IsDuplicityVersion() -- true = server | false = client

    Load Json
    Order of loading (deps)
        Load that module
        check if loaded
        repeat


    Potentially:

    Module = true / false
    Load Json
    Loop table
        check if already loaded
            check if dep loaded
            if not => load dep
                then load module

]]--
