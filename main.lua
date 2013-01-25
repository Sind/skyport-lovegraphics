

function love.load( )
	-- love.graphics.setMode( 0, 0 , false, false)
	-- love.graphics.setMode(love.graphics.getWidth(),love.graphics.getHeight(),true,false)
	-- debug.debug()
	json = require "dkjson"
	class = require "class"
	require "net"
	require "LUBE"
	require "draw"
	-- requires here
	ipCounter = 1
	ipInfo = {"",""}

	love.filesystem.setIdentity("Skyport - samplegraphics")

	background = love.graphics.newImage("graphics/starrysky.png")

	imagelist = {"void","grass","rock", "explosium", "rubidium","scrap","spawn"}
	hexes = {}

	for i = 1, #imagelist do
		hexes[i] = love.graphics.newImage("graphics/" .. imagelist[i] .. ".png")
	end
	waitingForInfo = true
	waitingForConnect = true
	
end

function love.draw( )
	if waitingForConnect then
		net:draw()
	else
		for i = 0, love.graphics.getWidth(), background:getWidth() do
			for j = 0, love.graphics.getHeight(), background:getHeight() do
				love.graphics.draw(background, i, j)
			end
		end
		draw:drawBoard()
		draw:drawEntities()
 	end
end

function love.update()
	if waitingForConnect then
		net:update()
	end
end

function love.keypressed(key, unicode)   -- we do not need the unicode, so we can leave it out
	if key == "escape" then
      	love.event.push("quit")   -- actually causes the app to quit
	end

	if waitingForInfo then
		net:keypressed(key, unicode)
	end
end