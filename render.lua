render = class:new()

function render:background( canvas )
	love.graphics.setCanvas( canvas )

	for i = 0, canvas:getWidth(), background:getWidth() do
	   for j = 0, canvas:getHeight(), background:getHeight() do
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
				local realX = render:toRealX(j,k)
				local realY = render:toRealY(j,k)
				local thisImage = hex[gamestate.map.data[j][k]]
				love.graphics.draw(thisImage, realX, realY)
			end
		end
	end
	love.graphics.setCanvas()
end

function render:players( canvas, players)
	local colorArray = {{255,0,0},{0,255,0},{0,0,255},{255,255,0},{255,0,255},{0,255,255}}
	for i,v in pairs(players) do
		render:player(canvas, v, colorArray[i])
	end
end

function render:player( canvas, player, color)
	love.graphics.setCanvas( canvas )
	local realX = render:toRealX(player.realJ+1,player.realK+1)
	local realY = render:toRealY(player.realJ+1,player.realK+1)
	love.graphics.print(player.name,realX,realY)
	love.graphics.setColor(color[1],color[2],color[3])
	love.graphics.circle("fill", realX+32, realY+32,10)
	love.graphics.setColor(255,255,255)

	love.graphics.setCanvas()
end

function render:stats( canvas, state)
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(40,40,40)
	love.graphics.rectangle("fill",0,0,canvas:getWidth(),canvas:getHeight())
	love.graphics.setColor(255,255,255)
	local offset = 100
	
	love.graphics.print("Turn number: " .. state.turn,20,20)

	for i,player in ipairs(state.players) do
		render:playerstats(canvas, player, (i-.5)*offset)
	end
	love.graphics.setCanvas()
end

function render:playerstats( canvas, player, offset )
	love.graphics.print(player.name,25,offset,0,1.5,1.5)
	love.graphics.print("Score: " .. player.score,15,offset+25)
	love.graphics.print("HP:",15,offset+40)
	love.graphics.setColor(125,0,0)
	love.graphics.rectangle("fill",50,offset+40,player.health,13)
	love.graphics.setColor(255,255,255)
	love.graphics.print(player.health,60,offset + 40)
	love.graphics.print("Primary weapon: " .. player["primary-weapon"]["name"] .. " " .. player["primary-weapon"]["level"] .. "\nSecond weapon: " .. player["secondary-weapon"]["name"] .. " " .. player["secondary-weapon"]["level"], 15, offset + 60)
end

function render:toRealX( k , j )
	return 48 * (gamestate.map["k-length"]-k+j-1)
end

function render:toRealY( k, j )
	return 32 * (j + k - 2)
end
