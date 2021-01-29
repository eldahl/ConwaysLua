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

    love.graphics.setBackgroundColor(104, 136, 248)					-- Set the background color to a nice blue

    love.window.setTitle("Conway's Game of Life")					-- Window title
    love.window.setMode(1024, 768)									-- Game window resolution

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
    
	-- Glider gun
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

end

function love.keypressed(key)
	if key == "up" 		then newDirection = 1 end
	if key == "escape" 	then love.event.quit() end
	if key == "d" 		then update() end
end

function love.update()
	update()
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
		love.graphics.draw(cells[i][j].gfx, 14+i*8, 14+j*8, 0, 0.25, 0.25)
	end
	end

end

function love.draw(dt)
	drawCells()

	love.graphics.print("x: ")
	love.graphics.print("y: ", 0, 10)
end

