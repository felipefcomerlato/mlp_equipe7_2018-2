require("love.filesystem")
require("love.image")

local thread = love.thread.getThread()
local path = nil

while path == nil do
	path = thread:receive("path")
end

local image = love.image.newImageData(path)

thread:send("image", image)
