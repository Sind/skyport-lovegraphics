render = class:new()

function render:background( canvas )
	love.graphics.setCanvas( canvas )
	for i = 0, i < canvas.getWidth, i = i + background.getWidth do
		for j = 0, j < canvas.getHeight, j = j + background.getHeight do
			love.graphics.draw(background,i,j)
		end
	end
	love.graphics.setCanvas()
end

function render:tiles( canvas )
	love.graphics.setCanvas( canvas )
	for j = 1, j <= tonumber(gamestate.map.j-length), j = j+1 do
		for k = 1, k<= tonumber(gamestate.map.k-length), k = k+1 do
			--
		end
	end
	love.graphics.setCanvas()
end