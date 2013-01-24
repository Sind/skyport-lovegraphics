net = class:new()

function net:waitForConnection()
	conn = lube.tcpClient()
	conn.handshake = "Sandwich"
	conn:setPing(true, 2, "areYouStillThere?\n")
	
	conn.callbacks.recv = rcvCallback

	if assert(conn:connect(ipInfo[1], ipInfo[2], true)) then
		return true
	else
		return false
	end
end

		-- conn = lube.tcpServer()
		-- conn.handshake = "helloCardboard"
		-- conn:setPing(true, 16, "areYouStillThere?\n")
		-- conn:listen(3410)
		-- conn.callbacks.recv = serverRecv
		-- conn.callbacks.connect = function() numConnected = numConnected + 1 end
		-- conn.callbacks.disconnect = function() numConnected = numConnected - 1 end
function rcvCallback(data)
    --data is the data received, do anything you want with it
end

