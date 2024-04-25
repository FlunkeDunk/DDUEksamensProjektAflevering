extends UpgradeButton

@export var mult: UpgradeButton

func whenBought() -> void:
	generatorMenu.multBase += 1
	mult.updateText()
