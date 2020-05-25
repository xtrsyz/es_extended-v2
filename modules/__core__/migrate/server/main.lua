on('esx:db:ready', function()

	print('ensuring migrations')

  	local boot = ESX.Modules['boot']
	local index    = 0
	local results  = {}
	local start
	local manifest = LoadResourceFile(GetCurrentResourceName(), 'fxmanifest.lua')

	self.Ensure('base')

	for i=1, #boot.CoreOrder, 1 do

    	local module = boot.CoreOrder[i]
		self.Ensure(module, true)

	end

	for i=1, #boot.Order, 1 do

    	local module = boot.Order[i]
		self.Ensure(module, false)

	end

  emit('esx:migrations:done')

end)
