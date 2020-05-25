-- Immediate definitions

local _print = print

print = function(...)

  local args = {...}
  local str  = '[^4esx^7]'

  for i=1, #args, 1 do
    str = str .. ' ' .. tostring(args[i])
  end

  _print(str)

end

local tableIndexOf = function(t, val)

  for i=1, #t, 1 do
    if t[i] == val then
      return i
    end
  end

  return -1

end

-- ESX base
ESX                   = {}
ESX.Ready             = false
ESX.Modules           = {}
ESX.TimeoutCount      = 1
ESX.CancelledTimeouts = {}

ESX.GetConfig = function()
  return Config
end

ESX.LogError = function(err)
  local str = '^7' .. err .. ' ' .. debug.traceback()
  print(str)
end

ESX.EvalFile = function(resource, file, env)

  env        = env or {}
  env._G     = env
  local code = LoadResourceFile(resource, file)
  local fn   = load(code, '@' .. resource .. ':' .. file, 't', env)

  local status, result = xpcall(fn, function(err)
    ESX.LogError('[error] in @' .. resource .. ':' .. file .. '\n' .. err)
  end)

  return env

end

ESX.SetTimeout = function(msec, cb)

  local id = (ESX.TimeoutCount + 1 < 65635) and (ESX.TimeoutCount + 1) or 1

  SetTimeout(msec, function()

    if ESX.CancelledTimeouts[id] then
      ESX.CancelledTimeouts[id] = nil
    else
      cb()
    end

  end)

  ESX.TimeoutCount = id;

  return id

end

ESX.ClearTimeout = function(id)
  CancelledTimeouts[id] = true
end

ESX.SetInterval = function(msec, cb)

  local id = (ESX.TimeoutCount + 1 < 65635) and (ESX.TimeoutCount + 1) or 1

  local run

  run = function()

    ESX.SetTimeout(msec, function()

      if ESX.CancelledTimeouts[id] then
        ESX.CancelledTimeouts[id] = nil
      else
        cb()
        run()
      end

    end)

  end

  ESX.TimeoutCount = id;

  run()

  return id

end

ESX.ClearInterval = function(id)
  CancelledTimeouts[id] = true
end

-- ESX main module
ESX.Modules['__MAIN__'] = {}
local self              = ESX.Modules['__MAIN__']

local resName = GetCurrentResourceName()
local modType = IsDuplicityVersion() and 'server' or 'client'

self.CoreEntries = json.decode(LoadResourceFile(resName, 'modules/__core__/modules.json'))
self.Entries     = json.decode(LoadResourceFile(resName, 'modules.json'))

self.CoreOrder   = {}
self.Order       = {}

self.GetModuleEntryPoints = function(name)

  local isCore          = self.IsCoreModule(name)
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

self.IsCoreModule = function(name)
  return tableIndexOf(self.CoreEntries, name) ~= -1
end

self.ModuleHasEntryPoint = function(name)

  local isCore          = self.IsCoreModule(name)
  local shared, current = self.GetModuleEntryPoints(name, isCore)

  return shared or current

end

self.createModuleEnv = function(name, isCore)

  local env = {}

  for k,v in pairs(env) do
    env[k] = v
  end

  env.__RESOURCE__ = resName
  env.__ISCORE__   = isCore
  env.__MODULE__   = name
  env.module       = {}
  env.self         = env.module
  env.M            = self.LoadModule

  env.print = function(...)

    local args = {...}
    local str  = '[^3' .. name .. '^7]'

    for i=1, #args, 1 do
      str = str .. ' ' .. tostring(args[i])
    end

    print(str)

  end

  local menv           = setmetatable(env, {__index = _G, __newindex = _G})
  env._ENV           = menv
  env.module.__ENV__ = menv

  return env

end

self.LoadModule = function(name)

  local isCore = self.IsCoreModule(name)
  local prefix = isCore and '__core__/' or ''

  if ESX.Modules[name] == nil then

    TriggerEvent('esx:module:load:before', name, isCore)

    local menv            = self.createModuleEnv(name, isCore)
    local shared, current = self.GetModuleEntryPoints(name, isCore)
    local env

    if shared then
      env = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/module.lua', menv)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/events.lua', env)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/shared/main.lua',   env)
    end

    if current then

      if env then
        ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua', env)
      else
        env = ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/module.lua', menv)
      end

      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/events.lua', env)
      ESX.EvalFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/main.lua',   env)
    end

    ESX.Modules[name] = env['module']

    if isCore then
      self.CoreOrder[#self.CoreOrder + 1] = name
    else
      self.Order[#self.Order + 1] = name
    end

    TriggerEvent('esx:module:load:done', name, isCore)

  end

  return ESX.Modules[name]

end

