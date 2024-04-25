extends Control


@onready var textureRect = %TextureRect
@onready var outline = textureRect.material
@onready var shopItem: AudioStream = load("res://Assets/AudioFiles/buySucceed.wav")

signal selected(item, itself)

var item: Item

var hovered: bool = false
func _init():
	z_index = 1

func _process(delta):
	textureRect.texture = item.inventorySprite
	textureRect.global_position = round(textureRect.global_position)

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false

func _on_pressed():
	selected.emit(item, self)
	SfxManager.play_sound(shopItem)
