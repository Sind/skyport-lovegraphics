function connect(ip,port)
	conn = lube.tcpClient()
	local table = {
		message = "connect",
		revision = 1,
		password = "supersecretpassword",
		laserstyle = "start-stop"
	}
	conn.handshake = false
	conn:setPing(false)
	local connected = conn:connect(ip, port, true)
	conn:send(json.encode(table,{indent = false}).."\n")
	conn.callbacks.recv = rcvCallback
	assert(connected, "Could not connect to server\nMake sure the server is started up before you start the graphics engine")
end


function rcvCallback(data)
	-- print(data)
	local lines = split(data, "\n")
	for k,v in ipairs(lines) do
		processLine(v)
	end
end

function processLine(data)
	print(data)
	if data ~= nil then
		local datacontainer, pos, err = json.decode(data,1,nil)
		if err then
			-- print("fail to decode json package: " .. err)
			return
		end
		local thingy = datacontainer.message
		if thingy == "gamestate" then
			if datacontainer["turn"] ~= 0 then
				gamestateset = true
				gamestate = datacontainer
			else
				playernames = {}
				for i,player in ipairs(datacontainer.players) do
					playernames[i] = player.name
				end
			end
		elseif thingy == "action" then
			actions = actions + 1
			actionTable[3] = actionTable[2]
			actionTable[2] = actionTable[1]
			actionTable[1] = datacontainer
			actiontime = 0
		elseif thingy == "connect" then
			--
		elseif thingy == "endactions" then
			--print("gamestate set: " .. tostring(gamestateset))
			if not gamestateset then
				--print("printing ready!")
				conn:send("{\"message\":\"ready\"}\n")
			end
			endturn = true
		elseif thingy == "highlight" then
			table.insert(highlightQue,datacontainer)
		elseif thingy == "subtitle" then
			textDisplay = true
			textTimer = 3
			displayText = datacontainer.text
		elseif thingy == "endturn" then
			highlightQue = {}
		else
			--print("couldn't understand message: " .. thingy)
		end
	end
end
