render = class:new()

function render:background( canvas )
   love.graphics.setCanvas( canvas )
	for i = 0, canvas:getWidth(),  background:getWidth() do
	   for j = 0, canvas:getHeight(),background:getHeight() do
	   					love.graphics.draw(background,i,j)
		end
	end
	love.graphics.setCanvas()
end

function render:tiles( canvas )
	-- print(canvas:getHeight())
	love.graphics.setCanvas( canvas )
	for j = 1, gamestate.map["j-length"] do
		for k = 1, gamestate.map["k-length"] do
			if gamestate.map.data[j][k] ~= "V" then
				local realX = 48 * (gamestate.map["k-length"]-k+j-1)
				local realY = 32 * (j + k - 2)
				if not set then
				print("\nrealX: " .. realX .. "\nrealY: " .. realY)
				end
				local thisImage = hex[gamestate.map.data[j][k]]
				love.graphics.draw(thisImage, realX, realY)
			end
		end
	end
	-- love.graphics.draw(hex["G"],0,0)
	set = true
	love.graphics.setCanvas()
end