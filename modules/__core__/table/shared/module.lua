table.indexOf = function(t, val)

  for i=1, #t, 1 do
    if t[i] == val then
      return i
    end
  end

  return -1

end

table.lastIndexOf = function(t, val)

  for i=#t, 1, -1 do
    if t[i] == val then
      return i
    end
  end

  return -1
end

table.find = function(t, cb)

  for i=1, #t, 1 do
    if cb(t[i]) then
      return t[i]
    end
  end

  return nil

end

table.findIndex = function(t, cb)

  for i=1, #t, 1 do
    if cb(t[i]) then
      return i
    end
  end

  return -1
end

table.filter = function(t, cb)

  local newTable = {}

  for i=1, #t, 1 do
    if cb(t[i]) then
      table.insert(newTable, t[i])
    end
  end

  return newTable

end

table.map = function(t, cb)

  local newTable = {}

  for i=1, #t, 1 do
    newTable[i] = cb(t[i], i)
  end

  return newTable

end

table.reverse = function(t)

  local newTable = {}

  for i=#t, 1, -1 do
    table.insert(newTable, t[i])
  end

  return newTable

end

table.clone = function(t)

  if type(t) ~= 'table' then return t end

  local meta   = getmetatable(t)
  local target = {}

  for k,v in pairs(t) do
    if type(v) == 'table' then
      target[k] = table.clone(v)
    else
      target[k] = v
    end
  end

  setmetatable(target, meta)

  return target

end

table.concat = function(t1, t2)

  if type(t2) == 'string' then
    local separator = t2
    return table.join(t1, separator)
  end

  local t3 = table.clone(t1)

  for i=1, #t2, 1 do
    table.insert(t3, t2[i])
  end

  return t3

end

table.join = function(t, sep)

  local sep = sep or ','
  sep       = tostring(sep)
  local str = ''

  for i=1, #t, 1 do

    if i > 1 then
      str = str .. sep
    end

    str = str .. tostring(t[i])

  end

  return str

end

table.merge = function(t1, t2)

  for k,v in pairs(t2) do
    if type(v) == 'table' then
      table.merge(t1[k] or {}, t2[k] or {})
    else
      t1[k] = t2[k]
    end
  end

  return t1

end
