waitingForConnect = class:new()

function waitingForConnect:update(dt)
	if init then
		infocounter = 0;
		connect(ip,port)
		init = false
	end
	
	if gamestateset then
		exit = true
		
	end

	if exit then
		init = true
		exit = false
		mode = 3
	end
end

function waitingForConnect:draw()
	love.graphics.print("waiting for connection",100,100)
end

function waitingForConnect:keypressed(key,unicode)
	--
end