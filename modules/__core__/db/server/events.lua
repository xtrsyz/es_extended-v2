
MySQL.ready(function()
  emit('esx:db:internal:ready')
end)

on('esx:db:internal:ready', function()

  -- Init minimum required schemas here
  self.InitTable('migrations', 'id', {
    {name = 'id',     type = 'INT',     length = 11, default = nil, extra = 'NOT NULL AUTO_INCREMENT'},
    {name = 'module', type = 'VARCHAR', length = 64,  default = nil, extra = nil},
    {name = 'last',   type = 'INT',     length = 11, default = nil, extra = nil},
  })

  self.InitTable('users', 'identifier', {
    {name = 'identifier', type = 'VARCHAR',  length = 40, default = nil,                                                extra = 'NOT NULL'},
    {name = 'name',       type = 'LONGTEXT', length = nil, default = 'NULL',                                             extra = nil},
    {name = 'accounts',   type = 'LONGTEXT', length = nil, default = 'NULL',                                             extra = nil},
    {name = 'group',      type = 'VARCHAR',  length = 64,  default = 'user',                                             extra = nil},
    {name = 'inventory',  type = 'LONGTEXT', length = nil, default = 'NULL',                                             extra = nil},
    {name = 'job',        type = 'VARCHAR',  length = 32,  default = 'unemployed',                                       extra = nil},
    {name = 'job_grade',  type = 'INT',      length = 11, default = 0,                                                  extra = nil},
    {name = 'loadout',    type = 'LONGTEXT', length = nil, default = 'NULL',                                             extra = nil},
    {name = 'position',   type = 'VARCHAR',  length = 255, default = '{"x":-269.4,"y":-955.3,"z":31.2,"heading":205.8}', extra = nil},
    {name = 'is_dead',    type = 'INT',      length = 1, default = 0,                                                  extra = nil},
  })

  self.InitTable('jobs', 'name', {
    {name = 'name',  type = 'VARCHAR', length = 64,  default = nil,    extra = 'NOT NULL'},
    {name = 'label', type = 'VARCHAR', length = 64,  default = 'NULL', extra = nil},
  }, {
    {name = 'unemployed', label = 'Unemployed'}
  })

  self.InitTable('job_grades', 'id', {
    {name = 'id',          type = 'INT',      length = 11,  default = nil,    extra = 'NOT NULL AUTO_INCREMENT'},
    {name = 'job_name',    type = 'VARCHAR',  length = 32,   default = 'NULL', extra = nil},
    {name = 'grade',       type = 'INT',      length = 11,  default = nil,    extra = 'NOT NULL'},
    {name = 'name',        type = 'VARCHAR',  length = 64,   default = nil,    extra = 'NOT NULL'},
    {name = 'label',       type = 'VARCHAR',  length = 64,   default = nil,    extra = 'NOT NULL'},
    {name = 'salary',      type = 'INT',      length = 0,    default = nil,    extra = 'NOT NULL'},
    {name = 'skin_male',   type = 'LONGTEXT', length = nil,  default = nil,    extra = 'NOT NULL'},
    {name = 'skin_female', type = 'LONGTEXT', length = nil,  default = nil,    extra = 'NOT NULL'},
  }, {
    {job_name = 'unemployed', grade = 0, name = 'unemployed', label = 'Unemployed', salary = 200, skin_male = '{}', skin_female = '{}'}
  })

  self.InitTable('items', 'name', {
    {name = 'name',        type = 'VARCHAR',  length = 64,   default = nil,    extra = 'NOT NULL'},
    {name = 'label',       type = 'VARCHAR',  length = 64,   default = nil,    extra = 'NOT NULL'},
    {name = 'weight',      type = 'INT',      length = 11,  default = nil,    extra = 'NOT NULL'},
    {name = 'rare',        type = 'INT',      length = 1,  default = nil,    extra = 'NOT NULL'},
    {name = 'can_remove',  type = 'INT',      length = 1,   default = nil,    extra = 'NOT NULL'},
  })

  -- Leave a chance to extend schemas here
  emit('esx:db:init', self.InitTable, self.ExtendTable)

  -- Ensure schemas in database
  for k,v in pairs(self.Tables) do
    v:ensure()
  end

  -- database ready for migrations
  emit('esx:db:ready')

end)
