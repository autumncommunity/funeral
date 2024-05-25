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
    MsgC(color_white, getTimeStamp(), COLOR_BLUE, " [INFO] ", COLOR_GREY, tostring(message), "\n")
end

function class.static.Warning(message)
    MsgC(color_white, getTimeStamp(), COLOR_YELLOW, " [WARN] ", COLOR_GREY, tostring(message), "\n")
end

function class.static.Error(message)
    MsgC(color_white, getTimeStamp(), COLOR_RED, " [ERR] ", COLOR_GREY, tostring(message), "\n")
end

return class