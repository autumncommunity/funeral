/**
 * NetworkChannel
 * * Класс, нужный для регистрации канала для network-передач.
*/

local class = {}
class.name = "NetworkChannel"

/**
    * constructor
    * * Регистрирует канал через util.AddNetworkString
*/

function class:new(channelName)
    self.channelName = channelName
    self.serverTypes = {}
    self.clientTypes = {}

    if SERVER then
        util.AddNetworkString(channelName)
    end
end

/**
    * ClientToServer
    * * Устанавливает типы данных, передаваемые клиентом серверу
    * @param vararg тип(-ы) данных
*/

function class:ClientToServer(...)
    self.serverTypes = {...}

    return self
end

/**
    * ServerToClient
    * * Устанавливает типы данных, передаваемые сервером клиенту
    * @param vararg тип(-ы) данных
*/

function class:ServerToClient(...)
    self.clientTypes = {...}

    return self
end

return class