extends UpgradeButton

func whenBought() -> void:
	Globals.stats.playerHealthIncrease += int(scaling)
