extends Node2D
class_name SpaceObject


@export var sound: AudioStream
@export var outlineHolder: Node
@export var cleared: bool = false
@export var objectName: String = "BasePlanetNam"
@export var objectDescription: String = ""
@export var hasReadied: bool = false

var planetSprite: Sprite2D
var difficulty: float
var hovered: bool = false
var selected: bool = false

@onready var area2D: Area2D = $Area2D

signal clicked(objectName, description, planet)
signal deselected
	
func _ready():
	hovered = false
	selected = false
	hasReadied = true
	setup()
func setup() -> void:
	if objectName == "BasePlanetName":
		generateName()
	generateStats()
	setDescription()
	if !area2D.mouse_entered.is_connected(hover):
		area2D.mouse_entered.connect(hover)
		area2D.mouse_exited.connect(unhover)

func hover() -> void:
	hovered = true

func unhover() -> void:
	hovered = false

func generateName() -> void:
	pass

func setDescription() -> void:
	pass

func select() -> void:
	selected = true
	SfxManager.play_sound(sound)
	clicked.emit(objectName, objectDescription, self)
	outlineHolder.material.set_shader_parameter("enabled", true)

func deselect() -> void:
	selected = false
	deselected.emit()
	outlineHolder.material.set_shader_parameter("enabled", false)

func _unhandled_input(event) -> void:
	if cleared:
		return
	if event.is_action_released("fire"):
		if selected:
			deselect()
		elif hovered:
			call_deferred("select")

func generateStats() -> void:
	pass

func clear() -> void:
	cleared = true
	greyOut()
	
func greyOut() -> void:
	pass

func _enter_tree() -> void:
	if !hasReadied:
		return
	selected = false
	hovered = false
	outlineHolder.material.set_shader_parameter("enabled", false)
