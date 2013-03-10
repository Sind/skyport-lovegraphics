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
	for i,v in ipairs(players) do
		render:player(canvas, v, colorArray[i])
	end
end

function render:player( canvas, player, color)
	love.graphics.setCanvas( canvas )
	local realX = render:toRealX(player.realJ+1,player.realK+1)
	local realY = render:toRealY(player.realJ+1,player.realK+1)
	love.graphics.print(player.name,realX,realY)
	love.graphics.setColor(color)
	love.graphics.circle("fill", realX+20, realY+19,10)
	love.graphics.setColor(255,255,255)

	love.graphics.setCanvas()
end

function render:highlights(canvas,que)
	love.graphics.setCanvas(canvas)
	for i,v in ipairs(que) do
		v.color[4] = 128
		love.graphics.setColor(v.color)
		local J,K = animations:setJKp(v.coordinate)
		love.graphics.rectangle("fill",render:toRealX(J+1,K+1),render:toRealY(J+1,K+1),40,38)
		love.graphics.setColor(255,255,255)
	end
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
	if player == currentPlayer then
		love.graphics.setColor(255,0,0)
	end
	love.graphics.print(player.name,25,offset,0,1.5,1.5)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Score: " .. player.score,15,offset+25)
	love.graphics.print("HP:",15,offset+40)
	love.graphics.setColor(125,0,0)
	love.graphics.rectangle("fill",50,offset+40,player.health,13)
	love.graphics.setColor(255,255,255)
	love.graphics.print(player.health,60,offset + 40)
	love.graphics.print("Primary weapon: " .. player["primary-weapon"]["name"] .. " " .. player["primary-weapon"]["level"] .. "\nSecond weapon: " .. player["secondary-weapon"]["name"] .. " " .. player["secondary-weapon"]["level"], 15, offset + 60)
end

function render:laser(canvas,wd)
	-- print("rendering laser")
	-- tablePrint(wd)

	love.graphics.setCanvas(canvas)
	love.graphics.setColor(255,255,255,200)
	love.graphics.draw(laserArt[wd.size],wd.x,wd.y,wd.rotation,wd.length,1,laserArt[wd.size]:getWidth()/2,laserArt[wd.size]:getHeight()/2)
	love.graphics.setColor(255,255,255,255)
	love.graphics.setCanvas()
end

function render:mortar(canvas,wd)

	love.graphics.setCanvas(canvas)
	if wd.atype == "bombthrow" then
		love.graphics.setColor(0,0,0)
		love.graphics.circle("fill",wd.x+20,wd.y+19,wd.size)
		love.graphics.setColor(255,255,255)
	elseif wd.atype == "explosion" then
		love.graphics.setColor(255,255,255,wd.alpha)
		love.graphics.draw(explosionImage,wd.x+20,wd.y+19,0,1,1,explosionImage:getWidth()/2,explosionImage:getHeight()/2)
		love.graphics.setColor(255,255,255,255)
	elseif wd.atype == "smallexplosion" then
	        love.graphics.setColor(255,255,255,wd.alpha)
		love.graphics.draw(smallExplosionImage,wd.x+20,wd.y+19,0,1,1,
				   smallExplosionImage:getWidth()/2,smallExplosionImage:getHeight()/2)
		love.graphics.setColor(255,255,255,255)
	end
	love.graphics.setCanvas()
end

function render:droid(canvas,wd)

end

function render:toRealX( j, k )
	return 30 * (gamestate.map["k-length"]+k-j-1)
end

function render:toRealY( j, k )
	return 19 * (j + k - 2)
end
