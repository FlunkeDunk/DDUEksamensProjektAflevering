extends ColorRect
class_name InventorySpace

var type: String = ""
var arrayType: String
var empty: bool = true
var index: int
signal itemAdded(item)
signal itemRemoved(item)
signal itemChanged(item: Item)
signal hovered(space)
signal unHovered


func _on_mouse_entered():
	self_modulate = Color(1.3, 1.3, 1.3)
	hovered.emit(self)

func _on_mouse_exited():
	self_modulate = Color(1, 1, 1)
	unHovered.emit()

func addItem(inventoryItem: Control) -> bool:
	if inventoryItem.item.type == type and empty:
		var previousParent = inventoryItem.get_parent()
		if previousParent.has_method("removeItem"):
			inventoryItem.get_parent().removeItem()
		inventoryItem.reparent(self)
		Globals.inventory.moveItem(inventoryItem.item, index, arrayType, previousParent.index, previousParent.arrayType)
		inventoryItem.position = Vector2(0, 0)
		empty = false
		itemAdded.emit(inventoryItem.item, index, arrayType, previousParent.index, previousParent.arrayType)
		itemChanged.emit(inventoryItem.item)
		return true
	return false

func removeItem() -> void:
	itemRemoved.emit(get_child(0).item)
	itemChanged.emit(null)
	empty = true
