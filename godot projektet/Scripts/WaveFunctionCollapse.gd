extends Node2D

@export var tileMap: TileMap
var globalSubGridSize: Vector2 = Vector2(4, 4)
var globalGridSize: Vector2 = Vector2(7, 4)
var subGridArray: Array[SubGrid]
var source: int = 0
var tiles: Array[Tile] = []
var gridRect: Rect2i
var tileSize: Vector2i

signal mapGenerated

class SubGrid:
	var timesFailed: int = 0
	var grid: Array[Cell]
	var tiles: Array[Tile]
	var gridSize: Vector2
	var startCord: Vector2
	
	var bottomRowTiles: Array[Tile] = []
	var rightCollumTiles: Array[Tile] = []
	
	var tilesAbove: Array[Tile]
	var tilesBelow: Array[Tile]
	var tileToTheLeft: Array[Tile]
	var tilesToTheRight: Array[Tile]
	

	func _init(tilesArray: Array[Tile], sc: Vector2, size: Vector2) -> void:
		self.tiles = tilesArray
		self.startCord = sc
		self.gridSize = size
		
	func setupGrid() -> void:
		grid = []
		for x in gridSize.x:
			for y in gridSize.y:
				var arrayIndex = (x * gridSize.y + y)
				var cell = Cell.new()
				grid.append(cell)
				grid[arrayIndex].coord = Vector2(x, y)
				grid[arrayIndex].collapsed = false
				grid[arrayIndex].options = tiles
		if tilesAbove != []:
			for x in gridSize.x:
					grid[gridSize.y * x].options = tilesAbove[x].downTiles
		if tilesBelow != []:
			for x in gridSize.x:
				grid[gridSize.y * x + gridSize.y - 1].options = tilesBelow[x].upTiles.filter(func(option): return option in grid[gridSize.y * x + gridSize.y - 1].options)
		if tileToTheLeft != []:
			for y in gridSize.y:
				grid[y].options = tileToTheLeft[y].rightTiles.filter(func(option): return option in grid[y].options)
		if tilesToTheRight != []:
			for y in gridSize.y:
				grid[y + gridSize.x * (gridSize.y - 1)].options = tilesToTheRight[y].leftTiles.filter(func(option): return option in grid[y].options)
			

	func generateMap() -> bool:
		var failed: bool = true
		timesFailed = 0
		while(failed):
			setupGrid()
			for i in gridSize.x * gridSize.y:
				var randomLowestEntropyCoords = findLowestEntropy()
				failed = !collapse(randomLowestEntropyCoords)
				if failed:
					timesFailed += 1
					if timesFailed > 25:
						return true
					break
			if !failed:
				for x in gridSize.x:
					bottomRowTiles.append(grid[x * gridSize.y + gridSize.y - 1].tile)
				for y in gridSize.y:
					rightCollumTiles.append(grid[(gridSize.x - 1) * gridSize.y + y].tile)
		return false

	func findLowestEntropy() -> Vector2:
		var sortGrid = grid.duplicate()
		sortGrid = sortGrid.filter(func(cell): return !cell.collapsed)
		sortGrid.sort_custom(sortByEntropy)
		sortGrid = sortGrid.filter(func(tile): return tile.options.size() == sortGrid[0].options.size())
		var randomPoint = sortGrid[(randi() + timesFailed) % sortGrid.size()]
		return randomPoint.coord

	func collapse(coords: Vector2) -> bool:
		var arrayIndex = coords.x * gridSize.y + coords.y
		var tilesToPlace: Array = grid[arrayIndex].options
		if tilesToPlace.size() == 0:
			return false
		var tiletoPlace = pickWeighted(tilesToPlace)
		grid[arrayIndex].collapsed = true
		grid[arrayIndex].tile = tiletoPlace
		
		if coords.x > 0:
			var leftIndex = (coords.x-1) * gridSize.y + coords.y
			grid[leftIndex].options = tiletoPlace.leftTiles.filter(func(option): return option in grid[leftIndex].options)
		
		if coords.x + 1 < gridSize.x:
			var rightIndex = (coords.x+1) * gridSize.y + coords.y
			grid[rightIndex].options = tiletoPlace.rightTiles.filter(func(option): return option in grid[rightIndex].options)
		
		if coords.y > 0:
			var upIndex = (coords.x) * gridSize.y + coords.y -1
			grid[upIndex].options = tiletoPlace.upTiles.filter(func(option): return option in grid[upIndex].options)
		
		if coords.y + 1 < gridSize.y:
			var downIndex = (coords.x) * gridSize.y + coords.y + 1
			grid[downIndex].options = tiletoPlace.downTiles.filter(func(option): return option in grid[downIndex].options)
		return true
	
	func sortByEntropy(a: Cell, b: Cell) -> bool:
		return a.calculateEntropy() < b.calculateEntropy()
	
	func pickWeighted(tileArray: Array) -> Tile:
		var sumOfWeights: int = 0
		for tile in tileArray:
			sumOfWeights += tile.weight	
		var roll = (randi() + timesFailed) % (sumOfWeights + 1)
		var weightChecked = 0
		for tile in tileArray:
			weightChecked += tile.weight
			if roll <= weightChecked:
				return tile
		return

class Cell:
	var coord: Vector2
	var collapsed: bool
	var options: Array
	var tile: Tile
	
	func duplicate() -> Cell:
		var newCell: Cell = Cell.new()
		newCell.coord = self.coord
		newCell.collapsed = self.collapsed
		newCell.options = self.options
		newCell.tile = self.tile
		return newCell
	
	func calculateEntropy() -> float:
		var sumOfWeights: float = 0
		var sumOfWeigthTimesLogWeight: float = 0
		for newTile in options:
			sumOfWeights += newTile.weight
			sumOfWeigthTimesLogWeight += newTile.weight * log(newTile.weight)
		if sumOfWeights == 0:
			return 0
		var entropy: float = log(sumOfWeights) - (sumOfWeigthTimesLogWeight / sumOfWeights) 
		return entropy
		

class Tile:
	var atlasCords: Array
	var alternative: int = 0
	var edges: Array
	var weight: int
	
	var leftTiles: Array
	var rightTiles: Array
	var upTiles: Array
	var downTiles: Array
	
	func _init(ac: Array, e: Array, a: int, w: int):
		self.atlasCords = ac
		self.edges = e
		self.alternative = a
		self.weight = w

	func rotated(rotation: int) -> Tile:
		var rotatedEdges: Array = []
		for i in 4:
			rotatedEdges.append(self.edges[(i + - rotation + 4) % 4])
		var rotatedTile: Tile = Tile.new(self.atlasCords, rotatedEdges, self.alternative + rotation, self.weight)
		return rotatedTile
		
	func calculateNeighbors(functionTiles: Array) -> void:
		for tile in functionTiles:
			if edges[0] == tile.edges[2].reverse():
				leftTiles.append(tile)
			if edges[1] == tile.edges[3].reverse():
				upTiles.append(tile)
			if edges[2] == tile.edges[0].reverse():
				rightTiles.append(tile)
			if edges[3] == tile.edges[1].reverse():
				downTiles.append(tile)

func _init():
	calculateTiles()

func calculateTiles() -> void:
	var groundTileCoords: Array = []
	for x in 2:
		for y in 4:
			groundTileCoords.append(Vector2(x, y))
	for i in 10:
		groundTileCoords.append(Vector2(1, 3))
	tiles.append(Tile.new(groundTileCoords, ["GG", "GG", "GG", "GG"], 0, 80))
	#Grass
		#Side grass
	tiles.append(Tile.new([Vector2(2,1)], ["GG", "TT", "TT", "TT"], 0, 1))
	tiles.append(Tile.new([Vector2(3,0)], ["TT", "GG", "TT", "TT"], 0, 1))
	tiles.append(Tile.new([Vector2(4,1)], ["TT", "T", "GG", "TT"], 0, 1))
	tiles.append(Tile.new([Vector2(3,2)], ["TT", "TT", "TT", "GG"], 0, 1))
		#Cornor grass
	tiles.append(Tile.new([Vector2(2,0)], ["GG", "GG", "TT", "TT"], 0, 1))
	tiles.append(Tile.new([Vector2(4,0)], ["TT", "GG", "GG", "TT"], 0, 1))
	tiles.append(Tile.new([Vector2(4,2)], ["TT", "TT", "GG", "GG"], 0, 1))
	tiles.append(Tile.new([Vector2(2,2)], ["GG", "TT", "TT", "GG"], 0, 1))
		#Center grass
	tiles.append(Tile.new([Vector2(3,1)], ["TT", "TT", "TT", "TT"], 0, 1))
	 #Walls
		#Corner Top Walls
	tiles.append(Tile.new([Vector2(5,0)], ["GG", "GG", "Et", "tE"], 0, 3))
	tiles.append(Tile.new([Vector2(7,0)], ["tE", "GG", "GG", "Et"], 0, 3))
	#Side Top Walls
	tiles.append(Tile.new([Vector2(5,1)], ["GG", "Et", "tt", "tE"], 0, 3))
	tiles.append(Tile.new([Vector2(6,0)], ["tE", "GG", "Et", "tt"], 0, 3))
	tiles.append(Tile.new([Vector2(7,1)], ["tt", "tE", "GG", "Et"], 0, 3))
	# Top center wall
	tiles.append(Tile.new([Vector2(6,1)], ["tt", "tt", "tt", "tt"], 0, 3))
	#Front Top Walls
	tiles.append(Tile.new([Vector2(5,2)], ["GG", "Et", "EW", "WE"], 0, 3))
	tiles.append(Tile.new([Vector2(6,2)], ["WE", "tt", "EW", "WW"], 0, 3))
	tiles.append(Tile.new([Vector2(7,2)], ["WE", "tE", "GG", "EW"], 0, 3))
	#Front Bottom Walls
	tiles.append(Tile.new([Vector2(5,3)], ["GG", "EW", "WE", "GG"], 0, 3))
	tiles.append(Tile.new([Vector2(6,3)], ["EW", "WW", "WE", "GG"], 0, 3))
	tiles.append(Tile.new([Vector2(7,3)], ["EW", "WE", "GG", "GG"], 0, 3))
	
	for tile in tiles:
		tile.calculateNeighbors(tiles)

func calculateGrids() -> void:
	var megaFailed: bool = true
	var borderTile = tiles[0]
	var blockTile = Tile.new([Vector2(6,0)], ["nan", "nan", "nan", "nan"], 0, 1)
	placeBorders(borderTile)
	placeBlockingBorder(blockTile)
	
	var borderArrayHorizontal: Array[Tile] = []
	borderArrayHorizontal.resize(round(globalSubGridSize.y))
	borderArrayHorizontal.fill(borderTile)
	
	var borderArrayVertical: Array[Tile] = []
	borderArrayVertical.resize(round(globalSubGridSize.y))
	borderArrayVertical.fill(borderTile)
	while(megaFailed):
		subGridArray.clear()
		for x in globalGridSize.x:
			for y in globalGridSize.y:
				var subGrid = SubGrid.new(tiles, Vector2(x * globalSubGridSize.x, y * globalSubGridSize.y), globalSubGridSize)
				if x > 0:
					subGrid.tileToTheLeft = subGridArray[(x-1) * globalGridSize.y + y].rightCollumTiles
				else:
					subGrid.tileToTheLeft = borderArrayVertical
				if x == globalGridSize.x - 1:
					subGrid.tilesToTheRight = borderArrayVertical
				if y > 0:
					subGrid.tilesAbove = subGridArray[x * globalGridSize.y + y - 1].bottomRowTiles
				else:
					subGrid.tilesAbove = borderArrayHorizontal
				if y == globalGridSize.y - 1:
					subGrid.tilesBelow = borderArrayHorizontal
				megaFailed = subGrid.generateMap()
				if megaFailed:
					break
				subGridArray.append(subGrid)
				for cell in subGrid.grid:
					tileMap.set_cell(0, subGrid.startCord + cell.coord, source, cell.tile.atlasCords.pick_random(), cell.tile.alternative)
			if megaFailed:
					break
	gridRect = tileMap.get_used_rect()
	tileSize = tileMap.tile_set.tile_size
	mapGenerated.emit()

func placeBorders(borderTile: Tile) -> void:
	var gridSize = globalGridSize * globalSubGridSize
	for x in gridSize.x:
		tileMap.set_cell(0, Vector2(x, -1), source, borderTile.atlasCords.pick_random(), borderTile.alternative)
		tileMap.set_cell(0, Vector2(x, gridSize.y), source, borderTile.atlasCords.pick_random(), borderTile.alternative)
	for y in gridSize.y:
		tileMap.set_cell(0, Vector2(-1, y), source, borderTile.atlasCords.pick_random(), borderTile.alternative)
		tileMap.set_cell(0, Vector2(gridSize.x, y), source, borderTile.atlasCords.pick_random(), borderTile.alternative)
	tileMap.set_cell(0, Vector2(-1, -1), source, borderTile.atlasCords.pick_random(), borderTile.alternative)
	tileMap.set_cell(0, Vector2(gridSize.x, -1), source, borderTile.rotated(1).atlasCords.pick_random(), borderTile.alternative)
	tileMap.set_cell(0, Vector2(gridSize.x, gridSize.y), source, borderTile.rotated(2).atlasCords.pick_random(), borderTile.alternative)
	tileMap.set_cell(0, Vector2(-1, gridSize.y), source, borderTile.atlasCords.pick_random(), borderTile.alternative)

func placeBlockingBorder(blockTile: Tile) -> void:
	var gridSize = globalGridSize * globalSubGridSize
	for x in range(-1, gridSize.x + 1):
		tileMap.set_cell(0, Vector2(x, -2), source, blockTile.atlasCords.pick_random(), blockTile.alternative)
		tileMap.set_cell(0, Vector2(x, gridSize.y + 1), source, blockTile.atlasCords.pick_random(), blockTile.alternative)
	for y in range(-1, gridSize.y + 1):
		tileMap.set_cell(0, Vector2(-2, y), source, blockTile.atlasCords.pick_random(), blockTile.alternative)
		tileMap.set_cell(0, Vector2(gridSize.x + 1, y), source, blockTile.atlasCords.pick_random(), blockTile.alternative)
