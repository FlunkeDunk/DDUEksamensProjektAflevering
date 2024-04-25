extends HBoxContainer

func updateChildren() -> void:
	pass

func addBuff(buff: Buff) -> void:
	for UI in get_children():
		if UI.type == buff.type:
			UI.addBuff(buff)
			return
	var buffUI = load("res://Scenes/buff_ui.tscn").instantiate()
	add_child(buffUI)
	buffUI.addBuff(buff)
