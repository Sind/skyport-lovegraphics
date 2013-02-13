levelRender= class:new()

function levelRender:update(dt)
	if init then
		board = love.graphics.newCanvas((gamestate.map["k-length"]+gamestate.map["j-length"])*48-32,(gamestate.map["k-length"]+gamestate.map["j-length"])*32)
		scoreboard = love.graphics.newCanvas(200,love.graphics.getHeight())

		boardX = 0
		boardY = 0

		background = love.graphics.newImage("graphics/starrysky.png")
		hex = {}
		hex["G"] = love.graphics.newImage("graphics/grass.png")
		hex["R"] = love.graphics.newImage("graphics/rubidium.png")
		hex["C"] = love.graphics.newImage("graphics/scrap.png")
		hex["E"] = love.graphics.newImage("graphics/explosium.png")
		hex["S"] = love.graphics.newImage("graphics/spawn.png")
		hex["O"] = love.graphics.newImage("graphics/rock.png")

		action = false

		init = false
	end

	animations:setJK(gamestate.players)

	if action then
		if currentAction.type == "move" then
			-- gamestate.players = 
			animations:move(dt,gamestate.players,currentAction)
		end
	end
	print(gamestate.players[1].position)
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
		render:players(board, gamestate.players)
		render:stats(scoreboard)
		love.graphics.draw(board,0,0,0,1,1,boardX,boardY)
		love.graphics.draw(scoreboard,love.graphics.getWidth()-scoreboard:getWidth(),0)
	end
end

function levelRender:keypressed(key,unicode)
	if key == "left" then
		if boardX ~= 0 then
			boardX = boardX - 1
		end
	elseif key == "right" then
		if board:getWidth()> love.graphics.getWidth() - scoreboard:getWidth() + boardX then
			boardX = boardX + 1
		end
	elseif key == "up" then
		if boardY ~= 0 then
			boardY = boardY - 1
		end
	elseif key == "down" then
		if board:getHeight() > love.graphics.getHeight() + boardY then
			boardY = boardY + 1
		end
	end
end

function levelRender:keyreleased(key,unicode)

end
