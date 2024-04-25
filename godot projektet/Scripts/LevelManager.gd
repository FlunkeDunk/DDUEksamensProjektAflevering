extends Control
var currentLevel: String
var currentMenu: String
@onready var mainScene = $".."
#@onready var ui = $"../UI"
@onready var canvasLayer = $"../CanvasLayer"
@onready var animationPlayer = %AnimationPlayer
@onready var fadeRect= $"../CanvasLayer/ColorRect"



var firstScene: String = "res://Scenes/main_menu.tscn"
var level
var shipMenu: Menu
var menuInstance
var currentLevelNumber: int
var nextFade: bool = false


signal levelLoaded
signal saveLoaded

func _ready():
	loadLevel(firstScene, false)

func unloadLevel():
	if level is Menu:
		remove_child(level)
		shipMenu = level
		return
	if is_instance_valid(level):
		level.queue_free()
	level = null

func loadLevel(levelToLoad: String, fade: bool):
	unloadLevel()
	unpause()
	currentLevel = levelToLoad
	var levelPath = currentLevel
	var loadedLevel = load(levelPath)
	if loadedLevel:
		if fade:
			nextFade = true
		else:
			fadeRect.color.a = 0
			nextFade = false
			
		level = loadedLevel.instantiate()
		if level is Menu and shipMenu:
			level = shipMenu
		level.position = Vector2.ZERO
		call_deferred("add_child",level)
		call_deferred("emit_signal", "levelLoaded")

func loadSave() -> void:
	unloadLevel()
	unpause()
	shipMenu = load("res://Scenes/ShipMenu.tscn").instantiate()
	nextFade = true
	level = shipMenu
	level.position = Vector2.ZERO
	call_deferred("add_child",level)
	call_deferred("emit_signal", "levelLoaded")
	level.loaded = true
	saveLoaded.emit()

func loadSpaceObject(spaceObject: SpaceObject) -> void:
	unloadLevel()
	nextFade = true
	var objectInstance
	if spaceObject is Planet:
		objectInstance = load("res://Scenes/planet_surface.tscn").instantiate()
		objectInstance.planet = spaceObject
	elif spaceObject is SpaceStation:
		objectInstance = load("res://Scenes/shop.tscn").instantiate()
	
	level = objectInstance
	level.position = Vector2.ZERO
	call_deferred("add_child",level)
	call_deferred("emit_signal", "levelLoaded")

func loadMenu(menu: PackedScene):
	menuInstance = menu.instantiate()
	menuInstance.position = Vector2.ZERO
	canvasLayer.call_deferred("add_child", menuInstance)
	get_tree().paused = true

func pause() -> void:
	var pauseMenu = load("res://Scenes/pause_screen.tscn")
	if pauseMenu:
		loadMenu(pauseMenu)
		

func playFade():
	animationPlayer.play_backwards("fade_in")

func unpause() -> void:
	get_tree().paused = false
	if is_instance_valid(menuInstance):
		menuInstance.queue_free()
	menuInstance = null

func _on_child_entered_tree(node):
	if nextFade:
		animationPlayer.play("fade_in")
		nextFade = false


