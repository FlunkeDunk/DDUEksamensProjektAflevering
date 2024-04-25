extends GeneratorScene

func _init():
	energyGenerated = load("res://Data/Generators/on_enemy_killed.tres").energyGenerated
	var correctSignal = getSpawner().enemyDiedNaiveSignal
	if !correctSignal.is_connected(trigger):
		correctSignal.connect(trigger)
