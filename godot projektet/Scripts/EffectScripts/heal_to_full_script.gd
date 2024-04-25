extends EffectScene

var healTimer: Timer = Timer.new()

func _init():
	set_process(true)
	add_child(healTimer)
	healTimer.one_shot = true
	energyNeeded = load("res://Data/Effects/heal_to_full.tres").energyNeeded

func _process(delta):
	if !healTimer.is_stopped():
		getPlayer().healPercentHp(100*delta/healTimer.wait_time)

func doEffect() -> void:
	healTimer.start(5)
	#getPlayer().healPercentHp(100)
