extends GeneratorScene

func _init():
	energyGenerated = load("res://Data/Generators/on_damage_taken.tres").energyGenerated
	var correctSignal = getPlayer().tookDamage
	if !correctSignal.is_connected(trigger):
		correctSignal.connect(trigger)
