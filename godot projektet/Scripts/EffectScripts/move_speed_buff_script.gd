extends EffectScene

func _init():
	energyNeeded = load("res://Data/Effects/move_speed_buff.tres").energyNeeded

func doEffect() -> void:
	var buff: Buff = load("res://Scenes/Buffs/move_speed_buff.tscn").instantiate()
	getBuffManager().addBuff(buff)
