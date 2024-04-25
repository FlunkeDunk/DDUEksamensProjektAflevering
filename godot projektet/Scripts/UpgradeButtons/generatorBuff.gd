extends UpgradeButton

@export var powercore: UpgradeButton

func whenBought() -> void:
	generatorMenu.generatorBoost += scaling/100
	powercore.updateText()
