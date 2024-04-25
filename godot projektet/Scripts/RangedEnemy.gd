extends Enemy

@export var bulletNode: PackedScene
@onready var enemyShoot: AudioStream = load("res://Assets/AudioFiles/enemyRanged.wav")

var fireRate: float = 1
var length: int = 10
var spread: int = 10

func shoot() -> void:
	var bulletInstance = bulletNode.instantiate()
	var bulletRotation: float = (player.position - position).angle()
	bulletInstance.position = position + (Vector2.RIGHT * length).rotated(bulletRotation)
	bulletInstance.rotation = bulletRotation
	bulletInstance.rotation += deg_to_rad(spread) * (randf() * 2 -1)
	bulletInstance.damage *= damageMult
	bulletInstance.set_collision_mask_value(2, false)
	get_tree().get_root().call_deferred("add_child", bulletInstance)
	SfxManager.play_sound(enemyShoot)
