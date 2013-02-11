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
	-- love.graphics.draw(hex["G"],0,0)
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
	local split = split(player.position, ",")
	local jpos = tonumber(split[1])
	local kpos = tonumber(split[2])
	local realX = render:toRealX(jpos+1,kpos+1)
	local realY = render:toRealY(jpos+1,kpos+1)
	love.graphics.print(player.name,realX,realY)
	love.graphics.setColor(color[1],color[2],color[3])
	love.graphics.circle("fill", realX+32, realY+32,10)
	love.graphics.setColor(255,255,255)

	love.graphics.setCanvas()
end

function render:stats( canvas )
	love.graphics.setCanvas(canvas)
	-- body
	love.graphics.setCanvas()
end

function render:toRealX( k , j )
	return 48 * (gamestate.map["k-length"]-k+j-1)
end

function render:toRealY( k, j )
	return 32 * (j + k - 2)
end
