extends Node
class_name Buff
@export var time: float
@export var buffAmount: float
@export var sprite: Texture2D
@export var type: String
var timer: Timer = Timer.new()
var UI: Control

func _ready():
	add_child(timer)
	timer.timeout.connect(endBuff)


func addBuff() -> void:
	if type == "MOVESPEED":
		Globals.stats.speedMultBuff += buffAmount
	if type == "FIRERATE":
		Globals.stats.fireRateMultBuff += buffAmount

func endBuff() -> void:
	if type == "MOVESPEED":
		Globals.stats.speedMultBuff -= buffAmount
	if type == "FIRERATE":
		Globals.stats.fireRateMultBuff -= buffAmount
	queue_free()
	if UI != null:
		UI.endBuff(self)
