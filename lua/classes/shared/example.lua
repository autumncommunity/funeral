local class = {}
class.name = "Example"
class.static = {
    example_var = "example value"
}

function class:new()
    print("Created new object of class \"Example\"")
end

/* static method */

function class.static.BuyMeABeer()
    print("Example print")
end

return class