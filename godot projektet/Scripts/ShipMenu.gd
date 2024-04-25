extends Menu
class_name ShipMenu
@onready var radar: Control = %Radar
@onready var inventoryMenu: Control = %InventoryMenu
@onready var camera: Camera2D = %Camera
@onready var menuWidth: Vector2 
@onready var vBoxContainer = %VBoxContainer
@onready var levelManager = $".."

var generatorMenu: Control

var currentMenu: int = 0
var travelSpeed: float = 5.0
var hasReadied: bool = false
var loaded: bool = false

func _ready():
	var separation = vBoxContainer.theme.get_constant("separation", "HBoxContainer")
	size.x = (1920)*3+separation*2
	menuWidth = Vector2(1920+separation, 0)
	hasReadied = true
	if loaded:
		loadSave()
	else:
		setupSave()

func save() -> void:
	print("save")
	var newConfig = ConfigFile.new()
	newConfig.set_value("SAVES","hasSave",true)
	newConfig.save("user://saves.cfg")
	ResourceSaver.save(Globals.inventory, "user://Inventory.tres", 1)
	ResourceSaver.save(Globals.stats, "user://Stats.tres", 1)
	Globals.newStatsCreated.emit()
	var packedGenerator = PackedScene.new()
	packedGenerator.pack(generatorMenu)
	ResourceSaver.save(packedGenerator, "user://Generator.tscn", 1)
	radar.savePlanets()

func loadSave() -> void:
	inventoryMenu.inventory.clearInventory()
	print("load") 
	Globals.stats = ResourceLoader.load("user://Stats.tres")
	Globals.inventory = ResourceLoader.load("user://Inventory.tres")
	Globals.newStatsCreated.emit()
	var newGenerator: Control = ResourceLoader.load("user://Generator.tscn").instantiate()
	generatorMenu = newGenerator
	generatorMenu.radar = radar
	vBoxContainer.add_child(generatorMenu)
	radar.loadPlanets()
	inventoryMenu.inventory.call_deferred("updateInventory",Globals.inventory)

func setupSave() -> void:
	generatorMenu = load("res://Scenes/generator_menu.tscn").instantiate()
	generatorMenu.radar = radar
	vBoxContainer.add_child(generatorMenu)
	Globals.stats = GlobalStats.new()
	Globals.inventory = Inventory.new()
	Globals.inventory.currentGun = load("res://Data/Guns/AutoRifle.tres")
	inventoryMenu.inventory.call_deferred("updateInventory",Globals.inventory)
	
func _enter_tree():
	if hasReadied:
		save()
		var separation = vBoxContainer.theme.get_constant("separation", "HBoxContainer")
		size = Vector2((1920)*3+separation*2, 1080)
	SfxManager.play_ambience(load("res://Assets/AudioFiles/spaceAmbience.mp3"))
	SfxManager.play_music(load("res://Assets/AudioFiles/ship_music.mp3"))

func _unhandled_key_input(event):
	if event.is_action_released("ui_right"):
		currentMenu = min(currentMenu+1, vBoxContainer.get_child_count()-1)
		camera.tweenToPos(menuWidth*currentMenu)
	elif event.is_action_released("ui_left"):
		currentMenu = max(currentMenu-1, 0)
		camera.tweenToPos(menuWidth*currentMenu)
	if event.is_action_pressed("ui_cancel"):
		levelManager.pause()

