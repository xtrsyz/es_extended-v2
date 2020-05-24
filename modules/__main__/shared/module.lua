-- ESX base
ESX                   = {}
ESX.Ready             = false
ESX.Modules           = {}
ESX.Loops             = {}
ESX.LoopsRunning      = {}
ESX.TimeoutCount      = 1
ESX.CancelledTimeouts = {}

ESX.GetConfig = function()
  return Config
end

ESX.LogError = function(err)
  local str = '^7' .. err .. ' ' .. debug.traceback()
  print(str)
end

ESX.LogScopeError = function(scope, err)
  local str = '^7[esx] error in scope (' .. scope .. ') ' .. err .. ' ' .. debug.traceback()
  print(str)
end


ESX.LogLoopError = function(loop, err)
  local str = '^7[esx] error in loop (' .. loop .. ') ' .. err .. ' ' .. debug.traceback()
  print(str)
end

ESX.Loop = function(name, func, wait, conditions)

  ESX.Loops[name] = {
    func      = func,
    wait      = wait,
    conditons = conditions or {},
    name      = name,
  }

end

ESX.Scope = function(name, func)

  local status, result = xpcall(func, function(err)
    ESX.LogScopeError(name, err)
  end)

  return result
end

ESX.MakeScope = function(name, func)

  return function(...)

    local status, result = xpcall(func, function(err)
      ESX.LogScopeError(name, err)
    end)

    return result

  end

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

    local menv           = setmetatable(_menv, {__index = _G, __newindex = _G})
    _menv._ENV           = menv
    _menv.module.__ENV__ = menv

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

    TriggerEvent('esx:module:load:done', name, isC)

  end

  return ESX.Modules[name]

end

