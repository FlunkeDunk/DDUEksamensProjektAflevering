extends Item
class_name Gun

@export_category("Stats")
@export var damageMultiplier: float = 1
@export var bulletCount: int = 1
@export var fireRate: float = 10
@export var spread: int = 10
@export var burstSize: int = 1
@export var reloadTime: float = 1
@export var maxAmmo: int = 10

@export_category("Visual")
@export var lenght: int = 24
@export var offSet: Vector2 = Vector2(9, 0)
@export var sprite: Texture2D

@export_category("Audio")
@export var shootSound: AudioStream = load("res://Assets/AudioFiles/basicShoot.wav")
@export var reloadSound: AudioStream = load("res://Assets/AudioFiles/laserReload.wav")
@export_category("Bullet")
@export var bulletNode: PackedScene


func _init():
	type = "Gun"

