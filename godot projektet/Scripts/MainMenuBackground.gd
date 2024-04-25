extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	var tween: Tween = create_tween()
	var tweenTime: float = 120
	tween.set_loops()
	tween.tween_property(self, "position", Vector2(-9458, -5291), tweenTime)
	tween.tween_property(self, "position", Vector2(0, 0), tweenTime)
