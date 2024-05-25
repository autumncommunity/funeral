/**
 * WebUI
 * * Класс, отвечающий за CEF юзер интерфейсы.
*/

local class = {}
class.static = {}
class.list = {} /* список существующих панелей */
class.name = "WebUI"

/**
    * constructor
    * * Задает необходимые поля
    * @param name - Ключ конкретного WebUI в таблице со всеми WebUI
    * @param url - URL-ссылка, которая будет открываться
    * @param save_on_close? - Будет ли текущий WebUI полностью удалятся при вызове метода Close?
*/

function class:new(name, url, save_on_close)
    local panel = class.list[name]

    if panel then
        if IsValid(panel) then
            panel:Remove()
        end

        class.list[name] = nil
    end

    self.panel = NULL
    self.name = name
    self.url = url
    self.isSave = save_on_close or false
end

/**
    * Prepare (static)
    * * Возвращает панель если она не существует, либо создает ее и возвращает.
    * @param name - Ключ конкретного WebUI в таблице со всеми WebUI
    * @param url - URL-ссылка, которая будет открываться
    * @param save_on_close? - Будет ли текущий WebUI полностью удалятся при вызове метода Close?

    example:
        WebUI.Prepare("HUD", "asset://garrysmod/hud.html", false)
*/

function class.static.Prepare(name, url, save_on_close)
    local panel = class.list[name]

    if IsValid(panel) then
        return panel
    end

    return _G[class.name]:new(name, url, save_on_close) /* это нужно на случай если class.name кто-то поменяет жи ес */
end

/**
    * Open
    * * Создает и открывает WebUI
    * @param parent? - VGUI панель, на которой будет открыт текущий WebUI (по умолч. = vgui.GetWorldPanel())
*/

function class:Open(parent)
    if IsValid(self.panel) then
        if self.isSave then
            return self.panel:Show()
        end

        self.panel:Remove()
    end

    self.panel = vgui.Create("DHTML", parent)
    self.panel:Dock(FILL)
    self.panel:OpenURL(self.url)
end

/**
    * GetPanel
    * * Возвращает DHTML панель
    * @param parent? - Закрывает WebUI. Если у текущего WebUI save_on_close == true, то тогда WebUI будет просто скрыт, без удаления панели через panel:Remove()
*/

function class:GetPanel()
    return self.panel
end

/**
    * PushTable
    * * Добавляет переменную в JS, которая будет являться таблицей
    * @param variable_name - название переменной в JS
    * @param tab - таблица, которяа будет добавлена в JS
*/

function class:PushTable(variable_name, tab)
    if not IsValid(self.panel) then
        return
    end

    /* я не придумал другого метода, как можно пушить таблицу в js */
    local code = "var " .. variable_name .. " = " .. util.TableToJSON(tab)

    self.panel:QueueJavascript(code)
end

/**
    * Close
    * * Закрывает/скрывает WebUI
    * @param parent? - Закрывает WebUI. Если у текущего WebUI save_on_close == true, то тогда WebUI будет просто скрыт, без удаления панели через panel:Remove()
*/

function class:Close()
    if not IsValid(self.panel) then
        return
    end

    self.panel[self.isSave and "Hide" or "Remove"](self.panel)
end

return class