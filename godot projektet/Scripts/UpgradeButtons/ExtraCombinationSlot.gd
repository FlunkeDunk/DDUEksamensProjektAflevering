extends UpgradeButton

func whenBought() -> void:
	Globals.inventory.addCombinationSlot()
