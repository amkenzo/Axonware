--[[
    |------------ [ Credits ] ------------|
    | Original by Mike                    |
    | Modified by Axon                    |
    |-------------------------------------|
    | Last Modified 7/14/2023             |
    |-------------------------------------|
]]--

local HttpService = game:GetService("HttpService")

local SHA2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Egor-Skriptunoff/pure_lua_SHA/master/sha2.lua"))()

local Utility = {}
Utility.__index = Utility

function Utility.new(Api, Id, Layer, Expire)
    local self = {}

    self.Api = Api or 's1.wayauth.com'
    self.Id = Id or 12345
    self.Layer = Layer or 1
    self.Expire = Expire or 0
    self.Validator = SHA2.sha256(os.date('%d%m%Y'))

    return setmetatable(self, Monetize)
end

function Utility:create()
    local Base = 'http://%s/v2/create/%s/%s/%s'
    local Url = Base:format(self.Api, self.Id, self.Validator, self.Layer)

    self.Task = HttpService:JSONDecode(game:HttpGet(Url))
    
    return self.Task
end

function Utility:verify()
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

function Utility:getLink()
    local Base = 'http://%s/v2/wait/%s'
    local Url = Base:format(self.Api, self.Task.id)

    return Url
end

return Monetize
