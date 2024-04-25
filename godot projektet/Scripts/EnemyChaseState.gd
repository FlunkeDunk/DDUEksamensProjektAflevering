class_name EnemyChaseState
extends State

@export var enemy: Enemy
@export var animationPlayer: AnimationPlayer
@export var sprite: AnimatedSprite2D

@onready var pathFindingTimer: Timer = Timer.new()

func enterState() -> void:
	set_physics_process(true)
	set_process(true)
	add_child(pathFindingTimer)
	pathFindingTimer.start(0.1)
	pathFindingTimer.timeout.connect(updatePathFindingTarget)
	animationPlayer.speed_scale = 2

func exitState() -> void:
	set_physics_process(false)
	set_process(false)
	pathFindingTimer.stop()
	
func _physics_process(delta):
	var vectorToNextPoint: Vector2 = enemy.navigationAgent.get_next_path_position()
	enemy.velocity += (-enemy.position + vectorToNextPoint).normalized() * enemy.speed
	
func _process(delta):
	sprite.flip_h = enemy.position.x - enemy.player.position.x > 0
	animationPlayer.play("run")

func updatePathFindingTarget() -> void:
	enemy.navigationAgent.set_target_position(enemy.player.position)
