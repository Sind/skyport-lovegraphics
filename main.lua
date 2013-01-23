function love.load( )
	-- requires here

	love.filesystem.setIdentity("Skyport - samplegraphics")

	background = love.graphics.newImage("graphics/starrysky.png")

	imagelist = {"void","grass","rock", "explosium", "rubidium","scrap","spawn"}
	hexes = {}

	for i = 1, #imagelist do
		hexes[i] = love.graphics.newImage("graphics/" .. imagelist[i] .. ".png")
	end
end

function love.draw( )
	love.graphics.draw(background,0,0)
end