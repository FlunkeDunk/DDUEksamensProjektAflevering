extends Node2D

@onready var player = $".."
@onready var fireRateTimer: Timer = $FireRateTimer
@onready var reloadTimer: Timer = $ReloadTimer
@onready var gunSprite = $GunSprite

@export var currentGun: Gun

var ammo: int

signal shoot
signal reloadSignal

func _ready() -> void:
	currentGun = Globals.inventory.currentGun
	changeGun(currentGun)
	if !currentGun:
		return
	ammo = currentGun.maxAmmo
	player.updateAmmo(ammo, currentGun.maxAmmo)

func _physics_process(delta):
	if !currentGun:
		return
	if Input.is_action_pressed("fire"):
		if fireRateTimer.is_stopped() and !get_parent().inventoryOpen:
			if ammo > 0:
				reloadTimer.stop()
				for i in max(delta*calculateFireRate(), 1):
					ammo -=1
					shootGun()
					if ammo == 0:
						reload()
						return
			if ammo == 0:
				reload()
	if Input.is_action_pressed("reload"):
		reload()
func shootGun() -> void:
	if !currentGun:
		return
	fireRateTimer.start(1/(calculateFireRate()))
	player.updateAmmo(ammo, currentGun.maxAmmo)
	var bulletPosition: Vector2 = player.position + (Vector2.RIGHT * currentGun.lenght).rotated(gunSprite.rotation)
	for shot in currentGun.bulletCount:
		var bulletInstance = currentGun.bulletNode.instantiate()
		bulletInstance.position = bulletPosition
		bulletInstance.rotation = gunSprite.rotation
		var bulletRotation: float = deg_to_rad(currentGun.spread) * (randf() * 2 -1) 
		bulletInstance.rotation += bulletRotation
		bulletInstance.damage *= currentGun.damageMultiplier
		bulletInstance.set_collision_mask_value(1, false)
		player.get_parent().call_deferred("add_child", bulletInstance)
	Globals.screenShake(currentGun.damageMultiplier * currentGun.bulletCount * 2)
	player.knockBack(currentGun.damageMultiplier * currentGun.bulletCount * 2/calculateFireRate(), Vector2.RIGHT.rotated(PI + gunSprite.rotation))
	SfxManager.play_sound(currentGun.shootSound)
	emit_signal("shoot")

func reload() -> void:
	if !currentGun:
		return
	if reloadTimer.is_stopped():
		SfxManager.play_sound(currentGun.reloadSound)
		reloadTimer.start(currentGun.reloadTime)

func changeGun(gun: Gun) -> void:
	currentGun = gun
	if gun:
		gunSprite.texture = gun.sprite
		gunSprite.offset = gun.offSet
		ammo = min(gun.maxAmmo, ammo)
		player.updateAmmo(ammo, currentGun.maxAmmo)
		return
	gunSprite.texture = null
	player.updateAmmo(0, 0)

func _on_reload_timer_timeout():
	if !currentGun:
		return
	reloadSignal.emit()
	ammo = currentGun.maxAmmo
	player.updateAmmo(ammo, currentGun.maxAmmo)

func calculateFireRate() -> float:
	return currentGun.fireRate*(Globals.stats.playerFireRateMult + Globals.stats.fireRateMultBuff)
