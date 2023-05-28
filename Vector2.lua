--[[ 3gData May 2023]]

local Vector2 = {}
Vector2.__index = Vector2

--[[

__index(table, index)	Fires when table[index] is indexed, if table[index] is nil. Can also be set to a table, in which case that table will be indexed.
__newindex(table, index, value)	Fires when table[index] tries to be set (table[index] = value), if table[index] is nil. Can also be set to a table, in which case that table will be indexed.
__call(table, ...)	Fires when the table is called like a function, ... is the arguments that were passed.
__concat(table, value)	Fires when the .. concatenation operator is used on the table.
__mul(table, value)	The * mulitplication operator.
__mod(table, value)	The % modulus operator.
__metatable	If present, locks the metatable so getmetatable will return this instead of the metatable and setmetatable will error. Non-function value.

]]

function Unit(a,b)
    local DeltaY = b.y-a.y
    local DeltaX = b.x - a.x
    return math.deg(math.atan(DeltaY/DeltaX))
end

function Vector2.new(X, Z)
    local self = setmetatable({}, Vector2)
    self.x = X
    self.y = Z
    self.magnitude = math.abs(X + Z)
    self.unit = -Unit({y = 0, x = 0}, self) --We set our unit to a direction pointing towards 0,0. We dont make a Vector2 for parameter #1 due to recursiveness.
    return self
end

function Vector2:Normals()
    self.magnitude = math.abs(self.x+self.y)
end

function Vector2:lerp(Goal, Alpha)
    return (self + (Goal-self) * Alpha)
end

function Vector2:unpack()
    return self.x,self.y
end


function Vector2.__sub(a,b)
    assert(a, "Invalid Parameter #1 for vector sub")
    assert(b, "Invalid Parameter #2 for vector sub")
    local X1,Z1 = a.x,a.y
    local X2,Z2 = b.x, b.y
    local vector = Vector2.new(X1-X2, Z1-Z2)
    vector.unit = Unit(a, b)
    return vector
end

function Vector2.__add(a,b)
    local X1,Z1 = a.x,a.y
    local X2,Z2 = b.x, b.y
    local vector = Vector2.new(X1-X2, Z1-Z2)
    vector.unit = Unit(a,a)
    return vector
end

function Vector2.__unm(a)
    a.x = -a.x
    a.y = -a.y
    a.unit = -a.unit
    return a
end

function Vector2.__div(a,b)
    assert(a, "Invalid Parameter #1 for vector div")
    assert(b, "Invalid Parameter #2 for vector div")
    if type(a) == "number" then
        b.x = b.x / a
        b.y = b.y / a
        b:Normals()
        return b
    end

    if type(b) == "number" then
        a.x = a.x/b
        a.y = a.y/b
        a:Normals()
        return a
    elseif type(b) == "table" and b.magnitude then
        return Vector2.new(a.x/b.x, a.y/b.y)
    end
end

function Vector2.__eq(a,b)
    return (a.x == b.x and a.y == b.y)
end

function Vector2.__lt (a,b)
    return (a.magnitude < b.magnitude)
end

function Vector2.__le(a,b)
    return (a.magnitude <= b.magnitude)
end

function Vector2.__pow(a,b)
    a.y = a.y^b
    a.x = a.x^b
    a:Normals()
end

function Vector2.__mul(a,b)
    assert(a, "Invalid Parameter #1 for vector multiplication")
    assert(b, "Invalid Parameter #2 for vector multiplication")
    if type(a) == "number" then
        b.x = b.x * a
        b.y = b.y * a
        return b
    end
    if type(b) == "number" then
        a.x = a.x * b
        a.y = a.y * b
        return a
    elseif type(b) == "table" and b.magnitude then
        return Vector2.new(a.x*b.x, a.y*b.y)
    end
    local str = "Attempt to perform vector arithmetic with invalid values. #1: %s #2: %s"
    error(string.format(str, a, b))
end

function Vector2.__tostring(a)
    return string.format("%s, %s", a.x,a.y)
end

return Vector2
