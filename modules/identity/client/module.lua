self.Init = function()

  local translations = ESX.EvalFile(__RESOURCE__, 'modules/identity/data/locales/' .. Config.Locale .. '.lua')['Translations']
  LoadLocale('identity', Config.Locale, translations)

end
