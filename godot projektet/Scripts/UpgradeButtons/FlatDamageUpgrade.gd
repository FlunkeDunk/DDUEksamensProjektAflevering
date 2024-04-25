extends UpgradeButton


func whenBought() -> void:
	Globals.stats.playerFlatDamage += scaling
