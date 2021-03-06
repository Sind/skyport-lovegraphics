animations = {}

function animations.setJK( players )
	for i,player in ipairs(players) do
		player.realJ, player.realK = animations.setJKp(player.position)
	end
end

function animations.setJKp( coordinates )
	local positions = split(coordinates,",")
	local J = positions[1]
	local K = positions[2]
	return J, K
end

function animations.move( dt, player, actionData )
	actiontime = actiontime + dt * 3

	local direction = actionData.direction
	
	if direction == "up" then
		player.realK = player.realK - dt * 3
		player.realJ = player.realJ - dt * 3
	elseif direction == "left-up" then
		player.realK = player.realK - dt * 3
	elseif direction == "left-down" then
		player.realJ = player.realJ + dt * 3
	elseif direction == "down" then
		player.realK = player.realK + dt * 3
		player.realJ = player.realJ + dt * 3
	elseif direction == "right-down" then
		player.realK = player.realK + dt * 3
	elseif direction == "right-up" then
		player.realJ = player.realJ - dt * 3
	end

	if actiontime >= 1 then
		player.realJ = math.floor(player.realJ+.5)
		player.realK = math.floor(player.realK+.5)
		player.position = player.realJ .. "," .. player.realK
		actions = actions-1
		actiontime = 0
	end
end

function animations.laser( dt, player, actionData )
	-- if not laser then
	-- table.insert(highlightQue,{message=highlight,coordinate=actionData.start,color={255,128,128}})
	-- table.insert(highlightQue,{message=highlight,coordinate=actionData.stop,color={128,128,255}})
	-- end
	laser = true

	-- print("got to laser")
	actiontime = actiontime + dt
	local direction = actionData.direction

	local laserRotation = 0

	if direction == "right-up" then
		laserRotation = math.rad(-30) -- math.pi / 6
	elseif direction == "up" then
		laserRotation = math.rad(-90) -- math.pi/2
	elseif direction == "left-up" then
		laserRotation = math.rad(-150) -- 5 * math.pi / 6
	elseif direction == "left-down" then
		laserRotation = math.rad(-210) -- 7 * math.pi / 6
	elseif direction == "down" then
		laserRotation = math.rad(-270) -- 3 * math.pi / 2
	elseif direction == "right-down" then
		laserRotation = math.rad(30) -- 11 * math.pi / 6
	end
	
	local pJ, pK = animations.setJKp(actionData.start)
	local px = render.toRealX(pJ+1,pK+1)
	local py = render.toRealY(pJ+1,pK+1)

	local lTime = 0
	if actiontime > .25 then
		lTime = .5
	else
		lTime = actiontime*2
	end

	local lx, ly = animations.linInterpol(lTime,actionData.start, actionData.stop)
	local laserLength = math.sqrt((2*(lx-px))^2 + (2*(ly-py))^2)
	lx = lx+20
	ly = ly+19


	if actiontime > .4 and actiontime < .6 then
		laserSize = 3
	elseif actiontime > .3 and actiontime < .7 then
		laserSize = 2
	elseif actiontime < 1 then
		laserSize = 1
	else
		actiontime = 0
		actions = actions - 1
		laser = false
		return nil
	end
	return {x = lx, y = ly, length = laserLength, size = laserSize, rotation = laserRotation}
end
function animations.determineTileType(absoluteJ, absoluteK)
   local tileType = gamestate.map.data[absoluteJ+1][absoluteK+1] or "V"
   
  return tileType
end

function animations.mortar( dt, player, actionData )
	-- if not mortar then
	-- 	table.insert(highlightQue,{message = highlight,coordinate=player.position,color={255,128,128}})
	-- 	local pJ,pK = animations.setJKp(player.position)
	-- 	local vJ,vK = animations.setJKp(actionData.coordinates)
	-- 	local pString = pJ+vJ .. "," .. pK+vK
	-- 	table.insert(highlightQue,{message = highlight,coordinate=pString,color={128,128,255}})
	-- end
	mortar = true
	actiontime = actiontime + dt * 2
	if actiontime <= 1 then
		local bombsize = math.sin(actiontime*math.pi) * 4

		local bx,by = animations.newpos(actiontime, player.position, actionData.coordinates)

		return {atype = "bombthrow", x = bx, y = by, size = bombsize}
	elseif actiontime < 1.5 then

		local pJ,pK = animations.setJKp(player.position)
		local vJ,vK = animations.setJKp(actionData.coordinates)

		local tileType = "V"
		pcall(function() tileType = animations.determineTileType(pJ + vJ, pK + vK) end)
		
		local pString = pJ+vJ .. "," .. pK+vK
		local bx,by = animations.linInterpol(1,player.position,pString)
		local a = 200 - math.abs(actiontime -1.25) * 4 * 100

		if tileType == "V" or tileType == "O" then
		   return {atype = "smallexplosion", x = bx, y = by, alpha = a}
		else
		   return {atype = "explosion", x = bx, y = by, alpha = a}		   
		end
		
	else
		actiontime = 0
		actions = actions - 1
		mortar = false
		return nil
	end
end

function animations.droid( dt, player, actionData )
	if not droid then
		actionData.positions = {}

		actionData.positions[1] = player.position
		local pJ, pK = animations.setJKp(player.position)

		for i = 1, #actionData.sequence,1 do
			local nJ, nK = animations.setJKp(actionData.positions[i])

			local direction = actionData.sequence[i]

			if direction == "up" then
				nK = nK - 1
				nJ = nJ - 1
			elseif direction == "left-up" then
				nK = nK - 1
			elseif direction == "left-down" then
				nJ = nJ + 1
			elseif direction == "down" then
				nK = nK + 1
				nJ = nJ + 1
			elseif direction == "right-down" then
				nK = nK + 1
			elseif direction == "right-up" then
				nJ = nJ - 1
			end

			actionData.positions[i+1] = (nJ .. "," .. nK)
		end

		droidCounter = 1
	end
	droid = true


	actiontime = actiontime + dt * 2

	if actiontime > .5 then
		actiontime = 0
		droidCounter = droidCounter+1
	end

	if droidCounter == #actionData.positions then
		local a = 200 - math.abs(actiontime -.25) * 8 * 100
		-- print(actionData.positions[droidCounter])
		local bJ, bK = animations.setJKp(actionData.positions[droidCounter])
		-- print(bJ .. "," .. bK)
		local bx = render.toRealX(bJ+1,bK+1)
		local by = render.toRealY(bJ+1,bK+1)
		return {atype = "explosion",x = bx, y = by, alpha = a}
	elseif droidCounter == #actionData.positions+1 then
		droid = false
		actiontime = 0
		actions = actions - 1
		return nil
	end

	local bx,by = animations.linInterpol(actiontime*2,actionData.positions[droidCounter],actionData.positions[droidCounter+1])
	return {atype = "droidmove", x = bx, y = by}
end

function animations.mine(dt,player,actionData)
	mine = true
	actiontime = actiontime + dt

	if actiontime > .5 then
		mine = false
		actiontime = 0
		actions = actions - 1
		return nil
	end
	local pJ, pK = animations.setJKp(player.position)
	local bx = render.toRealX(pJ,pK)
	local by = render.toRealY(pJ,pK) - actiontime * 32

	local tileType = animations.determineTileType(pJ,pK)
	local a = 100 + math.sin(dt*math.pi*2) * 100

	return {atype = tileType, x = bx, y = by, alpha = a}
end


function animations.linInterpol(time,start,stop)
	local pJ, pK = animations.setJKp(start)
	local vJ, vK = animations.setJKp(stop)

	local dJ = vJ - pJ
	local dK = vK - pK

	local bJ = pJ + dJ * time
	local bK = pK + dK * time


	local bx = render.toRealX(bJ+1,bK+1)
	local by = render.toRealY(bJ+1,bK+1)
	return bx, by
end

function animations.newpos(time,start,vector)
	local pJ, pK = animations.setJKp(start)
	local dJ, dK = animations.setJKp(vector)

	local bJ = pJ + dJ * ((-math.cos(time*math.pi))+1)/2
	local bK = pK + dK * ((-math.cos(time*math.pi))+1)/2

	local bx = render.toRealX(bJ+1,bK+1)
	local by = render.toRealY(bJ+1,bK+1)

	return bx, by
end


--[[
function animations:JKaddx(direction)
	if direction == "up"
		return 0
	elseif direction == "right-up" then

end

function animations:JKaddy(direction)
	if direction == "up" then
		return -38
	elseif direction == "right-up" then
		return -38
		elseif direction == "left-up" then
end

]]