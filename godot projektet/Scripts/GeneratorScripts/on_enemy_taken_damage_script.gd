extends GeneratorScene

func _init():
	energyGenerated = load("res://Data/Generators/on_enemy_taken_damage.tres").energyGenerated
	var correctSignal = getSpawner().enemyDamageTakenSignal
	if !correctSignal.is_connected(trigger):
		correctSignal.connect(trigger.bind())
