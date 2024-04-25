extends UpgradeButton


func whenBought() -> void:
	Globals.stats.playerEnergyMult += scaling/100
