extends EffectScene

func _init():
	energyNeeded = load("res://Data/Effects/shoot_again.tres").energyNeeded

func doEffect() -> void:
	await get_tree().create_timer(0.05).timeout
	getGun().shootGun()


