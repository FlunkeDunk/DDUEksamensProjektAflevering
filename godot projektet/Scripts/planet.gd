extends SpaceObject
class_name Planet


@export var randomColor: Color = Color(randf(), randf(), randf(), 1.0)
@export var randomRotaion: float = randf() * 2 * PI
@export var scaleFactor: float = randf()*0.5 + 0.5

var syllables: Array = ["xorg", "sti", "an", "be", "lan", "gyl", "ogg", "flo", "nix", "zy", "gho", "ri", "wa", "u", "per", "ing", "on", "com", "tion", "ex", "oth", "num", "nit", "cov", "_", "qxi", "quan", "mi", "lum", "bou"]
var weathers: Array = ["Windy", "Stormy", "Flooded", "Chaotic", "Clear", "Sunny", "Splendid"]
var atmospheres : Array = ["Toxic", "Earthlike", "None"]
var size: int
var mass: int
var temperature: int
var weather: String
var atmosphere: String

@onready var collisionShape: CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	super._ready()
	generateName()
	setup()

func setup() -> void:
	super.setup()
	planetSprite = $SubViewportContainer/SubViewport/PlanetSprite
	outlineHolder = $SubViewportContainer
	planetSprite.rotation = randomRotaion
	planetSprite.scale = Vector2(scaleFactor, scaleFactor) * 0.07
	collisionShape.scale = Vector2(scaleFactor, scaleFactor)
	outlineHolder.material.set_shader_parameter("modulate", randomColor)
	

func generateName() -> void:
	objectName = ""
	var syllableCount: int = randi() % 3 + 2
	for i in syllableCount:
		objectName += syllables[randi() % syllables.size()]
	if randi() % 3 == 2:
		objectName += str(randi()%100) 
	objectName = objectName.capitalize()

func generateStats() -> void:
	size = round(scaleFactor * 10000)
	mass = round(scaleFactor * 10000000 * (randf() * 2 + 1))
	temperature = max(-273, (randomColor.r * 255 -  randomColor.b * 255) * (randomColor.g * 0.5 + 0.5) + 30)
	weather = weathers[randi() % weathers.size()]
	atmosphere = atmospheres[randi() % atmospheres.size()]


func setDescription() -> void:
	objectDescription = "Diameter: " + str(size) + " km"+ "\nMass: " + str(mass) + " megaton"+ "\nTemperature: " + str(temperature) + " degrees"+ "\nWeather: " + str(weather) + "\nAtmosphere: " + str(atmosphere)
	
func greyOut() -> void:
	outlineHolder.material.set_shader_parameter("modulate", randomColor * 0.5)
