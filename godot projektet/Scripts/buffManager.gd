extends Node
class_name BuffManager

@onready var buffContainer: Node = getBuffContainer()
var player: Player
var connected: bool = false

func _init(p):
	self.player = p

func addBuff(buff: Buff) -> void:
	add_child(buff)
	buff.addBuff()
	if !Globals.stats.artifactsResetOnReload:
		buff.timer.start(buff.time)
	elif !connected:
		player.gun.reloadSignal.connect(removeBuffs)
		connected = true
	buffContainer.addBuff(buff)


func removeBuffs() -> void:
	for buff in get_children():
		buff.endBuff()
		remove_child(buff)

func getBuffContainer() -> HBoxContainer:
	return get_parent().ui.buffContainer
