function connect(ip,port)
	conn = lube.tcpClient()
	local table = {
		connect = 1
	}
	conn.handshake = false
	--conn.handshake = json.encode(table,{indent = false}) .. "\n"
	conn:setPing(false)
	conn.callbacks.recv = rcvCallback()
	conn:connect(ip, port, true)
	conn:send(json.encode(table,{indent = false})
end

function rcvCallback(data)
    --data is the data received, do anything you want with it
end
