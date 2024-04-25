extends Resource
class_name Item

@export var name: String

@export var description: String

@export var inventorySprite: Texture2D

@export var price: int = 10

@export_range(0,4) var rarity: int = 2

var type: String

func getDescription() -> String:
	return description
