levelRender = class:new()

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

		actions = 0
		actionTable = {nil,nil,nil}

		endturn = false

		init = false
		ready = json.encode( { message = "ready"},{indent = false})
	end
	if gamestateset then
	   animations:setJK(gamestate.players)
	end
	if actions > 0 then
		if actionTable[actions].type == "move" then
			animations:move(dt,gamestate.players,actionTable[actions])
		end
	end

	levelRender:testButtons();

	if actions == 0 and endturn then
		conn:send(ready .. '\n')
		endturn = false
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
		gamestate.players = levelRender:sortplayers(gamestate.players)
		render:players(board, gamestate.players)
		render:stats(scoreboard, gamestate)
		love.graphics.draw(board,0,0,0,1,1,boardX,boardY)
		love.graphics.draw(scoreboard,love.graphics.getWidth()-scoreboard:getWidth(),0)
	end
end


function levelRender:testButtons()
	if love.keyboard.isDown("left") then
		if boardX >= 0 then
			boardX = boardX - 10
		end
	elseif love.keyboard.isDown("right") then
		if board:getWidth() > love.graphics.getWidth() - scoreboard:getWidth() + boardX then
			boardX = boardX + 10
		end
	end
	if love.keyboard.isDown("up") then
		if boardY >= 0 then
			boardY = boardY - 10
		end
	elseif love.keyboard.isDown("down") then
		if board:getHeight() > love.graphics.getHeight() + boardY then
			boardY = boardY + 10
		end
	end
end

function levelRender:sortplayers(players)
	local playerstable = {}
	local index = 1
	for i,playername in ipairs(playernames) do
		for j,player in ipairs(players) do
			if playername == player.name then
				playerstable[i] = player
				break
			end
		end
	end
	return playerstable
end