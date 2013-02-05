function connect(ip,port)
	conn = lube.tcpClient()
	local table = {
		connect = 1
	}
	conn.handshake = false
	--conn.handshake = json.encode(table,{indent = false}) .. "\n"
	conn:setPing(false)
	conn:connect(ip, port, true)
	conn:send(json.encode(table,{indent = false}).."\n")
	conn.callbacks.recv = rcvCallback
	print(conn.callbacks.recv)
	print(rcvCallback)
	if not conn.connected then crogbteobvoer() end
end


function rcvCallback(data)
        print(data)
	if data ~= nil then
	   -- gamestateset = true
	   local datacontainer, pos, err = json.decode(data,1,nil)
		local thingy = datacontainer.message
		if thingy == "gamestate" then
		gamestateset = true
		gamestate = datacontain
		elseif thingy == "action" then
			--
		elseif thingy == "connect" then
			--
		end
	end
end
