

function love.load( )
	-- love.graphics.setMode( 0, 0 , false, false)
	-- love.graphics.setMode(love.graphics.getWidth(),love.graphics.getHeight(),true,false)
	debug.debug()
	require "class"
	require "net"
	require "LUBE"
	require "draw"
	-- requires here
	ipCounter= 1
	ipInfo = {} -- host, port
	waitingForInfo = true
	while waitingforHost do
	end
	net:waitForConnection()

	love.filesystem.setIdentity("Skyport - samplegraphics")

	background = love.graphics.newImage("graphics/starrysky.png")

	imagelist = {"void","grass","rock", "explosium", "rubidium","scrap","spawn"}
	hexes = {}

	for i = 1, #imagelist do
		hexes[i] = love.graphics.newImage("graphics/" .. imagelist[i] .. ".png")
	end
end

function love.draw( )
	for i = 0, love.graphics.getWidth(), background:getWidth() do
		for j = 0, love.graphics.getHeight(), background:getHeight() do
			love.graphics.draw(background, i, j)
		end
	end
	draw:drawBoard()
	draw:drawEntities()
end


function love.keypressed(key)   -- we do not need the unicode, so we can leave it out
   if waitingForInfo then
   	if key == "enter" then
   		if ipCounter == 2 then
   			waitingForInfo = false
   		else
   			ipCounter = ipCounter + 1
   		end
   	end
   	ipInfo[ipCounter] = ipInfo[ipCounter] .. key
   end


   if key == "escape" then
      	love.event.push("quit")   -- actually causes the app to quit
  end
end