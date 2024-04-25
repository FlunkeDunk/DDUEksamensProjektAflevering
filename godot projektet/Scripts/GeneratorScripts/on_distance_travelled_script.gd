extends GeneratorScene

var distance: float = 0

func _init():
	energyGenerated = load("res://Data/Generators/on_distance_travelled.tres").energyGenerated
	var correctSignal = getPlayer().distanceTravelled
	if !correctSignal.is_connected(distanceTravelled):
		correctSignal.connect(distanceTravelled)
	
func distanceTravelled(amount: float) -> void:
	distance += amount
	while distance >= 15:
		distance -= 15
		trigger()
