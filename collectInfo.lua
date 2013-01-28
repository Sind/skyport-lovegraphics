collectInfo = class:new()

ipCounter = 1
ipInfo = {"",""}

function collectInfo:update()
	if(init) then
		waitingForInfo = true
		init = false
	end
	if waitingForInfo == false then
		exit = true
	end

	if exit then
		ip = ipInfo[1]
		port = tonumber(ipInfo[2])
		init = true
		exit = false
		mode = 2
	end

end

function collectInfo:draw()
	local marker = {"",""}
	if ipCounter == 1 then
		marker[1] = "|"
	else
		marker[2] = "|"
	end
	love.graphics.print("IP: " .. ipInfo[1] .. marker[1], 300, 200)
	love.graphics.print("Port: " .. ipInfo[2] .. marker[2], 300, 230)
end

function collectInfo:keypressed(key, unicode)
	if unicode > 45 and unicode < 58 and unicode ~= 47 then
		ipInfo[ipCounter] = ipInfo[ipCounter] .. key
	end
	if key == "return" or key == "tab" or key == "down" then
		if ipCounter == 2 then
			waitingForInfo = false
		else
			ipCounter = 2
			if ipInfo[1] == "" then
			ipInfo[1] = "127.0.0.1"
			end
		end
	end
	if key == "up" then
		if ipCounter == 2 then
			ipCounter = 1
		end
	end
	if key == "backspace" then
		ipInfo[ipCounter] = string.sub(ipInfo[ipCounter], 1, -2)
	end
end