extends Control
class_name InventoryDisplay

@export var onPlanet: bool = false

@onready var equipped: Control = %Equipped
@onready var effects: Control = %Effects
@onready var generators: Control = %Generators
@onready var guns: Control = %Guns
@onready var equippedGunContainer: Control = %EquippedGunContainer
@onready var equippedGun: Control = %EquippedGun
@onready var artifacts: Control = %Artifacts
@onready var itemName: Control = %ItemName
@onready var itemDescription: Control = %ItemDescription
@onready var itemStats: Control = %ItemStats

var player: Node
var hoveredSlot: InventorySpace
var firstEnter: bool = true

signal combinationsChanged()
signal combinationCompleted()
signal gunChanged(gun: Gun)

func _enter_tree():
	if firstEnter:
		return
	updateInventory(Globals.inventory)

func _ready():

	firstEnter = false
	updateInventory(Globals.inventory)
	for slot in getAllSlots():
		slot.hovered.connect(slotHovered)
		slot.unHovered.connect(slotUnHovered)
	for index in effects.get_children().size():
		effects.get_child(index).index = index
		effects.get_child(index).arrayType = "Effect"
	for index in generators.get_children().size():
		generators.get_child(index).index = index
		generators.get_child(index).arrayType = "Generator"
	for index in guns.get_children().size():
		guns.get_child(index).index = index
		guns.get_child(index).arrayType = "Gun"
	for index in equipped.get_children().size():
		equipped.get_child(index).index = index
		equipped.get_child(index).combinationChanged.connect(sendCombinationsChangedSignal)
		equipped.get_child(index).completed.connect(sendCombinationCompletedSignal)
		for slot in equipped.get_child(index).container.get_children():
			slot.arrayType = "Equipped"
	equippedGun.arrayType = "EquippedGun"
	equippedGun.itemChanged.connect(sendGunChanged)

func _unhandled_key_input(event):
	if event.is_action_pressed("OpenInventory") && onPlanet:
		if !visible:
			show()
			updateInventory(Globals.inventory)
		else:
			hide()
	if event.is_action_pressed("ui_cancel") && onPlanet:
		hide()
	

func updateItem(nameOfItem: String, description: String, stats: String) -> void:
	itemName.text = nameOfItem
	itemDescription.text = description
	itemStats.text = stats

func slotHovered(intentorySlot: InventorySpace) -> void:
	hoveredSlot = intentorySlot

func slotUnHovered() -> void:
	hoveredSlot = null

func tryAddItemToSpace(item: InventoryItem) -> void:
	if hoveredSlot:
		if !hoveredSlot.addItem(item):
			item.global_position = item.start
			return
	else:
		item.global_position = item.start

func quickUnequip(inventoryItem: InventoryItem) -> void:
	if inventoryItem.item.type == "Gun":
		for slot in guns.get_children():
			if slot.addItem(inventoryItem):
				return
	var combinationScene = inventoryItem.get_parent().get_parent().get_parent()
	combinationScene.itemRemoved(inventoryItem.item)
	if inventoryItem.item.type == "Effect":
		for slot in effects.get_children():
			if slot.addItem(inventoryItem):
				return
	else:
		for slot in generators.get_children():
			if slot.addItem(inventoryItem):
				return
	

func tryQuickAddItem(inventoryItem: InventoryItem) -> void:
	if inventoryItem.item.type == "Gun":
		if !equippedGun.empty && inventoryItem.get_parent() == equippedGun:
			quickUnequip(inventoryItem)
			return
		equippedGun.addItem(inventoryItem)
		return
	if inventoryItem.equipped:
		quickUnequip(inventoryItem)
		return
	var combinations = Globals.inventory.getCombinations()
	for i in combinations.size():
		if combinations[i].getItemOfType(inventoryItem.item.type) == null:
			var combinationScene = equipped.get_child(i)
			combinationScene.addToCombination(inventoryItem.item, null, null, inventoryItem.get_parent().index, inventoryItem.item.type)
			combinationScene.quickEquip(inventoryItem)
			return

func addToInventory(item: Item, container:Container, slotNumber: int) -> void:
	var slot = container.get_child(slotNumber)
	if slot.empty == true:
		slot.empty = false
		var inventoryItemInstance = load("res://Scenes/InventorySpaces/inventory_item.tscn").instantiate()
		inventoryItemInstance.item = item
		inventoryItemInstance.hover.connect(updateItem)
		inventoryItemInstance.tryAdded.connect(tryAddItemToSpace)
		inventoryItemInstance.tryQuickEquipped.connect(tryQuickAddItem)
		if container == equippedGunContainer:
			inventoryItemInstance.equipped = true
		slot.call_deferred("add_child", inventoryItemInstance)
		return

func addCombination(combination:Combination, combinationNumber: int) -> void:
	while combinationNumber > equipped.get_child_count()-1:
		var newCombo = load("res://Scenes/combinationScene.tscn").instantiate()
		equipped.add_child(newCombo)
	var combo = equipped.get_child(combinationNumber)
	combo.combination = combination
	for slot in combo.container.get_children():
		if combination.getItemOfType(slot.type) != null:
			slot.empty = false
			var inventoryItemInstance = load("res://Scenes/InventorySpaces/inventory_item.tscn").instantiate()
			inventoryItemInstance.item = combination.getItemOfType(slot.type)
			inventoryItemInstance.tryQuickEquipped.connect(tryQuickAddItem)
			inventoryItemInstance.hover.connect(updateItem)
			inventoryItemInstance.tryAdded.connect(tryAddItemToSpace)
			slot.call_deferred("add_child", inventoryItemInstance)

func updateInventory(inventory: Inventory) -> void:
	if !inventory.combinationSlotAdded.is_connected(updateInventory):
		inventory.combinationSlotAdded.connect(updateInventory.bind(inventory))
	clearInventory()
	addSlots(inventory)
	for index in inventory.getEffects().size():
		if inventory.getEffects()[index]:
			addToInventory(inventory.getEffects()[index], effects, index)
	for index in inventory.getGenerators().size():
		if inventory.getGenerators()[index]:
			addToInventory(inventory.getGenerators()[index], generators, index)
	for index in inventory.getGuns().size():
		if inventory.getGuns()[index]:
			addToInventory(inventory.getGuns()[index], guns, index) 
	for index in inventory.getCombinations().size():
		addCombination(inventory.getCombinations()[index], index)
	for index in inventory.getArtifacts().size():
		addToInventory(inventory.getArtifacts()[index], artifacts, index)
	if inventory.currentGun:
		addToInventory(inventory.currentGun, equippedGunContainer, 1)
func addSlots(inventory: Inventory) -> void:
	while inventory.getEffects().size() > effects.get_child_count():
		var newSlot = load("res://Scenes/InventorySpaces/inventory_space_effect.tscn").instantiate()
		newSlot.arrayType = "Effects"
		effects.add_child(newSlot)
	while inventory.getGenerators().size() > generators.get_child_count():
		var newSlot = load("res://Scenes/InventorySpaces/inventory_space_generator.tscn").instantiate()
		newSlot.arrayType = "Generators"
		generators.add_child(newSlot)
	while inventory.getGuns().size() > guns.get_child_count():
		var newSlot = load("res://Scenes/InventorySpaces/inventory_space_gun.tscn").instantiate()
		newSlot.arrayType = "Gun"
		guns.add_child(newSlot)
	
	
	
	while inventory.getArtifacts().size() > artifacts.get_child_count():
		var newSlot = load("res://Scenes/InventorySpaces/inventory_space_artifact.tscn").instantiate()
		newSlot.arrayType = "Artifact"
		artifacts.add_child(newSlot)
	while inventory.getArtifacts().size() < artifacts.get_child_count():
		artifacts.get_child(0).free()

func clearInventory() -> void:
	for slot in getAllSlots():
		for item in slot.get_children():
			item.queue_free()
		slot.empty = true
	for combination in equipped.get_children():
		combination.combination = null

func getAllSlots() -> Array[InventorySpace]:
	var slots:Array[InventorySpace] = []
	for slot in effects.get_children():
		slots.append(slot)
	for slot in generators.get_children():
		slots.append(slot)
	for slot in guns.get_children():
		slots.append(slot)
	for slot in artifacts.get_children():
		slots.append(slot)
	for combimation in equipped.get_children():
		for slot in combimation.container.get_children():
			slots.append(slot)
	slots.append(equippedGun)
	return(slots)

func sendCombinationsChangedSignal() -> void:
	combinationsChanged.emit()

func sendGunChanged(gun: Gun) -> void:
	gunChanged.emit(gun)

func sendCombinationCompletedSignal() -> void:
	combinationCompleted.emit()
