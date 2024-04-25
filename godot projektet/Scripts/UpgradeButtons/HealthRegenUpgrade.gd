extends UpgradeButton

func whenBought() -> void:
	Globals.stats.playerRegenMult += scaling
