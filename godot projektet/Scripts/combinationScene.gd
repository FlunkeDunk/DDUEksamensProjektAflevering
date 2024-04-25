extends Control

var combination:Combination = Combination.new()
var index:int
@onready var equipmentSlotEffect = %EquipmentSlotEffect
@onready var equipmentSlotGenerator = %EquipmentSlotGenerator
@onready var equipSound: AudioStream = load("res://Assets/AudioFiles/basicEquipSound.wav")
@onready var unequipSound: AudioStream = load("res://Assets/AudioFiles/basicUnequipSound.wav")
@onready var container = %Container

signal combinationChanged()
signal completed()
func _ready():
	for slot in container.get_children():
		slot.itemAdded.connect(addToCombination)
		slot.itemRemoved.connect(itemRemoved)
		slot.child_entered_tree.connect(_on_child_entered_tree)
		slot.child_exiting_tree.connect(_on_child_exiting_tree)

func addToCombination(item: Item, _index , _array, prevIndex, prevArray) -> void:
	SfxManager.play_sound(equipSound)
	if item.type == "Effect":
		combination.addEffect(item)
	else:
		combination.addGenerator(item)
	Globals.inventory.removeItem(item, prevIndex, prevArray)
	combinationChanged.emit()
	if combination.isFull():
		completed.emit()

func quickEquip(inventoryItem) -> void:
	var item = inventoryItem.item
	var oldSlot = inventoryItem.get_parent()
	oldSlot.removeItem()
	oldSlot.remove_child(inventoryItem)
	if item.type == "Effect":
		equipmentSlotEffect.add_child(inventoryItem)
		equipmentSlotEffect.empty = false
	else:
		equipmentSlotGenerator.add_child(inventoryItem)
		equipmentSlotGenerator.empty = false


func itemRemoved(item:Item) -> void:
	SfxManager.play_sound(unequipSound)
	if item.type == "Effect":
		combination.removeEffect()
		equipmentSlotEffect.empty = true
	else:
		combination.removeGenerator()
		equipmentSlotGenerator.empty = true
	combinationChanged.emit()

func _on_child_entered_tree(node):
	if node.is_in_group("InventoryItem"):
		node.equipped = true


func _on_child_exiting_tree(node):
	if node.is_in_group("InventoryItem"):
		node.equipped = false
