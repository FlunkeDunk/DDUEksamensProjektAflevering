extends Area2D
class_name ChunkArea

@export var chunkCoordinate: Vector2

signal enteredChunk(coord)

func _ready():
	if !body_entered.is_connected(sendSignal):
		body_entered.connect(sendSignal)
	#if get_overlapping_bodies().size() > 0:
		#sendSignal(RigidBody2D.new)
	

func sendSignal(body) -> void:
	queue_free()
	enteredChunk.emit(chunkCoordinate)
