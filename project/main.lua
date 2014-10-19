worldMap =
{
  {4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,7,7,7,7,7,7,7,7},
  {4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,7},
  {4,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7},
  {4,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7},
  {4,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,7},
  {4,0,4,0,0,0,0,5,5,5,5,5,5,5,5,5,7,7,0,7,7,7,7,7},
  {4,0,5,0,0,0,0,5,0,5,0,5,0,5,0,5,7,0,0,0,7,7,7,1},
  {4,0,6,0,0,0,0,5,0,0,0,0,0,0,0,5,7,0,0,0,0,0,0,8},
  {4,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,1},
  {4,0,8,0,0,0,0,5,0,0,0,0,0,0,0,5,7,0,0,0,0,0,0,8},
  {4,0,0,0,0,0,0,5,0,0,0,0,0,0,0,5,7,0,0,0,7,7,7,1},
  {4,0,0,0,0,0,0,5,5,5,5,0,5,5,5,5,7,7,7,7,7,7,7,1},
  {6,6,6,6,6,6,6,6,6,6,6,0,6,6,6,6,6,6,6,6,6,6,6,6},
  {8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4},
  {6,6,6,6,6,6,0,6,6,6,6,0,6,6,6,6,6,6,6,6,6,6,6,6},
  {4,4,4,4,4,4,0,4,4,4,6,0,6,2,2,2,2,2,2,2,3,3,3,3},
  {4,0,0,0,0,0,0,0,0,4,6,0,6,2,0,0,0,0,0,2,0,0,0,2},
  {4,0,0,0,0,0,0,0,0,0,0,0,6,2,0,0,5,0,0,2,0,0,0,2},
  {4,0,0,0,0,0,0,0,0,4,6,0,6,2,0,0,0,0,0,2,2,0,2,2},
  {4,0,6,0,6,0,0,0,0,4,6,0,0,0,0,0,5,0,0,0,0,0,0,2},
  {4,0,0,5,0,0,0,0,0,4,6,0,6,2,0,0,0,0,0,2,2,0,2,2},
  {4,0,6,0,6,0,0,0,0,4,6,0,6,2,0,0,5,0,0,2,0,0,0,2},
  {4,0,0,0,0,0,0,0,0,4,6,0,6,2,0,0,0,0,0,2,0,0,0,2},
  {4,4,4,4,4,4,4,4,4,4,1,1,1,2,2,2,2,2,2,3,3,3,3,3}
}

mapSizeRatio = 4

windowW = 0
windowH = 0
cameraX = 0
planeSize = 90 / 90
plane = {}
plane.x = 0
plane.y = planeSize

player = {}
player.x = 1.5
player.y = 1.5
player.angle = 0
player.direction = {}
player.direction.x = 1
player.direction.y = 0
player.speed = 6
player.turnSpeed = 200

shader = {}

function isWall(x, y)
  return worldMap[math.floor(y) + 1][math.floor(x) + 1] > 0
end

function love.load()
  love.graphics.setPointSize(mapSizeRatio * 0.9)
  love.graphics.setPointStyle("rough")
  love.graphics.setLineWidth(1)

  windowW = love.graphics.getWidth()
  windowH = love.graphics.getHeight()

  shader = love.graphics.newShader("shader.fs")
  -- shader:send("world", worldMap)
  -- shader:send("player_pos", {player.x, player.y})
  -- shader:send("player_ang", math.rad(player.angle))
  -- shader:send("plane_size", planeSize)

  love.window.setMode(800, 600, {resizable=true, vsync=false} )
end

function love.update(dt)

	if love.keyboard.isDown("up") then
    newPosX = player.x + player.direction.x * player.speed * dt
    newPosY = player.y + player.direction.y * player.speed * dt
    if not isWall(newPosX, player.y) then
		  player.x = newPosX
    end
    if not isWall(player.x, newPosY) then
      player.y = newPosY
    end

	end
	if love.keyboard.isDown("down") then
    newPosX = player.x - player.direction.x * player.speed * dt
    newPosY = player.y - player.direction.y * player.speed * dt
    if not isWall(newPosX, player.y) then
      player.x = newPosX
    end
    if not isWall(player.x, newPosY) then
      player.y = newPosY
    end
	end
	if love.keyboard.isDown("left") then
		newDir = player.angle - player.turnSpeed * dt
		player.angle = (newDir < 0) and (newDir + 360) or newDir
    player.direction.x = math.cos(math.rad(player.angle))
    player.direction.y = math.sin(math.rad(player.angle))
    plane.x = -planeSize * math.sin(math.rad(player.angle))
    plane.y = planeSize * math.cos(math.rad(player.angle))
	end
	if love.keyboard.isDown("right") then
		newDir = player.angle + player.turnSpeed * dt
		player.angle = (newDir >= 360) and (newDir - 360) or newDir
    player.direction.x = math.cos(math.rad(player.angle))
    player.direction.y = math.sin(math.rad(player.angle))
    plane.x = -planeSize * math.sin(math.rad(player.angle))
    plane.y = planeSize * math.cos(math.rad(player.angle))
	end

  -- shader:send("player_pos", {player.x, player.y})
  -- shader:send("player_ang", math.rad(player.angle))

end

function love.draw()
	worldHeight = table.getn(worldMap)
	worldWidth = table.getn(worldMap[1])

  -- love.graphics.setShader(shader)
  -- love.graphics.rectangle("fill", 0, 0, windowW, windowH)
  -- love.graphics.setShader()

  for i = 0, windowW do
    cameraX = 2 * i / windowW - 1
    rayPosX = player.x
    rayPosY = player.y
    rayDirX = player.direction.x + plane.x * cameraX;
    rayDirY = player.direction.y + plane.y * cameraX;

    mapX = math.floor(rayPosX)
    mapY = math.floor(rayPosY)
     
    sideDistX = 0
    sideDistY = 0
     
    deltaDistX = math.sqrt(1 + (rayDirY * rayDirY) / (rayDirX * rayDirX))
    deltaDistY = math.sqrt(1 + (rayDirX * rayDirX) / (rayDirY * rayDirY))
    perpWallDist = 0
     
    stepX = 0
    stepY = 0

    hit = 0
    side = 0

    if rayDirX < 0 then
      stepX = -1
      sideDistX = (rayPosX - mapX) * deltaDistX
    else
      stepX = 1
      sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX
    end
    if rayDirY < 0 then
      stepY = -1
      sideDistY = (rayPosY - mapY) * deltaDistY
    else
      stepY = 1
      sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY
    end

    -- perform DDA
    while hit == 0 do
      -- jump to next map square, OR in x-direction, OR in y-direction
      if sideDistX < sideDistY then
        sideDistX = sideDistX + deltaDistX
        mapX = mapX + stepX
        side = 0
      else
        sideDistY = sideDistY + deltaDistY
        mapY = mapY + stepY
        side = 1
      end
      -- Check if ray has hit a wall
      if worldMap[mapY + 1] == nil or worldMap[mapY + 1][mapX + 1] == nil or worldMap[mapY + 1][mapX + 1] > 0 then hit = 1 end
    end

    if side == 0 then
      perpWallDist = math.abs((mapX - rayPosX + (1 - stepX) / 2) / rayDirX)
    else
      perpWallDist = math.abs((mapY - rayPosY + (1 - stepY) / 2) / rayDirY)
    end

    lineHeight = math.abs(math.floor(windowH / perpWallDist * 1))

    drawStart = -lineHeight / 2 + windowH / 2
    if drawStart < 0 then 
      drawStart = 0 
    end
    drawEnd = lineHeight / 2 + windowH / 2
    if drawEnd >= windowH then
     drawEnd = windowH - 1
    end

    color = { 255, 255, 255, 255 }
    if worldMap[mapY + 1][mapX + 1] == 1 then
      color = { 255, 0, 0, 255 }
    elseif worldMap[mapY + 1][mapX + 1] == 2 then
      color = { 0, 255, 0, 255 }
    elseif worldMap[mapY + 1][mapX + 1] == 3 then
      color = { 0, 0, 255, 255 }
    elseif worldMap[mapY + 1][mapX + 1] == 4 then
      color = { 255, 0, 255, 255 }
    end

    if side == 1 then
      color[1] = color[1] * 0.5
      color[2] = color[2] * 0.5
      color[3] = color[3] * 0.5
      color[4] = color[4] * 0.5
    end

    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.line(i, drawStart, i, drawEnd)

    if (i % 10) == 0 then
      love.graphics.setColor(0, 255, 0, 64)
      love.graphics.line( rayPosX * mapSizeRatio, rayPosY * mapSizeRatio, (rayPosX + rayDirX * perpWallDist) * mapSizeRatio, (rayPosY + rayDirY * perpWallDist) * mapSizeRatio )
    end

  end

  love.graphics.setColor(255, 0, 255, 127)
	for y,row in ipairs(worldMap) do
    for x,col in ipairs(worldMap[y]) do
    	if worldMap[y][x] > 0 then
    		love.graphics.point((x - 0.5) * mapSizeRatio, (y - 0.5) * mapSizeRatio)
    	end
    end
  end
  -- love.graphics.line(player.x * mapSizeRatio, player.y * mapSizeRatio, (player.x + player.direction.x) * mapSizeRatio, (player.y + player.direction.y) * mapSizeRatio)
  -- love.graphics.line((player.x + player.direction.x) * mapSizeRatio, (player.y + player.direction.y) * mapSizeRatio, (player.x + player.direction.x + plane.x) * mapSizeRatio, (player.y + player.direction.y + plane.y) * mapSizeRatio)

  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.print((love.timer.getDelta() * 1000) .. "ms", 0, windowH - 20)
  love.graphics.print(love.timer.getFPS(), 0, windowH - 40)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end