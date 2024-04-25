extends Node2D

@export var item: Item
@onready var sprite = $Sprite2D
@onready var itemPickUp: AudioStream = load("res://Assets/AudioFiles/itemPickUp.mp3")


var scaleFactor: float = 1

var spriteOffset: float = 0
var rarityColor: Dictionary = {
	0 : Color(0.7, 0.7, 0.7),
	1 : Color(0.3, 0.9, 0.25),
	2 : Color(0.0, 0.5, 1.0),
	3 : Color(0.5, 0.1, 0.9),
	4 : Color(1.0, 0.7, 0.25),
}

func _ready():
	if item is Gun:
		sprite.texture = item.sprite
	else:
		sprite.texture = item.inventorySprite
		sprite.scale /= 6
	

func _process(delta):
	spriteOffset += delta
	sprite.offset.y = sin(spriteOffset) * 3 / sprite.scale.x

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		pickUp()
		SfxManager.play_sound(itemPickUp)
		
func pickUp() -> void:
	if item is Artifact:
		Globals.stats.artifactObtained(item)
		queue_free()
		return
	elif item is Gun:
		Globals.stats.gunObtained(item)
	
	Globals.inventory.addItem(item)
	queue_free()
