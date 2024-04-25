extends Node2D
var reward: Item

@onready var wfc = $WaveFunctionCollapse
@onready var player = $Player
@onready var levelManager = $".."
@onready var spawner: Spawner = $Spawner
@onready var levelClear: AudioStream = load("res://Assets/AudioFiles/levelClear.mp3")
@export var deathScreen: PackedScene

var planet: Planet
var spawnedReward: bool = false

func _ready():
	SfxManager.play_music(load("res://Assets/AudioFiles/planet_music.mp3"))
	wfc.calculateGrids()
	spawner.findSpawnableTiles()
	spawner.spawnPlayer()
	spawner.spawnEnemies()
	var gridRect = wfc.gridRect
	var tileSize = wfc.tileSize
	player.camera2d.limit_left = gridRect.position.x * tileSize.x + tileSize.x
	player.camera2d.limit_top = gridRect.position.y * tileSize.y + tileSize.y
	player.camera2d.limit_right = (gridRect.size.x + gridRect.position.x) * tileSize.x - tileSize.x
	player.camera2d.limit_bottom = (gridRect.size.y + gridRect.position.y) * tileSize.y - tileSize.x
	player.playerDead.connect(levelManager.loadMenu.bind(deathScreen))
	spawner.allEnemiesKilled.connect(levelCleared)
	spawner.enemyDiedSignal.connect(enemyDied)
	
	wfc.modulate = planet.randomColor
	
func enemyDied(enemy) -> void:
	player.addMoney(enemy.moneyDrop*pow(Globals.stats.energy, Globals.stats.energyToGold))
	
func levelCleared() -> void:
	spawnReward()
	Globals.stats.money = player.money
	player.ui.showLeaveButton()
	SfxManager.play_sound(levelClear)

func spawnReward() -> void:
	if spawnedReward:
		return
	if !reward:
		reward = Globals.stats.weightedRandomReward()
	spawnedReward = true
	var itemDrop = load("res://Scenes/item_pick_up.tscn").instantiate()
	itemDrop.item = reward
	itemDrop.position = spawner.getPositionOutsideRange(player.position, 100, false)
	call_deferred("add_child", itemDrop) 

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel") and planet.difficulty != 0:
		levelManager.pause()
		
