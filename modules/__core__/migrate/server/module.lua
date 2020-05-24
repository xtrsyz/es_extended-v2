M('db')

self.Ensure = function(module)

  print('ensure migration for ^3' .. module)

  local dir

  if module == 'base' then
    dir = 'migrations'
  else
    dir = 'modules/' .. module .. '/migrations'
  end

  local result      = MySQL.Sync.fetchAll('SELECT * FROM `migrations` WHERE `module` = @module', {['@module'] = module})
  local initial     = true
  local i           = 0
  local hasmigrated = false

  if #result > 0 then
    i       = result[1].last + 1
    initial = false
  end

  local sql = nil

  repeat

    sql = LoadResourceFile(GetCurrentResourceName(), dir .. '/' .. i .. '.sql')

    if sql ~= nil then

      print('running migration for ^3' .. module .. '^7 #' .. i)

      MySQL.Sync.execute(sql)

      if initial then
        MySQL.Sync.execute( 'INSERT INTO `migrations` (module, last) VALUES (@module, @last)', {['@module'] = module, ['@last'] = 0})
      else
        MySQL.Sync.execute( 'UPDATE `migrations` SET `last` = @last WHERE `module` = @module', {['@module'] = module, ['@last'] = i})
      end

      hasmigrated = true

    end

    i = i + 1

  until sql == nil

  if not hasmigrated then
    -- print('no pending migration for ^3' .. module .. '^7')
  end

  return initial

end