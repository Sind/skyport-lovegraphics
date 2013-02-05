function love.load(args)
	-- love.graphics.setMode( 0, 0 , false, false)
	-- love.graphics.setMode(love.graphics.getWidth(),love.graphics.getHeight(),true,false)
	
	json = require "dkjson"
	class = require "class"
	require "LUBE"
	require "collectInfo"
	require "waitingForConnect"
	require "net"

	gamemodes = {collectInfo,waitingForConnect,levelRender}


	argsN = 0
	for key,value in pairs(args) do argsN = argsN + 1 end	
	if argsN == 5 then
		ip = args[2]
		port = tonumber(args[3])
		mode = 2
	else
		mode = 1
	end
	gamestateset = false
	love.filesystem.setIdentity("Skyport - samplegraphics")
	quit = false
	init = true
end

function love.draw()
	gamemodes[mode]:draw()
end

function love.update(dt)
        gamemodes[mode]:update()
        if conn then
	   conn:update(dt)
	end
	
end

function love.keypressed(key,unicode)
	if key == "escape" then
      	love.event.push("quit")   -- actually causes the app to quit
	end

	gamemodes[mode]:keypressed(key,unicode)

end
