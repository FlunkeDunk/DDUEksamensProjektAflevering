extends EffectScene

func _init():
	energyNeeded = load("res://Data/Effects/heal_amount.tres").energyNeeded

func doEffect() -> void:
	getPlayer().heal(10)
