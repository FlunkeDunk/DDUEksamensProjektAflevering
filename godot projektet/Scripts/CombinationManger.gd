extends Node2D


@onready var player = $"../Player"
@onready var gun = $"../Player/Gun"
@onready var spawner = $"../Spawner"
@onready var playerUI = player.ui
@onready var inventory = player.inventory


func _ready() -> void:
	inventory.combinationsChanged.connect(update)
	update()

func update() -> void:
	var combinations = Globals.inventory.combinations
	while combinations.size() > get_child_count():
			var newCombinationNode = load("res://Scenes/combination_node.tscn").instantiate()
			newCombinationNode.energyChanged.connect(updateUI)
			add_child(newCombinationNode)
	while combinations.size() < get_child_count():
		get_child(get_child_count()-1).free()
	for i in get_child_count():
		var child = get_child(i)
		if combinations[i].isFull():
			child.combination = combinations[i]
		else:
			child.combination = null
		child.update()

func updateUI() -> void:
	var progressions:Array[int] = []
	for combination in get_children():
		var effect = combination.effectScene
		var progession = (float(effect.currentEnergy) / float(effect.energyNeeded) * 100)
		progressions.append(int(progession))
	playerUI.updateEffectProgression(progressions)
