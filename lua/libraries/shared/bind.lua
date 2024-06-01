/* you can handle binds on client and server */
bind = {}
bind.binds = {}

function bind:Register(button, callback, id)
    if not self.binds[button] then
        self.binds[button] = {}
    end

    id = id or #self.binds+1

    self.binds[button][id] = callback

    return id
end

function bind:UnRegister(button, id)
    if not self.binds[button] then
        return
    end

    self.binds[button][id] = nil
end

hook.Add("PlayerButtonUp", "funeral.binds", function(pl, button)
    if not IsFirstTimePredicted() then
        return
    end

    local binds = bind.binds[button]

    if not binds then
        return
    end

    for _, callback in pairs(binds) do
        callback(pl)
    end
end)