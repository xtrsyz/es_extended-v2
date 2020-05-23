ESX.Modules['controller'] = {}
local self = ESX.Modules['controller']

self.Table_load = json.decode(LoadResourceFile(GetCurrentResourceName(), './modules/controller/module_controller.json'))

for i=1, #self.Table_load, 1 do

    print(self.Table_load[i])

    local env = ESX.EvalFile(GetCurrentResourceName(), 'modules/' .. self.Table_load[i] .. '/server/module.lua', _ENV)

    ESX.EvalFile(GetCurrentResourceName(), 'modules/' .. self.Table_load[i] .. '/server/main.lua', env)
    ESX.EvalFile(GetCurrentResourceName(), 'modules/' .. self.Table_load[i] .. '/server/events.lua', env)

    local module = env['module']

    ESX.Modules[self.Table_load[i]] = module

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