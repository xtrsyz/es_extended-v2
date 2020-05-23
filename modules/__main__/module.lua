ESX.Modules['__MAIN__'] = {}
local self              = ESX.Modules['__MAIN__']

local resName = GetCurrentResourceName()
local modType = IsDuplicityVersion() and 'server' or 'client'

self.Entries = json.decode(LoadResourceFile(resName, 'modules.json'))
self.Order   = {}

self.ModuleHasEntryPoint = function(name)
  return LoadResourceFile(resName, 'modules/' .. name .. '/' .. modType .. '/module.lua') ~= nil
end

self.LoadModule = function(name)

  if ESX.Modules[name] == nil then

    TriggerEvent('esx:module:load:before', name)

    local _menv = {}

    for k,v in pairs(_menv) do
      _menv[k] = v
    end

    _menv._G           = _menv
    _menv.__RESOURCE__ = resName
    _menv.__MODULE__   = name
    _menv.module       = {}
    _menv.self         = _menv.module
    _menv.M            = self.LoadModule

    _menv.print = function(...)

      local args = {...}
      local str  = '[^3' .. name .. '^7]'

      for i=1, #args, 1 do
        str = str .. ' ' .. tostring(args[i])
      end

      print(str)

    end

    local menv = setmetatable(_menv, {__index = _G})

    local env = ESX.EvalFile(resName, 'modules/' .. name .. '/' .. modType .. '/module.lua', menv)
    ESX.EvalFile(resName, 'modules/' .. name .. '/' .. modType .. '/events.lua', env)
    ESX.EvalFile(resName, 'modules/' .. name .. '/' .. modType .. '/main.lua',   env)

    ESX.Modules[name] = env['module']

    self.Order[#self.Order + 1] = name

    TriggerEvent('esx:module:load:done', name)

  end

  return ESX.Modules[name]

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
