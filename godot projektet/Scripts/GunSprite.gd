extends Sprite2D

@onready var player = $"../.."


var gunOffset: Vector2 = Vector2(9, -2)

func _process(delta) -> void:
	flip_v = abs(rotation) > PI/2
	offset = gunOffset
	offset.y = gunOffset.y * (int(abs(rotation) > PI/2)*2-1)
	rotation = (player.get_global_mouse_position()-player.global_position+player.get_real_velocity()/60).angle()

