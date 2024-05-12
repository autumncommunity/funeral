--
-- Network Lib
-- * Author: smokingplaya
-- ? Network Lib - абстрация над обычной библиотекой net в Garry's Mod
--

network = network || {}
network.channels = network.channels || {}
/* types enums */
network.STRING = 0
network.ENTITY = 1
network.PLAYER = 2
/* UInt */
network.UINT4 = 3
network.UINT8 = 4
network.UINT16 = 5
/* Int */
network.INT4 = 6
network.INT8 = 7
network.INT16 = 8

network.types = {
    [network.STRING] = {Read = net.ReadString, Write = net.WriteString},
    [network.ENTITY] = {Read = net.ReadEntity, Write = net.WriteEntity},
    [network.PLAYER] = {Read = net.ReadPlayer, Write = net.WritePlayer}, /* если ты хочешь передать игрока, то нужно использовать это, а не ENTITY так как WriteEntity жрет (2^13)-1 бит, а WritePlayer (2^8)-1 бит */
    /* UInt */
    [network.UINT4] = {Read = function() return net.ReadUInt(4) end, Write = function(number) net.WriteUInt(number, 4) end},
    [network.UINT8] = {Read = function() return net.ReadUInt(8) end, Write = function(number) net.WriteUInt(number, 8) end},
    [network.UINT16] = {Read = function() return net.ReadUInt(16) end, Write = function(number) net.WriteUInt(number, 16) end},
    /* Int */
    [network.INT4] = {Read = function() return net.ReadInt(4) end, Write = function(number) net.WriteInt(number, 4) end},
    [network.INT8] = {Read = function() return net.ReadInt(8) end, Write = function(number) net.WriteInt(number, 8) end},
    [network.INT16] = {Read = function() return net.ReadInt(16) end, Write = function(number) net.WriteInt(number, 16) end},
}

function network:GetChannelName(name)
    return "e_" .. name
end

function network:RegisterChannel(name)
    local channel = NetworkChannel:new(self:GetChannelName(name))

    network.channels[name] = channel

    return channel
end

function network:GetChannel(name)
    return network.channels[self:GetChannelName(name)]
end

function network:SetupArgs(channel, ...)
    local types = SERVER and channel.clientTypes or channel.serverTypes

    for i, data in ipairs({...}) do
        local type = types[i]

        if !type then
            continue
        end

        local type_data = network.types[type]

        if !type_data or !type_data.Read then
            continue
        end

        type_data.Write(data)
    end
end

function network:ReadArgs(channel)
    local args = {}

    for i, type in ipairs(SERVER and channel.serverTypes or channel.clientTypes) do
        local type_data = network.types[type]

        if !type_data or !type_data.Read then
            continue
        end

        args[#args+1] = type_data.Read()
    end

    return unpack(args)
end

function network:Listen(channel, callback)
    local channel_name = channel.channelName

    net.Receive(channel_name, function(len, client)
        callback(client, function(...)
            net.Start(channel_name)

            network:SetupArgs(channel, ...)

            net[SERVER and "Send" or "SendToServer"](SERVER and client)
        end, len)
    end)
end
