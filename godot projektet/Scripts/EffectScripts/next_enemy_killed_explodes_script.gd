extends EffectScene

#var explosionStacked: int = 0
var damage = 30
var explosionScale = 0.8
func _init():
	energyNeeded = load("res://Data/Effects/next_enemy_killed_explodes.tres").energyNeeded

func doEffect() -> void:
	#explosionStacked += 1 
	#if !getSpawner().enemyDiedSignal.is_connected(spawnExplosion):
	getSpawner().enemyDiedSignal.connect(spawnExplosion, 8)

func spawnExplosion(enemy: Enemy) -> void:
	var explosion = load("res://Scenes/particle_explosion.tscn").instantiate()
	explosion.damage = damage
	explosion.explosionScale = explosionScale
	explosion.position = enemy.position
	get_tree().get_root().call_deferred("add_child", explosion)
	#explosionStacked -= 1
	#if explosionStacked <= 0:
	getSpawner().enemyDiedSignal.disconnect(spawnExplosion)
