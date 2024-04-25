extends Control

var generationSize = Vector2(2000, 2000)
var pixelScale: int = 6
var planetDist: int = 34 * pixelScale


@export var chunksGenerated: Array[Vector2] = []

var allPoints: Array[Vector2]

@onready var rng = RandomNumberGenerator.new()
@onready var planetContainer = %PlanetContainer
@onready var chunkAreaContainer = $ChunkAreaContainer


var planetContainerSmoothPosition: Vector2

signal planetsGeneratedSignal

func _ready():
	for chunk in chunkAreaContainer.get_children():
		if !chunk.enteredChunk.is_connected(generateChunk):
			chunk.enteredChunk.connect(generateChunk, 2)

func tweenPlanetContainer(planetPosition: Vector2) -> void:
	var tween
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.set_trans(2)
	var tweenTime = 2.5
	chunkAreaContainer.position = -planetPosition * planetContainer.scale.x + size/2
	tween.tween_property(planetContainer, "position", (-planetPosition) * planetContainer.scale.x + size/2, tweenTime)
	await get_tree().create_timer(tweenTime).timeout
	return


func setup():
	planetContainer.position = Vector2(1254, 863) / 2
	chunkAreaContainer.position = planetContainer.position
	generateChunk(Vector2(0, 0))
	
func emitSignal() -> void:
	planetsGeneratedSignal.emit()

func spawnPlanet(pos: Vector2, type: int):
	var planetInstance: SpaceObject
	if type <  95:
		planetInstance = load("res://Scenes/Planets/planet.tscn").instantiate()
	else:
		planetInstance = load("res://Scenes/Planets/space_station.tscn").instantiate()
	planetInstance.position = pos
	
	planetContainer.call_deferred("add_child", planetInstance)
	planetInstance.call_deferred("set_owner",self)
	
func removePlanets():
	for i in planetContainer.get_children():
		i.queue_free()
	for i in chunkAreaContainer.get_children():
		i.queue_free()

func generatePlanetPosition(area: Vector2i) -> Array[Vector2]:
	var repeatConstant: int = 30
	var radius: int = planetDist
	var points: Array[Vector2] = []
	var activePoints: Array[Vector2] = []
	var firstPoint: Vector2 = Vector2(0, 0)
	activePoints.append(firstPoint)
	points.append(firstPoint)
	while(activePoints.size() > 0):
		# Choose a random active point
		var index = randi() % activePoints.size()
		var samplePoint: Vector2 = activePoints[index]
		var placed: bool = false
		# Find a placement for a new point near the active point
		for i in range(repeatConstant):
			var randomAngle: float = 2 * PI * randf()
			var distance: float = radius+radius*randf()
			var newPoint = samplePoint + snapped(Vector2.from_angle(randomAngle) * distance, Vector2(pixelScale, pixelScale))
			var tooClose: bool = false
			for point in points:
				if newPoint.distance_squared_to(point) < radius*radius:
					tooClose = true
					break
			if !tooClose and newPoint.x > -area.x/2 and newPoint.x < area.x/2 and newPoint.y > -area.y/2 and newPoint.y < area.y/2:
				points.append(Vector2(newPoint.x, newPoint.y))
				activePoints.append(Vector2(newPoint.x, newPoint.y))
				placed = true
				break
		if !placed:
			activePoints.remove_at(index)
	points.remove_at(0)
	allPoints.append_array(points)
	return points
	
func generateChunk(chunkCoordinate) -> void:
	var offset: Vector2 = chunkCoordinate * (generationSize.x + planetDist)
	var points: Array[Vector2] = generatePlanetPosition(generationSize)
	for point in points:
		spawnPlanet(Vector2i(point + offset), rng.randi() % 100)
	chunksGenerated.append(chunkCoordinate)
	call_deferred("emitSignal")
	for surroundingCoord in getSurroundingCoords(chunkCoordinate):
		if !chunksGenerated.has(surroundingCoord):
			var chunkAreaInstance = load("res://Scenes/chunkArea.tscn").instantiate()
			chunkAreaInstance.chunkCoordinate = surroundingCoord
			chunkAreaInstance.position = surroundingCoord * (generationSize.x + planetDist) 
			chunkAreaInstance.enteredChunk.connect(generateChunk)
			chunksGenerated.append(surroundingCoord)
			chunkAreaContainer.call_deferred("add_child",chunkAreaInstance)
			chunkAreaInstance.call_deferred("set_owner", self)

func getSurroundingCoords(coord: Vector2) -> Array[Vector2]:
	var coords: Array[Vector2] = []
	for i in range(-1,2):
		coords.append(Vector2(coord.x + i, coord.y + 1))
		coords.append(Vector2(coord.x + i, coord.y))
		coords.append(Vector2(coord.x + i, coord.y - 1))
	coords.erase(coord)
	return coords


