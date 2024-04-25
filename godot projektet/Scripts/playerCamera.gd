extends Camera2D
@onready var player = $".."
@onready var screen: Viewport = get_tree().get_root().get_viewport()
@export_range(0, 50) var smoothSpeed: float

var shakeStrengh: float = 0

func _ready():
	Globals.playerCamera = self
var smoothPos: Vector2 = global_position

func _process(delta):
	var targetPos: Vector2
	var shake = Vector2.RIGHT.rotated(randf() * TAU) * randf() * shakeStrengh
	if shakeStrengh > 0:
		shakeStrengh = lerpf(shakeStrengh, 0, delta * 8)
	if !get_parent().inventoryOpen:
		targetPos = lerp(player.global_position, get_global_mouse_position(), 0.3)
	else:
		targetPos = player.global_position
	targetPos += shake
	smoothPos = lerp(smoothPos, targetPos, delta * smoothSpeed)
	global_position = smoothPos
	
func screenShake(strength: int) -> void:
	shakeStrengh = max(shakeStrengh, strength)
