local self = module

self.Init()

TriggerEvent('cron:runAt', 3, 0, self.WashMoneyCRON)
