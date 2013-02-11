levelRender= class:new()

function levelRender:update()
	if init then
		board = love.graphics.newCanvas((gamestate.map["k-length"]+gamestate.map["j-length"])*48-32,(gamestate.map["k-length"]+gamestate.map["j-length"])*32)
		scoreboard = love.graphics.newCanvas(200,love.graphics.getHeight())

		background = love.graphics.newImage("graphics/starrysky.png")
		hex = {}
		hex["G"] = love.graphics.newImage("graphics/grass.png")
		hex["R"] = love.graphics.newImage("graphics/rubidium.png")
		hex["C"] = love.graphics.newImage("graphics/scrap.png")
		hex["E"] = love.graphics.newImage("graphics/explosium.png")
		hex["S"] = love.graphics.newImage("graphics/spawn.png")
		hex["O"] = love.graphics.newImage("graphics/rock.png")

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
		render:players(board, gamestate.players)
		-- render:stats(scoreboard)
		love.graphics.draw(board,0,0)
		love.graphics.draw(scoreboard,love.graphics.getWidth()-scoreboard:getWidth(),0)
	end
end

function levelRender:keypressed(key,unicode)
	--
end
