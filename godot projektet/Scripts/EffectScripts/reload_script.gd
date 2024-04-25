extends EffectScene

func _init():
	energyNeeded = load("res://Data/Effects/reload.tres").energyNeeded

func doEffect() -> void:
	getGun()._on_reload_timer_timeout()

	
