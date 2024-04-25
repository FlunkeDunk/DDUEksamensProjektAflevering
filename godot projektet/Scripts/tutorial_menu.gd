extends Menu
class_name TutorialMenu

@onready var radar = %Radar
@onready var camera = %Camera
@onready var tutorialTitle = %TitleLabel
@onready var tutorialText = %TextLabel
@onready var tutorialContainer = %TutorialContainer
@onready var tutorialButton = %TutorialButton
@onready var vBoxContainer = $VBoxContainer

@onready var levelManager = get_tree().get_root().get_node("MainScene/LevelManager")

var generatorMenu: Control
var inventoryMenu: Control

var inventory: Control

var currentMenu: int = 0
var menuWidth: Vector2 
var travelSpeed: float = 5.0
var hasReadied: bool = false
var loaded: bool = false
var timesLoaded: int = 0
signal switchedMenu

func _ready():
	var separation = vBoxContainer.theme.get_constant("separation", "HBoxContainer")
	size.x = (1920)*3+separation*2

	menuWidth = Vector2(1920+separation, 0)
	hasReadied = true
	tutorialStage1()
	tutorialButton.pressed.connect(hideTutorial)

func hideTutorial() -> void:
	tutorialContainer.hide()

func _enter_tree():
	SfxManager.play_ambience(load("res://Assets/AudioFiles/spaceAmbience.mp3"))
	SfxManager.play_music(load("res://Assets/AudioFiles/ship_music.mp3"))
	if hasReadied:
		pass

func addInventory() -> void:
	inventoryMenu = load("res://Scenes/inventory_menu.tscn").instantiate()
	vBoxContainer.add_child(inventoryMenu)
	inventory = inventoryMenu.inventory

func addGeneratorMenu() -> void:
	generatorMenu = load("res://Scenes/generator_menu.tscn").instantiate()
	generatorMenu.radar = radar
	vBoxContainer.add_child(generatorMenu)

func _unhandled_key_input(event):
	if event.is_action_released("ui_right"):
		currentMenu = (currentMenu + vBoxContainer.get_child_count() + 1) % (vBoxContainer.get_child_count())
		camera.tweenToPos(menuWidth*currentMenu)
		switchedMenu.emit()
	elif event.is_action_released("ui_left"):
		currentMenu = (currentMenu + vBoxContainer.get_child_count() - 1) % (vBoxContainer.get_child_count())
		camera.tweenToPos(menuWidth*currentMenu)
		switchedMenu.emit()

func tutorialStage1():
	tutorialContainer.show()
	tutorialTitle.text = "Welcome"
	tutorialText.text = "Welcome aboard Captain.\nPlease travel to the planet on the left by selecting it and clicking deploy"
	radar.planetsGenerator.call_deferred("removePlanets")
	call_deferred("addTutorialPlanets")
	radar.deploy.connect(tutorialStage2, 4)

func tutorialStage2(_dist) -> void:
	tutorialContainer.show()
	radar.selectedPlanet.difficulty = 0
	tutorialContainer.reparent(get_tree().get_root().get_node("MainScene/CanvasLayer"))
	Globals.inventory.currentGun = load("res://Data/Guns/AutoRifle.tres")
	
	tutorialContainer.show()
	tutorialTitle.text = "Combat"
	tutorialText.text = "Use your gun to kill the aliens to obatin the item harbored on this planet.\nWe have equipped you with a device which points to the nearest alien.\nLeftclick to shoot.\"R\" to reload.\n\nOnce done click \"leave\" to go back to the ship."
	tree_entered.connect(tutorialStage3, 4)



func tutorialStage3() -> void:
	tutorialContainer.show()
	call_deferred("disableRadarSelection")
	tutorialContainer.show()
	Globals.inventory.addItem(load("res://Data/Generators/on_shoot.tres"))
	Globals.inventory.addItem(load("res://Data/Effects/shoot_again.tres"))
	Globals.inventory.addItem(load("res://Data/Guns/Revolver.tres"))
	Globals.inventory.currentGun = null
	tutorialTitle.text = "Inventory"
	tutorialButton.text = "Continue"
	tutorialText.text = "Congratulaions on your victory Capatin!\nItems you obtain can be equipped in the inventory use the right arrow key to go to the inventorymenu"
	addInventory()
	switchedMenu.connect(tutorialStage4, 4)
	
func tutorialStage4() -> void:
	tutorialContainer.show()
	
	tutorialContainer.show()
	tutorialButton.text = "Close"
	tutorialTitle.text = "Effects and generators"
	tutorialText.text = "Effects are items with powerful effetcs that only trigger once they reach a certain energy requirement. \nTo gain energy they need to be equipped with a generator that activates whenever a certain event occurs\nEquip a generator and an effect by shift+rightclicking on them"
	inventory.combinationCompleted.connect(tutorialStage5, 4)

func tutorialStage5() -> void:
	tutorialContainer.show()
	
	tutorialContainer.show()
	tutorialButton.text = "Close"
	tutorialTitle.text = "Guns"
	tutorialText.text = "Other than effects and generators you can also obtain and equip different kind of guns during your space adventure.\nTry equipping a gun with shift + leftclick."
	inventory.gunChanged.connect(tutorialStage6, 4)
	
func tutorialStage6(_gun) -> void:
	tutorialContainer.show()
	
	tutorialContainer.show()
	tutorialButton.text = "Continue"
	tutorialTitle.text = "Artifacts"
	tutorialText.text = "Artifacts are the last kind of item you will obtain when travelling through space. They cannot be equipped or discarded and are always active."
	tutorialButton.show()
	tutorialButton.pressed.connect(tutorialStage7, 4)
	
func tutorialStage7() -> void:
	tutorialContainer.show()
	
	addGeneratorMenu()
	tutorialButton.hide()
	tutorialButton.text = "Close"
	tutorialTitle.text = "Go to Powerplant panel"
	tutorialText.text = "Your ship also contains a Powerplant that produces power based on time travelled. Go to the powerplant control panel with the right arrow key"
	switchedMenu.connect(tutorialStage8)
	
func tutorialStage8() -> void:
	tutorialContainer.show()
	if currentMenu != 2:
		return
	switchedMenu.disconnect(tutorialStage8)
	tutorialTitle.text = "The Powerplant"
	tutorialButton.text = "Close"
	tutorialText.text = "You only start with a tiny amount of power in your battery. Spend that on a reactor to gain more power while you travel. \nEnergy can be used in the three tabs you see at the top to upgrade yourself and your powerplant"
	generatorMenu.generatorBought.connect(tutorialStage9, 4)
	
func tutorialStage9() -> void:
	tutorialContainer.show()
	
	tutorialTitle.text = "Combat again"
	radar.deploying = false
	tutorialButton.text = "Close"
	tutorialText.text = "Go to the next planet to try your new items, new gun and produce some power for your ship."
	radar.deploy.connect(tutorialStage10, 4)

func tutorialStage10(_dist) -> void:
	tutorialContainer.show()
	radar.selectedPlanet.difficulty = 0
	
	tutorialContainer.hide()
	tree_entered.connect(tutorialStage11, 4)
	
func tutorialStage11() -> void:
	call_deferred("disableRadarSelection")
	tutorialContainer.show()
	tutorialTitle.text = "Use earned power"
	tutorialText.text = "Go to the powerplant control panel to spend the power you have earned by travelling."
	tutorialButton.text = "Close"
	generatorMenu.energyChanged.connect(tutorialStage12, 4)
	
func tutorialStage12() -> void:
	tutorialContainer.show()
	tutorialTitle.text = "Death"
	tutorialText.text = "When you die on a planet you will lose all your items on your current body.\nHowever you ship will recreate you with cloning technology although you still lose the items you have obtained. The powerplant doesn't reset when you die"
	tutorialButton.show()
	tutorialButton.text = "Continue"
	tutorialButton.pressed.connect(tutorialStage13, 4)

func tutorialStage13() -> void:
	tutorialContainer.show()
	radar.deploying = false
	
	tutorialTitle.text = "Shop"
	tutorialButton.text = "Close"
	tutorialText.text = "You may have noticed the Spacedollars you have earned by kiling aliens. Spacedollars can be used on Intergalactic Trade Stations to buy powerful items.\n Go to the spacestation to use some of the money you've earned"
	radar.deploy.connect(tutorialStage14, 4)
	
func tutorialStage14(_dist) -> void:
	tutorialContainer.show()
	
	tutorialTitle.text = "Buy items"
	tutorialText.text = "Congratulations on beating the tutorial!\nYou have learned all you need to fair well in space\nTo start an actual run click \"End tutorial\" returning to the main menu and click \"New Save\""
	tutorialButton.text = "End Tutorial"
	tutorialButton.pressed.connect(finishTutorial, 4)
	
func finishTutorial() -> void:
	
	levelManager.get_tree().reload_current_scene()

func addTutorialPlanets() -> void:
	radar.planetsGenerator.planetContainer.queue_free()
	radar.planetsGenerator.planetContainer = load("res://Scenes/tutorial_planets.tscn").instantiate()
	radar.planetsGenerator.add_child(radar.planetsGenerator.planetContainer)
	radar.connectPlanetSignals()

func disableRadarSelection() -> void:
	radar.deploying = true
