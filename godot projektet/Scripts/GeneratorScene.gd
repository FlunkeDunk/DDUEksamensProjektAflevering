extends CombinationItemScene
class_name GeneratorScene

var energyGenerated: int

signal generated(energy)

func trigger() -> void:
	generated.emit((energyGenerated+Globals.stats.flatEnergyIncrease)*Globals.stats.playerEnergyMult)
