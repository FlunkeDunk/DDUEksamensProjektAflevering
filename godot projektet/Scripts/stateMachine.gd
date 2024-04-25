class_name FiniteStateMachine
extends Node

@export var starterState: State
var state: State

func _ready() -> void:
	for child in get_children():
		child._init()
	changeState(starterState)

func changeState(newState: State) -> void:
	if state is State:
		state.exitState()
	newState.stateFinished.connect(changeState)
	newState.enterState()
	state = newState
