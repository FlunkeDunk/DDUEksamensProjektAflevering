extends Node

var playerCamera: Camera2D

@export var inventory:Inventory = Inventory.new()
@export var stats: GlobalStats = GlobalStats.new()
@export var settings: Settings = Settings.new()
var database: DatabaseManager

signal newStatsCreated()
signal resetGlobalStats()

func convertNum(number: float) -> String:
	if number < pow(10, 6):
		return str(number)
	var exponent: int = 0
	while number > 10:
		exponent += 1
		number *= 0.10
	return str(snapped(number, 0.001)) + "e" + str(exponent)

func screenShake(strength: float) -> void:
	playerCamera.screenShake(strength)



func resetStats() -> void:
	stats.resetArtifactStats()
	inventory.clearInventory()
	inventory.currentGun = load("res://Data/Guns/AutoRifle.tres")
	resetGlobalStats.emit()

