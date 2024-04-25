extends UpgradeButton

@export var capacity: UpgradeButton

func whenBought() -> void:
	capacity.updateScaling(scaling)


