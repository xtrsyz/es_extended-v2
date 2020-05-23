module = {}
local self = module

-- Properties
self.Config = ESX.EvalFile(GetCurrentResourceName(), 'modules/accessories/data/config.lua', {
  vector3 = vector3
})['Config']
