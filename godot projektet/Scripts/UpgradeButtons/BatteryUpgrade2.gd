extends UpgradeButton


func _ready():
	super._ready()
	generatorMenu.generatorBought.connect(updateEffect)

func whenBought() -> void:
	generatorMenu.energyLimit += scaling*generatorMenu.generatorsBought

func updateEffect() -> void:
	generatorMenu.energyLimit += bought*scaling
