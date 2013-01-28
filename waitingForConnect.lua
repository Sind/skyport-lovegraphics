waitingForConnect = class:new()

function waitingForConnect:update()
	if init then
	connect(ip,port)
	end
	--
end

function waitingForConnect:draw()
	love.graphics.print("waiting for connection",100,100)
end

function waitingForConnect:keypressed(key,unicode)
	--
end