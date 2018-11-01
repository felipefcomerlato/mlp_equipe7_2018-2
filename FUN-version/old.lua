function love.load()
	image = nil
	thread = love.thread.newThread("load", "load.lua")
	thread:start()
	thread:send("path", "images/mysteryb.png")
end

function love.draw()
	if image then
		love.graphics.draw(image, 0, 0)
	end
end

function love.update(dt)
	local receive = thread:receive("image")
	local error = thread:receive("error")

	if receive then
		image = love.graphics.newImage(receive)
	elseif error then
		print(error)
	end
end
