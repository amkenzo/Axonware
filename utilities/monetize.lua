--[[
    |------------ [ Credits ] ------------|
    | Original by Mike                    |
    | Modified by Axon                    |
    |-------------------------------------|
]]--

local HttpService = game:GetService("HttpService")

local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/main/bundle.lua"))().Init(game.CoreGui)
local SHA2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Egor-Skriptunoff/pure_lua_SHA/master/sha2.lua"))()

local Task = {}
Task.__index = Task

function Task.new(Api, Id, Layer, Expire)
    local self = {}

    self.Api = Api or 's1.wayauth.com'
    self.Id = Id or 12345
    self.Layer = Layer or 1
    self.Expire = Expire or 0
    self.Validator = SHA2.sha256(os.date('%d%m%Y'.. tostring(math.random(1, 999)))

    return setmetatable(self, Task)
end

function Task:create()
    local Base = 'http://%s/v2/create/%s/%s/%s'
    local Url = Base:format(self.Api, self.Id, self.Validator, self.Layer)

    self.Task = HttpService:JSONDecode(game:HttpGet(Url))
    
    return self.Task
end

function Task:verify()
    local Base = 'http://%s/v2/verify/%s/%s/%s'
    local Url = Base:format(self.Api, self.Task.id, self.Secret, self.Expire)
    local Response = HttpService:JSONDecode(game:HttpGet(Url))

    self.Data = Response

    if Response.success then
        if Response.validator:upper() == self.Validator:upper() then
            print('success')
            return true
        end
    end

    return false
end

function Task:copyLink()
    local Base = 'http://%s/v2/wait/%s'
    local Url = Base:format(self.Api, self.Task.id)

    return setclipboard(Url)
end

local nTask = Task.new(nil, 539927, 1, 300)
local Verified = false

nTask:create()

Iris:Connect(function()
    if not Verified then
        Iris.Window({'Axonware - Support The Creator', [Iris.Args.Window.NoClose] = true, [Iris.Args.Window.NoResize] = true, [Iris.Args.Window.NoScrollbar] = true, [Iris.Args.Window.NoCollapse] = true}, {size = Iris.State(Vector2.new(375, 60))}) do
            Iris.SameLine() do
                if Iris.Button({"Verify"}).clicked then
                    task.spawn(function()
                        Verified = nTask:verify()
                    end)
                end
                if Iris.Button({"Copy Link"}).clicked then
                    nTask:copyLink()
                end
                Iris.End()
            end
            Iris.End()
        end
    end
end)

repeat task.wait() until Verified

warn('Thanks For The Support, Have Fun!')
