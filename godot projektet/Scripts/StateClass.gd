extends Node
class_name State

signal stateFinished(state)

func _init():
	set_physics_process(false)
	set_process(false)

func enterState() -> void:
	pass
	
func exitState() -> void:
	pass
