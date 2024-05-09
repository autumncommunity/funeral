local string = getmetatable("")

/**
  * * Конкатинация строк через + (ex. "Hello, " + "world!")
*/
function string:__add(str)
    return self .. str
end