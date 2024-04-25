extends GeneratorScene

func _init():
	energyGenerated = load("res://Data/Generators/on_reload.tres").energyGenerated
	var correctSignal = getGun().reloadSignal
	if !correctSignal.is_connected(trigger):
		correctSignal.connect(trigger)
