extends UpgradeButton

func whenBought():
	generatorMenu.energyLimit += scaling

func updateScaling(change) -> void:
	priceScaling -= change
	price = basePrice*pow(priceScaling, bought)
	updateText()
