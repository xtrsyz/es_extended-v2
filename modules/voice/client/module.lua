ESX.Modules['voice'] = {}
local self = ESX.Modules['voice']

self.Init = function()
  local translations = ESX.EvalFile(GetCurrentResourceName(), 'modules/voice/data/locales/' .. Config.Locale .. '.lua')['Translations']
  LoadLocale('voice', Config.Locale, translations)
end
