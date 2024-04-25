class_name EnemyWanderState
extends State

@export var enemy: Enemy
@export var animationPlayer: AnimationPlayer
@export var sprite: AnimatedSprite2D
@export var rayCast: RayCast2D
@export var chaseState: State

@onready var navigationAgent: NavigationAgent2D = enemy.navigationAgent
@onready var pathFindingTimer: Timer = Timer.new()
func enterState() -> void:
	pathFindingTimer.timeout.connect(updatePathFindingTarget)
	navigationAgent.target_reached.connect(targetReached)
	enemy.damageTakenNaive.connect(finish)
	add_child(pathFindingTimer)
	pathFindingTimer.start(5)
	updatePathFindingTarget()
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)
	set_process(true)

func exitState() -> void:
	set_physics_process(false)
	set_process(false)
	pathFindingTimer.timeout.disconnect(updatePathFindingTarget)
	navigationAgent.target_reached.disconnect(targetReached)
	enemy.damageTakenNaive.disconnect(finish)
	
func finish() -> void:
	stateFinished.emit(chaseState)

func _physics_process(delta):
	var vectorToNextPoint: Vector2 = enemy.navigationAgent.get_next_path_position()
	enemy.velocity += (-enemy.position + vectorToNextPoint).normalized() * enemy.speed * 0.5
	
	if !rayCast.is_colliding() and rayCast.target_position.length_squared() < 150*150:
		finish()

func _process(delta):
	if enemy.velocity.x < 0:
		sprite.flip_h = true
	elif enemy.velocity.x > 0:
		sprite.flip_h = false
	
	if enemy.velocity.length_squared() > 0:
		animationPlayer.play("run")
	else:
		animationPlayer.play("idle")

func updatePathFindingTarget() -> void:
	var spawner: Spawner = enemy.get_parent()
	var targetPosition = spawner.getPositionOutsideRange(enemy.position, 100, false)
	navigationAgent.set_target_position(targetPosition)
	
func targetReached() -> void:
	navigationAgent.target_position = enemy.position
