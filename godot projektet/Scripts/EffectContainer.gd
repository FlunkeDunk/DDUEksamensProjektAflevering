extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func updateChildren() -> void:
	var combinations = Globals.inventory.combinations
	while combinations.size() > get_child_count():
			var newEffectUI = load("res://Scenes/EffectUI.tscn").instantiate()
			add_child(newEffectUI)
	while combinations.size() < get_child_count():
		get_child(get_child_count()-1).free()
	for i in get_child_count():
		var child = get_child(i)
		if combinations[i].effect != null:
			child.effect = combinations[i].effect
			child.updateSprite()
			child.show()
		else:
			child.hide()
func updateEffectProgression(progresisons: Array[int]) -> void:
	for i in get_child_count():
		get_child(i).updateProgressBar(progresisons[i])
