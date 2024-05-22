logger = {}

local color_grey = Color(200, 200, 200)

local function getTimeStamp()
    return os.date("[%H:%M:%S]", os.time())
end

local color_info = Color(0,81,255)
function logger.Info(message)
    MsgC(color_white, getTimeStamp(), color_info, " [INFO] ", color_grey, tostring(message), "\n")
end

local color_warning = Color(255,153,0)
function logger.Warning(message)
    MsgC(color_white, getTimeStamp(), color_warning, " [WARN] ", color_grey, tostring(message), "\n")
end

local color_error = Color(216,55,55)
function logger.Error(message)
    MsgC(color_white, getTimeStamp(), color_error, " [ERR] ", color_grey, tostring(message), "\n")
end