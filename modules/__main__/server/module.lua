local self = ESX.Modules['__MAIN__']

ESX.Items = {}
ESX.Jobs  = {}

ESX.DoesJobExist = function(job, grade)

  grade = tostring(grade)

  if job and grade and ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
    return true
  end

  return false

end

