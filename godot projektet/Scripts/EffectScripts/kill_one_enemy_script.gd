extends EffectScene

#var oneshots: int = 0

func _init():
	energyNeeded = load("res://Data/Effects/kill_one_enemy.tres").energyNeeded

func doEffect() -> void:
	getSpawner().enemyDamageTakenWithEnemy.connect(killEnemy, 8)

func killEnemy(enemy) -> void:
	if enemy.dead:
		return
	enemy.die()
	getSpawner().enemyDamageTakenWithEnemy.disconnect(killEnemy)
