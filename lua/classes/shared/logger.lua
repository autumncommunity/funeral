local class = {}
class.name = "logger"
class.static = {
    COLOR_GREY = Color(200, 200, 200),
    COLOR_BLUE = Color(0,102,255),
    COLOR_RED = Color(255,60,60),
    COLOR_YELLOW = Color(255,145,0)
}

local function getTimeStamp()
    return os.date("%H:%M:%S", os.time())
end

local COLOR_GREY = class.static.COLOR_GREY
local COLOR_BLUE = class.static.COLOR_BLUE
local COLOR_YELLOW = class.static.COLOR_YELLOW
local COLOR_RED = class.static.COLOR_RED

function class.static.Info(message)
    MsgC(COLOR_GREY, getTimeStamp(), COLOR_BLUE, " INFO ", color_white, tostring(message), "\n")
end

function class.static.Warning(message)
    MsgC(COLOR_GREY, getTimeStamp(), COLOR_YELLOW, " WARN ", color_white, tostring(message), "\n")
end

function class.static.Error(message)
    MsgC(COLOR_GREY, getTimeStamp(), COLOR_RED, " ERR ", color_white, tostring(message), "\n")
end

return class