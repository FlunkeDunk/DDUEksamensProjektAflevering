extends Node2D

var combination: Combination

signal energyChanged()

@onready var generatorScene = $GeneratorScene
@onready var effectScene = $EffectScene


func update() -> void:
	generatorScene.free()
	effectScene.free()
	generatorScene = Node2D.new()
	add_child(generatorScene)
	effectScene = Node2D.new()
	add_child(effectScene)
	if combination == null:
		generatorScene.set_script(load("res://Scripts/emptyScript.gd"))
		effectScene.set_script(load("res://Scripts/emptyScript.gd"))
		return
	generatorScene.set_script(combination.generator.nodeScript)
	if !generatorScene.generated.is_connected(addEnergy):
		generatorScene.generated.connect(addEnergy)
	
	effectScene.set_script(combination.effect.nodeScript)
func addEnergy(amount: int) -> void:
	effectScene.addEnergy(amount)
	energyChanged.emit()
