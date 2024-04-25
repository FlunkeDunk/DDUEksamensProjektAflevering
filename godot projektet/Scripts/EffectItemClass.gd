extends Item
class_name EffectItem

@export var energyNeeded: int = 10
@export var nodeScript: Script

func _init() -> void:
	type = "Effect"
	

func getDescription() -> String:
	return description +"\n\nEnergy required: " + str(snapped(energyNeeded - Globals.stats.flatEffectEnergyDecrease, 0.1))
