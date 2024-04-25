extends Node2D
class_name Explosion

var damage: float
var explosionScale: float
var explosionSound: AudioStream = load("res://Assets/AudioFiles/basicExplosion.wav")

@onready var area2D: Area2D = %Area2D
@onready var particles = %GPUParticles2D

func _ready():
	if Globals.settings.lowGraphics:
		particles.amount = 10
	SfxManager.play_sound(explosionSound)
	explosionScale = max(min(explosionScale, 1), 0.1)
	area2D.scale *= pow(explosionScale * 10, 0.5)
	particles.scale *= explosionScale
	for body in area2D.get_overlapping_bodies():
		_on_area_2d_body_entered(body)


func _on_area_2d_body_entered(body):
	body.takeDamage(damage * Globals.stats.playerDamageMult + Globals.stats.playerFlatDamage)
	body.knockBack(damage * Globals.stats.playerDamageMult + Globals.stats.playerFlatDamage, (body.position - position).normalized())
