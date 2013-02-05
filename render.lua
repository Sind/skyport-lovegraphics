render = class:new()

function render:background( canvas )
   love.graphics.setCanvas( canvas )
   print("height: " .. canvas:getHeight())
	for i = 0, canvas:getWidth(),  background:getWidth() do
	   for j = 0, canvas:getHeight(),background:getHeight() do
			love.graphics.draw(background,i,j)
		end
	end
	love.graphics.setCanvas()
end

function render:tiles( canvas )
	love.graphics.setCanvas( canvas )
	for j = 1, j <= tonumber(gamestate.map.j-length), 1 do
		for k = 1, k<= tonumber(gamestate.map.k-length), 1 do
			--
		end
	end
	love.graphics.setCanvas()
end