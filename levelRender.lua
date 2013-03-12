levelRender = class:new()

function levelRender:update(dt)
	if init then
		boardWidth = (gamestate.map["k-length"]+gamestate.map["j-length"])*30-20
		boardHeight = (gamestate.map["k-length"]+gamestate.map["j-length"])*20
		newwidth, newheight = pot(boardWidth, boardHeight)
		-- print(boardWidth .. " x " .. boardHeight)
		-- print(newwidth .. " x " .. newheight)
		board = love.graphics.newCanvas(pot(boardWidth, boardHeight))
	
		scoreboard = love.graphics.newCanvas(200,love.graphics.getHeight())

		boardX = 0
		boardY = 0

		background = love.graphics.newImage("graphics/starrysky.png")
		explosionImage = love.graphics.newImage("graphics/explosion.png")
		smallExplosionImage = love.graphics.newImage("graphics/small-explosion.png")

		laserArt = {}
		laserArt[1] = love.graphics.newImage("graphics/laserS1.png")
		laserArt[2] = love.graphics.newImage("graphics/laserS2.png")
		laserArt[3] = love.graphics.newImage("graphics/laserS3.png")

		hex = {}
		hex["G"] = love.graphics.newImage("graphics/grass.png")
		hex["R"] = love.graphics.newImage("graphics/rubidium.png")
		hex["C"] = love.graphics.newImage("graphics/scrap.png")
		hex["E"] = love.graphics.newImage("graphics/explosium.png")
		hex["S"] = love.graphics.newImage("graphics/spawn.png")
		hex["O"] = love.graphics.newImage("graphics/rock.png")

		currentPlayer = nil

		actions = 0
		actionTable = {nil,nil,nil}

		endturn = false

		init = false

		highlightQue = {}

		ready = json.encode( { message = "ready"},{indent = false})
		-- ready = json.encode({message = "ready"})
	end

	if pause then return end

	if gamestateset then
	   animations:setJK(gamestate.players)
	end
	if actions > 0 then
		currentAction = actionTable[actions]
		for i,cplayer in ipairs(gamestate.players) do
			if cplayer.name == currentAction.from then
				currentPlayer = cplayer
			end
		end

		local atype = currentAction.type
		if  atype == "move" then
			animations:move(dt,currentPlayer,currentAction)
		-- elseif atype == "mortar" then
		-- 	weaponData = animations:mortar(dt,currentPlayer,currentAction)
		elseif atype == "laser" then
			weaponData = animations:laser(dt,currentPlayer,currentAction)
		elseif atype == "mortar" then
			weaponData = animations:mortar(dt,currentPlayer,currentAction)
		elseif atype == "droid" then
			weaponData = animations:droid(dt,currentPlayer,currentAction)
		else
			actions = actions - 1
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
		render:highlights(board,highlightQue)

		if pause then
			love.graphics.print("Paused",boardWidth/2-50,boardHeight/2-50,0,5,5)
			return
		end

		if mortar then
			render:mortar(board,weaponData)
		end
		if laser then
			render:laser(board,weaponData)
		end
		if droid then
			render:droid(board,weaponData)
		end
		love.graphics.setColorMode("replace")
		love.graphics.draw(board,0,0,0,1,1,boardX,boardY)
		love.graphics.draw(scoreboard,love.graphics.getWidth()-scoreboard:getWidth(),0)
		love.graphics.setColorMode("modulate")
	end
end


function levelRender:testButtons()
	if love.keyboard.isDown("left") then
		if boardX >= 0 then
			boardX = boardX - 8
		end
	elseif love.keyboard.isDown("right") then
		if boardWidth > love.graphics.getWidth() - scoreboard:getWidth() + boardX then
			boardX = boardX + 8
		end
	end
	if love.keyboard.isDown("up") then
		if boardY >= 0 then
			boardY = boardY - 8
		end
	elseif love.keyboard.isDown("down") then
		if boardHeight > love.graphics.getHeight() + boardY then
			boardY = boardY + 8
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

function pot( width, height )
	local newWidth = 1
	local newHeight = 1
	local testbool = true
	while testbool do
		newWidth = newWidth * 2
		if newWidth >= width then testbool = false end
	end
	testbool = true
	while testbool do
		newHeight = newHeight * 2
		if newHeight >= height then testbool = false end
	end
	return newWidth, newHeight
end

function levelRender.keyreleased(key,unicode)
	if key == "space" then
		if pause then
			pause = false
			conn:send('{"message":"resume"}')
		else
			pause = true
			conn:send('{"message":"pause"}')
		end
	end

	if key == "+" then
		conn:send('{"message":"faster"}')
	end
	if key == "-" then
		conn:send('{"message":"slower"}')
	end
end