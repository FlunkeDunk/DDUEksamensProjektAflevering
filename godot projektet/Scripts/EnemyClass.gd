extends CharacterBody2D
class_name Enemy

signal damageTaken(itself)
signal damageTakenNaive
signal died(itself)

@export var navigationAgent: NavigationAgent2D
@export var health: float = 10
@export var collisionDamage: float = 10
@export_range(1, 1000) var moneyDrop: int = 10
@export var sprite: AnimatedSprite2D
@export var rayCast: RayCast2D
@onready var hitTimer: Timer = Timer.new()
@onready var maxHealth: float = health
@onready var enemyDeath: AudioStream = load("res://Assets/AudioFiles/enemyDeath1.wav")
@export var speed: int = 40

var player: Node2D
var agroRange: int
var damageMult: float = 1
var dead: bool = false

var knockbackVelocity: Vector2 = Vector2(0, 0)

func _init():
	add_to_group("Enemy")
	add_to_group("Entity")

func _ready() -> void:
	rayCast.add_exception(player)
	hitTimer.one_shot = true
	hitTimer.timeout.connect(hitTimerTimeout)
	add_child(hitTimer)
	
func _physics_process(delta):
	
	rayCast.target_position = player.position - position
	knockbackVelocity = lerp(knockbackVelocity, Vector2(0, 0), delta * 6)
	if knockbackVelocity.length_squared() > 10:
		velocity = knockbackVelocity
	var collison = move_and_slide()
	if collison != null:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("Player"):
				hitPlayer()
	velocity = Vector2.ZERO
	
func hitPlayer() -> void:
	player.takeDamage(collisionDamage * damageMult)
	
func setNavigationMap(map: RID) -> void:
	navigationAgent.set_navigation_map(map)


func takeDamage(amount: float) -> void:
	damageTaken.emit(self)
	damageTakenNaive.emit()
	health -= amount
	sprite.material.set_shader_parameter("enabled", true)
	hitTimer.start(0.05)
	if health <= 0 or Globals.stats.oneshotChance >= randf():
		die()

func hitTimerTimeout() -> void:
	sprite.material.set_shader_parameter("enabled", false)

func die() -> void:
	if dead:
		return
	died.emit(self)
	dead = true
	queue_free()
	SfxManager.play_sound(enemyDeath)

func hasFullHealth() -> bool:
	return health == maxHealth

func knockBack(strength: float, dir: Vector2 ) -> void:
	knockbackVelocity += dir * strength * 8
	knockbackVelocity = knockbackVelocity.limit_length(75)
