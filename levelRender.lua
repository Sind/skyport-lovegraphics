levelRender= class:new()

function levelRender:update()
	if init then
		board = love.graphics.newCanvas()
		init = false
	end

	if exit then
		init = true
		exit = false
		mode = 4
	end
end

function levelRender:draw()
	if not init then
		render:background(board)
		render:tiles(board)
		love.graphics.draw(board,0,0)
		love.graphics.draw("attempt",9,9)
	end
end

function levelRender:keypressed(key,unicode)
	--
end
