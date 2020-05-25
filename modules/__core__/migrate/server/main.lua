on('esx:db:ready', function()

	print('ensuring migrations')

  	local __MAIN__ = ESX.Modules['__MAIN__']
	local index    = 0
	local results  = {}
	local start
	local manifest = LoadResourceFile(GetCurrentResourceName(), 'fxmanifest.lua')
	local inform = false

	self.Ensure('base')

	for i=1, #__MAIN__.CoreOrder, 1 do

    	local module = __MAIN__.CoreOrder[i]
		local check  = self.Ensure(module, true)

	end

	for i=1, #__MAIN__.Order, 1 do

    	local module = __MAIN__.Order[i]
		local check  = self.Ensure(module, false)

	end

  emit('esx:migrations:done')

end)