extends Control
@onready var textureRect = $TextureRect

@export var effect: EffectItem
@onready var progressBar = $TextureProgressBar

func _ready() -> void:
	progressBar.value = 100

func updateSprite() -> void:
	textureRect.texture = effect.inventorySprite
	
func updateProgressBar(value: int) -> void:
	if value != 0:
		var tween
		if tween:
			tween.kill() # Abort the previous animation.
		tween = create_tween()
		tween.tween_property(progressBar, "value", 100-value, 0.1)
	else:
		progressBar.value = 100
