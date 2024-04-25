class_name Inventory
extends Resource

@export var generators: Array[GeneratorItem] = []
@export var effects: Array[EffectItem] = []
@export var guns: Array[Gun] = []
@export var artifacts: Array[Artifact] = []
@export var combinations: Array[Combination] = []
@export var currentGun: Gun = null
@export var effectsSize:int = 50
@export var generatorsSize:int = 50
@export var gunSize:int = 50
@export var combinationSize:int = 3

signal combinationSlotAdded()

func _init():
	effects.resize(effectsSize)
	generators.resize(generatorsSize)
	guns.resize(gunSize)
	for i in combinationSize:
		combinations.append(Combination.new())

func addCombinationSlot() -> void:
	combinationSize += 1
	combinations.append(Combination.new())
	combinationSlotAdded.emit()

func removeCombinationSlot() -> void:
	combinationSize -= 1
	var removedCombination = combinations.pop_back()
	removedCombination.returnToInventory()

func addItem(item:Item) -> void:
	var arrayType:Array
	if item.type == "Effect":
		arrayType = effects
	elif item.type == "Generator":
		arrayType = generators
	elif item.type == "Gun":
		arrayType = guns
	elif item.type == "Artifact":
		arrayType = artifacts
	for index in arrayType.size():
		if arrayType[index] == null:
			arrayType[index] = item
			return
	arrayType.append(item)
func getEffects() -> Array[EffectItem]:
	return effects

func getGenerators() -> Array[GeneratorItem]:
	return generators

func getGuns() -> Array[Gun]:
	return guns

func getArtifacts() -> Array[Artifact]:
	return artifacts

func getCombinations() -> Array[Combination]:
	return combinations

func removeItem(item:Item, position: int, array: String) -> void:
	var arrayType:Array = findArrayType(array)
	if arrayType != []:
		arrayType.remove_at(position)
		arrayType.insert(position, null)
	elif array == "EquippedGun":
		currentGun = null

func moveItem(item:Item, position:int, array: String, prevPosition: int, prevArray: String) -> void:
	removeItem(item, prevPosition, prevArray)
	if array != "Equipped" && array != "EquippedGun":
		var arrayType = findArrayType(array)
		if arrayType:
			findArrayType(array)[position] = item
	elif array == "EquippedGun":
		currentGun = item

func findArrayType(array: String) -> Array:
	var arrayType:Array = []
	if array == "Effect":
		arrayType = effects
	elif array == "Generator":
		arrayType = generators
	elif array == "Gun":
		arrayType = guns
	return arrayType

func clearInventory() -> void:
	generators.clear()
	effects.clear()
	guns.clear()
	artifacts.clear()
	combinations.clear()
	_init()
	currentGun = load("res://Data/Guns/AutoRifle.tres")
