function connect(ip,port)
	conn = lube.tcpClient()
	local table = {
		connect = 1
	}
	conn.handshake = json.encode(table,{indent = false}) .. "\n"
	conn:setPing(true, 16, "areYouStillThere?\n")
	conn.callbacks.recv = rcvCallback()
	conn:connect(ip, port, true)

end

function rcvCallback(data)
    --data is the data received, do anything you want with it
end
