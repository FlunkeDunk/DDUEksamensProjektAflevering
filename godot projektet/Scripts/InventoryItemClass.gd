extends Control
class_name InventoryItem

@export var item: Item

var hovered: bool = false
var dragged: bool = false
var equipped: bool = false
var dragable: bool = true
var start: Vector2 = Vector2()
var type: String = ""
var inventory: Control
@onready var textureRect: TextureRect = %TextureRect

signal hover(name, description, type)
signal tryAdded(itself)
signal tryQuickEquipped(itself)

func _init():
	add_to_group("InventoryItem")
	z_index = 1

func _ready():
	textureRect.texture = item.inventorySprite

func _on_mouse_entered():
	hovered = true
	hover.emit(item.name, item.getDescription(), item.type)
	self_modulate = Color(1.5, 1.5, 1.5)

func _on_mouse_exited():
	hovered = false
	self_modulate = Color(1, 1, 1)	

func _input(event):
	if Input.is_action_just_pressed("ui_quickmove_item") && hovered:
		quickEquip()
		
	elif Input.is_action_just_released("fire") && dragged:
		tryAdd()
	elif Input.is_action_just_pressed("fire") && hovered && item.type != "Artifact" and dragable:
		dragged = true
		top_level = true
		set_mouse_filter(MOUSE_FILTER_IGNORE)
		start = global_position
	

func _process(_delta):
	if dragged:
		global_position = get_global_mouse_position() - size/2

func quickEquip() -> void:
	if item.type != "Generator" and item.type != "Effect" and item.type != "Gun":
		return
	tryQuickEquipped.emit(self)
	
func tryAdd() -> void:
	tryAdded.emit(self)
	set_mouse_filter(MOUSE_FILTER_PASS)
	dragged = false
	top_level = false
