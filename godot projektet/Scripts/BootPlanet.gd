extends TextureRect


func _ready():
	show()
	var tween: Tween
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.finished.connect(queue_free)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
