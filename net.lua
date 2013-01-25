net = class:new()

function net:connect()
	conn = lube.tcpClient()
	conn.handshake = "Sandwich"
	conn:setPing(true, 16, "areYouStillThere?\n")
	conn.callbacks.recv = rcvCallback()
	conn:connect(ipInfo[0], tonumber(ipInfo[1]), true)

end

function rcvCallback(data)
    --data is the data received, do anything you want with it
end


function net:update()
	-- thisIsStartingToWork
end

function net:draw()
love.graphics.print("IP: " .. ipInfo[1], 300, 200)
love.graphics.print("Port: " .. ipInfo[2], 300, 230)
end

function net:keypressed(key, unicode)
	if unicode > 45 and unicode < 58 and unicode ~= 47 then
		ipInfo[ipCounter] = ipInfo[ipCounter] .. key
	end
	if key == "return" or key == "tab" or key == "down" then
		if ipCounter == 2 then
			waitingForInfo = false
		else
			ipCounter = 2
		end
	end
end
