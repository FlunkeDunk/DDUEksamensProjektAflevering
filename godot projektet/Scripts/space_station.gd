extends SpaceObject
class_name SpaceStation


# Called when the node enters the scene tree for the first time.
func setup():
	planetSprite = $Sprite2D
	objectName = "Intergalactic Trade Station " + str(randi() % 1000)
	if randf() > 0.5:
		objectName += "B"
	outlineHolder = planetSprite
	super.setup()

func greyOut() -> void:
	planetSprite.material.set_shader_parameter("modulate", Color(0.5, 0.5, 0.5, 1.0))
