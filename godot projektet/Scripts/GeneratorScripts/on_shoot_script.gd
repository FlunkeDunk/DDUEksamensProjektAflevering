extends GeneratorScene

func _init():
	energyGenerated = load("res://Data/Generators/on_shoot.tres").energyGenerated
	var correctSignal = getGun().shoot
	if !correctSignal.is_connected(trigger):
		correctSignal.connect(trigger)
