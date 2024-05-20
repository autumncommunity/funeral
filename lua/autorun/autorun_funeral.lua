funeral = {}
funeral.author = {"smokingplaya"}

/**
  * Loader
*/

funeral.loader = {}
funeral.loader.includes = {
    cl = function(path)
        if CLIENT then
            return include(path)
        end

        AddCSLuaFile(path)
    end,
    sh = function(path)
        if SERVER then
            AddCSLuaFile(path)
        end

        return include(path)
    end,
    sv = function(path)
        if not SERVER then
            return
        end

        return include(path)
    end,
}

function funeral.loader:Include(path)
    local file = path:GetFileFromFilename()
    local mount = self.includes[file:Left(2)]

    if not mount then
        logger.Debug("Файл \"" .. file .. "\" будет подключен как shared, т.к у него отсутствует префикс.")
        return self.includes.sh(path)
    end

    return mount(path)
end

function funeral.loader:IncludeDir(path, recursive, recursive_count)
    local files, folders = file.Find(path .. "/*", "LUA")

    logger.Info("Including dir \"" .. path .. "\"")

    for _, file in ipairs(files) do
        local file_ext = file:GetExtensionFromFilename()

        if file_ext != "lua" then
            continue
        end

        self:Include(path .. "/" .. file)
    end

    if not recursive then
        return
    end

    local rec_count = 0

    for _, folder in ipairs(folders) do
        rec_count = rec_count + 1

        self:IncludeDir(path .. "/" .. folder, not (rec_count >= (recursive_count or math.huge)))
    end
end

/**
  * Загрузчик классов
*/

funeral.classes = {}

local class_mt = {}
class_mt.__index = {}
class_mt.__tostring = function(self)
    return "[class " .. self.name .. "]"
end

function funeral:DefineClasses()
    local class_folder = "classes/"
    local files = file.Find(class_folder .. "*.lua", "LUA")

    for _, filename in ipairs(files) do
        local class = self.loader.includes.sh(class_folder .. filename)
        local class_name = class.name

        if !class or !class_name then
            continue
        end

        class = setmetatable(class, class_mt)

        class.__index = class
        class.__tostring = function(self)
            return "[object " .. class_name .. "]"
        end

        self.classes[class_name] = class

        _G[class_name] = _G[class_name] || {}

        _G[class_name]["new"] = function(_, ...)
            local object = setmetatable({}, class)

            object.GetClass = function()
                return class
            end

            if isfunction(object.new) then
                object:new(...)
            end

            return object
        end
    end
end

function funeral:DefineLibraries()
    local libraries_folder = "libraries/"
    local files = file.Find(libraries_folder .. "*.lua", "LUA")

    for _, filename in ipairs(files) do
        funeral.loader.includes.sh(libraries_folder .. filename)
    end
end

function funeral:LoadSystems()
    local systems_folder = "systems/"
    local _, system = file.Find(systems_folder + "*", "LUA")

    foreach(system, function(name)
        funeral[name] = {}

        local system_path = systems_folder + name + "/"
        local init_file = system_path + "init.lua"

        if not file.Exists(init_file, "LUA") then
            return logger.Error("System \"" + name + "\" haven't init.lua file!")
        end

        if SERVER then
            AddCSLuaFile(init_file)
        end

        include(init_file)

        if not funeral[name].include then
            return logger.Warning("System \"" + name + "\" doesn't include anything!")
        end

        logger.Info("Including system \"" + name + "\"")

        foreach(funeral[name].include, function(file_name)
            local current_path = system_path + file_name

            if not file.Exists(current_path, "LUA") then
                return logger.Error("System \"" + name + "\" tried to include non-exist file \"" + current_path + "\"")
            end

            funeral.loader:Include(current_path)
        end)
    end)
end

funeral:DefineClasses()
funeral:DefineLibraries()
funeral:LoadSystems()