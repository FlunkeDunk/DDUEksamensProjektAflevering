extends Control
class_name PlanetSelection

@onready var levelManager: Control = get_tree().get_root().get_node("MainScene/LevelManager/")
@onready var planetsGenerator = %PlanetsGenerator
@onready var planetNameLabel = %PlanetName
@onready var planetDescriptionLabel = %PlanetDescription
@onready var planetsBackground = %PlanetsBackground
@onready var deployButton = %DeployButton
@onready var shipSprite = %ShipSprite
@onready var shipMenu = $"../.."
@onready var deploySound: AudioStream = load("res://Assets/AudioFiles/UIBeepLighter.mp3")
@onready var shipLanding: AudioStream = load("res://Assets/AudioFiles/shipLanding.mp3")
@onready var planetsControl = %PlanetsControl

signal deploy
var deploying: bool = false
var selectedPlanet: SpaceObject

func _ready():
	Globals.resetGlobalStats.connect(resetDistance)
	planetsGenerator.planetsGeneratedSignal.connect(connectPlanetSignals)
	planetsGenerator.setup()
	planetdeselected()
	
func connectPlanetSignals() -> void:
	for planet in planetsGenerator.planetContainer.get_children():
		if planet.clicked.is_connected(planetSelected):
			planet.clicked.disconnect(planetSelected)
			planet.deselected.disconnect(planetdeselected)
		planet.clicked.connect(planetSelected)
		planet.deselected.connect(planetdeselected)

func planetSelected(planetName, description, planet) -> void:
	if deploying:
		return
	planetNameLabel.text = planetName
	selectedPlanet = planet
	var distance: float = shipSprite.global_position.distance_to(selectedPlanet.global_position)
	var time: String = "Traveltime: " + str(round(distance/shipMenu.travelSpeed)) + " days"
	planetDescriptionLabel.text = description + "\nDistance: " + str(int((shipSprite.global_position.distance_to(planet.global_position)))) + " Gigameter\n" + time
	
	deployButton.disabled = false

func planetdeselected() -> void:
	planetNameLabel.text = "No planet Selected"
	planetDescriptionLabel.text = ""
	deployButton.disabled = true

func _on_deploy_button_pressed():
	deploying = true
	SfxManager.play_sound(deploySound)
	SfxManager.play_sound(shipLanding)
	selectedPlanet.deselect()
	deployButton.disabled = true
	var distance = shipSprite.global_position.distance_to(selectedPlanet.global_position)
	Globals.stats.totalDistance += distance
	selectedPlanet.difficulty = Globals.stats.totalDistance
	await planetsGenerator.tweenPlanetContainer(selectedPlanet.position)
	levelManager.playFade()
	await get_tree().create_timer(0.6).timeout
	emit_signal("deploy", distance/shipMenu.travelSpeed)
	selectedPlanet.clear()
	levelManager.loadSpaceObject(selectedPlanet)
	SfxManager.stopAmbience()

func savePlanets() -> void:
	var packedScene: PackedScene = PackedScene.new()
	packedScene.pack(planetsGenerator)
	ResourceSaver.save(packedScene, "user://planets.tscn")

func loadPlanets() -> void:
	var packedScene: Control = ResourceLoader.load("user://planets.tscn").instantiate()
	planetsGenerator.queue_free()
	planetsControl.add_child(packedScene)
	planetsGenerator = packedScene
	planetsGenerator.planetsGeneratedSignal.connect(connectPlanetSignals)

func _enter_tree():
	deploying = false

func resetDistance() -> void:
	Globals.stats.totalDistance = 0
