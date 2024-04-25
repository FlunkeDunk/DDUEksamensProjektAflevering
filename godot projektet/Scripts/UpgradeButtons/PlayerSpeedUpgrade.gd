extends UpgradeButton

func whenBought() -> void:
	Globals.stats.playerSpeedMult += scaling/100
