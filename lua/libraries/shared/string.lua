local string_mt = getmetatable("")

/**
  * * Конкатенация строк через + (ex. "Hello, " + "world!")
*/

function string_mt:__add(str)
    return self .. str
end

function string.json(self)
  return util.JSONToTable(self)
end