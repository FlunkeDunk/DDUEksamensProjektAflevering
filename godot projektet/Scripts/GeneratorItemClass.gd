extends Item
class_name GeneratorItem

@export var energyGenerated: int
@export var nodeScript: Script

func _init() -> void:
	type = "Generator"

func getDescription() -> String:
	var descriptionArray = description.split("amount")
	return descriptionArray[0] + str(snapped((energyGenerated+Globals.stats.flatEnergyIncrease)*Globals.stats.playerEnergyMult, 0.1)) + descriptionArray[1]
