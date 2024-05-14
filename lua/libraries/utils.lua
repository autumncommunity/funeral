str = tostring

/**
  * foreach
  * ? Перебирает все элементы последовательно-пронумерованной таблицы
  * @param tab - Таблица с элементами для перебора
  * @param callback - Функция, вызывающаяся при каждой итерации
*/

function foreach(tab, callback)
    for k, v in ipairs(tab) do
        callback(v, k)
    end
end

/**
  * dump
  * ? Принтит в консоль значения которые вы в нее запихнете
  * @param vararg - значения, которые будут принтиться
*/
function dump(...)
    for _, v in ipairs({...}) do
        _G[type(v) == "table" and "PrintTable" or "print"](v)
    end
end