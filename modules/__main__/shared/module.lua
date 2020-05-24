ESX.Modules['__MAIN__'] = {}
local self              = ESX.Modules['__MAIN__']

local resName = GetCurrentResourceName()
local modType = IsDuplicityVersion() and 'server' or 'client'

self.CoreEntries = json.decode(LoadResourceFile(resName, 'modules/__core__/modules.json'))
self.Entries     = json.decode(LoadResourceFile(resName, 'modules.json'))

self.CoreOrder   = {}
self.Order       = {}

self.GetModuleEntryPoints = function(name, isCore)

  isCore                = isCore or false
  local prefix          = isCore and '__core__/' or ''
  local shared, current = false, false

  if LoadResourceFile(resName, 'modules/' .. prefix .. name .. '/shared/module.lua') ~= nil then
    shared = true
  end

  if LoadResourceFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua') ~= nil then
    current = true
  end

  return shared, current

end

self.ModuleHasEntryPoint = function(name, isCore)
  local shared, current = self.GetModuleEntryPoints(name, isCore)
  return shared or current
end

self.LoadModule = function(name, isCore)

  isCore       = isCore or false
  local prefix = isCore and '__core__/' or ''

  if ESX.Modules[name] == nil then

    TriggerEvent('esx:module:load:before', name, isCore)

    local _menv = {}

    for k,v in pairs(_menv) do
      _menv[k] = v
    end

    _menv._G           = _menv
    _menv.__RESOURCE__ = resName
    _menv.__ISCORE__   = isCore
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

    local menv           = setmetatable(_menv, {__index = _G})
    _menv.module.__ENV__ = menv

    local shared, current = self.GetModuleEntryPoints(name, isCore)
    local env

    if shared then
      env = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/module.lua', menv)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/events.lua', env)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/main.lua',   env)
    end

    if current then
      env = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua', menv)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/events.lua', env)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/main.lua',   env)
    end

    ESX.Modules[name] = env['module']

    if isCore then
      self.CoreOrder[#self.CoreOrder + 1] = name
    else
      self.Order[#self.Order + 1] = name
    end

    TriggerEvent('esx:module:load:done', name, isC)

  end

  return ESX.Modules[name]

end
