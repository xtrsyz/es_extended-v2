M('player')

xPlayer.createDBAccessor('firstName', {name = 'first_name', type = 'VARCHAR', length = 32,  default = 'NULL', extra = nil})
xPlayer.createDBAccessor('lastName',  {name = 'last_name',  type = 'VARCHAR', length = 32,  default = 'NULL', extra = nil})
xPlayer.createDBAccessor('DOB',       {name = 'dob',        type = 'VARCHAR', length = 10,  default = 'NULL', extra = nil})
xPlayer.createDBAccessor('isMale',    {name = 'is_male',    type = 'INT',     length = nil, default = 1,      extra = nil})
