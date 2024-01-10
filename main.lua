gfx = {}
cells = {}
cellsUpdate = {}

-- To copy functions and variables, the metatables __index has to be equal it self.
cellMT = {}
cellMT.__index = cellMT
cellMT.x = 0
cellMT.y = 0
cellMT.alive = false
cellMT.gfx = gfx.black

function newCell()
	cellobj = {}
	setmetatable(cellobj, cellMT)
	cellobj.gfx = gfx.black
	return cellobj
end

function cellMT:setAlive(isAlive)
	if isAlive == true then
		self.alive = true
		self.gfx = gfx.tile
	else
		self.alive = false
		self.gfx = gfx.black
	end
end
-- Birth rule: An empty, or "dead" cell with precisely three "live" neighbours (full cell) becomes live.
-- Death rule: A live cell with zero or one neighbours dies of isolation, a live cell with four or more neighbours dies of overcrowding.
-- Survival rule: A live cell with two or three neighbours remains alive.

function love.load()
	
	love.filesystem.setIdentity("Conway's Game of Life")			-- Identity for system
	love.keyboard.setKeyRepeat(true)

	love.graphics.setBackgroundColor(104, 136, 248, 255)					-- Set the background color to a nice blue

	love.window.setTitle("Conway's Game of Life")					-- Window title
	local flags = {
		vsync = 0,
	}
	love.window.setMode(648, 648, flags)									-- Game window resolution

	gfx.tile = love.graphics.newImage("tile.png")					-- Load textures
	gfx.black = love.graphics.newImage("black.png")

	gridSizeX = 80
	gridSizeY = 80

    for i = 0, gridSizeX do
    	cells[i] = {}
    	cellsUpdate[i] = {}
		for j = 0, gridSizeY do
			cells[i][j] = newCell()
			cells[i][j]:setAlive(false)

			cellsUpdate[i][j] = newCell()
			cellsUpdate[i][j]:setAlive(false)
		end
    end

	--[[
	cells[7][7]:setAlive(true)
	cells[8][8]:setAlive(true)
	cells[7][8]:setAlive(true)
	cells[6][8]:setAlive(true)
	]]

	-- Glider gun #1
	cells[10][12]:setAlive(true)
	cells[10][13]:setAlive(true)

	cells[11][12]:setAlive(true)
	cells[11][13]:setAlive(true)

	cells[20][12]:setAlive(true)
	cells[20][13]:setAlive(true)
	cells[20][14]:setAlive(true)

	cells[21][11]:setAlive(true)
	cells[21][15]:setAlive(true)

	cells[22][10]:setAlive(true)
	cells[22][16]:setAlive(true)
	cells[23][10]:setAlive(true)
	cells[23][16]:setAlive(true)

	cells[24][13]:setAlive(true)

	cells[25][11]:setAlive(true)
	cells[25][15]:setAlive(true)

	cells[26][12]:setAlive(true)
	cells[26][13]:setAlive(true)
	cells[26][14]:setAlive(true)

	cells[27][13]:setAlive(true)

	cells[30][10]:setAlive(true)
	cells[30][11]:setAlive(true)
	cells[30][12]:setAlive(true)
	cells[31][10]:setAlive(true)
	cells[31][11]:setAlive(true)
	cells[31][12]:setAlive(true)

	cells[32][9]:setAlive(true)
	cells[32][13]:setAlive(true)

	cells[34][8]:setAlive(true)
	cells[34][9]:setAlive(true)
	cells[34][13]:setAlive(true)
	cells[34][14]:setAlive(true)

	cells[44][10]:setAlive(true)
	cells[44][11]:setAlive(true)
	cells[45][10]:setAlive(true)
	cells[45][11]:setAlive(true)

	-- Glider gun #2
	cells[10][42]:setAlive(true)
	cells[10][43]:setAlive(true)

	cells[11][42]:setAlive(true)
	cells[11][43]:setAlive(true)

	cells[20][42]:setAlive(true)
	cells[20][43]:setAlive(true)
	cells[20][44]:setAlive(true)

	cells[21][41]:setAlive(true)
	cells[21][45]:setAlive(true)

	cells[22][40]:setAlive(true)
	cells[22][46]:setAlive(true)
	cells[23][40]:setAlive(true)
	cells[23][46]:setAlive(true)

	cells[24][43]:setAlive(true)

	cells[25][41]:setAlive(true)
	cells[25][45]:setAlive(true)

	cells[26][42]:setAlive(true)
	cells[26][43]:setAlive(true)
	cells[26][44]:setAlive(true)

	cells[27][43]:setAlive(true)

	cells[30][40]:setAlive(true)
	cells[30][41]:setAlive(true)
	cells[30][42]:setAlive(true)
	cells[31][40]:setAlive(true)
	cells[31][41]:setAlive(true)
	cells[31][42]:setAlive(true)

	cells[32][39]:setAlive(true)
	cells[32][43]:setAlive(true)

	cells[34][38]:setAlive(true)
	cells[34][39]:setAlive(true)
	cells[34][43]:setAlive(true)
	cells[34][44]:setAlive(true)

	cells[44][40]:setAlive(true)
	cells[44][41]:setAlive(true)
	cells[45][40]:setAlive(true)
	cells[45][41]:setAlive(true)
end

function love.keypressed(key)
	if key == "space" 	then doUpdate = not doUpdate end
	if key == "escape" 	then love.event.quit() end
	if key == "d" 		then update() end
end

local fps = 60
local frameTime = 1/fps

function love.update(dt)
	local startTime = love.timer.getTime()
	if(doUpdate) then
		update()
		local updateTime = love.timer.getTime() - startTime
	
		if frameTime > updateTime then
			-- 0.001 seconds delay is added by the love engine, so we remove that to hit the desired fps
			local remainingDeltaTime = frameTime - updateTime - 0.001
			love.timer.sleep(remainingDeltaTime)
		end
	end
end

function update()
	for i = 0, gridSizeX do
	for j = 0, gridSizeY do

		-- Survival rule
		if amountAlive(i,j) == 3 or amountAlive(i,j) == 2 and cells[i][j].alive then
			cellsUpdate[i][j]:setAlive(true)
		end

		-- Birth rule
		if amountAlive(i,j) == 3 then
			cellsUpdate[i][j]:setAlive(true) 
		end

		-- Death rule
		if amountAlive(i,j) <= 1 then
			cellsUpdate[i][j]:setAlive(false) 
		end
		if amountAlive(i,j) >= 4 then
			cellsUpdate[i][j]:setAlive(false)
		end
	end
	end
	
	-- cellsUpdate -> cells
	for i = 0, gridSizeX do
		for j = 0, gridSizeY do	
			cells[i][j] = cellsUpdate[i][j]
			cellsUpdate[i][j] = newCell()
		end
    end
end

function amountAlive(x,y)
	local amount = 0
	-- X--
	-- ---
	-- ---
	if x-1 > 0 and y-1 > 0 then
		if cells[x-1][y-1] ~= nil then
			if cells[x-1][y-1].alive then amount = amount + 1 end
		end
	end
	-- -X-
	-- ---
	-- ---
	if y-1 > 0 then
		if cells[x][y-1] ~= nil then
			if cells[x][y-1].alive then amount = amount + 1 end
		end
	end
	-- --X
	-- ---
	-- ---
	if not (x+1 > gridSizeX) and y-1 > 0 then
		if cells[x+1][y-1] ~= nil then
			if cells[x+1][y-1].alive then amount = amount + 1 end
		end
	end
	-- ---
	-- X--
	-- ---
	if x-1 > 0 then
		if cells[x-1][y] ~= nil then
			if cells[x-1][y].alive then amount = amount + 1 end
		end
	end
	-- ---
	-- --X
	-- ---
	if not (x+1 > gridSizeX) then
		if cells[x+1][y] ~= nil then
			if cells[x+1][y].alive then amount = amount + 1 end
		end
	end
	-- ---
	-- ---
	-- X--
	if x-1 > 0 and not (y+1 > gridSizeY) then
		if cells[x-1][y+1] ~= nil then
			if cells[x-1][y+1].alive then amount = amount + 1 end
		end
	end
	-- ---
	-- ---
	-- -X-
	if not (y+1 > gridSizeY) then
		if cells[x][y+1] ~= nil then
			if cells[x][y+1].alive then amount = amount + 1 end
		end
	end
	-- ---
	-- ---
	-- --X
	if not (x+1 > gridSizeX) and not (y+1 > gridSizeY) then
		if cells[x+1][y+1] ~= nil then
			if cells[x+1][y+1].alive then amount = amount + 1 end
		end
	end
	return amount
end

function drawCells()
	love.graphics.setColor(255,255,255,255)
	for i = 0, gridSizeX do
	for j = 0, gridSizeY do
		love.graphics.draw(cells[i][j].gfx, i*8, j*8, 0, 0.25, 0.25)
	end
	end

end

function love.draw(dt)
	love.graphics.clear(love.graphics.getBackgroundColor())
	drawCells()
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

