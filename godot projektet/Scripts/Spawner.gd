extends Node2D
class_name Spawner
@onready var wfc = $"../WaveFunctionCollapse"
@onready var player = $"../Player"

@onready var difficulty = get_parent().planet.difficulty
@onready var spawnFactor = get_parent().planet.scaleFactor

var spawnPoints: Array = []

signal enemyDiedSignal(enemy)
signal enemyDiedNaiveSignal
signal enemyDamageTakenSignal(enemy)
signal enemyDamageTakenWithEnemy(enemy)

signal allEnemiesKilled

func _ready():
	player.tookDamage.connect(knockbackEnemies)

func spawnEnemies() -> void:
	var enemyCount = int(pow(difficulty * 0.1, 0.6) * 2.5 * spawnFactor + 5)
	for i in enemyCount:
		if randi() % 2 == 0:
			spawnEnemy("res://Scenes/Enemies/ranged_enemy.tscn")
		else:
			spawnEnemy("res://Scenes/Enemies/melee_enemy.tscn")
		
func spawnEnemy(enemyPath: String) -> void:
	var enemyPosition = getNewEnemyPosition()
	var enemyInstance = load(enemyPath).instantiate()
	enemyInstance.died.connect(enemyDied)
	enemyInstance.health *= max(pow(difficulty * 0.03, 0.85) * 0.6, 1)
	enemyInstance.damageMult = max(pow(difficulty * 0.03, 0.85) * 0.15, 1)
	if difficulty == 0:
		enemyInstance.damageMult = 0
	enemyInstance.damageTaken.connect(enemyDamageTaken)
	enemyInstance.position = enemyPosition
	enemyInstance.player = player
	enemyInstance.setNavigationMap(wfc.tileMap.get_layer_navigation_map(0))
	call_deferred("add_child", enemyInstance)

func getClosestEnemyPosition(startPosition: Vector2) -> Vector2:
	var enemyPosition: Vector2 = Vector2.ZERO
	for enemy in get_children():
		if startPosition.distance_to(enemy.global_position) < startPosition.distance_to(enemyPosition) or enemyPosition == Vector2.ZERO:
			enemyPosition = enemy.global_position
	return enemyPosition

func findSpawnableTiles() -> void:
	spawnPoints.clear()
	for tile in wfc.tileMap.get_used_cells(0):
		var data = wfc.tileMap.get_cell_tile_data(0, tile)
		if data:
			if data.get_custom_data("spawnable"):
				spawnPoints.append(tile)
	spawnPoints.shuffle()

func getNewEnemyPosition() -> Vector2:
	var rangeSize: int = 200
	var enemyPosition = getPositionOutsideRange(player.position, 200, true)
	var distanceToStartSquared = (Vector2(enemyPosition)-(player.position)).length_squared()
	for i in spawnPoints.size():
		enemyPosition = spawnPoints.pop_back() * wfc.tileSize + wfc.tileSize / 2
		distanceToStartSquared = (Vector2(enemyPosition)-(player.position)).length_squared()
		if distanceToStartSquared > rangeSize*rangeSize:
			return enemyPosition
	return enemyPosition
	
	

func spawnPlayer() -> void:
	player.position = spawnPoints.pop_front() * wfc.tileSize

func getEnemies() -> Array[Node]:
	return get_children()

func enemyDied(enemy: Enemy) -> void:
	enemyDiedSignal.emit(enemy)
	enemyDiedNaiveSignal.emit()
	if get_child_count() <= 1:
		allEnemiesKilled.emit()
	
func enemyDamageTaken(enemy: Enemy) -> void:
	enemyDamageTakenSignal.emit()
	enemyDamageTakenWithEnemy.emit(enemy)

func getPositionOutsideRange(startPosition: Vector2, rangeSize: int, outside: bool) -> Vector2:
	var possiblePositions = spawnPoints.duplicate()
	possiblePositions.shuffle()
	var possiblePosition = possiblePositions.pop_back() * wfc.tileSize + wfc.tileSize / 2
	var distanceToStartSquared = (Vector2(possiblePosition)-(startPosition)).length_squared()
	while(distanceToStartSquared < rangeSize*rangeSize == outside):
		if possiblePositions.size() == 0:
			return spawnPoints.pick_random()
		possiblePosition = possiblePositions.pop_back() * wfc.tileSize + wfc.tileSize / 2
		distanceToStartSquared = (Vector2(possiblePosition)-(startPosition)).length_squared()
	spawnPoints.erase(possiblePosition)
	return possiblePosition

func knockbackEnemies() -> void:
	for enemy in get_children():
		var distanceToPlayer: float = enemy.position.distance_to(player.position)
		if distanceToPlayer < 80:
			enemy.knockBack((100 - distanceToPlayer) * 0.4, (enemy.position - player.position).normalized())
