extends EffectScene

func _init():
	energyNeeded = load("res://Data/Effects/fire_rate_buff.tres").energyNeeded

func doEffect() -> void:
	var buff: Buff = load("res://Scenes/Buffs/fire_rate_buff.tscn").instantiate()
	getBuffManager().addBuff(buff)
