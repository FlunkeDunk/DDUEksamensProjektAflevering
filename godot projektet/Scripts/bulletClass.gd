extends RigidBody2D
class_name Projectile

signal enemyHit

@export var damage: float = 5
@export var lifeTime: float = 1
@export var speed: float = 4
@export var distanceTravelled: float = 0
@export var canSplit: bool = true
@export var hitEnemySound: AudioStream = load("res://Assets/AudioFiles/basicHit.wav")
@export var hitSound: AudioStream = load("res://Assets/AudioFiles/basicBulletHit.wav")
@onready var deathTimer: Timer = Timer.new()
@onready var bulletSprite: Sprite2D = $SubViewportContainer/SubViewport/BulletSprite
@onready var subViewportContainer: SubViewportContainer = $SubViewportContainer

func _ready():
	add_child(deathTimer)
	deathTimer.connect("timeout", die)
	deathTimer.start(lifeTime)
	

func _process(delta):
	subViewportContainer.rotation = -rotation
	subViewportContainer.position = round(position) - position - subViewportContainer.size/2
	bulletSprite.rotation = rotation
	
func _physics_process(delta):
	distanceTravelled += speed
	var collison = move_and_collide(Vector2.from_angle(rotation) * speed)
	if collison != null:
		if collison.get_collider().is_in_group("Entity"):
			hitEnemy(collison.get_collider())
		SfxManager.play_sound(hitSound)
		die()
		
func hitEnemy(entity: Node) -> void:
	var damageDealt: float = (damage)
	if !entity.is_in_group("Player"):
		enemyHit.emit()
		damageDealt *= Globals.stats.playerDamageMult + Globals.stats.playerFlatDamage
		SfxManager.play_sound(hitEnemySound)
		if Globals.stats.bulletsExplode:
			explode(damageDealt)
		if Globals.stats.damageScaleWithDistance:
			damageDealt *= 1+distanceTravelled/100
		if entity.hasFullHealth():
			damageDealt *= Globals.stats.fullHealthDamage
		if Globals.stats.bulletsSplit and canSplit:
			split(entity)
		entity.knockBack(damageDealt, (entity.position - position).normalized())
	entity.takeDamage(damageDealt)
	
func die() -> void:
	queue_free()

func explode(explosionDamage) -> void:
	var explosion = load("res://Scenes/particle_explosion.tscn").instantiate()
	var explosionScale = explosionDamage / 50
	explosion.damage = explosionDamage
	explosion.position = position
	explosion.explosionScale = explosionScale
	get_parent().add_child(explosion)

func split(enemy) -> void:
	for i in 2:
		var bullet: Projectile = load(scene_file_path).instantiate()
		bullet.rotation = rotation - deg_to_rad(30 - 60 * i)
		bullet.add_collision_exception_with(enemy)
		bullet.damage = damage/2
		bullet.set_collision_mask_value(1, false)
		bullet.position = position
		bullet.canSplit = false
		get_parent().add_child(bullet)
