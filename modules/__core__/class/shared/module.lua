-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

-- From => http://lua-users.org/wiki/InheritanceTutorial

Extends = function(baseClass)

  local newClass = {}

  local classMt  = {
    __index = newClass,
  }

  function newClass:create(...)

    local newInst = {}

    setmetatable(newInst, classMt)

    if type(newClass.constructor) == 'function' then
      newInst:constructor(...)
    end

    return newInst

  end

  if baseClass ~= nil then
    setmetatable( newClass, { __index = baseClass } )
  end

  -- Implementation of additional OO properties starts here --

  -- Return the class object of the instance
  function newClass:type()
    return newClass
  end

  -- Return the super class object of the instance
  function newClass:super()
    return baseClass
  end

  -- Return true if the caller is an instance of theClass
  function newClass:instanceOf(theClass)

    local b_isa = false

    local curClass = newClass

    while (nil ~= curClass) and (false == b_isa) do
      if curClass == theClass then
        b_isa = true
      else
        curClass = curClass:superClass()
      end
    end

    return b_isa

  end

  return newClass

end
