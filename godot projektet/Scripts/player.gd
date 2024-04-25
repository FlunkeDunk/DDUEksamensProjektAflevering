extends CharacterBody2D
class_name Player

@onready var regenTimer = %RegenTimer
@onready var health: float = 100 + Globals.stats.playerHealthIncrease
@onready var maxHealth: float = health
@onready var hitAnimationPlayer = $HitAnimationPlayer
@onready var playerAnimationPlayer = $PlayerAnimationPlayer
@onready var money: int = Globals.stats.money
@onready var camera2d: Camera2D = $Camera2D
@onready var sprite2d: AnimatedSprite2D = $Sprite2D
@onready var gun = $Gun
@onready var gunSprite = $Gun/GunSprite
@onready var hurtSound: AudioStream = load("res://Assets/AudioFiles/PlayerHurt.mp3")
@onready var playerDeath: AudioStream = load("res://Assets/AudioFiles/playerDeath1.wav")
@onready var gameOver: AudioStream = load("res://Assets/AudioFiles/gameOver.mp3")
@onready var lightOccluder = $LightOccluder2D


@export var ui: Control
@export var inventory: Control
@export var spawner: Node2D

signal playerDead
signal distanceTravelled(distance: float)
signal tookDamage



var speed: int = 80
var speedCap: int = 1000
var direction: Vector2
var inventoryOpen: bool = false
var invincibleTime: float = 2
var iFrames: int = 0
var knockbackVelocity: Vector2 = Vector2(0, 0)
var levelCleared: bool = false

var buffManager: BuffManager = BuffManager.new(self)



func _init():
	add_to_group("Player")
	add_to_group("Entity")
	motion_mode = MOTION_MODE_FLOATING

func _ready():
	Globals.stats.speedMultBuff = 0
	Globals.stats.fireRateMultBuff = 0
	spawner.allEnemiesKilled.connect(clearLevel)
	ui.updateHealth(health, maxHealth)
	ui.updateMoney(money)
	add_child(buffManager)
	inventory.gunChanged.connect(gun.changeGun)
	regenTimer.timeout.connect(regen)

func _process(delta):
	sprite2d.flip_h = gunSprite.flip_v
	lightOccluder.scale.x = -int(sprite2d.flip_h) * 2 + 1
	if direction.length_squared() > 0:
		playerAnimationPlayer.play("run")
	elif velocity.length_squared() > 0.1:
		playerAnimationPlayer.stop()
	else:
		playerAnimationPlayer.play("idle")
	if !levelCleared:
		queue_redraw()

func _physics_process(delta):
	iFrames -= 1
	if iFrames == 0:
		hitAnimationPlayer.stop()
	elif iFrames == invincibleTime * 0.5 * 60:
		Engine.set_time_scale(1)
	if Input.is_action_just_pressed("OpenInventory"):
		inventoryOpen = !inventoryOpen
	if Input.is_action_just_pressed("ui_cancel"):
		inventoryOpen = false
	direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	velocity = direction.normalized()
	velocity *= min(speed * (Globals.stats.playerSpeedMult + Globals.stats.speedMultBuff), speedCap)
	velocity += knockbackVelocity
	move_and_slide()
	if get_position_delta().length_squared() > 0:
		distanceTravelled.emit(get_position_delta().length())
	knockbackVelocity = lerp(knockbackVelocity, Vector2(0, 0), delta * 10)

func updateHealth(amount) -> void:
	health = max(min(maxHealth, health + amount), 0)
	ui.updateHealth(health, maxHealth)

func takeDamage(amount) -> void:
	if iFrames > 0:
		return
	Engine.set_time_scale(0.4)
	SfxManager.play_sound(hurtSound)
	iFrames = int(invincibleTime) * 60
	Globals.screenShake(20)
	hitAnimationPlayer.play("hit")
	set_self_modulate(Color(2.0, 2.0, 2.0))
	updateHealth(-amount)
	tookDamage.emit()
	if health <= 0:
		die()
		SfxManager.play_sound(playerDeath)



func addMoney(amount) -> void:
	money += amount
	Globals.stats.score += 5*amount
	ui.updateMoney(money)

func heal(amount) -> void:
	updateHealth(amount)

func healPercentHp(percent) -> void:
	heal((maxHealth)*percent/100)

func updateAmmo(ammo: int, maxAmmo: int) -> void:
	ui.updateAmmo(ammo, maxAmmo)

func die() -> void:
	Engine.set_time_scale(1)
	Globals.screenShake(200)
	playerDead.emit()
	SfxManager.play_music(load("res://Assets/AudioFiles/gameOver.mp3"))
	

func regen() -> void:
	heal(Globals.stats.playerRegenMult)

func knockBack(strength: float, dir: Vector2 ) -> void:
	knockbackVelocity += dir * strength * 10
	knockbackVelocity = knockbackVelocity.limit_length(50)

func clearLevel() -> void:
	levelCleared = true
	queue_redraw()

func _draw() -> void:
	if levelCleared or !Globals.settings.showArrow:
		return
	var origin = Vector2.ZERO
	var enemyPosition: Vector2 = spawner.getClosestEnemyPosition(position)-position
	var clr = Color.RED
	var headAngle: float = 0.3
	var arrowLength: float = 20
	var headLength: float = 3
	var headPosition = enemyPosition.normalized()*arrowLength
	var arrowWidth: float = 0.5
	draw_line(origin, headPosition, clr, arrowWidth)
	var head : Vector2 = -headPosition.normalized() * headLength
	draw_line(headPosition, headPosition + head.rotated(headAngle),  clr, arrowWidth)
	draw_line(headPosition, headPosition + head.rotated(-headAngle),  clr, arrowWidth)


