extends UpgradeButton


func whenBought() -> void:
	Globals.stats.playerDamageMult += scaling/100
